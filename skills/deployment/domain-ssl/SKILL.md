---
name: domain-ssl
description: "Use when the user says 'domain', 'DNS', 'SSL', 'HTTPS', 'custom domain', 'certificate', 'Let's Encrypt', 'SPF', 'DKIM', 'DMARC', or needs to configure domains, DNS records, or SSL/TLS. Do NOT use for full deployment workflows (see railway-deploy, netlify-deploy)."
---

# 🌐 Domain & SSL — DNS Configuration & TLS Setup
*Configure custom domains, DNS records, SSL/TLS certificates, and email authentication for any hosting provider.*

## Activation

When this skill activates, output:

`🌐 Domain & SSL — Configuring domain and SSL/TLS...`

| Context | Status |
|---------|--------|
| **User says "domain", "DNS", "SSL", "HTTPS"** | ACTIVE |
| **User says "Let's Encrypt", "certificate", "custom domain"** | ACTIVE |
| **User says "SPF", "DKIM", "DMARC", "email DNS"** | ACTIVE |
| **User wants full app deployment** | DORMANT — see railway-deploy or netlify-deploy |
| **User wants security headers** | DORMANT — see csp-headers |

## Protocol

### Step 1: Gather Inputs

- **Domain name**: What domain/subdomains?
- **Registrar**: Where is the domain registered? (Cloudflare, Namecheap, GoDaddy, etc.)
- **Hosting**: Where does the app run? (Railway, Netlify, Hetzner, AWS, etc.)
- **Email**: Does the domain send email? (transactional, marketing, or none)
- **CDN**: Using Cloudflare, Fastly, or direct?

### Step 2: DNS Records

**Essential record types:**

| Type | Purpose | Example |
|------|---------|---------|
| `A` | Points domain to IPv4 | `@ → 1.2.3.4` |
| `AAAA` | Points domain to IPv6 | `@ → 2001:db8::1` |
| `CNAME` | Alias to another domain | `www → myapp.netlify.app` |
| `MX` | Email server | `@ → mx1.provider.com` (priority 10) |
| `TXT` | Verification, SPF, DKIM | `@ → "v=spf1 include:_spf.google.com ~all"` |
| `CAA` | Restrict certificate issuers | `@ → 0 issue "letsencrypt.org"` |
| `SRV` | Service discovery | `_sip._tcp → 10 5 5060 sip.example.com` |

**Common setups:**

```
# App on Railway/Render (CNAME)
www     CNAME   myapp.up.railway.app
@       A       <railway IP>  (or use redirect)

# App on Netlify
www     CNAME   mysite.netlify.app
@       A       75.2.60.5     (Netlify load balancer)

# App on Hetzner VPS
@       A       <server IP>
www     A       <server IP>

# Subdomain for API
api     CNAME   api.myapp.railway.app
```

**Verify propagation:**
```bash
# Check A record
dig +short example.com A

# Check CNAME
dig +short www.example.com CNAME

# Check all records
dig example.com ANY

# Check from specific DNS (bypass cache)
dig @8.8.8.8 example.com A

# Check propagation globally
# Use: https://www.whatsmydns.net/
```

### Step 3: SSL/TLS Configuration

**Let's Encrypt with Certbot:**
```bash
# Install
sudo apt install certbot python3-certbot-nginx  # or python3-certbot-apache

# Get certificate (nginx)
sudo certbot --nginx -d example.com -d www.example.com

# Get certificate (standalone, no web server)
sudo certbot certonly --standalone -d example.com

# Wildcard certificate (requires DNS challenge)
sudo certbot certonly --manual --preferred-challenges dns -d "*.example.com" -d example.com

# Auto-renewal (usually installed automatically)
sudo certbot renew --dry-run
# Cron: 0 0 1 * * certbot renew --quiet
```

**Caddy (automatic HTTPS):**
```
# Caddy handles SSL automatically — just specify the domain
example.com {
    reverse_proxy localhost:3000
}
# That's it. Caddy gets and renews certs from Let's Encrypt automatically.
```

**Nginx SSL config (after certbot):**
```nginx
server {
    listen 443 ssl http2;
    server_name example.com www.example.com;

    ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

    # TLS 1.2+ only (1.3 preferred)
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;

    # OCSP Stapling
    ssl_stapling on;
    ssl_stapling_verify on;
    resolver 1.1.1.1 8.8.8.8;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

# Redirect HTTP to HTTPS
server {
    listen 80;
    server_name example.com www.example.com;
    return 301 https://$host$request_uri;
}
```

### Step 4: Email DNS (SPF, DKIM, DMARC)

**SPF (who can send email from your domain):**
```
# TXT record on @
v=spf1 include:_spf.google.com include:sendgrid.net ~all

# Common includes:
# Google Workspace: include:_spf.google.com
# Microsoft 365:    include:spf.protection.outlook.com
# SendGrid:         include:sendgrid.net
# Mailgun:          include:mailgun.org
# Postmark:         include:spf.mtasv.net
```

**DKIM (cryptographic email verification):**
```
# TXT record — provider gives you the name and value
# Example for SendGrid:
s1._domainkey    TXT    "k=rsa; p=MIGfMA0GCSqGSIb3..."
```

**DMARC (policy for failed SPF/DKIM):**
```
# TXT record on _dmarc
_dmarc    TXT    "v=DMARC1; p=quarantine; rua=mailto:dmarc@example.com; pct=100"

# Policy options:
# p=none       — monitor only (start here)
# p=quarantine — send to spam
# p=reject     — reject entirely (strictest)
```

**Verification:**
```bash
# Check SPF
dig +short example.com TXT | grep spf

# Check DKIM
dig +short s1._domainkey.example.com TXT

# Check DMARC
dig +short _dmarc.example.com TXT

# Test deliverability: send test email to mail-tester.com
```

### Step 5: Certificate Monitoring

```bash
# Check certificate expiry
echo | openssl s_client -connect example.com:443 -servername example.com 2>/dev/null | openssl x509 -noout -dates

# Check SSL grade
# Use: https://www.ssllabs.com/ssltest/

# Monitor with cron alert (30 days before expiry)
EXPIRY=$(echo | openssl s_client -connect example.com:443 2>/dev/null | openssl x509 -noout -enddate | cut -d= -f2)
DAYS_LEFT=$(( ( $(date -d "$EXPIRY" +%s) - $(date +%s) ) / 86400 ))
if [ "$DAYS_LEFT" -lt 30 ]; then echo "⚠️ SSL expires in $DAYS_LEFT days"; fi
```

### Step 6: Output

```
━━━ DOMAIN & SSL CONFIGURATION ━━━━━━━━━━

── DNS RECORDS ───────────────────────────
[table of records to create/update]

── SSL/TLS ───────────────────────────────
Method: [Let's Encrypt / Cloudflare / managed]
Config: [server config snippet]

── EMAIL DNS ─────────────────────────────
SPF: [record]
DKIM: [record]
DMARC: [record]

── VERIFICATION ──────────────────────────
[dig commands to verify each record]

── MONITORING ────────────────────────────
[cert expiry check command/cron]
```

## Anti-Patterns

- **Using A records when CNAME works**: CNAME follows the target if the IP changes. A records break on IP change.
- **Forgetting www redirect**: Set up both `@` and `www`, redirect one to the other.
- **Not setting CAA records**: CAA restricts which CAs can issue certs. Without it, any CA can issue for your domain.
- **Starting DMARC at `p=reject`**: Always start at `p=none` to monitor, then tighten.
- **Ignoring certificate renewal**: Let's Encrypt certs last 90 days. Auto-renewal must be working.
- **Pointing DNS to Cloudflare but not enabling proxy**: DNS-only mode doesn't give you Cloudflare's DDoS protection or SSL.

## Escalation

Hand off when:
- Complex multi-CDN setup with failover
- DNSSEC implementation needed
- Enterprise certificate management (internal PKI)
- Regulatory requirements for specific TLS configurations

## Inputs
- Domain name and registrar
- Hosting provider
- Email sending services
- CDN preference

## Outputs
- DNS record configuration
- SSL/TLS setup commands and config
- Email authentication records (SPF/DKIM/DMARC)
- Verification commands
- Monitoring setup

## Level History

- **Lv.1** — Base: DNS record configuration, Let's Encrypt/Caddy/nginx SSL setup, email DNS (SPF/DKIM/DMARC), propagation debugging, certificate monitoring. (Origin: MemStack v3.3, Mar 2026)
