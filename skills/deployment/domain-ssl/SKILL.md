---
name: domain-ssl
description: "Configure custom domains, DNS records, SSL/TLS certificates, and email authentication. WHEN: user says 'domain', 'DNS', 'SSL', 'HTTPS', 'custom domain', 'certificate', 'Let's Encrypt', 'SPF', 'DKIM', 'DMARC'. NOT WHEN: full deployment workflow (see railway-deploy, netlify-deploy), security headers (see csp-headers)."
---

# Domain & SSL — DNS Configuration & TLS Setup

## Activation

| Context | Status |
|---------|--------|
| User says "domain", "DNS", "SSL", "HTTPS", "custom domain" | ACTIVE |
| User says "Let's Encrypt", "certificate", "SPF", "DKIM", "DMARC" | ACTIVE |
| Full app deployment | DORMANT — see railway-deploy, netlify-deploy |
| Security headers, CSP, HSTS-only | DORMANT — see csp-headers |

## Instructions

### Step 1: Gather Inputs

Collect: domain name, registrar, hosting provider, email services (if any), CDN preference.

**Gate:** Do not proceed without domain + hosting provider confirmed.

### Step 2: DNS Record Type Decision

Choose record type by this decision tree:

| Condition | Record Type |
|-----------|-------------|
| Pointing root (`@`) to a known static IP (VPS, dedicated) | A / AAAA |
| Pointing root (`@`) to a PaaS that provides no IP (Railway, Netlify, Vercel) | ALIAS (if registrar supports) or A to their load balancer IP |
| Pointing subdomain (`www`, `api`, etc.) to another hostname | CNAME |
| Registrar does not support ALIAS and PaaS has no stable IP | Use registrar's built-in redirect for root; CNAME for `www` |

Always configure both `@` and `www`. Redirect one to the other. Set CAA records to restrict certificate issuers.

**Gate:** Verify propagation before proceeding. Use `dig @8.8.8.8` for cache-bypass checks and a global propagation checker. Do not proceed to SSL until DNS resolves correctly from at least 3 geographically distributed resolvers.

### Step 3: SSL Certificate Type Decision

| Condition | Certificate Type |
|-----------|-----------------|
| PaaS with managed SSL (Netlify, Vercel, Railway, Cloudflare) | Use platform-managed — no manual cert needed |
| VPS/dedicated with auto-HTTPS server (Caddy) | Use Caddy's built-in ACME — zero config |
| VPS/dedicated with nginx/Apache | Let's Encrypt via certbot |
| Multiple subdomains under one cert | Wildcard cert (requires DNS-01 challenge) |
| Regulatory/compliance requirement for identity validation | EV or OV cert from commercial CA |
| Internal services only | Self-signed or internal CA (never for public) |

**Gate:** Certificate must be issued and serving before configuring HSTS.

### Step 4: HTTPS Redirect & HSTS

**Redirect enforcement rules:**
- All HTTP must 301-redirect to HTTPS. No exceptions for public-facing domains.
- Redirect must preserve path and query string.
- If behind Cloudflare proxy, use "Always Use HTTPS" setting instead of server-level redirect to avoid redirect loops.

**HSTS configuration rules:**
- Start with `max-age=86400` (1 day). Only increase after confirming no mixed content.
- Add `includeSubDomains` only when ALL subdomains support HTTPS.
- Add `preload` only after sustained `max-age=31536000` and submit to hstspreload.org.
- HSTS misconfiguration is hard to undo — browsers cache the policy for `max-age` duration.

**Gate:** Test for mixed content (HTTP resources on HTTPS pages) before enabling HSTS. Mixed content breaks pages silently.

### Step 5: Certificate Renewal Automation

**Decision rules:**
- Platform-managed certs: no action needed — provider handles renewal.
- Certbot: verify auto-renewal timer exists (`systemctl list-timers | grep certbot`). If missing, add cron/systemd timer for twice-daily renewal check.
- Caddy: automatic — no action needed.
- Wildcard certs: renewal requires DNS-01 challenge automation (certbot DNS plugin for your registrar, or acme.sh with DNS API).
- Set up monitoring alert when cert expiry < 30 days as a safety net regardless of automation.

### Step 6: Multi-Domain & Subdomain Strategy

| Pattern | Approach |
|---------|----------|
| Single app, root + www | One cert covering both names |
| Multiple apps on subdomains (`api.`, `app.`, `admin.`) | One wildcard cert OR individual certs per subdomain |
| Multiple unrelated domains on same server | Separate cert per domain (SNI handles routing) |
| Staging/preview environments | Wildcard on `*.staging.example.com` |

For email-sending domains, add SPF, DKIM, and DMARC TXT records. Start DMARC at `p=none`, tighten only after monitoring.

### Step 7: Verify & Output

Provide: DNS records to set, SSL method chosen, HSTS header value, renewal approach, verification commands, and any email DNS records needed.

## Examples

**PaaS subdomain:** User deploys on Railway, wants `api.example.com`. Decision: CNAME to Railway hostname, platform-managed SSL, no certbot needed. Add CAA restricting to Railway's CA. HSTS after confirming cert serves correctly.

**VPS multi-subdomain:** User runs nginx on Hetzner, wants `example.com` + `www` + `api` + `staging`. Decision: A record for root, CNAMEs for subs, wildcard Let's Encrypt cert with DNS-01 via Cloudflare API plugin, certbot auto-renewal timer, HSTS with `includeSubDomains` after verifying all subs serve HTTPS.

## Common Issues

- **Certificate chain incomplete:** Server sends leaf cert but not intermediate. Test with SSL Labs. Fix by serving `fullchain.pem`, not just `cert.pem`.
- **Mixed content after HTTPS migration:** Browser blocks HTTP resources on HTTPS pages. Audit all asset URLs, use protocol-relative or absolute HTTPS URLs. CSP `upgrade-insecure-requests` as interim fix.
- **Redirect loops with Cloudflare:** Cloudflare SSL mode set to "Flexible" while origin also redirects HTTP to HTTPS. Fix: set Cloudflare SSL to "Full (Strict)" when origin has a valid cert.

## Anti-Patterns

- Using A records when CNAME works (breaks on IP change)
- Skipping CAA records (any CA can issue for your domain)
- Jumping to HSTS `preload` before testing (irreversible for `max-age` duration)
- Starting DMARC at `p=reject` (start at `p=none`, monitor, then tighten)
- Manual cert renewal instead of automated (90-day expiry catches people)
- Pointing DNS through Cloudflare proxy in DNS-only mode (no DDoS protection or edge SSL)

## Escalation

Hand off when: multi-CDN failover, DNSSEC implementation, enterprise internal PKI, regulatory-specific TLS cipher requirements.

## Inputs

- Domain name and registrar
- Hosting provider and architecture (PaaS vs VPS)
- Email sending services (if any)
- CDN preference (Cloudflare, direct, etc.)

## Outputs

- DNS record set (types and values)
- SSL method and renewal approach
- HSTS header configuration
- Email authentication records (SPF/DKIM/DMARC) if applicable
- Verification steps

## Level History

- **Lv.1** — Base: DNS record configuration, Let's Encrypt/Caddy/nginx SSL setup, email DNS (SPF/DKIM/DMARC), propagation debugging, certificate monitoring. (Origin: MemStack v3.3, Mar 2026)
- **Lv.2** — Compressed: Removed implementation snippets (nginx configs, certbot commands, dig examples). Restructured as decision trees with validation gates. Added certificate chain and mixed content pitfalls, HSTS rollout rules, multi-domain strategy, redirect loop diagnosis. (Origin: MemStack v3.4, Mar 2026)
