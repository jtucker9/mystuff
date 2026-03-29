---
name: api-designer
description: "Use when the user says 'design API', 'API endpoints', 'REST API', 'API designer', 'route structure', 'API architecture', or is designing RESTful API routes, request/response schemas, and endpoint organization. Do NOT use for API security audits (see api-audit) or database design (see database-architect)."
---

# 🔌 API Designer — RESTful API Architecture
*Design production-grade RESTful (and optionally GraphQL) APIs with consistent resource modeling, pagination, filtering, error handling, authentication, versioning, and OpenAPI specification generation.*

## Activation

When this skill activates, output:

`🔌 API Designer — Designing your API surface...`

| Context | Status |
|---------|--------|
| **User says "design API", "API endpoints", "REST API"** | ACTIVE |
| **User asks for route structure or endpoint organization** | ACTIVE |
| **User needs request/response schema design** | ACTIVE |
| **User wants OpenAPI/Swagger spec generation** | ACTIVE |
| **User wants pagination, filtering, or sorting patterns** | ACTIVE |
| **User asks about API versioning strategy** | ACTIVE |
| **User wants GraphQL schema design** | ACTIVE — GraphQL mode |
| **User wants API security audit or penetration testing** | DORMANT — see api-audit |
| **User wants database schema or ERD design** | DORMANT — see database-architect |
| **User wants to deploy or host an API** | DORMANT — see railway-deploy or hetzner-setup |

## Protocol

### Step 1: Gather Inputs

Ask the user for these details before designing. Provide sensible defaults for anything not specified.

| Input | Question | Default |
|-------|----------|---------|
| **Domain** | What does this API serve? (e.g., e-commerce, SaaS, social platform) | — (required) |
| **Entities** | What are the core data entities? (e.g., users, products, orders) | — (required) |
| **Relationships** | How do entities relate? (1:1, 1:N, M:N) | Infer from entities |
| **Auth model** | JWT, API key, OAuth2, session cookies, or none? | JWT with refresh tokens |
| **Authorization** | RBAC, ABAC, resource ownership, or public? | RBAC with ownership |
| **Versioning** | URL path (`/v1/`), header (`Accept-Version`), or query param (`?v=1`)? | URL path |
| **Framework** | Express, FastAPI, Next.js API routes, Django REST, Go? | Express |
| **Format** | JSON:API, custom envelope, or flat JSON? | Custom envelope |
| **Audience** | Internal microservice, public third-party, or first-party frontend? | First-party frontend |
| **Real-time** | Do any resources need WebSocket or SSE subscriptions? | No |

**Example intake conversation:**

```
User: "Design an API for a project management tool"

AI gathers:
  Domain:         Project management SaaS
  Entities:       users, workspaces, projects, tasks, comments, labels
  Relationships:  workspace hasMany projects, project hasMany tasks,
                  task hasMany comments, task manyToMany labels
  Auth:           JWT with refresh tokens
  Authorization:  RBAC (owner, admin, member, viewer) + resource ownership
  Versioning:     URL path (/v1/)
  Framework:      Express
  Format:         Custom envelope
  Audience:       First-party SPA
```

### Step 2: Resource Modeling

Design URL structure using REST conventions. Every resource follows these rules:

| Rule | Example | Anti-pattern |
|------|---------|-------------|
| **Nouns, not verbs** | `POST /v1/orders` | ~~`POST /v1/createOrder`~~ |
| **Plural collection names** | `/v1/users` | ~~`/v1/user`~~ |
| **Hierarchical nesting (max 2 levels)** | `/v1/projects/:id/tasks` | ~~`/v1/projects/:id/tasks/:tid/comments/:cid/reactions`~~ |
| **IDs are path params** | `/v1/users/:userId` | ~~`/v1/users?id=123`~~ |
| **Actions as sub-resources** | `POST /v1/orders/:id/cancel` | ~~`POST /v1/cancelOrder`~~ |
| **Consistent casing (kebab-case)** | `/v1/line-items` | ~~`/v1/lineItems`~~ or ~~`/v1/line_items`~~ |

**Build the resource tree:**

```
── RESOURCE TREE ──────────────────────────────────

/v1
├── /auth
│   ├── POST   /register
│   ├── POST   /login
│   ├── POST   /refresh
│   ├── POST   /logout
│   └── POST   /forgot-password
│
├── /users
│   ├── GET    /                      → List users (admin)
│   ├── POST   /                      → Create user (admin)
│   ├── GET    /me                    → Current user profile
│   ├── PATCH  /me                    → Update own profile
│   ├── GET    /:userId               → Get user by ID
│   ├── PATCH  /:userId               → Update user (admin)
│   └── DELETE /:userId               → Delete user (admin)
│
├── /workspaces
│   ├── GET    /                      → List user's workspaces
│   ├── POST   /                      → Create workspace
│   ├── GET    /:workspaceId          → Get workspace
│   ├── PATCH  /:workspaceId          → Update workspace
│   ├── DELETE /:workspaceId          → Delete workspace
│   └── /members
│       ├── GET    /                  → List workspace members
│       ├── POST   /                  → Invite member
│       ├── PATCH  /:memberId         → Update member role
│       └── DELETE /:memberId         → Remove member
│
├── /projects
│   ├── GET    /                      → List projects (filtered by workspace)
│   ├── POST   /                      → Create project
│   ├── GET    /:projectId            → Get project
│   ├── PATCH  /:projectId            → Update project
│   ├── DELETE /:projectId            → Delete project
│   └── /tasks
│       ├── GET    /                  → List tasks in project
│       └── POST   /                  → Create task in project
│
├── /tasks
│   ├── GET    /                      → List all tasks (cross-project)
│   ├── GET    /:taskId               → Get task detail
│   ├── PATCH  /:taskId               → Update task
│   ├── DELETE /:taskId               → Delete task
│   └── /comments
│       ├── GET    /                  → List task comments
│       └── POST   /                  → Add comment
│
├── /comments
│   ├── PATCH  /:commentId            → Edit comment
│   └── DELETE /:commentId            → Delete comment
│
├── /labels
│   ├── GET    /                      → List labels
│   ├── POST   /                      → Create label
│   ├── PATCH  /:labelId              → Update label
│   └── DELETE /:labelId              → Delete label
│
└── /search
    └── GET    /                      → Full-text search across resources
```

**Collection vs. Singleton pattern:**

```
Collection (plural, returns array):
  GET  /v1/tasks          → { data: [...], meta: { ... } }

Singleton (by ID, returns object):
  GET  /v1/tasks/:taskId  → { data: { ... } }

Current-user singleton (no ID needed):
  GET  /v1/users/me       → { data: { ... } }
```

**Deep nesting alternative — use query params instead of deep paths:**

```
Instead of:  GET /v1/workspaces/:wid/projects/:pid/tasks/:tid/comments
Prefer:      GET /v1/comments?taskId=:tid
```

### Step 3: Endpoint Design

#### 3a: CRUD Mapping

Map HTTP methods to operations consistently:

| HTTP Method | Operation | Idempotent | Request Body | Success Code |
|-------------|-----------|-----------|-------------|-------------|
| `GET` | Read (single or collection) | Yes | None | `200 OK` |
| `POST` | Create | No | Required | `201 Created` |
| `PATCH` | Partial update | Yes | Required (partial) | `200 OK` |
| `PUT` | Full replace | Yes | Required (complete) | `200 OK` |
| `DELETE` | Remove | Yes | None | `204 No Content` |

**When to use PATCH vs PUT:**
- `PATCH /v1/tasks/:id` — send only changed fields: `{ "status": "done" }`
- `PUT /v1/tasks/:id` — send the complete resource representation (rarely used in practice)
- Prefer PATCH for most update operations — it is more bandwidth-efficient and less error-prone

#### 3b: Filtering, Pagination, and Sorting

**Pagination — Cursor-based (recommended for real-time data):**

```
GET /v1/tasks?cursor=eyJpZCI6MTAwfQ&limit=25

Response:
{
  "data": [...],
  "meta": {
    "hasMore": true,
    "nextCursor": "eyJpZCI6MTI1fQ",
    "prevCursor": "eyJpZCI6NzZ9",
    "limit": 25
  }
}
```

**Cursor implementation (Express):**

```javascript
app.get('/v1/tasks', authenticate, async (req, res) => {
  const limit = Math.min(parseInt(req.query.limit) || 25, 100); // Cap at 100
  const cursor = req.query.cursor
    ? JSON.parse(Buffer.from(req.query.cursor, 'base64url').toString())
    : null;

  const where = { projectId: req.query.projectId };
  if (cursor) {
    where.id = { [Op.lt]: cursor.id }; // Descending order
  }

  const items = await Task.findAll({
    where,
    order: [['id', 'DESC']],
    limit: limit + 1, // Fetch one extra to detect "hasMore"
  });

  const hasMore = items.length > limit;
  const data = hasMore ? items.slice(0, limit) : items;

  const nextCursor = hasMore
    ? Buffer.from(JSON.stringify({ id: data[data.length - 1].id })).toString('base64url')
    : null;

  res.json({
    data,
    meta: { hasMore, nextCursor, limit }
  });
});
```

**Cursor implementation (FastAPI):**

```python
from fastapi import FastAPI, Query, Depends
from base64 import urlsafe_b64encode, urlsafe_b64decode
import json

app = FastAPI()

@app.get("/v1/tasks")
async def list_tasks(
    cursor: str | None = Query(None),
    limit: int = Query(25, ge=1, le=100),
    project_id: str | None = Query(None, alias="projectId"),
    db: Session = Depends(get_db),
    user: User = Depends(get_current_user),
):
    query = db.query(Task).filter(Task.workspace_id.in_(user.workspace_ids))

    if project_id:
        query = query.filter(Task.project_id == project_id)

    if cursor:
        decoded = json.loads(urlsafe_b64decode(cursor))
        query = query.filter(Task.id < decoded["id"])

    items = query.order_by(Task.id.desc()).limit(limit + 1).all()
    has_more = len(items) > limit
    data = items[:limit] if has_more else items

    next_cursor = None
    if has_more:
        next_cursor = urlsafe_b64encode(
            json.dumps({"id": str(data[-1].id)}).encode()
        ).decode()

    return {
        "data": [TaskSchema.from_orm(t) for t in data],
        "meta": {"hasMore": has_more, "nextCursor": next_cursor, "limit": limit},
    }
```

**Pagination — Offset-based (simpler, good for admin dashboards):**

```
GET /v1/users?page=3&perPage=25

Response:
{
  "data": [...],
  "meta": {
    "page": 3,
    "perPage": 25,
    "totalItems": 247,
    "totalPages": 10
  }
}
```

**When to use which pagination style:**

| Factor | Cursor-based | Offset-based |
|--------|-------------|-------------|
| Real-time feeds with inserts/deletes | Preferred — stable pages | Unstable — items shift |
| "Jump to page 5" requirement | Not supported | Supported |
| Performance on large datasets | O(1) — index seek | O(n) — OFFSET scans rows |
| Deep pagination (page 1000+) | Efficient | Increasingly slow |
| Implementation complexity | Higher | Lower |

**Filtering — query parameter conventions:**

```
# Exact match
GET /v1/tasks?status=active&priority=high

# Multiple values (OR within field)
GET /v1/tasks?status=active,review

# Comparison operators (use bracket suffixes)
GET /v1/tasks?createdAt[gte]=2026-01-01&createdAt[lt]=2026-04-01
GET /v1/tasks?priority[ne]=low

# Nested resource filter
GET /v1/tasks?projectId=proj_abc123&assigneeId=usr_xyz789

# Supported operators:
#   [eq]   = equals (default when no operator)
#   [ne]   = not equals
#   [gt]   = greater than
#   [gte]  = greater than or equal
#   [lt]   = less than
#   [lte]  = less than or equal
#   [in]   = in list (comma-separated)
#   [nin]  = not in list
#   [like] = pattern match (use % wildcard)
```

**Sorting:**

```
# Single field sort (prefix with - for descending)
GET /v1/tasks?sort=-createdAt

# Multi-field sort (comma-separated)
GET /v1/tasks?sort=-priority,createdAt

# Default: -createdAt (newest first)
```

#### 3c: Search Endpoints

```
# Full-text search across resources
GET /v1/search?q=authentication+bug&type=tasks,comments&limit=20

Response:
{
  "data": [
    {
      "type": "task",
      "id": "task_abc123",
      "title": "Fix authentication bug in login flow",
      "highlight": "Fix <em>authentication</em> <em>bug</em> in login flow",
      "score": 0.95,
      "_links": { "self": "/v1/tasks/task_abc123" }
    },
    {
      "type": "comment",
      "id": "cmt_xyz789",
      "body": "This authentication bug is blocking the release",
      "highlight": "This <em>authentication</em> <em>bug</em> is blocking...",
      "score": 0.82,
      "_links": { "self": "/v1/comments/cmt_xyz789" }
    }
  ],
  "meta": { "totalResults": 14, "hasMore": true, "nextCursor": "..." }
}
```

#### 3d: Bulk Operations

For endpoints that need to create, update, or delete multiple resources in one request:

```
# Bulk create
POST /v1/tasks/bulk
{
  "operations": [
    { "action": "create", "data": { "title": "Task A", "projectId": "proj_1" } },
    { "action": "create", "data": { "title": "Task B", "projectId": "proj_1" } }
  ]
}

# Bulk update
PATCH /v1/tasks/bulk
{
  "ids": ["task_1", "task_2", "task_3"],
  "data": { "status": "archived" }
}

# Bulk delete
DELETE /v1/tasks/bulk
{
  "ids": ["task_1", "task_2", "task_3"]
}

# Bulk response (partial success is possible)
{
  "data": {
    "succeeded": ["task_1", "task_3"],
    "failed": [
      { "id": "task_2", "error": { "code": "FORBIDDEN", "message": "Not authorized" } }
    ]
  },
  "meta": { "total": 3, "succeeded": 2, "failed": 1 }
}
```

### Step 4: Request/Response Schema Design

#### 4a: Response Envelope

Use a consistent envelope for every response:

**Success — single resource:**
```json
{
  "data": {
    "id": "task_abc123",
    "type": "task",
    "title": "Implement login flow",
    "status": "active",
    "priority": "high",
    "assignee": {
      "id": "usr_xyz789",
      "name": "Jane Doe"
    },
    "createdAt": "2026-03-15T10:30:00Z",
    "updatedAt": "2026-03-28T14:22:00Z"
  },
  "_links": {
    "self": "/v1/tasks/task_abc123",
    "project": "/v1/projects/proj_def456",
    "comments": "/v1/tasks/task_abc123/comments"
  }
}
```

**Success — collection:**
```json
{
  "data": [
    { "id": "task_abc123", "type": "task", "title": "..." },
    { "id": "task_def456", "type": "task", "title": "..." }
  ],
  "meta": {
    "hasMore": true,
    "nextCursor": "eyJpZCI6InRhc2tfZGVmNDU2In0",
    "limit": 25,
    "totalItems": 142
  },
  "_links": {
    "self": "/v1/tasks?cursor=current",
    "next": "/v1/tasks?cursor=eyJpZCI6InRhc2tfZGVmNDU2In0&limit=25"
  }
}
```

**HATEOAS links pattern:**

Include `_links` on resources to enable client discoverability:

```json
{
  "data": {
    "id": "order_123",
    "status": "pending",
    "_links": {
      "self": { "href": "/v1/orders/order_123", "method": "GET" },
      "cancel": { "href": "/v1/orders/order_123/cancel", "method": "POST" },
      "pay": { "href": "/v1/orders/order_123/pay", "method": "POST" },
      "items": { "href": "/v1/orders/order_123/items", "method": "GET" }
    }
  }
}
```

State-dependent links — only include actions that are valid for the current state:

```javascript
function buildOrderLinks(order) {
  const links = {
    self: { href: `/v1/orders/${order.id}`, method: 'GET' },
    items: { href: `/v1/orders/${order.id}/items`, method: 'GET' },
  };

  if (order.status === 'pending') {
    links.pay = { href: `/v1/orders/${order.id}/pay`, method: 'POST' };
    links.cancel = { href: `/v1/orders/${order.id}/cancel`, method: 'POST' };
  }
  if (order.status === 'paid') {
    links.refund = { href: `/v1/orders/${order.id}/refund`, method: 'POST' };
    links.ship = { href: `/v1/orders/${order.id}/ship`, method: 'POST' };
  }
  if (order.status === 'shipped') {
    links.track = { href: `/v1/orders/${order.id}/tracking`, method: 'GET' };
  }

  return links;
}
```

#### 4b: Error Format — RFC 7807 (Problem Details)

All error responses follow RFC 7807 `application/problem+json`:

```json
{
  "type": "https://api.example.com/errors/validation-failed",
  "title": "Validation Failed",
  "status": 422,
  "detail": "The request body contains 2 validation errors.",
  "instance": "/v1/tasks",
  "traceId": "req_7f8a9b2c3d4e",
  "errors": [
    {
      "field": "title",
      "code": "REQUIRED",
      "message": "Title is required"
    },
    {
      "field": "priority",
      "code": "INVALID_ENUM",
      "message": "Priority must be one of: low, medium, high, critical",
      "received": "urgent"
    }
  ]
}
```

**Standard error codes and HTTP status mapping:**

| HTTP Status | Error Type | When to Use |
|------------|-----------|-------------|
| `400` | `bad-request` | Malformed JSON, missing required query params |
| `401` | `unauthorized` | Missing or expired authentication token |
| `403` | `forbidden` | Authenticated but insufficient permissions |
| `404` | `not-found` | Resource does not exist |
| `409` | `conflict` | Duplicate key, state conflict (e.g., already canceled) |
| `422` | `validation-failed` | Well-formed request but semantic validation errors |
| `429` | `rate-limited` | Too many requests |
| `500` | `internal-error` | Unexpected server error (never expose stack traces) |
| `503` | `service-unavailable` | Downstream dependency down, maintenance mode |

**Error handler implementation (Express):**

```javascript
class ApiError extends Error {
  constructor(status, type, title, detail, errors = []) {
    super(detail);
    this.status = status;
    this.type = type;
    this.title = title;
    this.detail = detail;
    this.errors = errors;
  }

  static badRequest(detail, errors) {
    return new ApiError(400, 'bad-request', 'Bad Request', detail, errors);
  }

  static unauthorized(detail = 'Authentication required') {
    return new ApiError(401, 'unauthorized', 'Unauthorized', detail);
  }

  static forbidden(detail = 'Insufficient permissions') {
    return new ApiError(403, 'forbidden', 'Forbidden', detail);
  }

  static notFound(resource = 'Resource') {
    return new ApiError(404, 'not-found', 'Not Found', `${resource} not found`);
  }

  static conflict(detail) {
    return new ApiError(409, 'conflict', 'Conflict', detail);
  }

  static validation(errors) {
    return new ApiError(
      422, 'validation-failed', 'Validation Failed',
      `The request body contains ${errors.length} validation error(s).`,
      errors
    );
  }

  static rateLimited(retryAfter = 60) {
    const err = new ApiError(429, 'rate-limited', 'Rate Limited',
      `Too many requests. Retry after ${retryAfter} seconds.`);
    err.retryAfter = retryAfter;
    return err;
  }
}

// Global error handler middleware
function errorHandler(err, req, res, next) {
  if (err instanceof ApiError) {
    const body = {
      type: `https://api.example.com/errors/${err.type}`,
      title: err.title,
      status: err.status,
      detail: err.detail,
      instance: req.originalUrl,
      traceId: req.id,
    };
    if (err.errors.length > 0) body.errors = err.errors;
    if (err.retryAfter) res.set('Retry-After', err.retryAfter);

    return res.status(err.status).type('application/problem+json').json(body);
  }

  // Unexpected errors — log full error, return generic message
  console.error(`[${req.id}] Unhandled error:`, err);
  res.status(500).type('application/problem+json').json({
    type: 'https://api.example.com/errors/internal-error',
    title: 'Internal Server Error',
    status: 500,
    detail: 'An unexpected error occurred. Please try again later.',
    instance: req.originalUrl,
    traceId: req.id,
  });
}

app.use(errorHandler);
```

**Error handler implementation (FastAPI):**

```python
from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from pydantic import BaseModel

class ApiError(Exception):
    def __init__(self, status: int, error_type: str, title: str,
                 detail: str, errors: list = None):
        self.status = status
        self.error_type = error_type
        self.title = title
        self.detail = detail
        self.errors = errors or []

app = FastAPI()

@app.exception_handler(ApiError)
async def api_error_handler(request: Request, exc: ApiError):
    body = {
        "type": f"https://api.example.com/errors/{exc.error_type}",
        "title": exc.title,
        "status": exc.status,
        "detail": exc.detail,
        "instance": str(request.url.path),
    }
    if exc.errors:
        body["errors"] = exc.errors
    return JSONResponse(status_code=exc.status, content=body,
                        media_type="application/problem+json")

# Usage
@app.get("/v1/tasks/{task_id}")
async def get_task(task_id: str, user: User = Depends(get_current_user)):
    task = await Task.get(task_id)
    if not task:
        raise ApiError(404, "not-found", "Not Found", f"Task {task_id} not found")
    if task.workspace_id not in user.workspace_ids:
        raise ApiError(403, "forbidden", "Forbidden", "You cannot access this task")
    return {"data": task}
```

#### 4c: Partial Responses (Field Selection)

Allow clients to request only the fields they need:

```
# Select specific fields
GET /v1/tasks?fields=id,title,status,assignee.name

# Expand nested resources (avoid N+1)
GET /v1/tasks?include=assignee,project,labels

# Combine
GET /v1/tasks?fields=id,title,status&include=assignee
```

**Implementation (Express):**

```javascript
function parseFields(fieldsParam) {
  if (!fieldsParam) return null;
  return fieldsParam.split(',').map(f => f.trim());
}

function pickFields(obj, fields) {
  if (!fields) return obj;
  return fields.reduce((result, field) => {
    const parts = field.split('.');
    if (parts.length === 1 && obj[field] !== undefined) {
      result[field] = obj[field];
    }
    // Handle nested: "assignee.name" -> { assignee: { name: ... } }
    if (parts.length === 2 && obj[parts[0]]) {
      result[parts[0]] = result[parts[0]] || {};
      result[parts[0]][parts[1]] = obj[parts[0]][parts[1]];
    }
    return result;
  }, {});
}

app.get('/v1/tasks', authenticate, async (req, res) => {
  const fields = parseFields(req.query.fields);
  const tasks = await Task.findAll({ /* ... */ });
  res.json({
    data: tasks.map(t => pickFields(t.toJSON(), fields)),
    meta: { /* ... */ }
  });
});
```

### Step 5: Authentication & Authorization Design

#### 5a: JWT Flow

```
┌──────────┐                  ┌──────────┐                  ┌──────────┐
│  Client  │                  │   API    │                  │ Database │
└────┬─────┘                  └────┬─────┘                  └────┬─────┘
     │  POST /v1/auth/login        │                             │
     │  { email, password }        │                             │
     ├────────────────────────────►│  Verify credentials         │
     │                             ├────────────────────────────►│
     │                             │◄────────────────────────────┤
     │  { accessToken, refresh }   │                             │
     │◄────────────────────────────┤  Issue tokens               │
     │                             │                             │
     │  GET /v1/tasks              │                             │
     │  Authorization: Bearer xxx  │                             │
     ├────────────────────────────►│  Validate access token      │
     │                             ├────────────────────────────►│
     │  { data: [...] }            │◄────────────────────────────┤
     │◄────────────────────────────┤                             │
     │                             │                             │
     │  POST /v1/auth/refresh      │                             │
     │  { refreshToken: yyy }      │                             │
     ├────────────────────────────►│  Validate + rotate refresh  │
     │                             ├────────────────────────────►│
     │  { accessToken, refresh }   │◄────────────────────────────┤
     │◄────────────────────────────┤  New token pair             │
```

**Token specifications:**

| Token | Lifetime | Storage | Contains |
|-------|---------|---------|----------|
| Access token | 15 minutes | Memory (or httpOnly cookie) | `sub`, `role`, `workspaceId`, `exp`, `iat` |
| Refresh token | 7 days | httpOnly secure cookie | `sub`, `tokenFamily`, `exp`, `iat` |

**JWT auth middleware (Express):**

```javascript
import jwt from 'jsonwebtoken';

function authenticate(req, res, next) {
  const header = req.headers.authorization;
  if (!header?.startsWith('Bearer ')) {
    throw ApiError.unauthorized('Missing or malformed Authorization header');
  }

  try {
    const token = header.slice(7);
    const payload = jwt.verify(token, process.env.JWT_SECRET, {
      algorithms: ['HS256'],  // Pin algorithm — never trust header
      issuer: 'api.example.com',
      audience: 'app.example.com',
    });
    req.user = payload;
    next();
  } catch (err) {
    if (err.name === 'TokenExpiredError') {
      throw ApiError.unauthorized('Access token expired');
    }
    throw ApiError.unauthorized('Invalid access token');
  }
}
```

**JWT auth dependency (FastAPI):**

```python
from fastapi import Depends, Header
from jose import jwt, JWTError
from datetime import datetime

async def get_current_user(authorization: str = Header(...)):
    if not authorization.startswith("Bearer "):
        raise ApiError(401, "unauthorized", "Unauthorized",
                       "Missing or malformed Authorization header")
    token = authorization[7:]
    try:
        payload = jwt.decode(
            token, settings.JWT_SECRET,
            algorithms=["HS256"],
            audience="app.example.com",
            issuer="api.example.com",
        )
        return UserContext(
            id=payload["sub"],
            role=payload["role"],
            workspace_id=payload.get("workspaceId"),
        )
    except JWTError:
        raise ApiError(401, "unauthorized", "Unauthorized", "Invalid access token")
```

#### 5b: API Key Authentication

For server-to-server or third-party integrations:

```
# API key in header (preferred)
GET /v1/tasks
X-API-Key: sk_live_abc123xyz789

# API key naming convention:
#   sk_live_*  — production secret key
#   sk_test_*  — sandbox/test key
#   pk_live_*  — publishable key (client-safe, limited scope)
```

**API key middleware:**

```javascript
async function authenticateApiKey(req, res, next) {
  const apiKey = req.headers['x-api-key'];
  if (!apiKey) return next(); // Fall through to JWT auth

  // Constant-time comparison to prevent timing attacks
  const keyRecord = await ApiKey.findOne({
    where: { keyHash: crypto.createHash('sha256').update(apiKey).digest('hex') },
    include: [{ model: User, as: 'owner' }],
  });

  if (!keyRecord || keyRecord.revokedAt) {
    throw ApiError.unauthorized('Invalid API key');
  }

  // Check scopes
  req.user = keyRecord.owner;
  req.apiKey = keyRecord;
  req.scopes = keyRecord.scopes; // e.g., ['tasks:read', 'tasks:write']
  next();
}
```

#### 5c: OAuth2 Scopes

Define granular scopes for API access control:

```
── SCOPE DEFINITIONS ────────────────────────

Scope                   Description
tasks:read              Read tasks and task details
tasks:write             Create, update, and delete tasks
projects:read           Read projects and project settings
projects:write          Create, update, and delete projects
users:read              Read user profiles
users:admin             Manage all users (admin only)
workspaces:manage       Create and configure workspaces
webhooks:manage         Create and manage webhook subscriptions
```

#### 5d: Rate Limiting Headers

Include rate limit information in every response:

```
HTTP/1.1 200 OK
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 87
X-RateLimit-Reset: 1711720800
Retry-After: 60            # Only on 429 responses
```

**Tiered rate limits:**

| Tier | Endpoints | Limit | Window |
|------|----------|-------|--------|
| **Standard** | Most GET/PATCH/DELETE | 100 req | 15 min |
| **Strict** | POST /auth/login, /auth/register | 5 req | 15 min |
| **Bulk** | POST /tasks/bulk, /search | 20 req | 1 min |
| **Webhook** | Incoming webhooks | 1000 req | 1 min |

### Step 6: Versioning Strategy

#### 6a: URL Path Versioning (Recommended)

```
GET /v1/tasks
GET /v2/tasks
```

Advantages: explicit, cacheable, easy to route, visible in logs.

**Router setup (Express):**

```javascript
import v1Router from './routes/v1/index.js';
import v2Router from './routes/v2/index.js';

app.use('/v1', v1Router);
app.use('/v2', v2Router);

// Redirect bare /api to latest stable version
app.get('/api', (req, res) => {
  res.redirect(301, '/v2');
});
```

**Router setup (Next.js App Router):**

```
app/
├── api/
│   ├── v1/
│   │   ├── tasks/
│   │   │   ├── route.ts          → GET (list), POST (create)
│   │   │   └── [taskId]/
│   │   │       └── route.ts      → GET, PATCH, DELETE
│   │   └── users/
│   │       └── route.ts
│   └── v2/
│       ├── tasks/
│       │   ├── route.ts          → Updated schema
│       │   └── [taskId]/
│       │       └── route.ts
│       └── users/
│           └── route.ts
```

**Next.js API route example:**

```typescript
// app/api/v1/tasks/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { authenticate } from '@/lib/auth';
import { prisma } from '@/lib/prisma';

const CreateTaskSchema = z.object({
  title: z.string().min(1).max(500),
  projectId: z.string(),
  priority: z.enum(['low', 'medium', 'high', 'critical']).default('medium'),
  assigneeId: z.string().optional(),
});

export async function GET(req: NextRequest) {
  const user = await authenticate(req);
  if (!user) {
    return NextResponse.json(
      { type: 'unauthorized', title: 'Unauthorized', status: 401,
        detail: 'Authentication required' },
      { status: 401 }
    );
  }

  const { searchParams } = new URL(req.url);
  const cursor = searchParams.get('cursor');
  const limit = Math.min(parseInt(searchParams.get('limit') || '25'), 100);
  const status = searchParams.get('status');
  const projectId = searchParams.get('projectId');

  const where: any = { workspace: { members: { some: { userId: user.id } } } };
  if (status) where.status = status;
  if (projectId) where.projectId = projectId;
  if (cursor) where.id = { lt: cursor };

  const tasks = await prisma.task.findMany({
    where,
    orderBy: { id: 'desc' },
    take: limit + 1,
    include: { assignee: { select: { id: true, name: true, avatar: true } } },
  });

  const hasMore = tasks.length > limit;
  const data = hasMore ? tasks.slice(0, limit) : tasks;

  return NextResponse.json({
    data,
    meta: {
      hasMore,
      nextCursor: hasMore ? data[data.length - 1].id : null,
      limit,
    },
  });
}

export async function POST(req: NextRequest) {
  const user = await authenticate(req);
  if (!user) {
    return NextResponse.json(
      { type: 'unauthorized', title: 'Unauthorized', status: 401,
        detail: 'Authentication required' },
      { status: 401 }
    );
  }

  const body = await req.json();
  const result = CreateTaskSchema.safeParse(body);
  if (!result.success) {
    return NextResponse.json(
      {
        type: 'validation-failed', title: 'Validation Failed', status: 422,
        detail: `${result.error.issues.length} validation error(s).`,
        errors: result.error.issues.map(i => ({
          field: i.path.join('.'), code: i.code, message: i.message,
        })),
      },
      { status: 422 }
    );
  }

  const task = await prisma.task.create({
    data: { ...result.data, creatorId: user.id },
  });

  return NextResponse.json({ data: task }, { status: 201 });
}
```

#### 6b: Header Versioning (Alternative)

```
GET /tasks
Accept: application/vnd.example.v2+json

# Or custom header:
GET /tasks
X-API-Version: 2
```

Advantages: cleaner URLs, version negotiation.
Disadvantages: harder to test in browser, less visible, CDN caching complexity.

#### 6c: Deprecation Headers

When sunsetting a version, include deprecation headers on every response:

```
HTTP/1.1 200 OK
Deprecation: Sun, 01 Jun 2026 00:00:00 GMT
Sunset: Sun, 01 Sep 2026 00:00:00 GMT
Link: </v2/tasks>; rel="successor-version"
```

| Header | Purpose |
|--------|---------|
| `Deprecation` | Date when the version was deprecated |
| `Sunset` | Date when the version will stop working |
| `Link` | URL of the replacement version |

**Deprecation middleware (Express):**

```javascript
function deprecated(sunsetDate, successorPath) {
  return (req, res, next) => {
    res.set('Deprecation', new Date().toUTCString());
    res.set('Sunset', new Date(sunsetDate).toUTCString());
    res.set('Link', `<${successorPath}>; rel="successor-version"`);
    next();
  };
}

// Apply to entire v1 router
v1Router.use(deprecated('2026-09-01', '/v2'));
```

#### 6d: Migration Path

When evolving between versions, map changes explicitly:

```
── VERSION MIGRATION: v1 → v2 ─────────────

Breaking Changes:
  - GET /v1/tasks response.data[].assignee (string ID)
    → GET /v2/tasks response.data[].assignee (object { id, name })

  - POST /v1/tasks field "due_date" (string)
    → POST /v2/tasks field "dueDate" (ISO 8601 string, camelCase)

  - DELETE /v1/tasks/:id returns 200
    → DELETE /v2/tasks/:id returns 204 No Content

Non-breaking additions (in v2):
  - New field: response.data[].labels (array)
  - New endpoint: GET /v2/tasks/:id/activity
  - New query param: ?include=comments,labels

Migration steps:
  1. Deploy v2 alongside v1
  2. Add Deprecation headers to v1 responses
  3. Update client SDKs to target v2
  4. Monitor v1 traffic until < 1% of total
  5. Sunset v1 after grace period
```

### Step 7: OpenAPI Specification Generation

Generate an OpenAPI 3.1 specification for the designed API:

```yaml
openapi: "3.1.0"
info:
  title: Project Management API
  description: RESTful API for managing workspaces, projects, tasks, and team collaboration.
  version: "1.0.0"
  contact:
    name: API Support
    email: api-support@example.com
  license:
    name: Proprietary
    url: https://example.com/terms

servers:
  - url: https://api.example.com/v1
    description: Production
  - url: https://staging-api.example.com/v1
    description: Staging
  - url: http://localhost:3000/v1
    description: Local development

tags:
  - name: Auth
    description: Authentication and token management
  - name: Tasks
    description: Task CRUD and management
  - name: Projects
    description: Project CRUD and settings
  - name: Users
    description: User profiles and management

paths:
  /tasks:
    get:
      tags: [Tasks]
      summary: List tasks
      description: Retrieve a paginated list of tasks. Supports cursor-based pagination, filtering, and sorting.
      operationId: listTasks
      security:
        - bearerAuth: []
        - apiKey: []
      parameters:
        - name: cursor
          in: query
          schema:
            type: string
          description: Cursor for pagination (base64url-encoded)
        - name: limit
          in: query
          schema:
            type: integer
            minimum: 1
            maximum: 100
            default: 25
          description: Number of items per page
        - name: status
          in: query
          schema:
            type: string
            enum: [active, review, done, archived]
          description: Filter by task status
        - name: projectId
          in: query
          schema:
            type: string
          description: Filter by project
        - name: assigneeId
          in: query
          schema:
            type: string
          description: Filter by assignee
        - name: sort
          in: query
          schema:
            type: string
            default: "-createdAt"
          description: "Sort field (prefix with - for descending). Supported: createdAt, updatedAt, priority, title"
        - name: fields
          in: query
          schema:
            type: string
          description: "Comma-separated list of fields to include (e.g., id,title,status)"
      responses:
        "200":
          description: Successful response
          headers:
            X-RateLimit-Limit:
              schema:
                type: integer
              description: Request limit per window
            X-RateLimit-Remaining:
              schema:
                type: integer
              description: Remaining requests in window
            X-RateLimit-Reset:
              schema:
                type: integer
              description: Unix timestamp when the window resets
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: "#/components/schemas/Task"
                  meta:
                    $ref: "#/components/schemas/PaginationMeta"
                  _links:
                    $ref: "#/components/schemas/CollectionLinks"
        "401":
          $ref: "#/components/responses/Unauthorized"
        "429":
          $ref: "#/components/responses/RateLimited"

    post:
      tags: [Tasks]
      summary: Create a task
      operationId: createTask
      security:
        - bearerAuth: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: "#/components/schemas/CreateTaskRequest"
      responses:
        "201":
          description: Task created
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    $ref: "#/components/schemas/Task"
        "401":
          $ref: "#/components/responses/Unauthorized"
        "422":
          $ref: "#/components/responses/ValidationFailed"

  /tasks/{taskId}:
    get:
      tags: [Tasks]
      summary: Get a task
      operationId: getTask
      security:
        - bearerAuth: []
      parameters:
        - name: taskId
          in: path
          required: true
          schema:
            type: string
          description: Task identifier
        - name: include
          in: query
          schema:
            type: string
          description: "Comma-separated relations to include (e.g., comments,labels,assignee)"
      responses:
        "200":
          description: Successful response
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    $ref: "#/components/schemas/Task"
                  _links:
                    $ref: "#/components/schemas/ResourceLinks"
        "404":
          $ref: "#/components/responses/NotFound"

    patch:
      tags: [Tasks]
      summary: Update a task
      operationId: updateTask
      security:
        - bearerAuth: []
      parameters:
        - name: taskId
          in: path
          required: true
          schema:
            type: string
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: "#/components/schemas/UpdateTaskRequest"
      responses:
        "200":
          description: Task updated
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    $ref: "#/components/schemas/Task"
        "404":
          $ref: "#/components/responses/NotFound"
        "422":
          $ref: "#/components/responses/ValidationFailed"

    delete:
      tags: [Tasks]
      summary: Delete a task
      operationId: deleteTask
      security:
        - bearerAuth: []
      parameters:
        - name: taskId
          in: path
          required: true
          schema:
            type: string
      responses:
        "204":
          description: Task deleted
        "404":
          $ref: "#/components/responses/NotFound"

  /auth/login:
    post:
      tags: [Auth]
      summary: Authenticate user
      operationId: login
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required: [email, password]
              properties:
                email:
                  type: string
                  format: email
                password:
                  type: string
                  minLength: 12
      responses:
        "200":
          description: Authentication successful
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: object
                    properties:
                      accessToken:
                        type: string
                        description: Short-lived JWT access token
                      refreshToken:
                        type: string
                        description: Long-lived refresh token
                      expiresIn:
                        type: integer
                        description: Access token lifetime in seconds
                        example: 900
        "401":
          $ref: "#/components/responses/Unauthorized"
        "429":
          $ref: "#/components/responses/RateLimited"

components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
    apiKey:
      type: apiKey
      in: header
      name: X-API-Key

  schemas:
    Task:
      type: object
      properties:
        id:
          type: string
          example: "task_abc123"
        type:
          type: string
          const: "task"
        title:
          type: string
          example: "Implement login flow"
        description:
          type: string
        status:
          type: string
          enum: [active, review, done, archived]
        priority:
          type: string
          enum: [low, medium, high, critical]
        assignee:
          type: object
          properties:
            id:
              type: string
            name:
              type: string
            avatar:
              type: string
              format: uri
        projectId:
          type: string
        labels:
          type: array
          items:
            type: object
            properties:
              id:
                type: string
              name:
                type: string
              color:
                type: string
        dueDate:
          type: string
          format: date-time
        createdAt:
          type: string
          format: date-time
        updatedAt:
          type: string
          format: date-time

    CreateTaskRequest:
      type: object
      required: [title, projectId]
      properties:
        title:
          type: string
          minLength: 1
          maxLength: 500
        description:
          type: string
          maxLength: 10000
        projectId:
          type: string
        priority:
          type: string
          enum: [low, medium, high, critical]
          default: medium
        assigneeId:
          type: string
        labelIds:
          type: array
          items:
            type: string
        dueDate:
          type: string
          format: date-time

    UpdateTaskRequest:
      type: object
      properties:
        title:
          type: string
          minLength: 1
          maxLength: 500
        description:
          type: string
          maxLength: 10000
        status:
          type: string
          enum: [active, review, done, archived]
        priority:
          type: string
          enum: [low, medium, high, critical]
        assigneeId:
          type: string
        labelIds:
          type: array
          items:
            type: string
        dueDate:
          type: string
          format: date-time

    PaginationMeta:
      type: object
      properties:
        hasMore:
          type: boolean
        nextCursor:
          type: string
        prevCursor:
          type: string
        limit:
          type: integer
        totalItems:
          type: integer

    CollectionLinks:
      type: object
      properties:
        self:
          type: string
          format: uri-reference
        next:
          type: string
          format: uri-reference
        prev:
          type: string
          format: uri-reference

    ResourceLinks:
      type: object
      additionalProperties:
        oneOf:
          - type: string
            format: uri-reference
          - type: object
            properties:
              href:
                type: string
                format: uri-reference
              method:
                type: string

    ProblemDetail:
      type: object
      description: RFC 7807 Problem Details
      properties:
        type:
          type: string
          format: uri
        title:
          type: string
        status:
          type: integer
        detail:
          type: string
        instance:
          type: string
        traceId:
          type: string
        errors:
          type: array
          items:
            type: object
            properties:
              field:
                type: string
              code:
                type: string
              message:
                type: string

  responses:
    Unauthorized:
      description: Authentication required or token invalid
      content:
        application/problem+json:
          schema:
            $ref: "#/components/schemas/ProblemDetail"
    Forbidden:
      description: Insufficient permissions
      content:
        application/problem+json:
          schema:
            $ref: "#/components/schemas/ProblemDetail"
    NotFound:
      description: Resource not found
      content:
        application/problem+json:
          schema:
            $ref: "#/components/schemas/ProblemDetail"
    ValidationFailed:
      description: Request validation failed
      content:
        application/problem+json:
          schema:
            $ref: "#/components/schemas/ProblemDetail"
    RateLimited:
      description: Too many requests
      headers:
        Retry-After:
          schema:
            type: integer
          description: Seconds until the rate limit resets
      content:
        application/problem+json:
          schema:
            $ref: "#/components/schemas/ProblemDetail"
```

### Step 8: Output Summary

After completing the design, present the endpoint summary table:

```
━━━ API DESIGN SUMMARY ━━━━━━━━━━━━━━━━━━━━

── OVERVIEW ────────────────────────────────
Domain:       Project Management SaaS
Base URL:     https://api.example.com/v1
Auth:         JWT (Bearer) + API Key
Versioning:   URL path (/v1/)
Format:       JSON envelope with HATEOAS links
Pagination:   Cursor-based (default), offset available

── ENDPOINT TABLE ──────────────────────────

Method  Path                              Auth    Roles              Desc
POST    /v1/auth/register                 No      —                  Register user
POST    /v1/auth/login                    No      —                  Authenticate
POST    /v1/auth/refresh                  No*     —                  Refresh token
POST    /v1/auth/logout                   Yes     any                Revoke token
POST    /v1/auth/forgot-password          No      —                  Password reset
GET     /v1/users                         Yes     admin              List users
POST    /v1/users                         Yes     admin              Create user
GET     /v1/users/me                      Yes     any                Own profile
PATCH   /v1/users/me                      Yes     any                Update own profile
GET     /v1/users/:userId                 Yes     admin              Get user
PATCH   /v1/users/:userId                 Yes     admin              Update user
DELETE  /v1/users/:userId                 Yes     admin              Delete user
GET     /v1/workspaces                    Yes     any                List workspaces
POST    /v1/workspaces                    Yes     any                Create workspace
GET     /v1/workspaces/:id                Yes     member+            Get workspace
PATCH   /v1/workspaces/:id                Yes     owner,admin        Update workspace
DELETE  /v1/workspaces/:id                Yes     owner              Delete workspace
GET     /v1/workspaces/:id/members        Yes     member+            List members
POST    /v1/workspaces/:id/members        Yes     admin+             Invite member
PATCH   /v1/workspaces/:id/members/:mid   Yes     admin+             Update role
DELETE  /v1/workspaces/:id/members/:mid   Yes     admin+             Remove member
GET     /v1/projects                      Yes     member+            List projects
POST    /v1/projects                      Yes     admin+             Create project
GET     /v1/projects/:id                  Yes     member+            Get project
PATCH   /v1/projects/:id                  Yes     admin+             Update project
DELETE  /v1/projects/:id                  Yes     admin+             Delete project
GET     /v1/projects/:id/tasks            Yes     member+            List project tasks
POST    /v1/projects/:id/tasks            Yes     member+            Create task
GET     /v1/tasks                         Yes     member+            List all tasks
GET     /v1/tasks/:taskId                 Yes     member+            Get task
PATCH   /v1/tasks/:taskId                 Yes     member+            Update task
DELETE  /v1/tasks/:taskId                 Yes     admin+             Delete task
POST    /v1/tasks/bulk                    Yes     member+            Bulk operations
GET     /v1/tasks/:taskId/comments        Yes     member+            List comments
POST    /v1/tasks/:taskId/comments        Yes     member+            Add comment
PATCH   /v1/comments/:commentId           Yes     owner              Edit comment
DELETE  /v1/comments/:commentId           Yes     owner,admin        Delete comment
GET     /v1/labels                        Yes     member+            List labels
POST    /v1/labels                        Yes     admin+             Create label
PATCH   /v1/labels/:labelId               Yes     admin+             Update label
DELETE  /v1/labels/:labelId               Yes     admin+             Delete label
GET     /v1/search                        Yes     member+            Full-text search

── STATISTICS ──────────────────────────────
Total endpoints:    38
Auth-required:      33 (87%)
Public:              5 (13%)
CRUD resources:      7 (users, workspaces, projects, tasks, comments, labels, members)

── GENERATED FILES ─────────────────────────
- openapi.yaml    — OpenAPI 3.1 specification
- routes/         — Route handler stubs for chosen framework
- middleware/     — Auth, validation, error handling, rate limiting
- schemas/        — Zod/Pydantic validation schemas

── NEXT STEPS ──────────────────────────────
1. Review endpoint table for missing operations
2. Validate OpenAPI spec: npx @redocly/cli lint openapi.yaml
3. Generate client SDK: npx openapi-typescript openapi.yaml -o types.ts
4. Set up API documentation: npx redocly build-docs openapi.yaml
5. Implement auth flow first, then CRUD endpoints
6. Add integration tests for each endpoint
```

## Anti-Patterns

| Anti-Pattern | Why It's Wrong | Correct Approach |
|-------------|----------------|------------------|
| Verbs in URLs (`/getUser`, `/createTask`) | Violates REST; HTTP method already conveys the action | Use nouns: `GET /users/:id`, `POST /tasks` |
| Singular resource names (`/user`, `/task`) | Inconsistent — collection and singleton differ in plurality | Always plural: `/users`, `/tasks`, `/users/:id` |
| Deep nesting beyond 2 levels | Hard to construct URLs, inflexible, couples resources | Flatten with query params: `GET /comments?taskId=x` |
| Returning raw database rows | Leaks schema details, couples DB to API contract | Map to explicit response DTOs with field allowlists |
| Using HTTP 200 for all responses | Clients cannot distinguish success types without parsing body | Use semantic status codes: 201 Created, 204 No Content, etc. |
| Inconsistent error formats | Every endpoint returns errors differently | Single RFC 7807 error format for all endpoints |
| Offset pagination on large datasets | `OFFSET 100000` causes full table scan | Use cursor-based pagination for feeds and large collections |
| Returning all fields always | Wastes bandwidth, exposes internal fields | Support `?fields=` and explicit response schemas |
| No versioning from day one | Breaking changes have no migration path | Start with `/v1/` even if no v2 is planned |
| Using query params for resource IDs | `/users?id=123` is not RESTful, not cacheable | Use path params: `/users/123` |
| Mixing camelCase and snake_case | Inconsistent DX, parsing headaches for clients | Pick one (camelCase for JS, snake_case for Python) and commit |
| No rate limiting | A single client can overload your API | Implement tiered rate limits from launch |
| Designing for your database, not your clients | Exposing internal join tables, DB column names | Design the API contract first, then map to storage |

## Escalation

Hand off to a human architect or specialist when:
- The API must support GraphQL and REST simultaneously with a shared data layer
- You are building a public API for third-party developers with SLA requirements
- The API requires complex multi-party OAuth flows (e.g., marketplace with sellers and buyers)
- Real-time requirements include multiplayer collaboration or presence (consider dedicated protocols)
- Regulatory requirements mandate specific data residency, audit logging, or encryption patterns (HIPAA, SOC2, PCI-DSS)
- The system requires eventual consistency patterns across microservices (sagas, event sourcing)
- Performance requires response times under 50ms with complex authorization logic

## Inputs
- Domain description (what the API serves)
- Entity list with relationships (1:1, 1:N, M:N)
- Authentication and authorization requirements
- Target framework (Express, FastAPI, Next.js, etc.)
- Versioning preference
- Response format preference (JSON:API, custom envelope, flat)
- Audience (internal, public third-party, first-party frontend)
- Real-time requirements (WebSocket, SSE, polling)
- Rate limiting requirements
- Existing OpenAPI spec to extend (optional)

## Outputs
- Resource tree with hierarchical URL structure
- Complete endpoint table (method, path, auth, roles, description)
- Request/response JSON schemas with examples
- RFC 7807 error format implementation
- Authentication middleware code (JWT + API key)
- Pagination implementation (cursor-based + offset fallback)
- Filtering and sorting query parameter conventions
- Deprecation and versioning strategy
- OpenAPI 3.1 specification (YAML)
- Framework-specific route handler stubs (Express, FastAPI, or Next.js)
- Rate limiting tier definitions

## Level History

- **Lv.1** — Base: Full 8-step protocol — input gathering, resource modeling (noun-based URLs, hierarchy rules, collection/singleton), CRUD mapping, cursor + offset pagination with code, filtering/sorting conventions, search endpoints, bulk operations, response envelope with HATEOAS, RFC 7807 error format, JWT + API key auth flows, OAuth2 scopes, rate limiting tiers, URL path versioning with deprecation headers, OpenAPI 3.1 spec generation, endpoint summary table. Framework examples for Express, FastAPI, and Next.js App Router. 13 anti-patterns, escalation criteria, full I/O specs. (Origin: MemStack v3.3, Mar 2026)
