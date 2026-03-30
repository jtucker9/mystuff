---
name: api-audit
description: "Audit API endpoints for auth flaws, authorization bypasses, injection, data exposure, and misconfigurations. Triggers: 'audit API', 'API security', 'endpoint audit', 'BOLA check', 'IDOR check', 'API pentest', 'check my routes'. NOT for: frontend security headers (csp-headers), dependency scanning (dependency-audit), database RLS (rls-checker)."
---

# API Audit -- Comprehensive API Security Assessment

Systematically audit API endpoints mapped to the OWASP API Security Top 10 (2023).

## Activation

| Context | Status |
|---------|--------|
| User says "audit API", "check API security", "endpoint audit" | ACTIVE |
| User wants BOLA/IDOR vulnerability checks | ACTIVE |
| User asks about JWT security, rate limiting, CORS | ACTIVE |
| User wants CSP or browser security headers | DORMANT -- see csp-headers |
| User wants dependency vulnerability scanning | DORMANT -- see dependency-audit |
| User wants database row-level security | DORMANT -- see rls-checker |

## Instructions

### Step 1: Gather Context

Determine before proceeding:
- **API type**: REST, GraphQL, gRPC, WebSocket
- **Framework**: Express, FastAPI, Next.js API routes, Django REST, Rails, Go, etc.
- **Auth method**: JWT, session cookies, API keys, OAuth2, none
- **Authz model**: RBAC, ABAC, resource ownership, ad-hoc
- **Deployment**: Public internet, internal microservice, hybrid
- **Known concerns**: Specific endpoints or patterns the user is worried about

If OpenAPI/Swagger spec or Postman collection exists, use it as ground truth.

**Gate**: Do not proceed without knowing API type, auth method, and framework.

### Step 2: Enumerate Attack Surface

Build an endpoint inventory: method, path, auth required, roles, input sources.

**Discovery approach by framework**:
- Express/Koa: search for `router.METHOD` and `app.METHOD` patterns in source
- Next.js: enumerate `pages/api/` or `app/api/` directory structure
- FastAPI/Django: search for `@app.METHOD` or `@router.METHOD` decorators
- OpenAPI spec: extract `.paths` keys

Classify each endpoint: public, authenticated, admin-only, webhook (signature-verified).

**Gate**: Inventory must be reviewed by user before deep audit. Missing routes = missed vulns.

### Step 3: OWASP API Security Top 10 Audit

Assess each endpoint against all 10 categories. Prioritize in order -- API1 is statistically most common.

**API1: Broken Object Level Authorization (BOLA/IDOR)** -- CRITICAL priority
- Every endpoint accepting an ID parameter must verify requester owns/can access that object
- Test: authenticate as User A, attempt to access User B's resources using User A's token
- Test: sequential ID enumeration across resource boundaries
- Check: bulk endpoints filter by user context, not just auth presence
- Check: GraphQL nested resolvers enforce authz at each resolver level
- Check: identity derived from token, never from client-supplied user ID
- Mitigation: UUIDs over sequential IDs; ownership scoping in every query

**API2: Broken Authentication**
- JWT: algorithm pinned server-side (never trust `alg` header), short-lived tokens (15min access / 7d refresh), refresh rotation, `iss`/`aud` validated, `kid` validated, no sensitive data in payload
- Test: alg:none attack, RS256-to-HS256 key confusion, password reset token entropy
- Rate limiting on login/reset endpoints (strict, failure-counting)
- No JWT in localStorage (httpOnly cookies preferred)

**API3: Broken Object Property Level Authorization**
- Mass assignment: can users set fields they shouldn't (role, isAdmin, isVerified)?
- Data exposure: do responses return internal fields (passwordHash, SSN, internalNotes)?
- Fix: explicit field allowlists for both reads and writes; `.strict()` schemas reject unknowns

**API4: Unrestricted Resource Consumption**
- Rate limiting present and tiered by endpoint sensitivity
- Pagination enforced with max page size (reject `limit=999999`)
- Request body size limits configured
- GraphQL: query depth/complexity limits in place
- File upload: size and type restrictions

**API5: Broken Function Level Authorization**
- Test admin endpoints with regular user tokens -- expect 401/403, not 200
- Test HTTP method override headers (`X-HTTP-Method-Override`)
- Verify role checks are server-side middleware, not frontend-only

**API6: Unrestricted Access to Sensitive Business Flows**
- Purchase/checkout, registration, referral/reward endpoints protected against automation
- CAPTCHA or equivalent on abuse-prone flows

**API7: Server Side Request Forgery (SSRF)**
- Any endpoint accepting URL parameters: test with internal IPs (169.254.169.254), localhost, DNS rebinding
- URL allowlisting preferred over blocklisting

**API8: Security Misconfiguration**
- CORS: must not reflect arbitrary origins or use `*` with credentials
- Error responses: no stack traces, file paths, or SQL in production
- Debug/admin endpoints disabled in production
- Default credentials tested

**API9: Improper Inventory Management**
- No stale API versions accessible (v1 when v3 is current)
- No undocumented endpoints: probe common paths (/api/debug, /api/test, /api/internal, /api/graphiql, /api/env, /api/config, /api/metrics)
- Deprecated endpoints return warnings or 410

**API10: Unsafe Consumption of APIs**
- Third-party API responses validated before use
- Webhook payloads signature-verified
- Timeouts on all external calls; redirects not blindly followed

**Gate**: Every OWASP category must have a pass/fail/not-applicable determination before proceeding.

### Step 4: Injection Testing

Test by API type:

| Vector | REST | GraphQL | gRPC |
|--------|------|---------|------|
| SQL injection | query params, body fields | variables, directive args | message fields |
| NoSQL injection | JSON operators (`$gt`, `$ne`) | same | N/A |
| XSS (stored) | body fields rendered elsewhere | mutation inputs | message fields |
| Path traversal | file path params, download endpoints | N/A | N/A |
| Command injection | params passed to shell commands | same | same |
| Prototype pollution (Node.js) | `__proto__` in JSON body | same | N/A |

**Gate**: If any injection succeeds, classify as CRITICAL and halt to report before continuing.

### Step 5: Classify and Report

**Severity decision tree**:
- Unauthorized access to other users' data + modify/delete = **CRITICAL**
- Unauthorized read of sensitive data (PII, financial, health) = **CRITICAL**
- Privilege escalation = **CRITICAL**
- Unauthorized read of non-sensitive data = **HIGH**
- Easy-to-exploit DoS = **HIGH**
- Hard-to-exploit DoS = **MEDIUM**
- Externally exploitable info leak = **MEDIUM**
- Internal-only info leak = **LOW**
- Best practice deviation = **INFO**

| Severity | Response Time |
|----------|---------------|
| CRITICAL | Fix immediately |
| HIGH | Fix within 48h |
| MEDIUM | Fix within 1 week |
| LOW | Fix within 1 month |
| INFO | Track |

Report format: summary (target, date, scope, auth method), finding counts by severity, each finding with OWASP category + endpoint + evidence + impact + remediation, prioritized remediation roadmap.

## Examples

**BOLA found on order endpoint**:
Endpoint `GET /api/orders/:id` returns any order for any authenticated user. User A's token retrieves User B's order data. Severity: CRITICAL (API1). Fix: scope query by `userId` from token.

**Mass assignment on profile update**:
`PUT /api/users/me` with `{"role":"admin"}` in body successfully escalates privileges. Severity: CRITICAL (API3). Fix: allowlist mutable fields; reject unknown properties with strict schema validation.

## Common Issues

| Issue | Fix |
|-------|-----|
| Rate limiter only on `/api/auth/login`, not on `/api/auth/reset-password` | Apply strict rate limits to all auth-adjacent endpoints |
| CORS reflects `Origin` header back as `Access-Control-Allow-Origin` | Use explicit origin allowlist; never reflect or wildcard with credentials |
| GraphQL introspection enabled in production | Disable introspection in production; add query depth/complexity limits |

## Anti-Patterns

| Anti-Pattern | Correct Approach |
|-------------|------------------|
| Authorization checks only in frontend | Enforce at API layer; attackers bypass the UI |
| Sequential integer IDs in URLs | UUIDs or non-guessable identifiers |
| Returning full database objects | Explicit field allowlists per endpoint |
| Single flat rate limit for all endpoints | Tiered limits by endpoint sensitivity |
| `Access-Control-Allow-Origin: *` with credentials | Explicit origin allowlist |
| Trusting JWT `alg` header | Pin algorithm server-side |
| Logging full request/response bodies | Log metadata only; redact sensitive fields |
| API keys as sole user authentication | API keys + short-lived tokens for user context |

## Escalation

Hand off to a human security professional when:
- Active exploitation discovered or production testing requires explicit authorization
- API handles payments, health data, or legal documents (compliance scope)
- Fix requires architectural overhaul or custom cryptographic review
- Vulnerabilities exist in third-party APIs you don't control

## Inputs

Endpoint inventory or codebase access, auth mechanism details, authorization model, framework/stack, deployment context.

## Outputs

Endpoint inventory with auth mapping, OWASP API Top 10 pass/fail per category, severity-classified findings with evidence and remediation, prioritized remediation roadmap.

## Level History

- **Lv.1** -- Base: Full OWASP API Top 10 audit protocol with discovery commands, testing scripts, code examples, CORS audit, input validation, severity classification, report template. (Origin: MemStack v2.0-v3.1)
- **Lv.2** -- Compressed: Decision-rule density rewrite. Removed inline code examples and curl scripts; preserved OWASP mapping, BOLA/IDOR methodology, auth bypass patterns, injection vectors by API type, rate limiting verification, data exposure checks, severity tree, endpoint discovery concepts. (Origin: MemStack v3.3, Mar 2026)
