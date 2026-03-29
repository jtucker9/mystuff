---
name: owasp-top10
description: "Use when the user says 'OWASP', 'OWASP top 10', 'security audit', 'vulnerability assessment', 'full security check', 'XSS', 'SQL injection', 'SSRF', or needs a comprehensive web application security review. Do NOT use for dependency-only audits (see dependency-audit) or secrets scanning (see secrets-scanner)."
---

# 🏛️ OWASP Top 10 — Web Application Security Assessment
*Systematic security assessment against the OWASP Top 10 (2021) vulnerability categories with detection methods, code examples, and remediation for each.*

## Activation

When this skill activates, output:

`🏛️ OWASP Top 10 — Running comprehensive security assessment...`

| Context | Status |
|---------|--------|
| **User says "OWASP", "security audit", "vulnerability assessment"** | ACTIVE |
| **User mentions specific vulns: "XSS", "SQL injection", "SSRF"** | ACTIVE |
| **User wants comprehensive application security review** | ACTIVE |
| **User wants dependency scanning only** | DORMANT — see dependency-audit |
| **User wants secrets scanning only** | DORMANT — see secrets-scanner |
| **User wants HTTP headers only** | DORMANT — see csp-headers |

## Protocol

### Step 1: Gather Inputs

- **Tech stack**: Language, framework, database, hosting
- **Application type**: API, SPA, SSR, monolith, microservices
- **Authentication**: Session-based, JWT, OAuth, API keys
- **Data sensitivity**: PII, financial, healthcare, public
- **Scope**: Full app, specific module, or code review of PR

### Step 2: Assess Each OWASP Category

---

#### A01:2021 — Broken Access Control

**What**: Users acting outside their intended permissions — accessing other users' data, elevating privileges, or bypassing access checks.

**Detection:**
```bash
# Find routes/endpoints missing auth middleware
grep -rn "router\.\(get\|post\|put\|delete\)" --include="*.js" --include="*.ts" | grep -v "auth\|protect\|guard\|middleware"

# Find direct object references without ownership checks
grep -rn "params\.id\|params\.userId\|req\.params" --include="*.js" --include="*.ts" | grep -v "auth\.uid\|req\.user\|session\.user"
```

**Vulnerable vs Fixed:**
```javascript
// ❌ VULNERABLE — IDOR: any user can access any invoice
app.get('/api/invoices/:id', async (req, res) => {
  const invoice = await db.query('SELECT * FROM invoices WHERE id = $1', [req.params.id]);
  res.json(invoice);
});

// ✅ FIXED — ownership check
app.get('/api/invoices/:id', authenticate, async (req, res) => {
  const invoice = await db.query(
    'SELECT * FROM invoices WHERE id = $1 AND user_id = $2',
    [req.params.id, req.user.id]
  );
  if (!invoice) return res.status(404).json({ error: 'Not found' });
  res.json(invoice);
});
```

**Checklist:**
- [ ] Every endpoint has authentication middleware
- [ ] Object access includes ownership/permission check
- [ ] Admin endpoints verify admin role server-side
- [ ] CORS is configured to allow only trusted origins
- [ ] Directory listing is disabled on web servers
- [ ] JWT tokens are validated on every request (not just at login)

---

#### A02:2021 — Cryptographic Failures

**What**: Weak or missing encryption for sensitive data — plaintext passwords, weak hashing, exposed data in transit.

**Detection:**
```bash
# Find plaintext password storage
grep -rn "password" --include="*.js" --include="*.ts" --include="*.py" | grep -iE "(= |:.*req\.|\.body\.|insert|update)" | grep -v "hash\|bcrypt\|argon\|scrypt"

# Find weak crypto
grep -rn "md5\|sha1\|DES\|RC4\|createCipher(" --include="*.js" --include="*.ts" --include="*.py"

# Find hardcoded encryption keys
grep -rn "encryption_key\|secret_key\|AES_KEY" --include="*.js" --include="*.ts" --include="*.py" | grep -E '=\s*["\x27]'
```

**Vulnerable vs Fixed:**
```python
# ❌ VULNERABLE — MD5 password hash (fast, crackable)
import hashlib
password_hash = hashlib.md5(password.encode()).hexdigest()

# ✅ FIXED — bcrypt with cost factor
import bcrypt
password_hash = bcrypt.hashpw(password.encode(), bcrypt.gensalt(rounds=12))
```

**Checklist:**
- [ ] Passwords hashed with bcrypt, argon2, or scrypt (NOT MD5/SHA1/SHA256)
- [ ] All traffic over HTTPS (TLS 1.2+ minimum, prefer 1.3)
- [ ] Sensitive data encrypted at rest (database, backups)
- [ ] No sensitive data in URLs (tokens, passwords in query strings)
- [ ] Encryption keys stored in environment variables, not code
- [ ] Old/weak cipher suites disabled

---

#### A03:2021 — Injection

**What**: Untrusted data sent to an interpreter as part of a command — SQL injection, NoSQL injection, OS command injection, LDAP injection.

**Detection:**
```bash
# SQL injection — string concatenation in queries
grep -rn "query.*\`\|query.*+ \|query.*%s\|query.*format\|execute.*f'" --include="*.js" --include="*.ts" --include="*.py" | grep -v "parameterized\|\$[0-9]\|?"

# Command injection
grep -rn "exec(\|execSync\|spawn(\|system(\|popen(\|os\.system\|subprocess\.call\|child_process" --include="*.js" --include="*.ts" --include="*.py"

# Template injection
grep -rn "render.*req\.\|template.*req\.\|eval(\|Function(" --include="*.js" --include="*.ts"
```

**Vulnerable vs Fixed:**
```javascript
// ❌ VULNERABLE — SQL injection via string concatenation
const user = await db.query(`SELECT * FROM users WHERE email = '${req.body.email}'`);

// ✅ FIXED — parameterized query
const user = await db.query('SELECT * FROM users WHERE email = $1', [req.body.email]);
```

```python
# ❌ VULNERABLE — command injection
import os
os.system(f"convert {user_filename} output.png")

# ✅ FIXED — use subprocess with argument list (no shell)
import subprocess
subprocess.run(["convert", user_filename, "output.png"], check=True)
```

**Checklist:**
- [ ] All SQL uses parameterized queries or ORM (never string concatenation)
- [ ] User input never passed to OS commands (use libraries instead)
- [ ] Template rendering uses auto-escaping
- [ ] Input validation on all user-supplied data (type, length, range)
- [ ] ORM used where possible to abstract SQL

---

#### A04:2021 — Insecure Design

**What**: Missing or ineffective security controls at the design level — no rate limiting, no account lockout, no fraud detection, threat modeling gaps.

**Assessment questions:**
- Is there rate limiting on login, registration, and password reset?
- Is there account lockout after N failed login attempts?
- Can a user enumerate valid email addresses via registration/reset?
- Are business logic flows protected against abuse (e.g., coupon reuse, price manipulation)?
- Is there a threat model documented for the application?

**Key patterns:**
```javascript
// ❌ INSECURE DESIGN — no rate limiting on login
app.post('/api/login', async (req, res) => {
  const user = await authenticate(req.body.email, req.body.password);
  // Attacker can brute-force passwords unlimited
});

// ✅ SECURE DESIGN — rate limiting + account lockout
const loginLimiter = rateLimit({ windowMs: 15 * 60 * 1000, max: 5 });
app.post('/api/login', loginLimiter, async (req, res) => {
  const failedAttempts = await getFailedAttempts(req.body.email);
  if (failedAttempts >= 5) return res.status(423).json({ error: 'Account locked. Try again in 15 minutes.' });
  // ... authenticate
});
```

**Checklist:**
- [ ] Rate limiting on authentication endpoints
- [ ] Account lockout after repeated failures
- [ ] Consistent error messages (don't reveal if email exists)
- [ ] Business logic abuse protection (can't reuse coupons, manipulate prices)
- [ ] Threat model exists and is reviewed with changes

---

#### A05:2021 — Security Misconfiguration

**What**: Default configs, unnecessary features enabled, missing security hardening, verbose error messages in production.

**Detection:**
```bash
# Debug mode in production
grep -rn "DEBUG.*=.*True\|NODE_ENV.*development\|debug:\s*true" --include="*.py" --include="*.js" --include="*.env"

# Default credentials
grep -rn "admin:admin\|root:root\|password:password\|default.*password" --include="*.js" --include="*.py" --include="*.yaml" --include="*.yml"

# Verbose errors exposed
grep -rn "stack.*trace\|\.stack\|traceback\|res\.send.*err\)" --include="*.js" --include="*.ts"

# Unnecessary HTTP methods
curl -X OPTIONS https://example.com/api/users -i
```

**Checklist:**
- [ ] Debug mode OFF in production
- [ ] Error messages don't expose stack traces, SQL, or internal paths
- [ ] Default accounts/passwords changed or removed
- [ ] Directory listing disabled
- [ ] Unnecessary HTTP methods disabled (TRACE, OPTIONS where unneeded)
- [ ] Security headers configured (see csp-headers skill)
- [ ] Admin interfaces not publicly accessible
- [ ] Server version headers removed (`Server:`, `X-Powered-By:`)

---

#### A06:2021 — Vulnerable and Outdated Components

**What**: Using libraries, frameworks, or platforms with known vulnerabilities.

*See the **dependency-audit** skill for comprehensive coverage.* Quick checks:

```bash
npm audit          # Node.js
pip-audit          # Python
cargo audit        # Rust
bundle audit check # Ruby
```

**Checklist:**
- [ ] Dependencies scanned for known CVEs
- [ ] No end-of-life frameworks or runtimes
- [ ] Lock files committed and reviewed
- [ ] Automated dependency updates configured (Dependabot, Renovate)

---

#### A07:2021 — Identification and Authentication Failures

**What**: Weak authentication — permits brute force, allows weak passwords, poor session management, credential stuffing.

**Detection:**
```bash
# Weak password requirements
grep -rn "password.*length\|minlength\|min.*pass" --include="*.js" --include="*.ts" --include="*.py"

# Session management issues
grep -rn "cookie\|session\|jwt\|token" --include="*.js" --include="*.ts" | grep -iE "(httponly|secure|samesite|maxage|expires)"
```

**Vulnerable vs Fixed:**
```javascript
// ❌ VULNERABLE — no password requirements, session never expires
app.post('/register', async (req, res) => {
  await createUser(req.body.email, req.body.password); // accepts "123"
  req.session.userId = user.id; // no expiry set
});

// ✅ FIXED — strong password, secure session
app.post('/register', async (req, res) => {
  if (req.body.password.length < 12) return res.status(400).json({ error: 'Minimum 12 characters' });
  const hash = await bcrypt.hash(req.body.password, 12);
  await createUser(req.body.email, hash);
  req.session.userId = user.id;
  req.session.cookie.maxAge = 24 * 60 * 60 * 1000; // 24h
  req.session.cookie.httpOnly = true;
  req.session.cookie.secure = true;
  req.session.cookie.sameSite = 'lax';
});
```

**Checklist:**
- [ ] Minimum password length 12+ characters
- [ ] Multi-factor authentication available for sensitive accounts
- [ ] Session tokens are random, long, and invalidated on logout
- [ ] Cookies set with `HttpOnly`, `Secure`, `SameSite`
- [ ] Password reset tokens expire (15-30 minutes)
- [ ] Brute force protection on all auth endpoints
- [ ] Credential stuffing protection (rate limiting, CAPTCHA after failures)

---

#### A08:2021 — Software and Data Integrity Failures

**What**: Code and infrastructure that doesn't verify integrity — CI/CD pipeline poisoning, unsigned updates, insecure deserialization.

**Detection:**
```bash
# Insecure deserialization
grep -rn "JSON\.parse\|pickle\.load\|yaml\.load\|unserialize\|eval(" --include="*.js" --include="*.ts" --include="*.py" --include="*.php"

# CI/CD using untrusted actions
grep -rn "uses:" .github/workflows/*.yml | grep -v "actions/\|github/"

# Subresource integrity missing
grep -rn "<script.*src=.*http" --include="*.html" | grep -v "integrity="
```

**Checklist:**
- [ ] CI/CD pipeline actions pinned to specific SHA (not `@latest` or `@main`)
- [ ] Subresource Integrity (SRI) on CDN-loaded scripts/styles
- [ ] No `eval()`, `pickle.load()`, or `yaml.load()` on untrusted data
- [ ] Software updates verified with signatures
- [ ] Database migrations reviewed before execution

---

#### A09:2021 — Security Logging and Monitoring Failures

**What**: Insufficient logging of security events, no alerting on suspicious activity, inability to detect breaches.

**What to log:**
| Event | Log? | Alert? |
|-------|------|--------|
| Login success | ✅ | No |
| Login failure | ✅ | After 5+ from same IP |
| Password change | ✅ | ✅ notify user |
| Permission change | ✅ | ✅ |
| Admin action | ✅ | Depends |
| Data export/download | ✅ | ✅ if bulk |
| API rate limit hit | ✅ | After pattern |
| 401/403 errors | ✅ | After 10+ from same source |
| Input validation failure | ✅ | After pattern (may indicate probing) |

**Checklist:**
- [ ] Authentication events logged (success and failure)
- [ ] Authorization failures logged with user context
- [ ] Logs include timestamp, user ID, IP, action, resource
- [ ] Logs do NOT contain passwords, tokens, or full credit card numbers
- [ ] Log aggregation and alerting configured
- [ ] Logs retained for incident investigation (90+ days)
- [ ] Log tampering protection (append-only, separate system)

---

#### A10:2021 — Server-Side Request Forgery (SSRF)

**What**: Application fetches a URL supplied by the user, allowing attackers to reach internal services, cloud metadata, or localhost.

**Detection:**
```bash
# Find URL fetching from user input
grep -rn "fetch(\|axios\.\|request(\|urllib\|requests\.\(get\|post\)\|http\.\(get\|request\)" --include="*.js" --include="*.ts" --include="*.py" | grep -iE "req\.\|body\.\|params\.\|query\."
```

**Vulnerable vs Fixed:**
```javascript
// ❌ VULNERABLE — fetches any URL the user provides
app.post('/api/preview', async (req, res) => {
  const response = await fetch(req.body.url);  // Can fetch http://169.254.169.254/latest/meta-data/
  res.json({ content: await response.text() });
});

// ✅ FIXED — URL allowlist + block internal ranges
const { URL } = require('url');
const ipRangeCheck = require('ip-range-check');

const BLOCKED_RANGES = ['127.0.0.0/8', '10.0.0.0/8', '172.16.0.0/12', '192.168.0.0/16', '169.254.0.0/16', '0.0.0.0/8'];

app.post('/api/preview', async (req, res) => {
  const parsed = new URL(req.body.url);
  if (!['http:', 'https:'].includes(parsed.protocol)) return res.status(400).json({ error: 'Invalid protocol' });
  const resolved = await dns.resolve4(parsed.hostname);
  if (resolved.some(ip => ipRangeCheck(ip, BLOCKED_RANGES))) return res.status(400).json({ error: 'Blocked' });
  const response = await fetch(req.body.url, { redirect: 'error' });
  res.json({ content: await response.text() });
});
```

**Checklist:**
- [ ] User-supplied URLs validated against allowlist
- [ ] Internal IP ranges blocked (127.x, 10.x, 172.16.x, 192.168.x, 169.254.x)
- [ ] Cloud metadata endpoints blocked (169.254.169.254)
- [ ] Redirects not followed (or re-validated after redirect)
- [ ] DNS rebinding protection (resolve then fetch, don't fetch URL directly)
- [ ] Protocol restricted to HTTP/HTTPS only

---

### Step 3: Severity Classification

| Finding | Severity | Criteria |
|---------|----------|----------|
| 🔴 Critical | P0 — Fix now | Active exploitation possible, data breach risk, auth bypass |
| 🟠 High | P1 — Fix this week | Privilege escalation, injection, SSRF to internal services |
| 🟡 Medium | P2 — Fix this sprint | Information disclosure, weak crypto, missing rate limits |
| 🟢 Low | P3 — Fix in backlog | Missing headers, verbose errors, minor misconfigs |

### Step 4: Output

```
━━━ OWASP TOP 10 SECURITY ASSESSMENT ━━━━

── SUMMARY ───────────────────────────────
Application: [name]
Stack: [tech stack]
Categories assessed: 10/10
Findings: [N] (Critical: X, High: Y, Medium: Z, Low: W)

── FINDINGS BY CATEGORY ──────────────────
A01 Broken Access Control:     [✅ Pass / 🔴 X findings]
A02 Cryptographic Failures:    [✅ Pass / 🔴 X findings]
A03 Injection:                 [✅ Pass / 🔴 X findings]
A04 Insecure Design:           [✅ Pass / 🟡 X findings]
A05 Security Misconfiguration: [✅ Pass / 🟡 X findings]
A06 Vulnerable Components:     [✅ Pass / 🟡 X findings]
A07 Authentication Failures:   [✅ Pass / 🔴 X findings]
A08 Data Integrity Failures:   [✅ Pass / 🟡 X findings]
A09 Logging Failures:          [✅ Pass / 🟢 X findings]
A10 SSRF:                      [✅ Pass / 🔴 X findings]

── DETAILED FINDINGS ─────────────────────
[per-finding: category, severity, location, description, fix]

── REMEDIATION PRIORITY ──────────────────
P0: [immediate fixes]
P1: [this week]
P2: [this sprint]
P3: [backlog]
```

## Anti-Patterns

- **Security by obscurity**: Hiding admin panels at `/admin-secret-path` is not access control. Always enforce authentication.
- **Client-side-only validation**: Everything on the client can be bypassed. Always validate server-side.
- **Trusting JWTs without verification**: Always verify the signature, issuer, audience, and expiration server-side.
- **Fixing only the specific finding, not the pattern**: One SQL injection means others likely exist. Fix the pattern (adopt parameterized queries everywhere), not just the instance.
- **Penetration testing as the only security measure**: Pen tests find known patterns. Threat modeling and code review catch design flaws that automated tools miss.

## Escalation

Hand off to a security professional when:
- Critical findings in production with evidence of exploitation
- Complex authentication/authorization architecture needs design review
- Compliance requirements (PCI-DSS, HIPAA, SOC 2) mandate certified assessors
- Custom cryptographic implementations need expert review
- Active incident response is needed (breach detected)

## Inputs
- Codebase access and tech stack
- Application type and architecture
- Authentication mechanism
- Data sensitivity classification

## Outputs
- Category-by-category assessment (10/10 OWASP categories)
- Findings with severity, location, description, and fix
- Vulnerable vs fixed code examples for each finding
- Prioritized remediation plan
- Security checklists for ongoing compliance

## Level History

- **Lv.1** — Base: Full OWASP Top 10 2021 assessment with detection commands, vulnerable/fixed code examples for each category, severity classification, checklists per category, remediation priority matrix. (Origin: MemStack v3.3, Mar 2026)
