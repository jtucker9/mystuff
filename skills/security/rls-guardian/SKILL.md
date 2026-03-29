---
name: rls-guardian
description: "Use when the user says 'CREATE TABLE', 'ALTER TABLE', 'new table', 'add table', 'database schema', or is creating/modifying PostgreSQL/Supabase tables in migration files. Automatically enforces RLS policy generation on schema changes. Do NOT use for auditing existing policies (see rls-checker) or general security review (see owasp-top10)."
---

# 🛡️ RLS Guardian — Automatic Row Level Security Enforcement
*Intercept schema changes and automatically generate RLS policies for new and modified tables, ensuring no table goes live without proper access control.*

## Activation

When this skill activates, output:

`🛡️ RLS Guardian — Enforcing Row Level Security on schema changes...`

| Context | Status |
|---------|--------|
| **User creates a new table (CREATE TABLE)** | ACTIVE |
| **User modifies a table (ALTER TABLE)** | ACTIVE |
| **User writes migration files** | ACTIVE |
| **User asks to add columns with access implications** | ACTIVE |
| **User wants to AUDIT existing policies** | DORMANT — see rls-checker |
| **User wants general security review** | DORMANT — see owasp-top10 |

## Protocol

### Step 1: Intercept Schema Change

When a CREATE TABLE or ALTER TABLE is detected, immediately analyze:

1. **Table name and purpose** — infer from name and columns
2. **Ownership column** — does it have `user_id`, `owner_id`, `created_by`, `org_id`, `team_id`?
3. **Sensitivity level** — does it contain PII, financial data, or access control data?
4. **Relationship pattern** — is it a parent entity, child entity, or junction table?

### Step 2: Classify Table Access Pattern

```
What kind of table is this?
├── User-owned data (has user_id/owner_id)
│   └── Pattern: OWNERSHIP — users access only their own rows
├── Organization/team data (has org_id/team_id)
│   └── Pattern: TENANT — users access rows within their org/team
├── Public reference data (categories, countries, settings)
│   └── Pattern: PUBLIC_READ — anyone reads, only admins write
├── System/admin data (roles, permissions, audit logs)
│   └── Pattern: ADMIN_ONLY — only admin/service_role access
├── Junction/relationship table (user_roles, team_members)
│   └── Pattern: RELATIONSHIP — access based on membership
└── Content with visibility (posts, comments with published flag)
    └── Pattern: VISIBILITY — public if published, owner if draft
```

### Step 3: Generate RLS Policies

**For every new table, generate the complete policy set:**

**OWNERSHIP Pattern:**
```sql
-- Table with user_id column — users own their rows
ALTER TABLE {table_name} ENABLE ROW LEVEL SECURITY;

-- Force RLS even for table owner (Supabase best practice)
ALTER TABLE {table_name} FORCE ROW LEVEL SECURITY;

-- SELECT: Users see only their own rows
CREATE POLICY "{table_name}_select_own"
  ON {table_name} FOR SELECT
  TO authenticated
  USING (user_id = auth.uid());

-- INSERT: Users can only create rows assigned to themselves
CREATE POLICY "{table_name}_insert_own"
  ON {table_name} FOR INSERT
  TO authenticated
  WITH CHECK (user_id = auth.uid());

-- UPDATE: Users can only modify their own rows
CREATE POLICY "{table_name}_update_own"
  ON {table_name} FOR UPDATE
  TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- DELETE: Users can only delete their own rows
CREATE POLICY "{table_name}_delete_own"
  ON {table_name} FOR DELETE
  TO authenticated
  USING (user_id = auth.uid());
```

**TENANT Pattern:**
```sql
ALTER TABLE {table_name} ENABLE ROW LEVEL SECURITY;
ALTER TABLE {table_name} FORCE ROW LEVEL SECURITY;

-- Helper function: get user's org memberships
-- (Create once, reuse across policies)
CREATE OR REPLACE FUNCTION auth.user_org_ids()
RETURNS SETOF uuid AS $$
  SELECT org_id FROM public.org_members WHERE user_id = auth.uid()
$$ LANGUAGE sql SECURITY DEFINER STABLE;

CREATE POLICY "{table_name}_tenant_select"
  ON {table_name} FOR SELECT TO authenticated
  USING (org_id IN (SELECT auth.user_org_ids()));

CREATE POLICY "{table_name}_tenant_insert"
  ON {table_name} FOR INSERT TO authenticated
  WITH CHECK (org_id IN (SELECT auth.user_org_ids()));

CREATE POLICY "{table_name}_tenant_update"
  ON {table_name} FOR UPDATE TO authenticated
  USING (org_id IN (SELECT auth.user_org_ids()))
  WITH CHECK (org_id IN (SELECT auth.user_org_ids()));

CREATE POLICY "{table_name}_tenant_delete"
  ON {table_name} FOR DELETE TO authenticated
  USING (org_id IN (SELECT auth.user_org_ids()));
```

**PUBLIC_READ Pattern:**
```sql
ALTER TABLE {table_name} ENABLE ROW LEVEL SECURITY;
ALTER TABLE {table_name} FORCE ROW LEVEL SECURITY;

-- Anyone can read (including anonymous)
CREATE POLICY "{table_name}_public_read"
  ON {table_name} FOR SELECT
  TO anon, authenticated
  USING (true);

-- Only admins can write
CREATE POLICY "{table_name}_admin_write"
  ON {table_name} FOR ALL
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM user_roles WHERE user_id = auth.uid() AND role = 'admin')
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM user_roles WHERE user_id = auth.uid() AND role = 'admin')
  );
```

**ADMIN_ONLY Pattern:**
```sql
ALTER TABLE {table_name} ENABLE ROW LEVEL SECURITY;
ALTER TABLE {table_name} FORCE ROW LEVEL SECURITY;

-- Only admin role can access
CREATE POLICY "{table_name}_admin_only"
  ON {table_name} FOR ALL
  TO authenticated
  USING (
    EXISTS (SELECT 1 FROM user_roles WHERE user_id = auth.uid() AND role = 'admin')
  )
  WITH CHECK (
    EXISTS (SELECT 1 FROM user_roles WHERE user_id = auth.uid() AND role = 'admin')
  );
-- No policy for 'anon' = anon gets nothing
```

**VISIBILITY Pattern:**
```sql
ALTER TABLE {table_name} ENABLE ROW LEVEL SECURITY;
ALTER TABLE {table_name} FORCE ROW LEVEL SECURITY;

-- Public: anyone can see published content
CREATE POLICY "{table_name}_public_read"
  ON {table_name} FOR SELECT
  TO anon, authenticated
  USING (published = true);

-- Owner: can see all their own (including drafts)
CREATE POLICY "{table_name}_owner_read"
  ON {table_name} FOR SELECT
  TO authenticated
  USING (author_id = auth.uid());

-- Owner: can write their own content
CREATE POLICY "{table_name}_owner_write"
  ON {table_name} FOR INSERT
  TO authenticated
  WITH CHECK (author_id = auth.uid());

CREATE POLICY "{table_name}_owner_update"
  ON {table_name} FOR UPDATE
  TO authenticated
  USING (author_id = auth.uid())
  WITH CHECK (author_id = auth.uid());

CREATE POLICY "{table_name}_owner_delete"
  ON {table_name} FOR DELETE
  TO authenticated
  USING (author_id = auth.uid());
```

**RELATIONSHIP Pattern (junction tables):**
```sql
ALTER TABLE {table_name} ENABLE ROW LEVEL SECURITY;
ALTER TABLE {table_name} FORCE ROW LEVEL SECURITY;

-- Members can see relationships they're part of
CREATE POLICY "{table_name}_member_select"
  ON {table_name} FOR SELECT TO authenticated
  USING (user_id = auth.uid());

-- Users can add themselves (join) but not others
CREATE POLICY "{table_name}_self_insert"
  ON {table_name} FOR INSERT TO authenticated
  WITH CHECK (user_id = auth.uid());

-- Users can remove themselves (leave) but not others
CREATE POLICY "{table_name}_self_delete"
  ON {table_name} FOR DELETE TO authenticated
  USING (user_id = auth.uid());

-- Admins/owners can manage all memberships
CREATE POLICY "{table_name}_admin_manage"
  ON {table_name} FOR ALL TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM {parent_table}
      WHERE id = {table_name}.{parent_id} AND owner_id = auth.uid()
    )
  );
```

### Step 4: Migration File Review Checklist

When reviewing migration files, verify:

- [ ] **Every CREATE TABLE has a matching ENABLE ROW LEVEL SECURITY**
- [ ] **Every table with RLS has policies for all 4 operations** (SELECT, INSERT, UPDATE, DELETE)
- [ ] **INSERT/UPDATE policies have WITH CHECK** (not just USING)
- [ ] **New columns with access implications** trigger policy review (e.g., adding `is_admin` column)
- [ ] **Foreign keys to unprotected tables** are flagged (data leak risk)
- [ ] **FORCE ROW LEVEL SECURITY** is set (Supabase best practice — applies RLS to table owner too)
- [ ] **Views and functions** that access the table respect RLS (SECURITY INVOKER, not DEFINER unless intentional)

### Step 5: Function and View Security

```sql
-- ❌ DANGEROUS: SECURITY DEFINER bypasses RLS
CREATE OR REPLACE FUNCTION get_all_items()
RETURNS SETOF items AS $$
  SELECT * FROM items;
$$ LANGUAGE sql SECURITY DEFINER;

-- ✅ SAFE: SECURITY INVOKER respects caller's RLS policies
CREATE OR REPLACE FUNCTION get_all_items()
RETURNS SETOF items AS $$
  SELECT * FROM items;
$$ LANGUAGE sql SECURITY INVOKER;

-- ✅ SAFE: View with security_invoker (PostgreSQL 15+)
CREATE VIEW public_items
  WITH (security_invoker = true)
AS SELECT * FROM items WHERE published = true;

-- ⚠️ Pre-PostgreSQL 15: Views run as DEFINER by default
-- Use a function with SECURITY INVOKER instead
```

**Decision tree for SECURITY DEFINER:**
```
Does this function need to bypass RLS?
├── No → Use SECURITY INVOKER (default safe choice)
├── Yes, for a specific administrative task
│   ├── Does it accept user input? → ⚠️ Risk: SQL injection bypasses ALL RLS
│   │   └── Validate all inputs, use parameterized queries
│   ├── Does it return data to the caller? → ⚠️ Risk: data leakage
│   │   └── Filter results to only what the caller should see
│   └── Is it called from client-side code? → ❌ Never expose DEFINER functions to clients
└── Use SECURITY DEFINER only when:
    - Internal server-side function
    - No user input in query construction
    - Returns aggregate/summary data only
    - Explicitly documented why DEFINER is needed
```

### Step 6: Performance Considerations

```sql
-- RLS policies run on EVERY row access. Optimize:

-- ✅ Index the columns used in policy conditions
CREATE INDEX idx_{table}_user_id ON {table_name}(user_id);
CREATE INDEX idx_org_members_user_org ON org_members(user_id, org_id);

-- ❌ SLOW: Subquery in policy without index
USING (org_id IN (SELECT org_id FROM org_members WHERE user_id = auth.uid()))

-- ✅ FASTER: Use a function that's marked STABLE (PostgreSQL caches result)
CREATE OR REPLACE FUNCTION auth.user_org_ids()
RETURNS SETOF uuid AS $$
  SELECT org_id FROM org_members WHERE user_id = auth.uid()
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Then in policy:
USING (org_id IN (SELECT auth.user_org_ids()))
```

### Step 7: Output

Present the guardian report alongside the generated SQL:

```
━━━ RLS GUARDIAN REPORT ━━━━━━━━━━━━━━━━━━

── SCHEMA CHANGE DETECTED ────────────────
Operation: CREATE TABLE [table_name]
Columns: [column list]
Ownership column: [user_id / org_id / none detected]

── ACCESS PATTERN ────────────────────────
Classification: [OWNERSHIP / TENANT / PUBLIC_READ / ADMIN_ONLY / VISIBILITY / RELATIONSHIP]
Reasoning: [why this pattern was chosen]

── GENERATED POLICIES ────────────────────
[complete SQL for all policies]

── INDEXES NEEDED ────────────────────────
[CREATE INDEX statements for policy performance]

── MIGRATION CHECKLIST ───────────────────
[✅/❌ for each item in Step 4]

── VERIFICATION QUERIES ──────────────────
[role impersonation tests to verify policies work]
```

## Anti-Patterns

- **Enabling RLS without FORCE**: Without `FORCE ROW LEVEL SECURITY`, the table owner bypasses all policies. In Supabase, this means the `postgres` role ignores your policies.
- **Using `FOR ALL` with a single policy**: A single ALL policy looks simpler but makes it harder to audit and debug. Use separate policies per operation.
- **Hardcoding user IDs in policies**: `USING (user_id = 'abc-123')` is fragile. Always use `auth.uid()` or equivalent.
- **Creating tables in a migration without RLS in the same migration**: If the migration fails between CREATE TABLE and ENABLE RLS, you have an unprotected table in production. Always combine them.
- **Using SECURITY DEFINER functions called from client-side RPC**: This is a privilege escalation path. Client-callable functions should always be SECURITY INVOKER.
- **Forgetting to update policies when adding columns**: Adding a `role` or `is_admin` column may require updating existing policies.

## Escalation

Hand off to a database security specialist when:
- Complex permission hierarchies (role inheritance, group-based access)
- Multi-tenant isolation with contractual SLA requirements
- Performance issues after adding RLS to large tables (millions of rows)
- Need to implement attribute-based access control (ABAC) beyond simple RBAC
- Regulatory compliance requires formal security review (SOC 2, HIPAA)

## Inputs
- CREATE TABLE or ALTER TABLE SQL statement
- Application context (user roles, tenancy model)
- Existing policy patterns in the project
- Performance requirements

## Outputs
- Table access pattern classification
- Complete RLS policy SQL (all 4 operations)
- Required index creation statements
- Migration file review checklist
- Verification queries for testing

## Level History

- **Lv.1** — Base: 6 access pattern templates (ownership, tenant, public_read, admin_only, visibility, relationship), automatic classification from column analysis, FORCE RLS enforcement, function/view security guidance, performance optimization, migration review checklist. (Origin: MemStack v3.3, Mar 2026)
