---
name: rls-checker
description: "Audit existing RLS policies on PostgreSQL/Supabase tables for gaps, over-permissions, and cross-tenant leaks. Triggers: 'check RLS', 'audit RLS', 'RLS policies', 'row level security', 'Supabase security audit', 'table access control'. NOT for writing new policies (rls-guardian), API security (api-audit), or general OWASP (owasp-top10)."
---

# RLS Checker -- Row Level Security Policy Audit

Audit existing Row Level Security policies to find unprotected tables, overly permissive policies, and privilege escalation paths.

## Activation

| Context | Status |
|---------|--------|
| "check RLS", "audit RLS", "RLS policies", "Supabase security" | ACTIVE |
| Verify existing policies are correct | ACTIVE |
| CREATE new RLS policies on new tables | DORMANT -- see rls-guardian |
| API endpoint security | DORMANT -- see api-audit |
| General OWASP assessment | DORMANT -- see owasp-top10 |

## Instructions

### Step 1: Gather Inputs

Collect: database connection method, schema scope (default `public`), application roles (anon/authenticated/service_role), multi-tenancy model (user_id/org_id/team_id), and known sensitive tables.

**Gate:** Do not proceed without connection method and at least one role identified.

### Step 2: Discover Tables and RLS Status

Query `pg_tables` for `rowsecurity` status across target schema. Any table with RLS disabled is fully accessible to any role -- highest-priority finding.

**Gate:** If zero tables found, confirm schema name and connection. Do not proceed on empty results.

### Step 3: Audit Policy Coverage

Query `pg_policies` for all policies on target schema. For each table with RLS enabled, check:

1. **Operation coverage** -- are SELECT, INSERT, UPDATE, DELETE all covered? Missing operations = implicit deny (locks out) or implicit allow (if RLS enabled but no policy for that cmd on permissive).
2. **USING vs WITH CHECK** -- INSERT/UPDATE policies without WITH CHECK allow writing rows the user shouldn't own.
3. **Permissive vs Restrictive** -- permissive policies OR together; restrictive policies AND with permissive results. Misunderstanding this = accidental over-grant.
4. **Role targeting** -- policies should target `authenticated`/`anon`, not `public` (which includes all roles).

**Gate:** Build the completeness matrix (table x operation) before proceeding to vulnerability analysis.

### Step 4: Check for Vulnerabilities

Classify each finding by severity:

| Severity | Condition |
|----------|-----------|
| CRITICAL | RLS disabled on table with sensitive columns (PII, financial, auth) |
| CRITICAL | Policy with `USING (true)` on sensitive table |
| HIGH | Missing WITH CHECK on INSERT/UPDATE policies |
| HIGH | Foreign key references from RLS-protected table to unprotected table (data leaks via joins) |
| MEDIUM | SECURITY DEFINER functions in public schema (bypass RLS unless explicitly restricted) |
| MEDIUM | Policies granting to service_role (redundant -- service_role bypasses RLS; signals confusion) |
| LOW | RLS enabled but zero policies (full lockout, not a leak, but breaks the app) |

### Step 5: Cross-Tenant Leak Detection

For multi-tenant apps: verify every policy's USING clause filters by the tenancy column. Test approach: role impersonation with User A's JWT, then SELECT/INSERT targeting User B's tenant ID. Expected: zero rows returned, insert rejected. If any row crosses tenants, escalate to CRITICAL.

**Gate:** If multi-tenant and any cross-tenant path exists, stop and report before suggesting fixes.

### Step 6: Policy Performance Review

Flag policies containing subqueries or function calls on columns lacking indexes. RLS policies execute per-row -- an unindexed `org_id IN (SELECT org_id FROM org_members WHERE user_id = auth.uid())` becomes a sequential scan on every access. Decision: use `auth.uid()` for simple ownership; use custom JWT claims (`auth.jwt() ->> 'org_id'`) when the membership lookup is expensive, trading token size for query performance.

### Step 7: Output Report

Deliver: summary counts, severity-classified findings, completeness matrix, fix recommendations (policy SQL), and verification approach. Include the `auth.uid()` vs custom claims recommendation where relevant.

## Examples

**Example 1 -- Missing RLS on payments table:** `payments` has columns `amount`, `card_last4`, RLS disabled. Severity: CRITICAL. Fix: enable RLS + add ownership policies for all four operations with `user_id = auth.uid()` in both USING and WITH CHECK.

**Example 2 -- FK leak path:** `orders` (RLS enabled, filtered by user_id) references `customers` (RLS disabled). Authenticated user can join through the FK to read other users' customer records. Severity: HIGH. Fix: enable RLS on `customers` with matching ownership policy.

## Common Issues

1. **RLS enabled, zero policies** -- Table becomes completely inaccessible (not a security leak but breaks functionality). Always add policies immediately after enabling RLS.
2. **Testing only with service_role** -- service_role bypasses all RLS. Passing tests with service_role proves nothing about policy correctness. Always test with anon/authenticated.
3. **Subquery policies without indexes** -- Policy runs per row. Missing index on the join column (e.g., `org_members.user_id`) turns every query into O(n*m). Add the index before deploying the policy.

## Anti-Patterns

- `USING (true)` on any table containing user-specific data -- equivalent to no RLS.
- Assuming RLS replaces input validation or prevents SQL injection -- RLS controls row visibility per role, nothing else.
- Granting direct database access (connection string) to client-side code -- bypasses Supabase's role system entirely.
- Enabling RLS in migration but deferring policies to "later" -- production tables silently locked out or exposed.

## Escalation

Hand off to database security specialist when: regulated data (PCI, HIPAA, SOC2), contractual multi-tenant isolation (B2B SaaS), complex role hierarchies (inherited permissions), measurable performance degradation from policy overhead, or suspected active cross-tenant data leakage.

## Inputs

- Database connection (Supabase URL + key, or PostgreSQL connection string)
- Schema scope (default: `public`)
- Application roles and multi-tenancy model
- Known sensitive tables

## Outputs

- Table-by-table RLS status with completeness matrix
- Severity-classified vulnerability findings
- Fix recommendations with policy SQL
- Performance observations and auth.uid() vs claims guidance

## Level History

- **Lv.1** -- Base: Full table/policy inventory, 6 vulnerability checks (disabled RLS, overly permissive, missing WITH CHECK, FK leaks, service_role exposure, SECURITY DEFINER functions), role impersonation testing, completeness matrix, 4 policy templates. (Origin: MemStack v3.3, Mar 2026)
- **Lv.2** -- Compressed: Decision-rule density rewrite. Removed full SQL examples, inline templates, and psql commands. Added severity classification table, validation gates, cross-tenant detection protocol, policy performance section with auth.uid() vs claims decision, structured step flow. (Origin: MemStack v3.4, Mar 2026)
