---
name: migration-planner
description: "Plan safe database schema migrations with rollback strategies. WHEN: 'migration', 'schema change', 'database migration', 'alter table', zero-downtime schema evolution. NOT: code refactoring (refactor-planner), writing tests (test-writer), API data sync (api-integration)."
---

# Migration Planner — Safe Database Schema Evolution

## Activation

| Context | Status |
|---------|--------|
| User says "migration", "schema change", "alter table" | ACTIVE |
| Rollback strategy, zero-downtime, breaking changes | ACTIVE |
| Code refactoring, not schema | DORMANT — refactor-planner |
| Writing tests for migration code | DORMANT — test-writer |

Output on activation: `Migration Planner — Planning your database migration...`

## Instructions

### Step 1: Gather Context

Collect before proceeding:
- **Current schema** vs **desired schema** (SQL, ORM models, or description)
- **Database**: PostgreSQL, MySQL, SQLite, MongoDB
- **ORM**: Prisma, Drizzle, Knex, TypeORM, raw SQL, Supabase CLI
- **Production?** Live data, row counts for affected tables
- **Downtime tolerance**: offline OK vs zero-downtime required

**Gate**: Must know database type + current/desired schema before Step 2.

### Step 2: Classify Changes

Categorize every schema diff into one of four migration types:

| Type | Examples | Default Risk |
|------|----------|-------------|
| **Additive** | ADD nullable column, ADD table, ADD index | Low |
| **Destructive** | DROP column/table, CHANGE type with data loss | High |
| **Data Transform** | Backfill, type conversion preserving data, split column | Medium |
| **Rename** | RENAME column/table (breaks all existing queries) | High |

Risk assessment matrix per change:

| Change | Risk | Why |
|--------|------|-----|
| ADD column (nullable/default) | Low | No existing data affected |
| ADD column (NOT NULL, no default) | Medium | Needs backfill first |
| ADD index on large table | Medium | Table lock during creation (use CONCURRENTLY on PG) |
| ADD constraint/FK | Medium | Existing data may violate |
| RENAME column | High | Breaks all queries using old name |
| CHANGE column type | High | Possible data loss or truncation |
| DROP column/table | High | Irreversible data loss |

**Gate**: Every change must have a type classification and risk level before Step 3.

### Step 3: Choose Migration Strategy

**Decision tree based on risk + downtime tolerance:**

- **Low risk + any tolerance** -> Direct migration (single UP/DOWN script)
- **Medium/High risk + downtime OK** -> Maintenance window migration (backup, migrate, verify, resume)
- **Medium/High risk + zero-downtime** -> Expand-contract pattern (see below)

**Expand-contract (zero-downtime) phases:**

1. **Expand**: Add new column/table (nullable). Old code unaffected.
2. **Dual-write**: Deploy code writing to both old and new. Backfill existing rows.
3. **Contract**: Switch reads to new. Stop writing old. Drop old after 24h hold.

For **renames**: add new column -> dual-write -> backfill -> switch reads -> drop old.
For **type changes**: add new typed column -> transform + dual-write -> switch -> drop old.

**Gate**: Strategy chosen and phases outlined before generating scripts.

### Step 4: Determine Dependency Order

Rules for migration sequencing:
1. **Independent tables** (no FKs) migrate first
2. **Parent/referenced tables** before children
3. **Child/referencing tables** after their parents exist
4. **Indexes and constraints** after data is in place
5. **Data backfills** after schema changes, before NOT NULL constraints
6. **Cleanup** (drops) last, after 24h hold

Drop foreign keys BEFORE dropping referenced tables. Add foreign keys AFTER both tables exist with valid data.

**Gate**: Dependency graph documented before writing migration files.

### Step 5: Generate Migration Plan

For each change, produce:
- **UP script** with numbered steps and comments
- **DOWN script** reversing each step
- **Data migration** with batching (1000-10000 rows) and `pg_sleep()` between batches for large tables

**Rollback strategy decision per change:**

| Change | Rollback | Data Loss? |
|--------|----------|-----------|
| ADD column | DROP column | No |
| Backfill | No action (old column intact) | No |
| ADD NOT NULL | DROP NOT NULL | No |
| DROP column | CANNOT rollback | YES |
| RENAME | RENAME back | No |
| CHANGE type | CHANGE back (if reversible) | Maybe |

**Destructive operations** (DROP, irreversible type changes): 24-hour hold period. Deploy migration, wait, verify no code references old schema, then drop.

**Supabase CLI workflow**: `supabase migration new <name>` -> edit SQL in `supabase/migrations/` -> `supabase db push` (staging) -> `supabase db push` (production). Always test in staging/local first.

### Step 6: Breaking Change Audit

Before finalizing, grep the codebase for every renamed/dropped/retyped column. Flag:
- INSERT/UPDATE statements missing new NOT NULL columns
- SELECT/WHERE referencing renamed or dropped columns
- ORM model definitions out of sync with new schema
- Orphaned rows that would violate new foreign keys

### Step 7: Testing Approach

Choose based on risk level:
- **Low risk**: Run in staging, verify with spot checks
- **Medium risk**: Shadow migration — run against production data copy, compare results
- **High risk**: Canary migration — apply to small partition first, monitor error rates, then full rollout

Always: backup before starting, verify data integrity after each step, monitor error rates during deployment, keep rollback scripts ready for 24h.

## Examples

**Example 1 — Additive, zero-downtime**: User wants to add `email` (unique, NOT NULL) to `users` table in production PostgreSQL.
Strategy: Expand-contract. Phase 1: `ADD COLUMN email TEXT` (nullable). Phase 2: backfill emails from auth provider, dual-write. Phase 3: `ADD UNIQUE CONSTRAINT`, `SET NOT NULL`. Phase 4: drop dual-write code. Single migration file, batched backfill, tested DOWN script drops column.

**Example 2 — Rename, zero-downtime**: Rename `orders.amount` to `orders.amount_cents` (type change from DECIMAL to INTEGER).
Strategy: Expand-contract with data transform. Add `amount_cents INT` -> dual-write both -> batch-convert `(amount * 100)::INT` -> switch reads to `amount_cents` -> stop writing `amount` -> 24h hold -> drop `amount`. Six-phase plan, two migration files.

## Common Issues

1. **Table locks on large tables**: Use `CREATE INDEX CONCURRENTLY` (PostgreSQL) for indexes. Batch data updates with sleep intervals. Avoid `ALTER TABLE ... SET NOT NULL` on huge tables without prior backfill.
2. **Orphaned foreign key data**: Always check for orphaned rows BEFORE adding FK constraints. Clean up violations first or the constraint will fail.
3. **ORM cache staleness**: After schema changes, ORM clients may cache old schema. Restart application servers or invalidate connection pools after migration.

## Anti-Patterns

- Dropping columns in the same migration that adds replacements (no rollback path)
- Running destructive migrations without a tested DOWN script
- Skipping staging and running directly in production
- Backfilling millions of rows in a single UPDATE (locks table, kills performance)
- Adding NOT NULL constraint before verifying all rows have values

## Escalation

- **50+ tables affected or cross-database migration**: Recommend dedicated DBA review
- **Multi-service schema dependency**: Map all consuming services before migrating; coordinate deploy order
- **Regulatory/compliance data**: Flag PII column changes for legal review before execution

## Inputs

- Current schema (SQL, ORM models, or description)
- Desired schema changes
- Database type and ORM
- Production status and data volume
- Downtime tolerance

## Outputs

- Schema diff with risk classification per change
- Migration strategy (direct, maintenance window, or expand-contract)
- Ordered migration files with UP/DOWN scripts
- Data migration approach with batching strategy
- Rollback plan per step with data loss flags
- Breaking change audit results
- Testing recommendation (staging/shadow/canary)
- Deployment checklist

## Level History

- **Lv.1** — Base: Schema diff analysis with risk categorization, UP/DOWN migration scripts (raw SQL + Prisma + Drizzle), batched data migrations, zero-downtime phased deployment, per-step rollback plans, breaking change detection, FK dependency ordering, deployment checklist. (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** — Compressed: Creator-level density rewrite. Decision-tree structure, four migration type classifications, expand-contract pattern, rollback strategy table, dependency ordering rules, shadow/canary testing tiers, Supabase CLI workflow, escalation criteria. Removed: full SQL scripts, complete ORM examples, verbose output templates. (Origin: MemStack v3.3, Mar 2026)
