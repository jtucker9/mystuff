---
name: rls-guardian
description: "Intercept CREATE TABLE, ALTER TABLE, new table, database schema, or migration files and enforce RLS policy generation. Do NOT use for auditing existing policies (rls-checker) or general security review (owasp-top10)."
---

# RLS Guardian — Automatic Row Level Security Enforcement

## Activation

`RLS Guardian — Enforcing Row Level Security on schema changes...`

| Context | Status |
|---------|--------|
| CREATE TABLE / ALTER TABLE detected | ACTIVE |
| Migration files with schema changes | ACTIVE |
| New columns with access implications (role, is_admin) | ACTIVE |
| Auditing existing policies | DORMANT — use rls-checker |
| General security review | DORMANT — use owasp-top10 |

## Instructions

### Step 1: Analyze Schema Change

Extract from the statement: table name, column list, ownership column (`user_id`, `owner_id`, `org_id`, `team_id`), sensitivity (PII/financial), relationship type (parent/child/junction).

**Gate:** If no table name or columns can be determined, ask the user before proceeding.

### Step 2: Classify Access Pattern

Decision tree for policy template selection:

| Signal | Pattern | Rule |
|--------|---------|------|
| Has `user_id` / `owner_id` | OWNERSHIP | Users access only their own rows via `auth.uid()` match |
| Has `org_id` / `team_id` | TENANT | Users access rows within their org; use `STABLE` helper function for membership lookup |
| Has `role` column or manages permissions | ADMIN_ONLY | Only admin/service_role; no `anon` policy = anon gets nothing |
| Reference data (categories, settings) | PUBLIC_READ | `anon + authenticated` SELECT with `USING (true)`; admin-gated writes |
| Has `published` / visibility flag | VISIBILITY | Public reads published; owner reads/writes all own rows |
| Junction table (user_roles, team_members) | RELATIONSHIP | Self-join/leave + parent owner manages all memberships |

**Gate:** Confirm classification with user if ambiguous (e.g., table has both `user_id` and `org_id`).

### Step 3: Generate Policies

Required for every table — no exceptions:

1. `ENABLE ROW LEVEL SECURITY` + `FORCE ROW LEVEL SECURITY` (in same migration as CREATE TABLE)
2. Separate policies for all four operations: SELECT, INSERT, UPDATE, DELETE
3. INSERT/UPDATE policies must include `WITH CHECK` (not just `USING`)
4. Target roles: `authenticated` for private data, `anon, authenticated` for public reads
5. Naming convention: `{table}_{pattern}_{operation}` (e.g., `orders_ownership_select`)
6. Index every column referenced in policy conditions

Supabase role mapping: `anon` = unauthenticated, `authenticated` = logged in, `service_role` = bypasses RLS entirely. Never grant `service_role` in client-side code.

**Gate:** Policy set must cover all four operations before proceeding. If a pattern merits fewer (e.g., no DELETE on audit logs), document the justification explicitly.

### Step 4: Validate Migration Safety

Checklist — every item must pass:

- Every CREATE TABLE has ENABLE + FORCE RLS in the same migration (no gap between table creation and protection)
- All four operations have policies with correct USING/WITH CHECK clauses
- Foreign keys to unprotected tables are flagged (data leak via join)
- Functions use SECURITY INVOKER unless DEFINER is justified (server-side only, no user input, aggregate returns only)
- Views use `security_invoker = true` (PG15+) or are replaced with INVOKER functions

**Gate:** Any checklist failure blocks the migration. Fix before output.

### Step 5: Output Report

Present: schema change summary, access pattern classification with reasoning, generated SQL, required indexes, checklist results, and verification approach.

Verification: provide role impersonation test queries — `SET ROLE authenticated` / `SET request.jwt.claims` to confirm policies filter correctly, then `RESET ROLE`.

## Examples

**User creates `orders` table with `user_id` column:** Classify as OWNERSHIP. Generate four policies matching `user_id = auth.uid()`. Index `user_id`. Include FORCE RLS.

**User creates `categories` table with `name`, `slug`, no ownership column:** Classify as PUBLIC_READ. SELECT policy with `USING (true)` for `anon, authenticated`. Write policies gated on admin role check. No user-specific index needed.

## Common Issues

**RLS enabled but not forced:** Table owner (`postgres` in Supabase) bypasses all policies. Always `FORCE ROW LEVEL SECURITY`.

**SECURITY DEFINER function exposed via RPC:** Client-callable DEFINER functions are privilege escalation. Use INVOKER for anything the client can reach.

**Tenant lookup without STABLE function:** Subquery in every policy condition without caching causes per-row evaluation. Create a `STABLE` helper function and index the membership table.

## Anti-Patterns

- Single `FOR ALL` policy instead of per-operation policies (harder to audit, debug, and evolve)
- CREATE TABLE in one migration, ENABLE RLS in another (gap = unprotected table in production)
- Hardcoded UUIDs in policies instead of `auth.uid()`
- Forgetting to update policies when adding access-relevant columns (`is_admin`, `role`, `visibility`)
- DEFINER functions that accept user input (SQL injection bypasses all RLS)

## Escalation

Hand off to a database security specialist when: complex permission hierarchies (role inheritance, ABAC), multi-tenant contractual SLAs, RLS performance degradation on millions of rows, or regulatory compliance (SOC 2, HIPAA) requiring formal review.

## Inputs

- CREATE TABLE or ALTER TABLE statement
- Application context (user roles, tenancy model)
- Existing policy patterns in the project

## Outputs

- Access pattern classification with reasoning
- Complete RLS policy SQL (all four operations)
- Index creation statements for policy columns
- Migration safety checklist (pass/fail)
- Role impersonation verification queries

## Level History

- **Lv.1** — Base: 6 access pattern templates (ownership, tenant, public_read, admin_only, visibility, relationship), automatic classification from column analysis, FORCE RLS enforcement, function/view security guidance, performance optimization, migration review checklist. (Origin: MemStack v3.3, Mar 2026)
- **Lv.2** — Compressed: Decision-rule density rewrite. Removed full SQL templates, added validation gates between steps, tightened to creator-level reference. Preserved: auto-activation triggers, pattern decision tree, four-operation policy requirement, migration safety checklist, Supabase role semantics, verification approach. (Origin: MemStack v3.4, Mar 2026)
