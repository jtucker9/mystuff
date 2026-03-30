---
name: netlify-deploy
description: "Deploy static sites, SPAs, and serverless/edge functions to Netlify. WHEN: 'deploy to Netlify', 'Netlify', 'static site deploy', 'netlify.toml', serverless functions on Netlify. NOT WHEN: backend API deployments (railway-deploy), VPS (hetzner-setup), persistent server processes."
---

# Netlify Deploy

## Activation

| Context | Status |
|---------|--------|
| "deploy to Netlify", "Netlify", "static site deploy" | ACTIVE |
| Serverless or edge functions on Netlify | ACTIVE |
| Backend API deployment | DORMANT — railway-deploy |
| VPS or persistent processes | DORMANT — hetzner-setup |

Output on activation: `Netlify Deploy — Configuring deployment...`

## Instructions

### Step 1: Detect Framework and Build Settings

Identify framework from project files. Apply defaults:

| Framework | Build Command | Publish Dir | Requires Plugin |
|-----------|--------------|-------------|-----------------|
| Next.js | `npm run build` | `.next` | `@netlify/plugin-nextjs` |
| React/Vite | `npm run build` | `dist` | No |
| Vue/Nuxt | `npm run build` | `.output/public` or `dist` | `@netlify/plugin-nuxt` for Nuxt 3 |
| Hugo | `hugo --minify` | `public` | No — pin `HUGO_VERSION` in env |
| Gatsby | `gatsby build` | `public` | `@netlify/plugin-gatsby` |
| Astro | `npm run build` | `dist` | No |
| Plain HTML | None | `.` or `public` | No |

**Gate:** Confirm build command runs locally before proceeding.

### Step 2: Configure Deploy Contexts

Apply settings per context hierarchy (most specific wins):

| Context | Purpose | Decision |
|---------|---------|----------|
| `production` | Live site from production branch | Secrets, production API URLs, analytics |
| `deploy-preview` | PR preview builds | Staging API URLs, test credentials |
| `branch-deploy` | Named branch builds | Branch-specific overrides only if needed |

Non-secret env vars go in `netlify.toml` per context. Secrets go through CLI or dashboard only.

**Gate:** Environment variables categorized as secret vs. non-secret before writing config.

### Step 3: Define Redirect and Header Rules

Decision tree:
- SPA with client-side routing? Add catch-all rewrite (`/* -> /index.html`, 200).
- API proxy to external backend? Add path-scoped rewrite with `force = true`.
- Domain canonicalization needed (www vs apex)? Add 301 redirect with `force = true`.
- Custom headers needed (CORS, caching, CSP)? Define in headers config.

Rule priority: first match wins. Order specific paths before catch-alls. Forced rules override existing content.

**Gate:** SPA rewrite present if framework uses client-side routing.

### Step 4: Decide on Functions

**Serverless vs. Edge functions:**

| Factor | Serverless | Edge |
|--------|-----------|------|
| Cold start tolerance | Acceptable | Need sub-50ms |
| Node.js API compatibility | Full | Deno-based, limited |
| Geolocation/personalization | Not needed | Needed at edge |
| Execution time limit | 10s (free) / 26s (pro) | 50ms target |

Place serverless functions in `netlify/functions/`. Edge functions in `netlify/edge-functions/`. Use custom path config to expose at clean URLs (e.g., `/api/*`).

**Gate:** If functions access secrets, verify those env vars are set in the target deploy context.

### Step 5: Evaluate Build Plugins

Categories to consider:
- **Framework adapters** — Required for SSR frameworks (Next.js, Nuxt, Gatsby). Auto-installed if framework detected.
- **Optimization** — Image compression, CSS purging, sitemap generation. Add only if measurable benefit.
- **Caching** — Build cache plugins for large dependency trees. Worth it if builds exceed 3 minutes.
- **Monitoring** — Lighthouse, bundle analysis. Add for production-critical sites.

Only add plugins that solve a stated problem. Do not install speculatively.

**Gate:** Each plugin has a clear justification documented.

### Step 6: Set Deploy Preview Strategy

Decisions:
- Branch deploys enabled for which branches? Default: production branch only + PR previews.
- Deploy notifications configured (Slack, email, webhook)?
- Auto-publish on? If off, production deploys require manual promotion.
- Form handling needed? Enable Netlify Forms only if the site has `<form>` elements that should be captured without a backend. Attribute-based detection (`data-netlify="true"`).

**Gate:** Preview URL accessible and functional before promoting to production.

### Step 7: Deploy and Verify

Deploy preview first. Verify: routes resolve, functions respond, env vars populated, redirects work. Then deploy to production.

**Gate:** Preview deploy returns 200 on all critical paths before production deploy.

## Examples

**1. React SPA with API proxy to Railway backend:**
Framework: React/Vite. Publish: `dist`. SPA rewrite for client routing. Proxy `/api/*` to Railway URL with force. Production env vars via CLI. No functions needed.

**2. Next.js with serverless API routes and edge personalization:**
Framework: Next.js. Plugin: `@netlify/plugin-nextjs`. API routes auto-deploy as serverless functions. Add edge function for geo-based content. Separate env vars per deploy context. PR previews with staging API URL.

## Common Issues

- **404 on page refresh (SPA):** Missing catch-all rewrite. Client-side routing needs `/* -> /index.html` with status 200.
- **Function timeout:** Free tier limits serverless to 10s. Move heavy computation to background functions or external service.
- **Build fails on deploy but works locally:** Node version mismatch. Pin `NODE_VERSION` in build environment. Check that all dependencies are in `package.json` (not globally installed).

## Anti-Patterns

- Committing secrets in `netlify.toml` — use CLI/dashboard for sensitive values.
- Installing framework adapter plugins manually when Netlify auto-detects them.
- Using edge functions for workloads that need full Node.js APIs.
- Enabling branch deploys for all branches — creates unnecessary builds and uses build minutes.
- Skipping deploy previews and pushing directly to production.

## Escalation

Hand off when:
- Streaming SSR or WebSocket connections required (not supported on Netlify).
- Bandwidth exceeds plan limits consistently — evaluate dedicated hosting.
- Need persistent background workers or long-running processes — use Railway or Hetzner.

## Inputs

- Framework and build configuration
- Redirect and header requirements
- Serverless/edge function needs
- Environment variables (secret vs. non-secret)
- Custom domain (if ready)
- Deploy preview strategy preferences

## Outputs

- `netlify.toml` configuration
- Function scaffolding (if needed)
- Deploy context environment plan
- Redirect/header rules
- Deployment verification checklist

## Level History

- **Lv.1** — Base: Framework-specific templates, redirect rules, serverless functions, env var management, CLI deployment, custom domain setup. (Origin: MemStack v3.3, Mar 2026)
- **Lv.2** — Compressed: Decision-rule format. Added edge vs serverless decision matrix, deploy context hierarchy, build plugin categories, deploy preview strategy, form handling approach, validation gates. Removed all code examples and CLI sequences. (Origin: MemStack v3.4, Mar 2026)
