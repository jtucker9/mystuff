---
name: owasp-top10
description: "WHAT: Systematic security assessment against OWASP Top 10 (2021). WHEN: user says 'OWASP', 'security audit', 'vulnerability assessment', 'XSS', 'SQL injection', 'SSRF', or needs comprehensive web app security review. NOT: dependency-only audits (dependency-audit), secrets scanning (secrets-scanner), HTTP headers only (csp-headers)."
---

# OWASP Top 10 -- Web Application Security Assessment

## Activation

| Context | Status |
|---------|--------|
| "OWASP", "security audit", "vulnerability assessment" | ACTIVE |
| Specific vulns: "XSS", "SQL injection", "SSRF" | ACTIVE |
| Comprehensive application security review | ACTIVE |
| Dependency scanning only | DORMANT -- see dependency-audit |
| Secrets scanning only | DORMANT -- see secrets-scanner |
| HTTP headers only | DORMANT -- see csp-headers |

## Instructions

### Step 1: Gather Inputs

Collect: tech stack (language, framework, DB, host), app type (API/SPA/SSR/monolith/microservices), auth mechanism (session/JWT/OAuth/API key), data sensitivity (PII/financial/healthcare/public), scope (full app/module/PR).

**Gate:** Do not proceed without stack and auth mechanism confirmed.

### Step 2: Assess All 10 Categories

For each category: search codebase for violation patterns, classify severity, note location.

**A01 Broken Access Control** -- Check: routes missing auth middleware; direct object references without ownership filter; admin endpoints lacking role verification server-side; CORS origin allowlist; JWT validated on every request not just login. Framework notes: Express -- middleware ordering matters, missing `next()` silently passes; Django -- `@login_required` is not `@permission_required`; Next.js -- API routes have no default auth; Supabase -- see rls-checker skill.

**A02 Cryptographic Failures** -- Check: password hashing algorithm (must be bcrypt/argon2/scrypt, reject MD5/SHA1/SHA256); TLS 1.2+ enforced; sensitive data encrypted at rest; no secrets in URLs/query strings; no hardcoded encryption keys. Framework notes: Django `SECRET_KEY` in settings.py not env = critical; Node `crypto.createCipher` is deprecated, must use `createCipheriv`.

**A03 Injection** -- Check: SQL via string concatenation/template literals (must be parameterized or ORM); OS command via `exec`/`system`/`popen` with user input; template injection via unescaped rendering. Framework notes: ORMs prevent SQL injection but raw query methods don't (Django `raw()`, Sequelize `literal()`); React auto-escapes JSX but `dangerouslySetInnerHTML` bypasses it.

**A04 Insecure Design** -- Check: rate limiting on auth endpoints; account lockout after N failures; user enumeration via registration/reset error messages; business logic abuse (coupon reuse, price manipulation); threat model existence. Not a code bug -- a missing control at the design level.

**A05 Security Misconfiguration** -- Check: debug mode in production; stack traces in error responses; default credentials; unnecessary HTTP methods (TRACE); server version headers (`X-Powered-By`, `Server`); admin interfaces publicly accessible. Framework notes: Django `DEBUG=True` leaks settings; Express sends `X-Powered-By: Express` by default; Rails `config.consider_all_requests_local`.

**A06 Vulnerable Components** -- Delegate to dependency-audit skill for full coverage. Quick check: run platform's native audit command (`npm audit`, `pip-audit`, `cargo audit`). Verify: no EOL runtimes, lock files committed, automated updates configured (Dependabot/Renovate).

**A07 Authentication Failures** -- Check: password minimum length (12+ chars); session cookie flags (`HttpOnly`, `Secure`, `SameSite`); token expiry (sessions 24h, reset tokens 15-30min); MFA availability for sensitive accounts; brute force protection on all auth endpoints. Framework notes: Express `express-session` defaults lack `secure` flag; Passport.js doesn't handle rate limiting.

**A08 Data Integrity Failures** -- Check: `eval()`/`pickle.load()`/`yaml.load()` on untrusted data; CI/CD actions pinned to SHA not `@latest`; CDN scripts have Subresource Integrity (SRI); database migrations reviewed before execution. Framework notes: Python `yaml.safe_load()` is safe, `yaml.load()` is not; PHP `unserialize()` on user data = RCE.

**A09 Logging and Monitoring Failures** -- Check: auth events logged (success + failure); authorization failures logged with user context; logs include timestamp/userID/IP/action/resource; logs exclude passwords/tokens/card numbers; log aggregation and alerting configured; 90+ day retention; tamper protection. Alert thresholds: 5+ login failures same IP, any permission change, bulk data export.

**A10 SSRF** -- Check: user-supplied URLs validated against allowlist; internal IP ranges blocked (127.x, 10.x, 172.16.x, 192.168.x, 169.254.x); cloud metadata blocked (169.254.169.254); redirects re-validated or blocked; DNS rebinding protection (resolve-then-fetch); protocol restricted to HTTP/HTTPS. Framework notes: any `fetch`/`axios`/`requests` call taking user input is a candidate.

**Gate:** All 10 categories assessed before proceeding to classification.

### Step 3: Classify Severity

| Severity | Priority | Criteria |
|----------|----------|----------|
| Critical | P0 -- fix now | Active exploitation possible, data breach risk, auth bypass |
| High | P1 -- fix this week | Privilege escalation, injection, SSRF to internal services |
| Medium | P2 -- fix this sprint | Info disclosure, weak crypto, missing rate limits |
| Low | P3 -- backlog | Missing headers, verbose errors, minor misconfigs |

**Gate:** Every finding has a severity assigned before output.

### Step 4: Verify Remediations

For each finding: confirm the fix addresses the pattern not just the instance. One SQL injection via concatenation means grep the entire codebase for the same pattern. Verify: parameterized queries adopted project-wide, not just at the reported location. Rerun the detection check to confirm zero matches.

### Step 5: Output Report

Format: summary (app name, stack, 10/10 assessed, finding counts by severity), category-by-category pass/fail with finding counts, detailed findings (category, severity, file:line, description, remediation), prioritized remediation plan (P0 through P3).

## Examples

**Express API with JWT auth:** Gather stack (Node/Express/PostgreSQL/JWT). A01: grep routes for missing auth middleware. A03: grep for template literal SQL. A07: check JWT expiry and cookie flags. A10: check if any endpoint fetches user-supplied URLs. Report findings with file locations and severity.

**Django SPA backend:** Gather stack (Python/Django/React/session auth). A02: check `SECRET_KEY` not hardcoded. A03: grep for `.raw()` and `.extra()` calls. A05: verify `DEBUG=False` in production settings. A09: check Django logging config captures auth events. Cross-reference with `settings.py` and middleware ordering.

## Common Issues

1. **ORM false safety** -- Teams assume ORM = no injection, but raw query escape hatches (`raw()`, `literal()`, `extra()`) reintroduce it. Always grep for raw query methods alongside string concatenation.
2. **Client-side auth checks only** -- Frontend route guards without server-side middleware. The route renders correctly but the API endpoint is wide open.
3. **Fixing instances not patterns** -- Patching one SQL injection while 12 others exist in the same codebase. The detection step must be project-wide, not file-scoped.

## Anti-Patterns

- Security by obscurity (hidden admin paths instead of auth enforcement)
- Client-side-only validation (everything bypassable via curl/Postman)
- Trusting JWTs without server-side signature/issuer/audience/expiry verification
- Pen testing as sole security measure (misses design flaws that code review catches)
- Fixing the finding not the pattern (one injection = assume more exist)

## Escalation

Hand off to security professional when: critical findings in production with exploitation evidence; complex auth architecture needs design review; compliance mandates certified assessors (PCI-DSS, HIPAA, SOC 2); custom crypto implementations; active incident response needed.

## Inputs

- Codebase access and tech stack
- Application type and architecture
- Authentication mechanism
- Data sensitivity classification

## Outputs

- 10/10 category assessment with pass/fail and finding counts
- Findings with severity, file:line location, description, and remediation
- Prioritized remediation plan (P0-P3)
- Scan tool recommendations by category: SAST (static analysis -- semgrep, CodeQL) for A01-A03/A08/A10; DAST (dynamic testing -- OWASP ZAP, Burp) for A04/A05/A07; SCA (composition analysis -- npm audit, Snyk) for A06

## Level History

- **Lv.1** -- Base: Full OWASP Top 10 2021 assessment with detection commands, vulnerable/fixed code examples for each category, severity classification, checklists per category, remediation priority matrix. (Origin: MemStack v3.3, Mar 2026)
- **Lv.2** -- Compressed: Decision-rule format, validation gates, framework-specific gotchas, pattern-not-instance remediation verification, scan tool categorization (SAST/DAST/SCA), removed tutorial code blocks. (Origin: MemStack v3.4, Mar 2026)
