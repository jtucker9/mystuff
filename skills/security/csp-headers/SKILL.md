---
name: csp-headers
description: "Configure Content-Security-Policy and HTTP security headers. WHEN: 'CSP', 'Content-Security-Policy', 'security headers', 'HSTS', 'X-Frame-Options', 'clickjacking', 'XSS protection headers'. NOT: API endpoint security (api-audit), dependency scanning (dependency-audit), full OWASP assessment (owasp-top10)."
---

# CSP and Security Headers

## Activation

| Context | Status |
|---------|--------|
| User says "CSP", "security headers", "Content-Security-Policy" | ACTIVE |
| User mentions "HSTS", "X-Frame-Options", "clickjacking protection" | ACTIVE |
| User wants to fix mixed content or frame embedding issues | ACTIVE |
| User wants API endpoint security review | DORMANT -- see api-audit |
| User wants dependency vulnerability scanning | DORMANT -- see dependency-audit |

## Instructions

### Step 1: Gather Inputs

Collect: target URL(s), serving platform (nginx/Apache/Caddy/Express/Next.js/Cloudflare/etc.), existing headers if any, third-party scripts/styles/fonts/APIs loaded, iframe requirements (embed others or embedded by others), compliance needs (PCI-DSS, HIPAA, SOC 2).

**Gate:** Do not proceed without at least URL and platform identified.

### Step 2: Audit Current Headers

Run `curl -sI <url>` and score each header against this checklist:

| Header | Threat Mitigated |
|--------|-----------------|
| `Content-Security-Policy` | XSS, data injection, clickjacking |
| `Strict-Transport-Security` | Protocol downgrade, MITM |
| `X-Frame-Options` | Clickjacking (legacy; CSP `frame-ancestors` supersedes) |
| `X-Content-Type-Options` | MIME sniffing attacks |
| `Referrer-Policy` | URL-based data leakage |
| `Permissions-Policy` | Unauthorized browser API access |
| `Cross-Origin-Opener-Policy` | Cross-origin window reference attacks |
| `Cross-Origin-Embedder-Policy` | Spectre-class side-channel (enables `SharedArrayBuffer`) |
| `Cross-Origin-Resource-Policy` | Unauthorized cross-origin resource reads |

Grade: A = present + strict, B = present + weak, F = missing. Remove deprecated `X-XSS-Protection` if found (introduces vulnerabilities in older browsers; CSP replaces it).

**Gate:** Audit table must be complete before building CSP.

### Step 3: Build CSP Directives

Map each directive to its threat surface:

| Directive | Controls | Default to |
|-----------|----------|-----------|
| `default-src` | Fallback for all fetch directives | `'self'` |
| `script-src` | JS execution (primary XSS surface) | `'self'` + nonces for inline |
| `style-src` | CSS loading | `'self'` + nonces preferred over `'unsafe-inline'` |
| `img-src` | Image loading | `'self' data: https:` |
| `font-src` | Font loading | `'self'` + CDN domains |
| `connect-src` | XHR, fetch, WebSocket | `'self'` + API domains |
| `object-src` | Plugins (Flash legacy) | `'none'` always |
| `frame-src` | Iframes loaded BY this page | `'none'` unless embedding |
| `frame-ancestors` | Who can iframe THIS page | `'none'` unless embedded |
| `base-uri` | `<base>` tag restriction | `'self'` |
| `form-action` | Form submission targets | `'self'` |
| `upgrade-insecure-requests` | HTTP to HTTPS auto-upgrade | Always include |

**Nonce vs hash decision:**
- Inline scripts exist and can be refactored out --> `script-src 'self'` (strictest)
- Few inline scripts, server renders pages --> nonces (per-request random, added to `<script nonce="...">`)
- Static inline scripts, no server rendering (SPA) --> hashes (`'sha256-...'`)
- Last resort only --> `'unsafe-inline'` (negates XSS protection)

Nonces require server-side generation (16+ random bytes, base64). Each request gets a fresh nonce. Hash is computed on exact script content; any whitespace change invalidates it.

**Trusted Types:** For applications with heavy DOM manipulation, add `require-trusted-types-for 'script'` to prevent DOM XSS. Libraries must be Trusted Types compatible or wrapped.

**Gate:** Each `'unsafe-inline'` or `'unsafe-eval'` inclusion must have a documented justification.

### Step 4: Configure Remaining Headers

Decision rules for each:

**HSTS:** HTTPS-only with no revert plans --> `max-age=63072000; includeSubDomains`. Add `preload` only when certain (removal from preload list takes months; submit at hstspreload.org). Some subdomains on HTTP --> omit `includeSubDomains`. Uncertain --> start with `max-age=86400` and increase.

**X-Frame-Options:** Not embedded --> `DENY`. Same-domain embedding only --> `SAMEORIGIN`. Specific external domains --> use CSP `frame-ancestors` instead (X-Frame-Options cannot allowlist specific domains). Set both for legacy browser compatibility.

**Referrer-Policy:** Sensitive data in URLs --> `no-referrer` or `same-origin`. Privacy-conscious default --> `strict-origin-when-cross-origin`. Affiliates need referrer data --> `no-referrer-when-downgrade`.

**Permissions-Policy:** Disable unused browser APIs: `camera=(), microphone=(), geolocation=(), payment=(), usb=()`. First-party use --> `camera=(self)`. Specific iframe needs access --> `camera=(self "https://allowed.example.com")`.

**Gate:** All headers from the Step 2 checklist must have a configured value before generating platform config.

### Step 5: Generate Platform Config

Produce ready-to-paste configuration for the user's identified platform. Use the `always` flag in nginx `add_header` (without it, error pages lack headers). For Express, prefer `helmet` middleware. For Next.js, use `headers()` in config.

**Gate:** Config must include every header from Steps 3-4. Verify no copy-paste artifacts from other platforms.

### Step 6: Deploy Report-Only First

Three-phase rollout -- never skip to enforcing:

1. **Report-Only (1-2 weeks):** Use `Content-Security-Policy-Report-Only` header with `report-uri /csp-report`. Collect violations, identify legitimate breakage. Zero enforcement.
2. **Tighten (1 week):** Allowlist legitimate sources from reports. Remove unnecessary `'unsafe-inline'`/`'unsafe-eval'`. Redeploy as report-only.
3. **Enforce:** Switch to `Content-Security-Policy`. Monitor 48 hours post-deploy. Keep `report-uri` active permanently.

**Gate:** User must confirm report-only results reviewed before recommending enforcement switch.

## Examples

**SPA with Google Analytics and Stripe:** `default-src 'self'` base. Add GA domains to `script-src` and `connect-src`, Stripe to `script-src` and `frame-src`. Use nonces for any inline bootstrap scripts. `object-src 'none'; frame-ancestors 'none'`.

**Static marketing site, no inline JS:** `default-src 'self'; script-src 'self'; style-src 'self'; img-src 'self' data: https:; object-src 'none'; frame-ancestors 'none'; upgrade-insecure-requests`. Strictest posture; no nonces/hashes needed.

## Common Issues

1. **`eval is not allowed` from libraries:** Some libraries (template engines, charting libs) use `eval()`. Adding `'unsafe-eval'` weakens CSP. Prefer libraries that don't require it. If unavoidable, isolate to that specific `script-src` entry and document the risk.
2. **Inline styles break after CSP:** Frameworks (React, styled-components) inject inline styles. Use nonces in SSR or accept `'unsafe-inline'` in `style-src` (lower risk than in `script-src` since style injection rarely enables code execution).
3. **Third-party widget loads cascade:** Chat widgets, analytics, and ad scripts often load additional sub-resources from undocumented domains. Report-only phase catches these. Expect 2-3 iterations to stabilize allowlists.

## Anti-Patterns

- `'unsafe-inline' + 'unsafe-eval'` on all directives -- defeats CSP entirely; fix root cause instead
- Copy-pasting CSP from another site -- every site has different dependencies; build from actual resource loading
- Deploying enforcing CSP without report-only phase -- will break production
- Setting HSTS `preload` casually -- removal takes months once submitted
- Omitting `always` in nginx `add_header` -- error pages (404, 500) left unprotected
- Ignoring `frame-ancestors` in CSP and relying solely on `X-Frame-Options` -- CSP is more flexible and takes precedence in modern browsers

## Escalation

Hand off to security specialist when:
- Payment processing is involved (PCI-DSS has specific header requirements)
- Cross-origin isolation needed for `SharedArrayBuffer` (COOP/COEP interactions are complex)
- Service Workers with complex caching interact with CSP
- Multiple teams own different parts of the same domain (CSP coordination)
- Specific compliance audit required (SOC 2, ISO 27001)

## Inputs

- Application URL(s) and serving platform
- Current security headers (if any)
- Third-party services and CDNs in use
- Iframe embedding requirements
- Compliance requirements

## Outputs

- Current headers audit with grades
- CSP built directive-by-directive with justifications
- Full security headers set
- Platform-specific configuration (ready to paste)
- Report-only rollout plan with phases

## Level History

- **Lv.1** -- Base: Directive-by-directive CSP builder, all major security headers with decision trees, platform configs for 6 server types, nonce and hash implementation, report-only rollout strategy, violation debugging guide, third-party allowlist reference. (Origin: MemStack v3.3, Mar 2026)
- **Lv.2** -- Compressed: Removed full config blocks and code samples, retained decision logic and directive mapping, added validation gates, added Trusted Types concept, tightened anti-patterns. (Origin: MemStack v3.4, Mar 2026)
