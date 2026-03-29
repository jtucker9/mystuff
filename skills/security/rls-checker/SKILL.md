---
name: rls-checker
description: "Use when the user says 'check RLS', 'audit RLS', 'RLS policies', 'row level security', 'Supabase security audit', 'table access control', or needs to verify row-level security policies on PostgreSQL/Supabase tables. Do NOT use for writing new RLS policies from scratch (see rls-guardian) or API-level security (see api-audit)."
---

# 🔍 RLS Checker — Row Level Security Policy Audit
*Audit existing Row Level Security policies across PostgreSQL/Supabase tables to find unprotected tables, overly permissive policies, and privilege escalation paths.*

## Activation

When this skill activates, output:

`🔍 RLS Checker — Auditing Row Level Security policies...`

| Context | Status |
|---------|--------|
| **User says "check RLS", "audit RLS", "RLS policies"** | ACTIVE |
| **User mentions "Supabase security", "table access control"** | ACTIVE |
| **User wants to verify existing policies are correct** | ACTIVE |
| **User wants to CREATE new RLS policies on new tables** | DORMANT — see rls-guardian |
| **User wants API endpoint security** | DORMANT — see api-audit |
| **User wants general OWASP assessment** | DORMANT — see owasp-top10 |

## Protocol

### Step 1: Gather Inputs

Ask the user for:
- **Database access**: Supabase project URL + service role key, or direct PostgreSQL connection?
- **Schema scope**: Which schemas? (usually `public`)
- **Application context**: What roles access the database? (anon, authenticated, service_role)
- **Multi-tenancy**: Is this a multi-tenant application? How is tenancy determined? (org_id, team_id, user_id)
- **Known sensitive tables**: Any tables with PII, financial data, or admin-only data?

### Step 2: Discover All Tables and RLS Status

```sql
-- Find all tables and their RLS status
SELECT
  schemaname,
  tablename,
  rowsecurity AS rls_enabled,
  CASE
    WHEN rowsecurity THEN '✅ Enabled'
    ELSE '❌ DISABLED'
  END AS status
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY rowsecurity ASC, tablename;

-- Count: tables with vs without RLS
SELECT
  COUNT(*) FILTER (WHERE rowsecurity) AS rls_enabled,
  COUNT(*) FILTER (WHERE NOT rowsecurity) AS rls_disabled,
  COUNT(*) AS total
FROM pg_tables
WHERE schemaname = 'public';
```

**Any table with `rls_disabled` is fully accessible to any authenticated role.** This is the most common and dangerous misconfiguration.

### Step 3: Audit Existing Policies

```sql
-- List ALL policies on ALL tables
SELECT
  schemaname,
  tablename,
  policyname,
  permissive,  -- 'PERMISSIVE' or 'RESTRICTIVE'
  roles,
  cmd,          -- SELECT, INSERT, UPDATE, DELETE, ALL
  qual AS using_expression,
  with_check AS with_check_expression
FROM pg_policies
WHERE schemaname = 'public'
ORDER BY tablename, policyname;

-- Find tables with RLS enabled but NO policies (locks out everyone)
SELECT t.tablename
FROM pg_tables t
LEFT JOIN pg_policies p ON t.tablename = p.tablename AND t.schemaname = p.schemaname
WHERE t.schemaname = 'public'
  AND t.rowsecurity = true
  AND p.policyname IS NULL;

-- Find tables with only SELECT policies (missing INSERT/UPDATE/DELETE protection)
SELECT tablename,
  array_agg(DISTINCT cmd) AS covered_operations,
  ARRAY['SELECT','INSERT','UPDATE','DELETE'] - array_agg(DISTINCT cmd::text) AS missing_operations
FROM pg_policies
WHERE schemaname = 'public'
GROUP BY tablename;
```

### Step 4: Check for Common Vulnerabilities

**Vulnerability 1: RLS Disabled on Sensitive Tables**
```sql
-- Tables without RLS that have "sensitive" column names
SELECT tablename, array_agg(column_name::text) AS sensitive_columns
FROM information_schema.columns
WHERE table_schema = 'public'
  AND column_name IN ('email', 'password', 'password_hash', 'ssn', 'credit_card',
                       'phone', 'address', 'salary', 'api_key', 'token', 'secret')
  AND table_name IN (
    SELECT tablename FROM pg_tables WHERE schemaname = 'public' AND NOT rowsecurity
  )
GROUP BY tablename;
```

**Vulnerability 2: Overly Permissive Policies**
```sql
-- Policies that grant access to ALL rows (no WHERE clause effectively)
-- Look for: qual = 'true' or qual IS NULL with permissive policy
SELECT tablename, policyname, cmd, roles, qual
FROM pg_policies
WHERE schemaname = 'public'
  AND (qual = 'true' OR qual IS NULL)
  AND permissive = 'PERMISSIVE';
```

Common overly-permissive patterns:
```sql
-- ❌ BAD: Allows any authenticated user to read ALL rows
CREATE POLICY "allow_all_select" ON items
  FOR SELECT TO authenticated USING (true);

-- ✅ GOOD: Users can only read their own rows
CREATE POLICY "select_own" ON items
  FOR SELECT TO authenticated USING (user_id = auth.uid());
```

**Vulnerability 3: Missing USING vs WITH CHECK**
```sql
-- INSERT/UPDATE policies need WITH CHECK to validate new data
-- USING alone doesn't prevent inserting rows you shouldn't own
SELECT tablename, policyname, cmd, qual AS using_expr, with_check
FROM pg_policies
WHERE schemaname = 'public'
  AND cmd IN ('INSERT', 'UPDATE', 'ALL')
  AND with_check IS NULL;
```

```sql
-- ❌ BAD: Can insert rows with any user_id
CREATE POLICY "insert_items" ON items
  FOR INSERT TO authenticated WITH CHECK (true);

-- ✅ GOOD: Can only insert rows assigned to yourself
CREATE POLICY "insert_own" ON items
  FOR INSERT TO authenticated WITH CHECK (user_id = auth.uid());
```

**Vulnerability 4: Privilege Escalation via Foreign Keys**
```sql
-- If table A has RLS but references table B without RLS,
-- data from B can leak through joins
SELECT
  tc.table_name AS referencing_table,
  ccu.table_name AS referenced_table,
  t.rowsecurity AS referenced_has_rls
FROM information_schema.table_constraints tc
JOIN information_schema.constraint_column_usage ccu
  ON tc.constraint_name = ccu.constraint_name
JOIN pg_tables t
  ON t.tablename = ccu.table_name AND t.schemaname = 'public'
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND tc.table_schema = 'public'
  AND NOT t.rowsecurity;
```

**Vulnerability 5: Service Role Bypass**
```sql
-- service_role bypasses ALL RLS. Check what uses service_role.
-- In Supabase: only server-side code should use service_role key.
-- Client-side code must use anon or authenticated roles.

-- Check if any policy explicitly grants to service_role (redundant, raises questions)
SELECT tablename, policyname, roles
FROM pg_policies
WHERE 'service_role' = ANY(roles);
```

**Vulnerability 6: Function Security (SECURITY DEFINER)**
```sql
-- Functions with SECURITY DEFINER run as the function OWNER (usually superuser)
-- They bypass RLS unless explicitly set to respect it
SELECT
  n.nspname AS schema,
  p.proname AS function_name,
  CASE p.prosecdef WHEN true THEN '⚠️ SECURITY DEFINER' ELSE '✅ SECURITY INVOKER' END AS security,
  pg_get_functiondef(p.oid) AS definition
FROM pg_proc p
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'public'
  AND p.prosecdef = true;
```

### Step 5: Test Policies with Role Impersonation

```sql
-- Test as anonymous user
SET ROLE anon;
SELECT * FROM items LIMIT 5;  -- Should return nothing or only public items
RESET ROLE;

-- Test as authenticated user (set jwt claims)
SET ROLE authenticated;
SET request.jwt.claims = '{"sub": "user-uuid-here", "role": "authenticated"}';
SELECT * FROM items LIMIT 5;  -- Should return only this user's items
RESET ROLE;

-- Test cross-tenant access
SET ROLE authenticated;
SET request.jwt.claims = '{"sub": "user-a-uuid"}';
SELECT * FROM items WHERE user_id = 'user-b-uuid';  -- Should return 0 rows
RESET ROLE;

-- Test INSERT protection
SET ROLE authenticated;
SET request.jwt.claims = '{"sub": "user-a-uuid"}';
INSERT INTO items (user_id, name) VALUES ('user-b-uuid', 'hijack');  -- Should fail
RESET ROLE;
```

### Step 6: Policy Completeness Matrix

Build a matrix showing coverage:

| Table | RLS | SELECT | INSERT | UPDATE | DELETE | Tenant Isolation | Notes |
|-------|-----|--------|--------|--------|--------|-----------------|-------|
| `users` | ✅ | ✅ own | ✅ own | ✅ own | ❌ missing | ✅ user_id | Need DELETE policy |
| `items` | ✅ | ✅ own | ✅ own | ✅ own | ✅ own | ✅ user_id | Complete |
| `payments` | ❌ | - | - | - | - | - | 🔴 CRITICAL: No RLS |
| `admin_settings` | ✅ | ✅ admin | ❌ missing | ❌ missing | ❌ missing | N/A | Need write policies |

### Step 7: Common Policy Templates

Provide recommended policies for unprotected tables:

**Pattern 1: User Ownership**
```sql
-- Users can only access their own rows
ALTER TABLE items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "select_own" ON items FOR SELECT TO authenticated
  USING (user_id = auth.uid());

CREATE POLICY "insert_own" ON items FOR INSERT TO authenticated
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "update_own" ON items FOR UPDATE TO authenticated
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "delete_own" ON items FOR DELETE TO authenticated
  USING (user_id = auth.uid());
```

**Pattern 2: Organization/Team Multi-Tenancy**
```sql
-- Users can access rows belonging to their organization
CREATE POLICY "org_select" ON projects FOR SELECT TO authenticated
  USING (
    org_id IN (
      SELECT org_id FROM org_members WHERE user_id = auth.uid()
    )
  );
```

**Pattern 3: Role-Based (Admin + Member)**
```sql
-- Admins can do everything, members can only read
CREATE POLICY "admin_all" ON settings FOR ALL TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM user_roles
      WHERE user_id = auth.uid() AND role = 'admin'
    )
  );

CREATE POLICY "member_read" ON settings FOR SELECT TO authenticated
  USING (true);  -- All authenticated users can read
```

**Pattern 4: Public Read, Authenticated Write**
```sql
-- Anyone can read, only authenticated users can write their own
CREATE POLICY "public_read" ON posts FOR SELECT TO anon, authenticated
  USING (published = true);

CREATE POLICY "author_write" ON posts FOR INSERT TO authenticated
  WITH CHECK (author_id = auth.uid());
```

### Step 8: Output

```
━━━ RLS AUDIT REPORT ━━━━━━━━━━━━━━━━━━━━

── SUMMARY ───────────────────────────────
Tables scanned: [N]
RLS enabled: [X] / RLS disabled: [Y]
Policies found: [N]
Vulnerabilities found: [N] (Critical: X, High: Y, Medium: Z)

── 🔴 CRITICAL FINDINGS ─────────────────
[Tables with no RLS that contain sensitive data]
[Overly permissive policies (USING true)]
[Missing WITH CHECK on write operations]

── 🟡 WARNINGS ──────────────────────────
[Incomplete operation coverage]
[Foreign key leak paths]
[SECURITY DEFINER functions]

── POLICY COMPLETENESS MATRIX ────────────
[Table from Step 6]

── RECOMMENDED FIXES ─────────────────────
[SQL statements to fix each finding]

── VERIFICATION QUERIES ──────────────────
[Role impersonation tests to verify fixes]
```

## Anti-Patterns

- **Enabling RLS without adding policies**: This locks out ALL access including your own application. Always add policies immediately after enabling RLS.
- **Using `USING (true)` on sensitive tables**: This is equivalent to no RLS — it permits all rows. Only use on genuinely public data.
- **Forgetting WITH CHECK on INSERT/UPDATE**: USING controls reads, WITH CHECK controls writes. Without WITH CHECK, users can insert rows they shouldn't own.
- **Testing only with service_role**: service_role bypasses RLS. Always test with `anon` and `authenticated` roles.
- **Assuming RLS protects against SQL injection**: RLS controls which rows a role can access. It doesn't prevent injection attacks — use parameterized queries.
- **Complex subqueries in policies without indexes**: RLS policies run on every row access. A slow policy = slow queries. Index the columns used in policy conditions.

## Escalation

Hand off to a database security specialist when:
- The application handles financial transactions or PII subject to regulation
- Multi-tenant data isolation is critical (B2B SaaS with contractual obligations)
- Complex permission hierarchies exist (roles within roles, inherited permissions)
- Performance degradation is observed after adding RLS policies
- You suspect active data leakage between tenants

## Inputs
- Database connection (Supabase URL + key or PostgreSQL connection string)
- Schema scope
- Application role structure
- Multi-tenancy model (if applicable)
- Known sensitive tables

## Outputs
- Table-by-table RLS status inventory
- Policy completeness matrix (table x operation)
- Categorized vulnerability findings with severity
- SQL fix scripts for each finding
- Role impersonation test queries
- Recommended policy templates

## Level History

- **Lv.1** — Base: Full table/policy inventory, 6 vulnerability checks (disabled RLS, overly permissive, missing WITH CHECK, FK leaks, service_role exposure, SECURITY DEFINER functions), role impersonation testing, completeness matrix, 4 policy templates (ownership, org, role-based, public/private). (Origin: MemStack v3.3, Mar 2026)
