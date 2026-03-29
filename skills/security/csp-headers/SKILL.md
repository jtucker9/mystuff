---
name: csp-headers
description: "Use when the user says 'CSP', 'Content-Security-Policy', 'security headers', 'HSTS', 'X-Frame-Options', 'clickjacking', 'XSS protection headers', or needs to configure HTTP security headers for a web application. Do NOT use for API endpoint security (see api-audit) or dependency scanning (see dependency-audit)."
---

# 🛡️ CSP & Security Headers — HTTP Security Header Configuration
*Audit, generate, and deploy Content-Security-Policy and HTTP security headers across web servers and frameworks.*

## Activation

When this skill activates, output:

`🛡️ CSP & Security Headers — Analyzing and configuring HTTP security headers...`

| Context | Status |
|---------|--------|
| **User says "CSP", "security headers", "Content-Security-Policy"** | ACTIVE |
| **User mentions "HSTS", "X-Frame-Options", "clickjacking protection"** | ACTIVE |
| **User wants to fix mixed content or frame embedding issues** | ACTIVE |
| **User wants API endpoint security review** | DORMANT — see api-audit |
| **User wants dependency vulnerability scanning** | DORMANT — see dependency-audit |
| **User wants full OWASP assessment** | DORMANT — see owasp-top10 |

## Protocol

### Step 1: Gather Inputs

Ask the user for:
- **Application URL(s)**: What domains/subdomains need headers?
- **Tech stack**: What serves the responses? (nginx, Apache, Caddy, Express, Next.js, Cloudflare, etc.)
- **Current state**: Are any security headers already configured?
- **Third-party services**: What external scripts/styles/fonts/APIs are loaded? (analytics, CDNs, payment processors, chat widgets)
- **Iframe requirements**: Does the app need to be embedded in iframes? Does it embed other sites?
- **Compliance needs**: Any specific requirements? (PCI-DSS, HIPAA, SOC 2)

### Step 2: Audit Current Headers

Check existing headers using curl:

```bash
# Check all security-relevant headers
curl -sI https://example.com | grep -iE '(content-security|strict-transport|x-frame|x-content-type|referrer-policy|permissions-policy|cross-origin|x-xss)'

# Check for missing headers
curl -sI https://example.com | head -30
```

**Score each header** against this checklist:

| Header | Present? | Value | Grade |
|--------|----------|-------|-------|
| `Content-Security-Policy` | | | |
| `Strict-Transport-Security` | | | |
| `X-Frame-Options` | | | |
| `X-Content-Type-Options` | | | |
| `Referrer-Policy` | | | |
| `Permissions-Policy` | | | |
| `Cross-Origin-Opener-Policy` | | | |
| `Cross-Origin-Embedder-Policy` | | | |
| `Cross-Origin-Resource-Policy` | | | |

**Grading:**
- 🟢 **A**: Header present with strict, correct value
- 🟡 **B**: Header present but could be stricter
- 🔴 **F**: Header missing or misconfigured

### Step 3: Build Content-Security-Policy

CSP is the most complex and impactful header. Build it directive by directive.

**Directive Reference:**

| Directive | Controls | Recommended Default |
|-----------|----------|-------------------|
| `default-src` | Fallback for all fetch directives | `'self'` |
| `script-src` | JavaScript execution | `'self'` (add nonces for inline) |
| `style-src` | CSS loading | `'self' 'unsafe-inline'` (or nonces) |
| `img-src` | Image loading | `'self' data: https:` |
| `font-src` | Font loading | `'self'` |
| `connect-src` | XHR, fetch, WebSocket | `'self'` + API domains |
| `media-src` | Audio/video | `'self'` |
| `object-src` | Plugins (Flash, etc.) | `'none'` |
| `frame-src` | Iframes loaded BY the page | `'none'` (unless embedding) |
| `frame-ancestors` | Who can iframe THIS page | `'none'` (unless embedded) |
| `base-uri` | `<base>` tag restriction | `'self'` |
| `form-action` | Form submission targets | `'self'` |
| `upgrade-insecure-requests` | Auto-upgrade HTTP to HTTPS | Include always |
| `block-all-mixed-content` | Block HTTP on HTTPS pages | Include always |
| `report-uri` / `report-to` | Violation reporting endpoint | Configure for monitoring |

**Decision Tree — Inline Script Strategy:**

```
Do you have inline <script> tags or onclick handlers?
├── No → Use `script-src 'self'` (strictest)
├── Yes, and you CAN refactor them out
│   └── Refactor to external files → `script-src 'self'`
├── Yes, but refactoring is impractical
│   ├── Few inline scripts → Use nonces: `script-src 'nonce-{random}'`
│   └── Many inline scripts → Use hashes: `script-src 'sha256-{hash}'`
└── Yes, and you need maximum compatibility
    └── Last resort: `script-src 'self' 'unsafe-inline'` (weakens XSS protection)
```

**Nonce Implementation (recommended for inline scripts):**

```javascript
// Express middleware — generate per-request nonce
const crypto = require('crypto');

app.use((req, res, next) => {
  const nonce = crypto.randomBytes(16).toString('base64');
  res.locals.nonce = nonce;
  res.setHeader('Content-Security-Policy',
    `default-src 'self'; script-src 'self' 'nonce-${nonce}'; style-src 'self' 'nonce-${nonce}'; object-src 'none'; base-uri 'self';`
  );
  next();
});

// In templates: <script nonce="<%= nonce %>">...</script>
```

```python
# FastAPI middleware
import secrets, base64

@app.middleware("http")
async def csp_middleware(request, call_next):
    nonce = base64.b64encode(secrets.token_bytes(16)).decode()
    request.state.nonce = nonce
    response = await call_next(request)
    response.headers["Content-Security-Policy"] = (
        f"default-src 'self'; script-src 'self' 'nonce-{nonce}'; "
        f"style-src 'self' 'nonce-{nonce}'; object-src 'none'; base-uri 'self';"
    )
    return response
```

**Hash Implementation (for static inline scripts):**

```bash
# Generate hash of an inline script
echo -n 'console.log("hello")' | openssl dgst -sha256 -binary | base64
# Output: abc123...
# Use in CSP: script-src 'sha256-abc123...'
```

**Common Third-Party CSP Allowlists:**

| Service | Directives Needed |
|---------|-------------------|
| Google Analytics | `script-src https://www.googletagmanager.com https://www.google-analytics.com; connect-src https://www.google-analytics.com; img-src https://www.google-analytics.com` |
| Google Fonts | `style-src https://fonts.googleapis.com; font-src https://fonts.gstatic.com` |
| Stripe | `script-src https://js.stripe.com; frame-src https://js.stripe.com https://hooks.stripe.com` |
| YouTube embeds | `frame-src https://www.youtube.com https://www.youtube-nocookie.com` |
| Cloudflare CDN | `script-src https://cdnjs.cloudflare.com; style-src https://cdnjs.cloudflare.com` |
| Sentry | `script-src https://browser.sentry-cdn.com; connect-src https://*.ingest.sentry.io` |
| Intercom | `script-src https://widget.intercom.io; connect-src https://*.intercom.io wss://*.intercom.io; frame-src https://intercom-sheets.com` |
| Hotjar | `script-src https://static.hotjar.com https://script.hotjar.com; connect-src https://*.hotjar.com wss://*.hotjar.io; frame-src https://vars.hotjar.com; img-src https://static.hotjar.com` |

### Step 4: Configure All Security Headers

**Complete header set with recommended values:**

```
# === CRITICAL ===
Content-Security-Policy: [built in Step 3]
Strict-Transport-Security: max-age=63072000; includeSubDomains; preload
X-Content-Type-Options: nosniff
X-Frame-Options: DENY

# === IMPORTANT ===
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: camera=(), microphone=(), geolocation=(), payment=()

# === ADVANCED (Cross-Origin Isolation) ===
Cross-Origin-Opener-Policy: same-origin
Cross-Origin-Embedder-Policy: require-corp
Cross-Origin-Resource-Policy: same-origin
```

**Header-by-header decision guide:**

**Strict-Transport-Security (HSTS):**
```
Is the site HTTPS-only with no plans to revert?
├── Yes, single domain → max-age=63072000; includeSubDomains
├── Yes, ready for browser preload → max-age=63072000; includeSubDomains; preload
│   └── Then submit to https://hstspreload.org
├── Yes, but some subdomains are HTTP → max-age=63072000 (no includeSubDomains)
└── No / unsure → Start with max-age=86400 (1 day), increase gradually
```

**X-Frame-Options:**
```
Does this site need to be embedded in iframes?
├── No → DENY
├── Yes, only by same domain → SAMEORIGIN
└── Yes, by specific domains → Use CSP frame-ancestors instead
    (X-Frame-Options cannot allowlist specific domains)
```

**Referrer-Policy:**
```
Does the site pass sensitive data in URLs (tokens, user IDs)?
├── Yes → no-referrer or same-origin
├── No, but privacy-conscious → strict-origin-when-cross-origin (recommended default)
└── No, and affiliates need referrer data → no-referrer-when-downgrade
```

**Permissions-Policy:**
```
Does the site use browser APIs (camera, mic, geolocation, payment)?
├── No → Disable all: camera=(), microphone=(), geolocation=(), payment=(), usb=()
├── Yes, first-party only → camera=(self), microphone=(self), etc.
└── Yes, specific iframes need access → camera=(self "https://meet.example.com")
```

### Step 5: Generate Platform-Specific Configuration

**Nginx:**
```nginx
# /etc/nginx/conf.d/security-headers.conf
# Include in server blocks: include /etc/nginx/conf.d/security-headers.conf;

add_header Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self'; connect-src 'self'; object-src 'none'; frame-ancestors 'none'; base-uri 'self'; form-action 'self'; upgrade-insecure-requests;" always;
add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
add_header X-Content-Type-Options "nosniff" always;
add_header X-Frame-Options "DENY" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
add_header Permissions-Policy "camera=(), microphone=(), geolocation=(), payment=()" always;
add_header Cross-Origin-Opener-Policy "same-origin" always;
add_header Cross-Origin-Resource-Policy "same-origin" always;
```

**Apache (.htaccess):**
```apache
<IfModule mod_headers.c>
    Header always set Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; object-src 'none'; frame-ancestors 'none'; base-uri 'self'; upgrade-insecure-requests;"
    Header always set Strict-Transport-Security "max-age=63072000; includeSubDomains; preload"
    Header always set X-Content-Type-Options "nosniff"
    Header always set X-Frame-Options "DENY"
    Header always set Referrer-Policy "strict-origin-when-cross-origin"
    Header always set Permissions-Policy "camera=(), microphone=(), geolocation=(), payment=()"
</IfModule>
```

**Caddy (Caddyfile):**
```
example.com {
    header {
        Content-Security-Policy "default-src 'self'; script-src 'self'; object-src 'none';"
        Strict-Transport-Security "max-age=63072000; includeSubDomains; preload"
        X-Content-Type-Options "nosniff"
        X-Frame-Options "DENY"
        Referrer-Policy "strict-origin-when-cross-origin"
        Permissions-Policy "camera=(), microphone=(), geolocation=(), payment=()"
    }
}
```

**Express.js (using helmet):**
```javascript
const helmet = require('helmet');

app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", "data:", "https:"],
      connectSrc: ["'self'"],
      fontSrc: ["'self'"],
      objectSrc: ["'none'"],
      frameAncestors: ["'none'"],
      baseUri: ["'self'"],
      formAction: ["'self'"],
      upgradeInsecureRequests: [],
    },
  },
  strictTransportSecurity: {
    maxAge: 63072000,
    includeSubDomains: true,
    preload: true,
  },
  referrerPolicy: { policy: 'strict-origin-when-cross-origin' },
  frameguard: { action: 'deny' },
}));
```

**Next.js (next.config.js):**
```javascript
const securityHeaders = [
  { key: 'Content-Security-Policy', value: "default-src 'self'; script-src 'self' 'unsafe-eval' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; font-src 'self'; connect-src 'self'; object-src 'none'; frame-ancestors 'none';" },
  { key: 'Strict-Transport-Security', value: 'max-age=63072000; includeSubDomains; preload' },
  { key: 'X-Content-Type-Options', value: 'nosniff' },
  { key: 'X-Frame-Options', value: 'DENY' },
  { key: 'Referrer-Policy', value: 'strict-origin-when-cross-origin' },
  { key: 'Permissions-Policy', value: 'camera=(), microphone=(), geolocation=(), payment=()' },
];

module.exports = {
  async headers() {
    return [{ source: '/(.*)', headers: securityHeaders }];
  },
};
```

**Cloudflare Workers:**
```javascript
export default {
  async fetch(request) {
    const response = await fetch(request);
    const newResponse = new Response(response.body, response);

    newResponse.headers.set('Content-Security-Policy', "default-src 'self'; object-src 'none';");
    newResponse.headers.set('Strict-Transport-Security', 'max-age=63072000; includeSubDomains; preload');
    newResponse.headers.set('X-Content-Type-Options', 'nosniff');
    newResponse.headers.set('X-Frame-Options', 'DENY');
    newResponse.headers.set('Referrer-Policy', 'strict-origin-when-cross-origin');
    newResponse.headers.set('Permissions-Policy', 'camera=(), microphone=(), geolocation=(), payment=()');

    return newResponse;
  }
};
```

### Step 6: CSP Rollout Strategy — Report-Only First

**Never deploy CSP in enforcing mode without testing first.**

```
Phase 1 (Week 1-2): Report-Only
  Header: Content-Security-Policy-Report-Only: [your policy]; report-uri /csp-report
  → Collect violations, identify legitimate breakage

Phase 2 (Week 3): Tighten Policy
  → Whitelist legitimate sources found in reports
  → Remove unnecessary 'unsafe-inline' / 'unsafe-eval'
  → Re-deploy as Report-Only

Phase 3 (Week 4): Enforce
  Header: Content-Security-Policy: [final policy]; report-uri /csp-report
  → Monitor for 48 hours post-deploy
  → Keep report-uri active permanently
```

**CSP violation report endpoint (Express):**
```javascript
app.post('/csp-report', express.json({ type: 'application/csp-report' }), (req, res) => {
  const violation = req.body['csp-report'];
  console.warn('CSP Violation:', {
    blockedURI: violation['blocked-uri'],
    violatedDirective: violation['violated-directive'],
    documentURI: violation['document-uri'],
    sourceFile: violation['source-file'],
    lineNumber: violation['line-number'],
  });
  res.status(204).end();
});
```

### Step 7: Debugging CSP Violations

**Common violations and fixes:**

| Violation | Cause | Fix |
|-----------|-------|-----|
| `Refused to execute inline script` | Inline `<script>` without nonce/hash | Add nonce or move to external file |
| `Refused to load the stylesheet` | External CSS not in `style-src` | Add domain to `style-src` |
| `Refused to connect to` | fetch/XHR to unlisted domain | Add domain to `connect-src` |
| `Refused to frame` | iframe src not in `frame-src` | Add domain to `frame-src` |
| `Refused to load the image` | Image from unlisted source | Add domain to `img-src` |
| `eval is not allowed` | Library uses `eval()` | Add `'unsafe-eval'` to `script-src` (risky) or find alternative library |
| `Refused to load the font` | Web font from unlisted CDN | Add CDN to `font-src` |

**Browser DevTools**: Open Console and filter by "CSP" or "Content Security Policy" to see all violations in real time.

### Step 8: Output

Present the complete security headers configuration:

```
━━━ SECURITY HEADERS REPORT ━━━━━━━━━━━━━━

── CURRENT STATE ─────────────────────────
[audit results table from Step 2]
Overall Grade: [A-F]

── CONTENT-SECURITY-POLICY ───────────────
[full CSP directive with comments]

── ALL HEADERS ───────────────────────────
[complete header set]

── PLATFORM CONFIG ───────────────────────
[ready-to-paste config for their platform]

── ROLLOUT PLAN ──────────────────────────
Phase 1: Report-Only (2 weeks)
Phase 2: Tighten (1 week)
Phase 3: Enforce (ongoing)

── THIRD-PARTY ALLOWLIST ─────────────────
[services detected and their required directives]

── MONITORING ────────────────────────────
[CSP report endpoint setup]
```

## Anti-Patterns

- **`unsafe-inline` + `unsafe-eval` everywhere**: Defeats the purpose of CSP entirely. If you need both on all directives, fix the root cause instead.
- **Copy-pasting CSP from another site**: Every site has different third-party dependencies. Always build CSP from your actual resource loading.
- **Deploying CSP in enforcing mode without Report-Only first**: Will break your site in production. Always test first.
- **Forgetting `always` in nginx `add_header`**: Without `always`, headers aren't sent on error pages (404, 500), leaving them unprotected.
- **Setting HSTS `preload` without understanding**: Once in the preload list, removing your domain takes months. Only preload when you're certain HTTPS is permanent.
- **Using `X-XSS-Protection: 1; mode=block`**: This header is deprecated and can actually introduce vulnerabilities in older browsers. Remove it; CSP is the replacement.
- **Ignoring `frame-ancestors` in CSP**: `X-Frame-Options` is the legacy approach. CSP `frame-ancestors` is more flexible and takes precedence in modern browsers. Set both for compatibility.

## Escalation

Hand off to a security specialist when:
- The application processes payments (PCI-DSS has specific header requirements)
- Cross-origin isolation is needed for SharedArrayBuffer (COOP/COEP interactions are complex)
- The site uses Service Workers with complex caching (CSP interactions with SW are tricky)
- Multiple teams own different parts of the same domain (CSP coordination across teams)
- You need to pass a specific compliance audit (SOC 2, ISO 27001)

## Inputs
- Application URL(s) and tech stack
- Current security headers (if any)
- Third-party services and CDNs in use
- Iframe embedding requirements
- Compliance requirements

## Outputs
- Current headers audit with grades
- Complete CSP built directive-by-directive
- Full security headers set with recommended values
- Platform-specific configuration (nginx/Apache/Caddy/Express/Next.js/Cloudflare)
- Report-Only rollout plan
- CSP violation report endpoint
- Third-party allowlist documentation

## Level History

- **Lv.1** — Base: Directive-by-directive CSP builder, all major security headers with decision trees, platform configs for 6 server types, nonce and hash implementation, report-only rollout strategy, violation debugging guide, third-party allowlist reference. (Origin: MemStack v3.3, Mar 2026)
