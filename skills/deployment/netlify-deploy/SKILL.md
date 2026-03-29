---
name: netlify-deploy
description: "Use when the user says 'deploy to Netlify', 'Netlify', 'static site deploy', 'netlify.toml', or needs to deploy a static site, SPA, or serverless functions to Netlify. Do NOT use for backend API deployments (see railway-deploy) or VPS (see hetzner-setup)."
---

# 🌍 Netlify Deploy — Static Site & Serverless Deployment
*Deploy static sites, SPAs, and serverless functions to Netlify with build configuration, redirects, custom domains, and edge functions.*

## Activation

When this skill activates, output:

`🌍 Netlify Deploy — Configuring Netlify deployment...`

| Context | Status |
|---------|--------|
| **User says "deploy to Netlify", "Netlify", "static site deploy"** | ACTIVE |
| **User wants serverless functions on Netlify** | ACTIVE |
| **User wants backend API deployment** | DORMANT — see railway-deploy |
| **User wants VPS deployment** | DORMANT — see hetzner-setup |

## Protocol

### Step 1: Gather Inputs

- **Framework**: React, Next.js, Astro, Hugo, Gatsby, plain HTML?
- **Build command**: What builds the site?
- **Output directory**: Where does the build output go?
- **Serverless functions**: Any API routes or functions needed?
- **Custom domain**: Domain name ready?
- **Environment variables**: What secrets/config needed?

### Step 2: Create netlify.toml

**React / Vite:**
```toml
[build]
  command = "npm run build"
  publish = "dist"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

[build.environment]
  NODE_VERSION = "20"
```

**Next.js:**
```toml
[build]
  command = "npm run build"
  publish = ".next"

[[plugins]]
  package = "@netlify/plugin-nextjs"

[build.environment]
  NODE_VERSION = "20"
```

**Astro:**
```toml
[build]
  command = "npm run build"
  publish = "dist"

[build.environment]
  NODE_VERSION = "20"
```

**Hugo:**
```toml
[build]
  command = "hugo --minify"
  publish = "public"

[build.environment]
  HUGO_VERSION = "0.124.1"

[context.production.environment]
  HUGO_ENV = "production"
```

### Step 3: Redirects & Rewrites

```toml
# SPA fallback (client-side routing)
[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200

# API proxy to backend
[[redirects]]
  from = "/api/*"
  to = "https://api.myapp.railway.app/:splat"
  status = 200
  force = true

# Domain redirect (www to apex)
[[redirects]]
  from = "https://www.example.com/*"
  to = "https://example.com/:splat"
  status = 301
  force = true

# Custom 404
[[redirects]]
  from = "/*"
  to = "/404.html"
  status = 404
```

### Step 4: Serverless Functions

```
# Directory structure:
netlify/
  functions/
    hello.js        # Available at /.netlify/functions/hello
    submit-form.js
```

```javascript
// netlify/functions/hello.js
export default async (req, context) => {
  const name = new URL(req.url).searchParams.get('name') || 'World';
  return new Response(JSON.stringify({ message: `Hello, ${name}!` }), {
    headers: { 'Content-Type': 'application/json' },
  });
};

export const config = {
  path: "/api/hello"  // Custom path (instead of /.netlify/functions/hello)
};
```

### Step 5: Environment Variables

```bash
# Via CLI
npx netlify-cli env:set API_KEY "your-secret-value"
npx netlify-cli env:set DATABASE_URL "postgresql://..." --context production

# Or in netlify.toml (non-secret values only)
[context.production.environment]
  API_URL = "https://api.myapp.com"

[context.deploy-preview.environment]
  API_URL = "https://staging-api.myapp.com"
```

### Step 6: Deploy

```bash
# Install CLI
npm install -g netlify-cli

# Login
netlify login

# Link to existing site (or create new)
netlify init

# Deploy preview (test before production)
netlify deploy --dir=dist

# Deploy to production
netlify deploy --prod --dir=dist

# Or just push to git — Netlify auto-deploys from connected repo
git push origin main
```

### Step 7: Custom Domain

1. In Netlify Dashboard: Domain settings → Add custom domain
2. Set DNS records:
   - `A` record: `@` → `75.2.60.5`
   - `CNAME` record: `www` → `yoursite.netlify.app`
3. Enable HTTPS (automatic with Netlify-managed DNS)
4. Force HTTPS redirect in netlify.toml or dashboard

### Step 8: Output

```
━━━ NETLIFY DEPLOYMENT ━━━━━━━━━━━━━━━━━━

── CONFIGURATION ─────────────────────────
netlify.toml: [generated]
Build: [command]
Publish: [directory]

── FEATURES ──────────────────────────────
Redirects: [configured]
Functions: [N functions at /api/*]
Environment: [N variables set]

── DOMAINS ───────────────────────────────
Preview: [site-name.netlify.app]
Production: [custom domain if set]

── DEPLOY COMMANDS ───────────────────────
Preview: netlify deploy --dir=dist
Production: netlify deploy --prod --dir=dist
```

## Anti-Patterns

- **Missing SPA redirect**: Without the `/* → /index.html` redirect, refreshing any page returns 404.
- **Secrets in netlify.toml**: Only put non-sensitive values here. Use dashboard or CLI for secrets.
- **Large build artifacts**: Netlify has a 25GB bandwidth limit on free tier. Optimize images and assets.
- **Ignoring deploy previews**: Always check the preview URL before merging to main.

## Escalation

Hand off when:
- Complex server-side rendering with streaming (may need different platform)
- High-traffic site exceeding Netlify bandwidth limits
- Need for persistent server processes (websockets, long-running tasks)

## Inputs
- Framework and build configuration
- Redirect requirements
- Serverless function needs
- Custom domain
- Environment variables

## Outputs
- netlify.toml configuration
- Redirect rules
- Serverless function scaffolding
- Deploy commands
- Custom domain DNS records

## Level History

- **Lv.1** — Base: Framework-specific netlify.toml templates (React, Next.js, Astro, Hugo), redirect/rewrite rules, serverless functions, environment variable management, CLI deployment, custom domain setup. (Origin: MemStack v3.3, Mar 2026)
