---
name: database-architect
description: "Design PostgreSQL/Supabase schemas with entity modeling, naming conventions, relationships, indexing, RLS, and migration-ready output. Activate for 'design database', 'create tables', 'database schema', 'data model', 'ERD'. Do NOT activate for altering existing schemas (migration-planner), API route design (api-designer), or auditing existing RLS (rls-checker/rls-guardian)."
---

# Database Architect

## Activation

| Context | Status |
|---------|--------|
| Design new tables, schema, data model, ERD | ACTIVE |
| RLS policies or indexing as part of new schema | ACTIVE |
| ALTER existing tables, migrate schemas | DORMANT — migration-planner |
| API route design over schema | DORMANT — api-designer |
| Audit or add RLS to existing tables | DORMANT — rls-checker / rls-guardian |

## Instructions

### Step 1: Gather Inputs

Collect before designing; default anything unspecified.

| Input | Default |
|-------|---------|
| Domain (what the app does) | required |
| Core entities and relationships | required |
| Scale (rows per table) | thousands |
| Platform | Supabase |
| Multi-tenancy (single, user-isolated, org-based) | user-isolated |
| Auth model | Supabase Auth |
| Soft delete | yes |
| Audit trail | timestamps only |
| Existing schema to integrate with | greenfield |

**Gate:** Do not proceed until domain and entities are confirmed.

### Step 2: Entity-Relationship Modeling

Map the ERD in text notation before any SQL. Use: `1--N` (one-to-many), `1--1`, `N--N` (needs junction), `--\|` (cascade dependency). Present to user for validation.

Cardinality rules: 1:1 = FK with UNIQUE on child. 1:N = FK on many side. M:N = junction table with composite PK. Self-referencing = FK to own table (`parent_id`). Polymorphic = avoid (see Anti-Patterns).

**Gate:** User must confirm ERD before proceeding to table design.

### Step 3: Table Design

Naming conventions — enforced on every table, no exceptions:

| Element | Rule | Anti-pattern |
|---------|------|-------------|
| Tables | snake_case, plural | `OrgMember`, `org-members` |
| Columns | snake_case, singular | `createdAt`, `Created_At` |
| PKs | always `id` | `user_id` as PK on users |
| FKs | `{singular_table}_id` | `proj`, `projectID` |
| Booleans | `is_` or `has_` prefix | bare `active`, `verified` |
| Timestamps | `_at` suffix, always `TIMESTAMPTZ` | `TIMESTAMP`, `creation_date` |
| Junctions | `{tableA}_{tableB}` alphabetical | `label_task_map` |
| Indexes | `idx_{table}_{columns}` | auto-generated names |
| Constraints | `chk_{table}_{description}` | anonymous constraints |

UUID vs serial decision: UUID (`gen_random_uuid()`) for all user-facing tables — safe in URLs, no sequence contention, matches Supabase `auth.users.id`. BIGSERIAL only for high-volume internal tables (logs, events) where 8-byte storage and sequential I/O matter.

Every table gets: `id UUID PK DEFAULT gen_random_uuid()`, `created_at TIMESTAMPTZ NOT NULL DEFAULT now()`, `updated_at TIMESTAMPTZ NOT NULL DEFAULT now()`. Add `deleted_at TIMESTAMPTZ` if soft delete. Add `created_by`/`updated_by UUID REFERENCES auth.users(id)` if audit tracking. Apply `update_updated_at()` trigger to every table.

Column type constraints — use these exact types, never the alternatives:

- Short text: `TEXT` + named CHECK for length — never VARCHAR(n)
- Money: `NUMERIC(12,2)` — never FLOAT/REAL
- Enum-like: `TEXT` + CHECK with allowed values — not Postgres ENUM (hard to migrate)
- Boolean: `BOOLEAN DEFAULT false` — never nullable
- Timestamps: `TIMESTAMPTZ` — never bare `TIMESTAMP`
- JSON: `JSONB` only for truly dynamic/flexible fields
- Arrays: `TEXT[]` with GIN index for containment queries

**Gate:** Every constraint must be named. Anonymous constraints are a rejection.

### Step 4: Relationships

ON DELETE strategy decision tree:

- Child meaningless without parent? **CASCADE** (comments without task, org_members without org)
- Child survives but needs cleanup? **SET NULL** (tasks.assigned_to when user removed) — column must be nullable
- Child must preserve reference? **RESTRICT** (orders referencing product — keep history)
- Child should use a fallback? **SET DEFAULT** (tasks.category_id to "Uncategorized") — column must have DEFAULT

Polymorphic associations (`commentable_type` + `commentable_id`) are forbidden — no FK constraint possible. Alternatives: (a) separate nullable FKs with `CHECK (num_nonnulls(task_id, project_id) = 1)` for 2-3 targets, (b) separate junction tables for many targets.

1:1 implementation: PK of child IS the FK (`id UUID PRIMARY KEY REFERENCES parent(id) ON DELETE CASCADE`).

Self-referencing: add `parent_{table_singular}_id` column referencing own `id`, always index it, use recursive CTEs for tree traversal.

**Gate:** Every FK must have an explicit ON DELETE strategy with documented rationale.

### Step 5: Indexing Strategy

Index type selection:

| Query pattern | Index type |
|---------------|-----------|
| Equality, range, ORDER BY on scalars | B-tree (default) |
| Full-text search, tsvector | GIN on tsvector |
| JSONB containment (`@>`, `?`, `?\|`) | GIN on JSONB column |
| Array containment (`@>`, `&&`) | GIN on array column |
| Geometric/spatial, range types | GiST |
| ILIKE '%partial%', fuzzy matching | GIN with `pg_trgm` extension |

Composite index rule: equality columns first, then range/sort columns. Index on `(a, b, c)` serves queries on `(a)`, `(a, b)`, `(a, b, c)` but NOT `(b)` or `(c)` alone.

Partial indexes: filter with WHERE to shrink index size (e.g., `WHERE deleted_at IS NULL` for soft-delete tables).

Covering indexes: use INCLUDE for columns needed in SELECT but not WHERE, avoiding heap lookups.

Mandatory indexes: every FK column (Postgres does NOT auto-index FKs), every `deleted_at` with partial filter, every `created_at DESC` for pagination.

When NOT to index: low-cardinality columns (use partial index instead), write-heavy tables with rare reads, tables under 10K rows, columns already covered by a composite index's leading columns.

**Gate:** Every FK column must have a corresponding index in the output.

### Step 6: Row-Level Security

Skip if platform is not Supabase and user did not request RLS.

Critical rule: always `ENABLE ROW LEVEL SECURITY` and `FORCE ROW LEVEL SECURITY` and add policies in the SAME migration. Enabling without policies locks out all access.

RLS pattern selection by multi-tenancy model:

- **User ownership (single-user isolation):** USING/WITH CHECK on `created_by = auth.uid()` for all operations.
- **Org multi-tenancy:** Create `get_user_org_ids()` helper function (`SECURITY DEFINER STABLE`), filter by `organization_id IN (SELECT get_user_org_ids())`. Roles gate write operations (owner/admin for destructive ops).
- **Role-based within org:** Create `get_user_org_role(org_id)` helper, use role checks in USING clauses (owner/admin = ALL, member = read+create, viewer = read only).
- **Public read, authenticated write:** anon+authenticated SELECT with `is_published = true`, owner-only write with `author_id = auth.uid()`.
- **Inherited access (child via parent):** Use `EXISTS` subquery against parent table, which triggers parent's own RLS policies.

RLS performance rules: index every column in USING/WITH CHECK. Use `SECURITY DEFINER` helpers for complex subqueries. Mark helpers as `STABLE`. Prefer `EXISTS` over `IN` for correlated subqueries.

Never use `USING (true)` on sensitive tables. Always pair USING with WITH CHECK on INSERT/UPDATE policies.

**Gate:** Every table with RLS enabled must have at least one policy per operation (SELECT, INSERT, UPDATE, DELETE).

### Step 7: Migration Generation

Order: extensions, functions, tables (dependency order — parents before children), indexes, RLS policies, triggers.

Supabase workflow: `supabase migration new {name}` creates the file, paste SQL, `supabase db reset` to test locally, `supabase db push` to deploy.

For audit log: use BIGSERIAL PK (high-volume append-only), generic trigger function with `TG_OP`/`TG_TABLE_NAME`, JSONB for old/new data, index on `(table_name, record_id)` and `changed_at DESC`.

Supabase profiles pattern: auto-create profile row on `auth.users` INSERT via trigger with `SECURITY DEFINER`.

**Gate:** Migration must run cleanly on `supabase db reset` — no forward references, no missing dependencies.

### Step 8: Output Summary

Present: domain, table count, relationship count, multi-tenancy model, text ERD, table list with purpose, index summary, RLS pattern used, migration file path, next steps (review ERD, run migration, test RLS, add seed data).

## Examples

**Example 1:** "Design a database for a project management SaaS"
Decisions: org-based multi-tenancy via `org_members` junction with role column, CASCADE from org down to projects/tasks/comments, SET NULL on `tasks.assigned_to`, GIN trigram index on task title for search, org-scoped RLS with `get_user_org_ids()` helper.
Result: 7 tables + audit log, 15+ indexes, full RLS with role-gated writes, single migration file.

**Example 2:** "I need tables for a blog platform with public and draft posts"
Decisions: user-isolated (no orgs), UUID PKs, public-read/owner-write RLS pattern with `is_published` gate, separate nullable FKs for comments on posts vs pages (not polymorphic), GIN index on `to_tsvector` for post search, soft delete on posts only.
Result: 4 tables (profiles, posts, comments, categories), partial index on published posts, dual RLS policies (anon read published, owner read all).

## Common Issues

- **RLS locks out all access after enable:** You enabled RLS without adding policies in the same migration. Always do both atomically.
- **JOIN performance degrades on large tables:** FK columns lack indexes. Postgres does not auto-create FK indexes — add them explicitly.
- **Polymorphic column breaks referential integrity:** Replace `commentable_type`/`commentable_id` with separate nullable FKs and a `num_nonnulls() = 1` CHECK, or use junction tables.

## Anti-Patterns

- VARCHAR(n) instead of TEXT + named CHECK constraint — inflexible, hard to change
- Anonymous constraints — produce cryptic error messages, impossible to reference in migrations
- TIMESTAMP without timezone — ambiguous, timezone-dependent bugs
- FLOAT/REAL for money — rounding errors accumulate
- Polymorphic `_type` + `_id` columns — no FK enforcement possible
- Enabling RLS without policies in the same migration
- `USING (true)` on tables with sensitive data — equivalent to no RLS
- Missing WITH CHECK on INSERT/UPDATE policies — users can write rows they shouldn't own
- Storing computed values without trigger maintenance — data drifts
- Over-indexing — every index slows writes; only index columns in WHERE, JOIN, ORDER BY
- God tables with 50+ columns — split into focused tables with 1:1 relationships

## Escalation

Hand off to specialist DBA when: sharding/partitioning (100M+ rows), multi-region replication, permission hierarchies beyond 2 levels, regulatory data residency, query planner optimization at scale, high-ingest time-series (TimescaleDB), graph relationships exceeding recursive CTE limits.

## Inputs

Domain and core entities (required), relationships, scale, platform, multi-tenancy model, auth model, soft delete/audit preferences, existing schema constraints.

## Outputs

Text ERD, table definitions with named constraints/triggers, index strategy with rationale, RLS policies (if Supabase), migration-ready SQL, schema summary report.

## Level History

- **Lv.1** — Base: Full schema design protocol — entity modeling, naming conventions, UUID/serial decision, column types, CHECK constraints, FK ON DELETE strategies, junction tables, polymorphic alternatives, indexing (B-tree/GIN/GiST/trigram, composite, partial, covering), RLS patterns (ownership, org, role-based, public/private, inherited), migration generation, common patterns, anti-patterns, escalation. (Origin: MemStack v3.3, Mar 2026)
- **Lv.2** — Compressed: Creator-level density rewrite. Removed all SQL code blocks and example migrations. Converted to decision rules, constraints, and validation gates. Added Examples and Common Issues sections. (Origin: MemStack v3.4, Mar 2026)
