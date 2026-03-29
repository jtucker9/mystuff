---
name: database-architect
description: "Use when the user says 'design database', 'create tables', 'database schema', 'data model', 'ERD', or is designing PostgreSQL/Supabase table structures, relationships, RLS policies, or migrations. Do NOT use for migrating existing schemas (see migration-planner) or API design (see api-designer)."
---

# 🏗️ Database Architect — Schema Design & Data Modeling
*Design production-grade PostgreSQL/Supabase schemas with proper entity modeling, naming conventions, relationships, indexing strategies, Row-Level Security, and migration-ready SQL output.*

## Activation

When this skill activates, output:

`🏗️ Database Architect — Designing your data model...`

| Context | Status |
|---------|--------|
| **User says "design database", "create tables", "database schema"** | ACTIVE |
| **User says "data model", "ERD", "entity relationship"** | ACTIVE |
| **User asks for table structures, column types, or constraints** | ACTIVE |
| **User wants RLS policies as part of new schema design** | ACTIVE |
| **User wants indexing strategy for new tables** | ACTIVE |
| **User wants to ALTER existing tables or migrate schemas** | DORMANT — see migration-planner |
| **User wants API route design over the schema** | DORMANT — see api-designer |
| **User wants to audit existing RLS policies** | DORMANT — see rls-checker |
| **User wants to add RLS to existing unprotected tables** | DORMANT — see rls-guardian |

## Protocol

### Step 1: Gather Inputs

Ask the user for these details before designing. Provide sensible defaults for anything not specified.

| Input | Question | Default |
|-------|----------|---------|
| **Domain** | What does this application do? (e-commerce, SaaS, CRM, social platform) | — (required) |
| **Entities** | What are the core data objects? (users, products, orders, etc.) | — (required) |
| **Relationships** | How do entities relate? (user has many orders, product belongs to category) | Infer from domain |
| **Scale** | Expected row counts? (thousands, millions, billions per table) | Thousands |
| **Platform** | Supabase, raw PostgreSQL, or PostgreSQL + ORM? | Supabase |
| **Multi-tenancy** | Single-tenant, user-isolated, or organization-based? | User-isolated |
| **Auth model** | Supabase Auth, custom JWT, session-based? | Supabase Auth |
| **Soft delete** | Should records be soft-deleted (archived) or hard-deleted? | Soft delete |
| **Audit trail** | Do you need created_by/updated_by tracking or a full audit log? | Timestamps only |
| **Existing schema** | Are there existing tables this must integrate with? | Greenfield |

**Example intake conversation:**

```
User: "Design a database for a project management SaaS"

AI gathers:
  Domain:         Project management SaaS
  Entities:       users, organizations, projects, tasks, comments, labels
  Relationships:  org hasMany users (via membership), org hasMany projects,
                  project hasMany tasks, task hasMany comments,
                  task manyToMany labels
  Scale:          100K users, millions of tasks
  Platform:       Supabase
  Multi-tenancy:  Organization-based
  Auth:           Supabase Auth
  Soft delete:    Yes for tasks/projects, no for comments
  Audit trail:    Timestamps + created_by
```

### Step 2: Entity-Relationship Modeling

Before writing SQL, map out the ERD in text notation. This ensures the user validates the data model before implementation.

**ERD notation conventions:**

```
[EntityA] 1──N [EntityB]       → One-to-Many (EntityA has many EntityB)
[EntityA] 1──1 [EntityB]       → One-to-One
[EntityA] N──N [EntityB]       → Many-to-Many (requires junction table)
[EntityA] 1──N? [EntityB]      → One-to-Many (optional — EntityB may have 0..N)
[EntityA] ──┤ [EntityB]        → EntityB depends on EntityA (cascade delete)
```

**Build the ERD:**

```
── ENTITY-RELATIONSHIP DIAGRAM ──────────────────────

[users] 1──N [org_members] N──1 [organizations]
                                      │
                                      1
                                      │
                                      N
                                 [projects]
                                      │
                                      1
                                      │
                                      N
                                   [tasks] N──N [labels]
                                      │         (via task_labels)
                                      1
                                      │
                                      N
                                  [comments]

Key:
  users ──── org_members ──── organizations  (M:N via junction)
  organizations ──── projects                 (1:N, cascade)
  projects ──── tasks                         (1:N, cascade)
  tasks ──── comments                         (1:N, cascade)
  tasks ──── labels                           (M:N via task_labels)
```

**Cardinality rules:**

| Relationship | Implementation | Junction table? |
|-------------|----------------|-----------------|
| **1:1** | FK with UNIQUE constraint on child | No |
| **1:N** | FK on the "many" side pointing to the "one" side | No |
| **M:N** | Junction table with two FKs forming composite PK | Yes |
| **Self-referencing** | FK on same table (e.g., `parent_id` → `id`) | No |
| **Polymorphic** | Avoid if possible — use junction tables or separate FKs | See Step 4 |

### Step 3: Table Design

Apply these conventions to every table.

**Naming conventions:**

| Element | Convention | Example | Anti-pattern |
|---------|-----------|---------|-------------|
| **Tables** | snake_case, plural | `org_members` | ~~`OrgMember`~~, ~~`org-members`~~ |
| **Columns** | snake_case, singular | `created_at` | ~~`createdAt`~~, ~~`Created_At`~~ |
| **Primary keys** | `id` | `id UUID` | ~~`user_id`~~ as PK on `users` table |
| **Foreign keys** | `{referenced_table_singular}_id` | `project_id` | ~~`proj`~~, ~~`projectID`~~ |
| **Booleans** | `is_` or `has_` prefix | `is_active`, `has_verified_email` | ~~`active`~~, ~~`verified`~~ |
| **Timestamps** | `_at` suffix | `created_at`, `deleted_at` | ~~`creation_date`~~ |
| **Junction tables** | `{tableA}_{tableB}` alphabetically | `task_labels` | ~~`label_task_map`~~ |
| **Indexes** | `idx_{table}_{columns}` | `idx_tasks_project_id` | Auto-generated names |
| **Constraints** | `chk_{table}_{description}` | `chk_tasks_status_valid` | No name (anonymous) |

**Primary key strategy — UUID vs serial:**

| Factor | UUID (`gen_random_uuid()`) | Serial (`BIGSERIAL`) |
|--------|---------------------------|---------------------|
| **Distributed inserts** | Excellent — no coordination | Poor — sequence contention |
| **URL exposure** | Safe — not enumerable | Risky — sequential, guessable |
| **Storage** | 16 bytes | 8 bytes |
| **Index performance** | Slightly worse (random I/O) | Better (sequential) |
| **Supabase default** | Yes — `auth.users.id` is UUID | Not standard |
| **Recommendation** | **Use for all user-facing tables** | Use for high-volume internal tables (logs, events) |

**Standard column set for every table:**

```sql
-- Every table gets these columns
id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()

-- If soft delete is enabled:
deleted_at  TIMESTAMPTZ  -- NULL = active, NOT NULL = soft-deleted

-- If audit tracking is enabled:
created_by  UUID REFERENCES auth.users(id),
updated_by  UUID REFERENCES auth.users(id)
```

**Updated_at trigger (apply to every table):**

```sql
-- Create the function once
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply to each table
CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON tasks
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();
```

**Column type reference:**

| Data | Type | Notes |
|------|------|-------|
| Identifier | `UUID` | `gen_random_uuid()` default |
| Short text | `TEXT` with CHECK | `CHECK (char_length(name) <= 255)` — avoid VARCHAR |
| Long text | `TEXT` | No length limit |
| Email | `TEXT` + CHECK | `CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')` |
| URL | `TEXT` + CHECK | `CHECK (url ~* '^https?://')` |
| Enum-like | `TEXT` + CHECK | `CHECK (status IN ('draft','active','archived'))` |
| Money | `NUMERIC(12,2)` | Never use FLOAT for money |
| Percentage | `NUMERIC(5,2)` + CHECK | `CHECK (rate >= 0 AND rate <= 100)` |
| Boolean | `BOOLEAN` | Default to `false`, never NULL |
| Counter | `INTEGER` + CHECK | `CHECK (count >= 0)` |
| JSON config | `JSONB` | Use for flexible/dynamic fields only |
| Tags/array | `TEXT[]` | Use GIN index for containment queries |
| Timestamp | `TIMESTAMPTZ` | Always use TZ-aware — never `TIMESTAMP` |
| Date only | `DATE` | For birth dates, deadlines without times |
| IP address | `INET` | Native PostgreSQL type |
| Sort order | `INTEGER` | For user-defined ordering |

**CHECK constraints — always name them:**

```sql
-- ❌ BAD: Anonymous constraint
CREATE TABLE tasks (
  status TEXT CHECK (status IN ('todo','in_progress','done'))
);

-- ✅ GOOD: Named constraint with clear intent
CREATE TABLE tasks (
  status TEXT NOT NULL DEFAULT 'todo',
  CONSTRAINT chk_tasks_status_valid
    CHECK (status IN ('todo', 'in_progress', 'done'))
);
```

**Example complete table:**

```sql
CREATE TABLE tasks (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id    UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  created_by    UUID NOT NULL REFERENCES auth.users(id),
  assigned_to   UUID REFERENCES auth.users(id),
  title         TEXT NOT NULL,
  description   TEXT,
  status        TEXT NOT NULL DEFAULT 'todo',
  priority      INTEGER NOT NULL DEFAULT 0,
  position      INTEGER NOT NULL DEFAULT 0,
  due_date      DATE,
  completed_at  TIMESTAMPTZ,
  deleted_at    TIMESTAMPTZ,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT chk_tasks_title_length
    CHECK (char_length(title) BETWEEN 1 AND 500),
  CONSTRAINT chk_tasks_status_valid
    CHECK (status IN ('todo', 'in_progress', 'in_review', 'done', 'cancelled')),
  CONSTRAINT chk_tasks_priority_range
    CHECK (priority BETWEEN 0 AND 4),
  CONSTRAINT chk_tasks_completed_consistency
    CHECK (
      (status = 'done' AND completed_at IS NOT NULL) OR
      (status != 'done' AND completed_at IS NULL)
    )
);

CREATE TRIGGER set_tasks_updated_at
  BEFORE UPDATE ON tasks
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();
```

### Step 4: Relationship Implementation

**Foreign key ON DELETE strategy decision tree:**

```
Does the child make sense without the parent?
│
├── NO → CASCADE
│   Examples: comments without a task, org_members without an org
│   ON DELETE CASCADE — deleting parent removes children
│
├── YES, but needs cleanup → SET NULL
│   Examples: tasks.assigned_to when user is removed
│   ON DELETE SET NULL — column must be nullable
│
├── YES, and must preserve reference → RESTRICT
│   Examples: orders referencing a product (keep order history)
│   ON DELETE RESTRICT — block parent deletion
│
└── YES, use a default → SET DEFAULT
    Examples: tasks.category_id falling back to "Uncategorized"
    ON DELETE SET DEFAULT — column must have a DEFAULT
```

**Standard foreign key implementation:**

```sql
-- 1:N — Project has many tasks
ALTER TABLE tasks
  ADD CONSTRAINT fk_tasks_project
  FOREIGN KEY (project_id) REFERENCES projects(id)
  ON DELETE CASCADE;

-- 1:N — Task optionally assigned to user
ALTER TABLE tasks
  ADD CONSTRAINT fk_tasks_assigned_to
  FOREIGN KEY (assigned_to) REFERENCES auth.users(id)
  ON DELETE SET NULL;

-- M:N — Tasks have many labels (junction table)
CREATE TABLE task_labels (
  task_id   UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
  label_id  UUID NOT NULL REFERENCES labels(id) ON DELETE CASCADE,
  PRIMARY KEY (task_id, label_id)
);

-- 1:1 — User has one profile
CREATE TABLE profiles (
  id         UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name TEXT,
  avatar_url   TEXT,
  bio          TEXT
);
-- Note: PK is the FK itself — guarantees 1:1
```

**Self-referencing (hierarchical data):**

```sql
-- Tasks with subtasks
ALTER TABLE tasks
  ADD COLUMN parent_task_id UUID REFERENCES tasks(id) ON DELETE CASCADE;

-- Index for efficient tree queries
CREATE INDEX idx_tasks_parent_task_id ON tasks(parent_task_id);

-- Recursive CTE to get full subtask tree
WITH RECURSIVE task_tree AS (
  SELECT id, title, parent_task_id, 0 AS depth
  FROM tasks
  WHERE id = :root_task_id

  UNION ALL

  SELECT t.id, t.title, t.parent_task_id, tt.depth + 1
  FROM tasks t
  JOIN task_tree tt ON t.parent_task_id = tt.id
  WHERE t.deleted_at IS NULL
)
SELECT * FROM task_tree ORDER BY depth, title;
```

**Polymorphic associations — avoid the anti-pattern:**

```sql
-- ❌ BAD: Polymorphic — `commentable_type` + `commentable_id`
CREATE TABLE comments (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  commentable_type TEXT,     -- 'task', 'project', 'file'
  commentable_id   UUID,     -- No FK constraint possible!
  body             TEXT
);

-- ✅ GOOD: Separate nullable FKs (works for 2-3 targets)
CREATE TABLE comments (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id     UUID REFERENCES tasks(id) ON DELETE CASCADE,
  project_id  UUID REFERENCES projects(id) ON DELETE CASCADE,
  body        TEXT NOT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT chk_comments_single_parent
    CHECK (num_nonnulls(task_id, project_id) = 1)
);

-- ✅ ALSO GOOD: Separate junction tables (works for many targets)
CREATE TABLE task_comments (
  task_id    UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
  comment_id UUID NOT NULL REFERENCES comments(id) ON DELETE CASCADE,
  PRIMARY KEY (task_id, comment_id)
);

CREATE TABLE project_comments (
  project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  comment_id UUID NOT NULL REFERENCES comments(id) ON DELETE CASCADE,
  PRIMARY KEY (project_id, comment_id)
);
```

### Step 5: Indexing Strategy

**Index type decision tree:**

```
What kind of query are you optimizing?
│
├── Equality or range on scalar columns (=, <, >, BETWEEN, ORDER BY)
│   → B-tree (default)
│   CREATE INDEX idx_tasks_status ON tasks(status);
│
├── Full-text search (LIKE '%term%', tsvector)
│   → GIN on tsvector
│   CREATE INDEX idx_tasks_search ON tasks USING GIN(to_tsvector('english', title || ' ' || description));
│
├── JSONB containment (@>, ?, ?|, ?&)
│   → GIN on JSONB
│   CREATE INDEX idx_tasks_metadata ON tasks USING GIN(metadata);
│
├── Array containment (@>, &&)
│   → GIN on array
│   CREATE INDEX idx_tasks_tags ON tasks USING GIN(tags);
│
├── Geometric/spatial queries (PostGIS, range types)
│   → GiST
│   CREATE INDEX idx_locations_coords ON locations USING GIST(coordinates);
│
└── Trigram similarity (ILIKE '%partial%', pg_trgm)
    → GIN with trigram extension
    CREATE EXTENSION IF NOT EXISTS pg_trgm;
    CREATE INDEX idx_users_name_trgm ON users USING GIN(name gin_trgm_ops);
```

**Composite indexes — column order matters:**

```sql
-- Query: WHERE project_id = ? AND status = ? ORDER BY created_at DESC
-- Index must match: equality columns first, then range/sort columns
CREATE INDEX idx_tasks_project_status_created
  ON tasks(project_id, status, created_at DESC);

-- This index serves ALL of these queries efficiently:
--   WHERE project_id = ?
--   WHERE project_id = ? AND status = ?
--   WHERE project_id = ? AND status = ? ORDER BY created_at DESC
-- But NOT:
--   WHERE status = ?            (skips leading column)
--   WHERE created_at > ?        (skips leading columns)
```

**Partial indexes — index only what you query:**

```sql
-- Only index active (non-deleted) tasks — much smaller index
CREATE INDEX idx_tasks_active_project
  ON tasks(project_id, status)
  WHERE deleted_at IS NULL;

-- Only index unresolved tasks for the dashboard query
CREATE INDEX idx_tasks_unresolved
  ON tasks(assigned_to, due_date)
  WHERE status NOT IN ('done', 'cancelled') AND deleted_at IS NULL;

-- Only index verified users
CREATE INDEX idx_users_verified_email
  ON users(email)
  WHERE has_verified_email = true;
```

**Covering indexes (INCLUDE) — avoid heap lookups:**

```sql
-- Query: SELECT id, title, status FROM tasks WHERE project_id = ? AND deleted_at IS NULL
-- Include non-filtered columns so Postgres can answer from the index alone
CREATE INDEX idx_tasks_project_covering
  ON tasks(project_id)
  INCLUDE (title, status)
  WHERE deleted_at IS NULL;
```

**Unique indexes as constraints:**

```sql
-- User can only be a member of an org once
CREATE UNIQUE INDEX idx_org_members_unique
  ON org_members(organization_id, user_id);

-- Unique email but only for active (non-deleted) users
CREATE UNIQUE INDEX idx_users_unique_email_active
  ON users(email)
  WHERE deleted_at IS NULL;

-- Unique slug per project (soft-delete aware)
CREATE UNIQUE INDEX idx_projects_unique_slug
  ON projects(organization_id, slug)
  WHERE deleted_at IS NULL;
```

**When NOT to index:**

| Scenario | Why |
|----------|-----|
| **Low-cardinality columns** (e.g., `is_active` with 90% true) | B-tree scan not much faster than sequential scan — use partial index instead |
| **Write-heavy tables with rare reads** (event logs, audit trails) | Each index slows INSERT/UPDATE — only index if you query it |
| **Small tables (< 10K rows)** | Sequential scan is faster than index lookup at small scale |
| **Columns updated frequently** | Index maintenance on every UPDATE — only if the read benefit justifies it |
| **Already covered by another index** | Leading columns of a composite index cover single-column queries |

**Standard indexes for every schema:**

```sql
-- Always index foreign keys (PostgreSQL does NOT auto-index FKs)
CREATE INDEX idx_tasks_project_id ON tasks(project_id);
CREATE INDEX idx_tasks_assigned_to ON tasks(assigned_to);
CREATE INDEX idx_tasks_created_by ON tasks(created_by);
CREATE INDEX idx_comments_task_id ON comments(task_id);
CREATE INDEX idx_org_members_user_id ON org_members(user_id);
CREATE INDEX idx_org_members_org_id ON org_members(organization_id);

-- Always index soft-delete filter columns
CREATE INDEX idx_tasks_deleted_at ON tasks(deleted_at) WHERE deleted_at IS NULL;

-- Always index created_at for time-based queries and pagination
CREATE INDEX idx_tasks_created_at ON tasks(created_at DESC);
```

### Step 6: Row-Level Security

**Only apply this step if the platform is Supabase or the user explicitly wants RLS.**

**RLS activation pattern:**

```sql
-- ALWAYS enable RLS and add policies in the SAME migration
-- Enabling RLS without policies locks out all access
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

-- Force RLS for table owners too (Supabase best practice)
ALTER TABLE tasks FORCE ROW LEVEL SECURITY;
```

**Pattern 1: User Ownership (single-user isolation)**

```sql
-- User can only CRUD their own rows
CREATE POLICY "users_select_own" ON tasks
  FOR SELECT TO authenticated
  USING (created_by = auth.uid());

CREATE POLICY "users_insert_own" ON tasks
  FOR INSERT TO authenticated
  WITH CHECK (created_by = auth.uid());

CREATE POLICY "users_update_own" ON tasks
  FOR UPDATE TO authenticated
  USING (created_by = auth.uid())
  WITH CHECK (created_by = auth.uid());

CREATE POLICY "users_delete_own" ON tasks
  FOR DELETE TO authenticated
  USING (created_by = auth.uid());
```

**Pattern 2: Organization Multi-Tenancy**

```sql
-- Helper function: get user's org IDs (cache-friendly)
CREATE OR REPLACE FUNCTION get_user_org_ids()
RETURNS SETOF UUID AS $$
  SELECT organization_id
  FROM org_members
  WHERE user_id = auth.uid()
    AND deleted_at IS NULL;
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Users can access resources in their organizations
CREATE POLICY "org_select" ON projects
  FOR SELECT TO authenticated
  USING (organization_id IN (SELECT get_user_org_ids()));

CREATE POLICY "org_insert" ON projects
  FOR INSERT TO authenticated
  WITH CHECK (organization_id IN (SELECT get_user_org_ids()));

CREATE POLICY "org_update" ON projects
  FOR UPDATE TO authenticated
  USING (organization_id IN (SELECT get_user_org_ids()))
  WITH CHECK (organization_id IN (SELECT get_user_org_ids()));

CREATE POLICY "org_delete" ON projects
  FOR DELETE TO authenticated
  USING (organization_id IN (SELECT get_user_org_ids()));
```

**Pattern 3: Role-Based Access Within Organization**

```sql
-- Helper function: get user's role in a specific org
CREATE OR REPLACE FUNCTION get_user_org_role(org_id UUID)
RETURNS TEXT AS $$
  SELECT role FROM org_members
  WHERE user_id = auth.uid()
    AND organization_id = org_id
    AND deleted_at IS NULL;
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Admins can do everything, members can read and create, viewers can only read
CREATE POLICY "org_admin_all" ON projects
  FOR ALL TO authenticated
  USING (get_user_org_role(organization_id) IN ('owner', 'admin'));

CREATE POLICY "org_member_read" ON projects
  FOR SELECT TO authenticated
  USING (get_user_org_role(organization_id) IN ('owner', 'admin', 'member', 'viewer'));

CREATE POLICY "org_member_insert" ON projects
  FOR INSERT TO authenticated
  WITH CHECK (get_user_org_role(organization_id) IN ('owner', 'admin', 'member'));
```

**Pattern 4: Public Read, Authenticated Write**

```sql
-- Public content visible to everyone, writable by owners
CREATE POLICY "public_read" ON blog_posts
  FOR SELECT TO anon, authenticated
  USING (is_published = true);

CREATE POLICY "owner_read_drafts" ON blog_posts
  FOR SELECT TO authenticated
  USING (author_id = auth.uid());

CREATE POLICY "owner_write" ON blog_posts
  FOR INSERT TO authenticated
  WITH CHECK (author_id = auth.uid());

CREATE POLICY "owner_update" ON blog_posts
  FOR UPDATE TO authenticated
  USING (author_id = auth.uid())
  WITH CHECK (author_id = auth.uid());
```

**Pattern 5: Inherited Access (child inherits parent's policies)**

```sql
-- Comments are accessible if user can access the parent task
CREATE POLICY "comments_via_task" ON comments
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM tasks
      WHERE tasks.id = comments.task_id
      AND tasks.deleted_at IS NULL
      -- This triggers the tasks table's own RLS policies
    )
  );
```

**RLS performance tips:**

- Index every column referenced in USING/WITH CHECK expressions
- Use `SECURITY DEFINER` helper functions for complex subqueries (avoids nested RLS evaluation)
- Mark helper functions as `STABLE` (tells Postgres the result won't change within a transaction)
- Prefer `EXISTS` over `IN` for correlated subqueries in policies
- Test with `EXPLAIN ANALYZE` after setting role: `SET ROLE authenticated; SET request.jwt.claims = '{"sub":"..."}';`

### Step 7: Migration Generation

Generate migration SQL ready for `supabase migration new` or raw `psql`.

**Supabase CLI workflow:**

```bash
# Create a new migration file
supabase migration new create_project_tables

# This creates: supabase/migrations/YYYYMMDDHHMMSS_create_project_tables.sql
# Paste the generated SQL into this file

# Test locally
supabase db reset

# Push to remote
supabase db push
```

**Migration file structure:**

```sql
-- Migration: create_project_tables
-- Description: Core schema for project management SaaS
-- Author: database-architect skill
-- Date: YYYY-MM-DD

-- ============================================================
-- EXTENSIONS
-- ============================================================
CREATE EXTENSION IF NOT EXISTS "pgcrypto";   -- for gen_random_uuid() if needed
CREATE EXTENSION IF NOT EXISTS "pg_trgm";    -- for trigram search indexes

-- ============================================================
-- FUNCTIONS
-- ============================================================
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- TABLES (ordered by dependency — parents before children)
-- ============================================================

-- 1. Organizations
CREATE TABLE organizations (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name        TEXT NOT NULL,
  slug        TEXT NOT NULL,
  avatar_url  TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at  TIMESTAMPTZ,

  CONSTRAINT chk_organizations_name_length
    CHECK (char_length(name) BETWEEN 1 AND 255),
  CONSTRAINT chk_organizations_slug_format
    CHECK (slug ~* '^[a-z0-9][a-z0-9-]{1,62}[a-z0-9]$')
);

CREATE UNIQUE INDEX idx_organizations_unique_slug
  ON organizations(slug) WHERE deleted_at IS NULL;

CREATE TRIGGER set_organizations_updated_at
  BEFORE UPDATE ON organizations
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- 2. Organization members (junction: users <-> organizations)
CREATE TABLE org_members (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id   UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  user_id           UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role              TEXT NOT NULL DEFAULT 'member',
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at        TIMESTAMPTZ,

  CONSTRAINT chk_org_members_role_valid
    CHECK (role IN ('owner', 'admin', 'member', 'viewer'))
);

CREATE UNIQUE INDEX idx_org_members_unique_membership
  ON org_members(organization_id, user_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_org_members_user_id ON org_members(user_id);
CREATE INDEX idx_org_members_org_id ON org_members(organization_id);

CREATE TRIGGER set_org_members_updated_at
  BEFORE UPDATE ON org_members
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- 3. Projects
CREATE TABLE projects (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id   UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  created_by        UUID NOT NULL REFERENCES auth.users(id),
  name              TEXT NOT NULL,
  slug              TEXT NOT NULL,
  description       TEXT,
  is_archived       BOOLEAN NOT NULL DEFAULT false,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at        TIMESTAMPTZ,

  CONSTRAINT chk_projects_name_length
    CHECK (char_length(name) BETWEEN 1 AND 255)
);

CREATE UNIQUE INDEX idx_projects_unique_slug_per_org
  ON projects(organization_id, slug) WHERE deleted_at IS NULL;
CREATE INDEX idx_projects_org_id ON projects(organization_id);
CREATE INDEX idx_projects_created_by ON projects(created_by);

CREATE TRIGGER set_projects_updated_at
  BEFORE UPDATE ON projects
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- 4. Tasks
CREATE TABLE tasks (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id      UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
  created_by      UUID NOT NULL REFERENCES auth.users(id),
  assigned_to     UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  parent_task_id  UUID REFERENCES tasks(id) ON DELETE CASCADE,
  title           TEXT NOT NULL,
  description     TEXT,
  status          TEXT NOT NULL DEFAULT 'todo',
  priority        INTEGER NOT NULL DEFAULT 0,
  position        INTEGER NOT NULL DEFAULT 0,
  due_date        DATE,
  completed_at    TIMESTAMPTZ,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  deleted_at      TIMESTAMPTZ,

  CONSTRAINT chk_tasks_title_length
    CHECK (char_length(title) BETWEEN 1 AND 500),
  CONSTRAINT chk_tasks_status_valid
    CHECK (status IN ('todo', 'in_progress', 'in_review', 'done', 'cancelled')),
  CONSTRAINT chk_tasks_priority_range
    CHECK (priority BETWEEN 0 AND 4)
);

CREATE INDEX idx_tasks_project_id ON tasks(project_id);
CREATE INDEX idx_tasks_assigned_to ON tasks(assigned_to);
CREATE INDEX idx_tasks_created_by ON tasks(created_by);
CREATE INDEX idx_tasks_parent_task_id ON tasks(parent_task_id);
CREATE INDEX idx_tasks_project_status
  ON tasks(project_id, status) WHERE deleted_at IS NULL;
CREATE INDEX idx_tasks_created_at ON tasks(created_at DESC);

CREATE TRIGGER set_tasks_updated_at
  BEFORE UPDATE ON tasks
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- 5. Labels
CREATE TABLE labels (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  organization_id   UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  name              TEXT NOT NULL,
  color             TEXT NOT NULL DEFAULT '#6B7280',
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT chk_labels_name_length
    CHECK (char_length(name) BETWEEN 1 AND 50),
  CONSTRAINT chk_labels_color_hex
    CHECK (color ~* '^#[0-9A-Fa-f]{6}$')
);

CREATE UNIQUE INDEX idx_labels_unique_name_per_org
  ON labels(organization_id, name);
CREATE INDEX idx_labels_org_id ON labels(organization_id);

-- 6. Task-Label junction
CREATE TABLE task_labels (
  task_id   UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
  label_id  UUID NOT NULL REFERENCES labels(id) ON DELETE CASCADE,
  PRIMARY KEY (task_id, label_id)
);

-- 7. Comments
CREATE TABLE comments (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  task_id     UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
  created_by  UUID NOT NULL REFERENCES auth.users(id),
  body        TEXT NOT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT chk_comments_body_not_empty
    CHECK (char_length(body) >= 1)
);

CREATE INDEX idx_comments_task_id ON comments(task_id);
CREATE INDEX idx_comments_created_by ON comments(created_by);

CREATE TRIGGER set_comments_updated_at
  BEFORE UPDATE ON comments
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ============================================================
-- ROW LEVEL SECURITY
-- ============================================================

-- Helper: get org IDs for current user
CREATE OR REPLACE FUNCTION get_user_org_ids()
RETURNS SETOF UUID AS $$
  SELECT organization_id FROM org_members
  WHERE user_id = auth.uid() AND deleted_at IS NULL;
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- Organizations: members can read, owners/admins can write
ALTER TABLE organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE organizations FORCE ROW LEVEL SECURITY;

CREATE POLICY "org_select" ON organizations
  FOR SELECT TO authenticated
  USING (id IN (SELECT get_user_org_ids()));

CREATE POLICY "org_insert" ON organizations
  FOR INSERT TO authenticated
  WITH CHECK (true);  -- Anyone can create an org

CREATE POLICY "org_update" ON organizations
  FOR UPDATE TO authenticated
  USING (id IN (
    SELECT organization_id FROM org_members
    WHERE user_id = auth.uid() AND role IN ('owner', 'admin') AND deleted_at IS NULL
  ));

-- Org members: visible to fellow members
ALTER TABLE org_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE org_members FORCE ROW LEVEL SECURITY;

CREATE POLICY "org_members_select" ON org_members
  FOR SELECT TO authenticated
  USING (organization_id IN (SELECT get_user_org_ids()));

CREATE POLICY "org_members_manage" ON org_members
  FOR ALL TO authenticated
  USING (organization_id IN (
    SELECT organization_id FROM org_members
    WHERE user_id = auth.uid() AND role IN ('owner', 'admin') AND deleted_at IS NULL
  ));

-- Projects: org members can read, members+ can write
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects FORCE ROW LEVEL SECURITY;

CREATE POLICY "projects_select" ON projects
  FOR SELECT TO authenticated
  USING (organization_id IN (SELECT get_user_org_ids()));

CREATE POLICY "projects_insert" ON projects
  FOR INSERT TO authenticated
  WITH CHECK (organization_id IN (SELECT get_user_org_ids()));

CREATE POLICY "projects_update" ON projects
  FOR UPDATE TO authenticated
  USING (organization_id IN (SELECT get_user_org_ids()));

CREATE POLICY "projects_delete" ON projects
  FOR DELETE TO authenticated
  USING (organization_id IN (
    SELECT organization_id FROM org_members
    WHERE user_id = auth.uid() AND role IN ('owner', 'admin') AND deleted_at IS NULL
  ));

-- Tasks: accessible if user can access the parent project
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasks FORCE ROW LEVEL SECURITY;

CREATE POLICY "tasks_select" ON tasks
  FOR SELECT TO authenticated
  USING (EXISTS (
    SELECT 1 FROM projects
    WHERE projects.id = tasks.project_id
    AND projects.organization_id IN (SELECT get_user_org_ids())
  ));

CREATE POLICY "tasks_insert" ON tasks
  FOR INSERT TO authenticated
  WITH CHECK (EXISTS (
    SELECT 1 FROM projects
    WHERE projects.id = tasks.project_id
    AND projects.organization_id IN (SELECT get_user_org_ids())
  ));

CREATE POLICY "tasks_update" ON tasks
  FOR UPDATE TO authenticated
  USING (EXISTS (
    SELECT 1 FROM projects
    WHERE projects.id = tasks.project_id
    AND projects.organization_id IN (SELECT get_user_org_ids())
  ));

CREATE POLICY "tasks_delete" ON tasks
  FOR DELETE TO authenticated
  USING (EXISTS (
    SELECT 1 FROM projects
    WHERE projects.id = tasks.project_id
    AND projects.organization_id IN (SELECT get_user_org_ids())
  ));

-- Comments: accessible via task -> project -> org chain
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments FORCE ROW LEVEL SECURITY;

CREATE POLICY "comments_select" ON comments
  FOR SELECT TO authenticated
  USING (EXISTS (
    SELECT 1 FROM tasks
    JOIN projects ON projects.id = tasks.project_id
    WHERE tasks.id = comments.task_id
    AND projects.organization_id IN (SELECT get_user_org_ids())
  ));

CREATE POLICY "comments_insert" ON comments
  FOR INSERT TO authenticated
  WITH CHECK (
    created_by = auth.uid()
    AND EXISTS (
      SELECT 1 FROM tasks
      JOIN projects ON projects.id = tasks.project_id
      WHERE tasks.id = comments.task_id
      AND projects.organization_id IN (SELECT get_user_org_ids())
    )
  );

CREATE POLICY "comments_update_own" ON comments
  FOR UPDATE TO authenticated
  USING (created_by = auth.uid());

CREATE POLICY "comments_delete_own" ON comments
  FOR DELETE TO authenticated
  USING (created_by = auth.uid());

-- Labels: org-scoped
ALTER TABLE labels ENABLE ROW LEVEL SECURITY;
ALTER TABLE labels FORCE ROW LEVEL SECURITY;

CREATE POLICY "labels_select" ON labels
  FOR SELECT TO authenticated
  USING (organization_id IN (SELECT get_user_org_ids()));

CREATE POLICY "labels_manage" ON labels
  FOR ALL TO authenticated
  USING (organization_id IN (SELECT get_user_org_ids()));

-- Task labels: accessible via task
ALTER TABLE task_labels ENABLE ROW LEVEL SECURITY;
ALTER TABLE task_labels FORCE ROW LEVEL SECURITY;

CREATE POLICY "task_labels_select" ON task_labels
  FOR SELECT TO authenticated
  USING (EXISTS (
    SELECT 1 FROM tasks
    JOIN projects ON projects.id = tasks.project_id
    WHERE tasks.id = task_labels.task_id
    AND projects.organization_id IN (SELECT get_user_org_ids())
  ));

CREATE POLICY "task_labels_manage" ON task_labels
  FOR ALL TO authenticated
  USING (EXISTS (
    SELECT 1 FROM tasks
    JOIN projects ON projects.id = tasks.project_id
    WHERE tasks.id = task_labels.task_id
    AND projects.organization_id IN (SELECT get_user_org_ids())
  ));

-- ============================================================
-- AUDIT LOG (optional — include if user requested audit trail)
-- ============================================================

CREATE TABLE audit_log (
  id          BIGSERIAL PRIMARY KEY,  -- Serial for high-volume append-only
  table_name  TEXT NOT NULL,
  record_id   UUID NOT NULL,
  action      TEXT NOT NULL,  -- INSERT, UPDATE, DELETE
  old_data    JSONB,
  new_data    JSONB,
  changed_by  UUID REFERENCES auth.users(id),
  changed_at  TIMESTAMPTZ NOT NULL DEFAULT now(),

  CONSTRAINT chk_audit_log_action_valid
    CHECK (action IN ('INSERT', 'UPDATE', 'DELETE'))
);

CREATE INDEX idx_audit_log_table_record ON audit_log(table_name, record_id);
CREATE INDEX idx_audit_log_changed_at ON audit_log(changed_at DESC);
CREATE INDEX idx_audit_log_changed_by ON audit_log(changed_by);

-- Generic audit trigger function
CREATE OR REPLACE FUNCTION audit_trigger()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO audit_log (table_name, record_id, action, new_data, changed_by)
    VALUES (TG_TABLE_NAME, NEW.id, 'INSERT', to_jsonb(NEW), auth.uid());
    RETURN NEW;
  ELSIF TG_OP = 'UPDATE' THEN
    INSERT INTO audit_log (table_name, record_id, action, old_data, new_data, changed_by)
    VALUES (TG_TABLE_NAME, NEW.id, 'UPDATE', to_jsonb(OLD), to_jsonb(NEW), auth.uid());
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO audit_log (table_name, record_id, action, old_data, changed_by)
    VALUES (TG_TABLE_NAME, OLD.id, 'DELETE', to_jsonb(OLD), auth.uid());
    RETURN OLD;
  END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Apply to tables that need auditing
CREATE TRIGGER audit_tasks
  AFTER INSERT OR UPDATE OR DELETE ON tasks
  FOR EACH ROW EXECUTE FUNCTION audit_trigger();
```

### Step 8: Output

After generating the schema, present this summary:

```
━━━ DATABASE ARCHITECT — SCHEMA REPORT ━━━━━━━━

── DATA MODEL ───────────────────────────────────
Domain:       [project management SaaS]
Tables:       [7] (+ 1 audit log)
Relationships: [6] foreign keys, [2] junction tables
Multi-tenancy: [organization-based via org_members]

── ENTITY-RELATIONSHIP DIAGRAM ──────────────────
[Text ERD from Step 2]

── TABLES ───────────────────────────────────────
  organizations     — Tenant boundary
  org_members       — User <-> Org junction (M:N with role)
  projects          — Scoped to organization
  tasks             — Scoped to project, supports subtasks
  labels            — Org-wide, reusable across projects
  task_labels       — Task <-> Label junction (M:N)
  comments          — Scoped to task
  audit_log         — Append-only change history

── INDEXES ──────────────────────────────────────
  [N] indexes total
  [N] foreign key indexes
  [N] unique indexes
  [N] partial indexes
  [N] composite indexes

── ROW LEVEL SECURITY ───────────────────────────
  All [N] tables: RLS enabled + forced
  Pattern: Organization multi-tenancy via get_user_org_ids()
  Helper functions: [list]

── MIGRATION FILES ──────────────────────────────
  supabase/migrations/YYYYMMDDHHMMSS_create_project_tables.sql

── NEXT STEPS ───────────────────────────────────
  1. Review the ERD and confirm entity relationships
  2. Run `supabase migration new create_project_tables` and paste SQL
  3. Run `supabase db reset` to test locally
  4. Test RLS with role impersonation queries
  5. Add seed data for development
  6. Update Ctrl+A → F9 if using field codes in related docs
```

## Common Schema Patterns

### Pattern A: User Profiles (extending Supabase Auth)

```sql
-- Extend auth.users with app-specific profile data
CREATE TABLE profiles (
  id            UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name  TEXT,
  avatar_url    TEXT,
  bio           TEXT,
  timezone      TEXT DEFAULT 'UTC',
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Auto-create profile on user signup via Supabase trigger
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, display_name)
  VALUES (NEW.id, NEW.raw_user_meta_data->>'display_name');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();
```

### Pattern B: Multi-Tenant SaaS (Organizations)

```sql
-- Organization with membership and roles
CREATE TABLE organizations (
  id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name  TEXT NOT NULL,
  slug  TEXT NOT NULL UNIQUE
);

CREATE TABLE org_members (
  organization_id  UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE,
  user_id          UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role             TEXT NOT NULL DEFAULT 'member'
                   CHECK (role IN ('owner','admin','member','viewer')),
  PRIMARY KEY (organization_id, user_id)
);

-- Every tenant-scoped table includes organization_id
-- RLS filters by org membership
```

### Pattern C: Soft Delete with Active Record Views

```sql
-- Create views that exclude soft-deleted rows for application use
CREATE VIEW active_tasks AS
  SELECT * FROM tasks WHERE deleted_at IS NULL;

CREATE VIEW active_projects AS
  SELECT * FROM projects WHERE deleted_at IS NULL;

-- Soft delete function
CREATE OR REPLACE FUNCTION soft_delete()
RETURNS TRIGGER AS $$
BEGIN
  NEW.deleted_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

### Pattern D: Audit Log

```sql
-- See full audit_log table and trigger in Step 7 migration output
-- Query patterns:

-- Get full history for a specific record
SELECT * FROM audit_log
WHERE table_name = 'tasks' AND record_id = :task_id
ORDER BY changed_at DESC;

-- Get all changes by a specific user
SELECT * FROM audit_log
WHERE changed_by = :user_id
ORDER BY changed_at DESC
LIMIT 50;

-- Get recent changes across all tables
SELECT table_name, action, record_id, changed_at
FROM audit_log
ORDER BY changed_at DESC
LIMIT 100;
```

## Anti-Patterns

| Anti-Pattern | Problem | Solution |
|-------------|---------|----------|
| **Using VARCHAR(n) instead of TEXT + CHECK** | VARCHAR limit is enforced at storage level, hard to change; TEXT + CHECK is flexible and explicit | Always use `TEXT` with a named CHECK constraint for length limits |
| **No named constraints** | Anonymous constraints produce cryptic error messages (`violates check constraint "tasks_check"`) | Always use `CONSTRAINT chk_{table}_{description}` |
| **TIMESTAMP without time zone** | Ambiguous — depends on server/session timezone. Leads to subtle bugs across time zones | Always use `TIMESTAMPTZ` |
| **Using FLOAT/REAL for money** | Floating-point rounding errors accumulate | Use `NUMERIC(12,2)` for monetary values |
| **Polymorphic `_type` + `_id` columns** | Cannot enforce FK constraints, no referential integrity | Use separate nullable FKs with CHECK, or junction tables |
| **Not indexing foreign keys** | PostgreSQL does not auto-create indexes on FK columns — joins and cascading deletes become full table scans | Create an index on every FK column |
| **Enabling RLS without adding policies** | Locks out ALL access including your application | Always add policies in the same migration as `ENABLE ROW LEVEL SECURITY` |
| **`USING (true)` on sensitive tables** | Equivalent to no RLS — all rows visible to all authenticated users | Use specific ownership or membership conditions |
| **Missing WITH CHECK on INSERT/UPDATE policies** | USING controls reads; without WITH CHECK, users can insert rows they should not own | Always pair USING with WITH CHECK on write operations |
| **Storing computed values that drift** | Redundant columns (e.g., `task_count` on projects) go stale without triggers | Use a view or computed column, or maintain via trigger |
| **Over-indexing** | Every index slows writes and consumes storage | Only index columns used in WHERE, JOIN, and ORDER BY clauses |
| **God tables with 50+ columns** | Hard to query, slow to update, unclear ownership | Split into focused tables with 1:1 relationships |

## Escalation

Hand off to a specialist database architect or DBA when:
- **Sharding or partitioning** is needed (table exceeds hundreds of millions of rows)
- **Cross-database replication** or multi-region requirements
- **Complex permission hierarchies** beyond 2 levels (role within role within tenant)
- **Regulatory compliance** requires specific data residency, encryption-at-rest configurations, or audit certifications
- **Performance tuning** at scale requires `EXPLAIN ANALYZE` expertise, query planner optimization, and connection pooling configuration
- **Time-series data** at high ingest rates — consider TimescaleDB extension
- **Graph relationships** (social networks, recommendation engines) — consider dedicated graph DB or recursive CTE performance limits

## Inputs

- Application domain and core entities
- Entity relationships (1:1, 1:N, M:N)
- Scale expectations (rows per table)
- Platform (Supabase, raw PostgreSQL, PostgreSQL + ORM)
- Multi-tenancy model
- Authentication model
- Soft delete and audit trail requirements
- Existing schema constraints (if integrating)

## Outputs

- Text-based Entity-Relationship Diagram
- Complete CREATE TABLE statements with constraints and triggers
- Index recommendations with rationale
- RLS policies (if Supabase)
- Migration-ready SQL file
- Schema summary report
- Common query patterns for the generated schema

## Level History

- **Lv.1** — Base: Full schema design protocol covering entity modeling, table design conventions (naming, UUID vs serial, column types, CHECK constraints), relationship implementation (FK strategies, junction tables, self-referencing, polymorphic alternatives), indexing strategy (B-tree/GIN/GiST, composite, partial, covering, when NOT to index), RLS patterns (ownership, org multi-tenancy, role-based, public/private, inherited access), migration generation with Supabase CLI workflow, common schema patterns (profiles, multi-tenant, soft delete, audit log), anti-patterns table, escalation criteria. (Origin: MemStack v3.3, Mar 2026)
