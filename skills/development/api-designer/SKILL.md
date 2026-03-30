---
name: api-designer
description: "Use when the user says 'design API', 'API endpoints', 'REST API', 'API designer', 'route structure', 'API architecture', or is designing RESTful API routes, request/response schemas, and endpoint organization. Do NOT use for API security audits (see api-audit) or database design (see database-architect)."
---

# API Designer — RESTful API Architecture

## Activation

| Context | Status |
|---------|--------|
| API endpoint design, route structure, request/response schemas | ACTIVE |
| OpenAPI/Swagger generation, pagination/filtering patterns | ACTIVE |
| GraphQL schema design | ACTIVE — GraphQL mode |
| API security audit | DORMANT — api-audit |
| Database schema/ERD | DORMANT — database-architect |

## Instructions

### Step 1: Gather Inputs

Required: domain, core entities, relationships.
Defaults: JWT auth, RBAC+ownership, URL-path versioning (`/v1/`), custom envelope, Express framework.
Ask: audience (first-party frontend / public third-party / internal microservice) — this changes auth, rate limiting, and documentation depth.

Verify: entities are nouns, relationships have cardinality (1:1, 1:N, M:N), no circular ownership. Clarify before proceeding.

### Step 2: Resource Modeling

Rules — violations of any of these are bugs:
- Nouns only, never verbs. `POST /orders` not `POST /createOrder`.
- Plural collections. `/users` not `/user`.
- Max 2 levels of nesting. Beyond that, flatten with query params: `GET /comments?taskId=X` not `/projects/:pid/tasks/:tid/comments`.
- IDs in path params, filters in query params.
- Non-CRUD actions as sub-resource POSTs: `POST /orders/:id/cancel`.
- Kebab-case for multi-word: `/line-items`.
- `/me` shortcut for current-user singleton.

Build a resource tree for all entities before writing any code. Confirm tree covers all entities from Step 1.

### Step 3: Endpoint Design

**CRUD mapping:**

| Method | Operation | Idempotent | Success Code |
|--------|-----------|-----------|-------------|
| GET | Read | Yes | 200 |
| POST | Create | No | 201 |
| PATCH | Partial update | Yes | 200 |
| PUT | Full replace (rare) | Yes | 200 |
| DELETE | Remove | Yes | 204 |

Prefer PATCH over PUT — send only changed fields.

**Pagination decision:**
- Cursor-based (default): stable under inserts/deletes, O(1) seek, no "jump to page N". Use for feeds, lists, real-time data. Encode cursor as base64url JSON. Fetch `limit + 1` to detect `hasMore`.
- Offset-based: only when users need page numbers (admin dashboards). Degrades at deep offsets. Cap `perPage` at 100.

**Filtering conventions:**
- Exact match: `?status=active`
- Multi-value OR: `?status=active,review`
- Comparison operators via bracket suffix: `?createdAt[gte]=2026-01-01`, `?priority[ne]=low`
- Operators: `eq` (default), `ne`, `gt`, `gte`, `lt`, `lte`, `in`, `nin`, `like`
- Sort: `?sort=-createdAt,priority` (prefix `-` = descending)

**Search:** `GET /search?q=term&type=tasks,comments` — return `highlight`, `score`, and `_links.self`.

**Bulk operations:** `POST|PATCH|DELETE /resources/bulk` — always return partial success: `{ succeeded: [], failed: [{ id, error }] }`.

### Step 4: Response Envelope

Consistent envelope on every response:

**Single resource:** `{ data: { id, type, ...fields }, _links: { self, related... } }`
**Collection:** `{ data: [...], meta: { hasMore, nextCursor, limit, totalItems? }, _links: { self, next } }`
**Error (RFC 7807):** `{ error: { code: "MACHINE_READABLE", status: 422, message: "Human-readable", details: [...] } }`

HATEOAS `_links` should be state-dependent — only include actions valid for the current resource state (e.g., `cancel` only on pending orders).

Common error codes: `validation_error` (422), `not_found` (404), `unauthorized` (401), `forbidden` (403), `conflict` (409), `rate_limited` (429), `internal_error` (500).

### Step 5: Auth Design

**JWT flow:** Access token (15min) + refresh token (7d). Access in `Authorization: Bearer`, refresh in httpOnly cookie or body. Audience and issuer claims required.

**API keys:** Header `X-API-Key`, prefix convention `sk_live_`/`sk_test_`/`pk_live_`, hash before storage (SHA-256), constant-time comparison.

**Rate limiting headers on every response:** `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`. Tier by endpoint sensitivity — strict (5/15min) on auth, standard (100/15min) on reads, bulk (20/min) on batch ops.

### Step 6: Versioning

Default: URL path (`/v1/`). Header-based (`Accept-Version`) only for internal APIs.
On deprecation: set `Deprecation: true`, `Sunset: <date>`, `Link: <migration-guide>` headers. Minimum 6-month sunset window.

### Step 7: OpenAPI Spec

Generate OpenAPI 3.1 YAML covering all endpoints. Include: paths, parameters, requestBody schemas, response schemas (success + errors), securitySchemes, reusable `components/schemas` for envelope, pagination meta, and error format. This is the deliverable — the spec IS the documentation.

### Step 8: Output

Deliver: resource tree, endpoint table (method / path / auth / roles / description), response envelope examples, OpenAPI spec, auth flow summary.

## Examples

**Example 1:** User says "design an API for a project management tool"

1. Gather: entities (users, workspaces, projects, tasks, comments, labels), relationships (workspace→projects 1:N, project→tasks 1:N, task↔labels M:N)
2. Resource tree: `/v1/auth`, `/v1/users`, `/v1/workspaces`, `/v1/workspaces/:id/members`, `/v1/projects`, `/v1/projects/:id/tasks`, `/v1/tasks`, `/v1/tasks/:id/comments`, `/v1/labels`, `/v1/search`
3. Deliver: endpoint table (~30 endpoints), cursor-paginated collections, JWT auth with RBAC (owner/admin/member/viewer), OpenAPI spec

**Example 2:** User says "I need REST endpoints for a blog with posts, categories, and comments"

1. Gather: entities (posts, categories, comments, authors), relationships (author→posts 1:N, post→comments 1:N, post↔categories M:N)
2. Key decisions: public read endpoints (no auth), auth required for writes, cursor pagination on posts, offset on admin dashboard
3. Deliver: endpoint table (~18 endpoints), public/authenticated split, OpenAPI spec

## Common Issues

- **Ambiguous entity ownership**: If two entities could "own" each other (e.g., users↔teams), clarify which is the parent resource. Usually the one that can exist independently.
- **Action endpoints vs state changes**: Prefer `PATCH /orders/:id { status: "cancelled" }` for simple state changes. Use `POST /orders/:id/cancel` only when the action has side effects beyond the state change (emails, refunds, inventory).
- **Conflicting nesting**: If the same resource appears under multiple parents (`/projects/:id/tasks` and `/users/:id/tasks`), make one canonical (`/tasks?projectId=X`) and the nested one a convenience alias.

## Anti-Patterns

- Verbs in URLs (`/getUser`, `/createOrder`).
- Inconsistent envelopes — some endpoints return `{ data }`, others return raw arrays.
- Leaking internal IDs (auto-increment) — use UUIDs or prefixed IDs (`usr_`, `task_`).
- Returning different error formats from different endpoints.
- No pagination on list endpoints — will break at scale.
- Nested URLs deeper than 2 levels.
- PUT for partial updates (should be PATCH).
- Exposing soft-deleted records in default queries without `?includeDeleted=true`.
- 200 status code for errors — always use proper HTTP status codes.

## Escalation

Hand off when: GraphQL federation across microservices, gRPC/protobuf API design, event-driven APIs (CQRS/event sourcing), API gateway configuration (Kong, AWS API Gateway).

## Inputs
- Domain, entities, relationships, auth model, audience, framework

## Outputs
- Resource tree, endpoint table, envelope spec, OpenAPI 3.1 YAML, auth flow

## Level History

- **Lv.1** — Base: Resource modeling rules, CRUD mapping, pagination/filtering conventions, envelope design, auth patterns, versioning. (Origin: MemStack v3.3, Mar 2026)
- **Lv.2** — Compressed: Removed implementation code and tutorials. Added terse examples, common issues, validation gates per Anthropic skill guide. (Mar 2026)
