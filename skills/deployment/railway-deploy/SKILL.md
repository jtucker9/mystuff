---
name: railway-deploy
description: "Use when the user says 'deploy to Railway', 'Railway setup', 'railway deploy', or needs to deploy a Node.js, Python, or Docker application to Railway with environment variables, custom domains, and monitoring. Do NOT use for Netlify, Vercel, or Hetzner deployments."
---

# Railway Deploy — Application Deployment to Railway.app
*Deploy applications to Railway with proper project configuration, service architecture, environment management, custom domains, and production-grade monitoring.*

## Activation

When this skill activates, output:

`Railway Deploy — Deploying your application to Railway...`

| Context | Status |
|---------|--------|
| **User says "deploy to Railway", "railway deploy"** | ACTIVE |
| **User says "Railway setup", "railway config"** | ACTIVE |
| **User needs PaaS deployment for Node/Python/Go/Rust app** | ACTIVE |
| **User wants to deploy to Netlify or Vercel** | DORMANT — see netlify-deploy |
| **User wants VPS/dedicated server setup** | DORMANT — see hetzner-setup |
| **User wants Docker containerization only** | DORMANT — see docker-setup |
| **User wants CI/CD pipeline design** | DORMANT — see ci-cd-pipeline |

## Protocol

### Step 1: Gather Inputs

Collect information before touching any configuration:

- **Application type**: Web server, API, worker, cron job, full-stack with DB?
- **Language/runtime**: Node.js, Python, Go, Rust, Java, static site?
- **Framework**: Express, Next.js, FastAPI, Django, Gin, Actix, Spring Boot?
- **Services needed**: PostgreSQL, MySQL, Redis, MongoDB?
- **Repository**: GitHub repo URL or local project?
- **Environment variables**: What secrets and config values are needed?
- **Domain**: Custom domain or Railway-provided `*.up.railway.app`?
- **Deployment trigger**: Auto-deploy from GitHub branch, or manual CLI deploys?

**Decision tree — what kind of Railway project?**

```
Is it a single service?
├── Yes → Single service project (Step 2A)
└── No
    ├── Monorepo (one repo, multiple services)?
    │   └── Monorepo project with root directory overrides (Step 3A)
    └── Multi-service (separate repos or services)?
        └── Multi-service project with internal networking (Step 3B)
```

### Step 2: Project Configuration

#### 2A: Railway CLI Setup

Install the Railway CLI and authenticate:

```bash
# Install Railway CLI
npm install -g @railway/cli

# Authenticate (opens browser for OAuth)
railway login

# Initialize a new Railway project (interactive)
railway init

# Or link to an existing Railway project
railway link
```

**Verify connection:**
```bash
# Confirm linked project
railway status

# List available environments
railway environment
```

#### 2B: railway.toml Configuration

The `railway.toml` file controls build and deploy settings. Place it in the project root.

**Node.js (Express/Fastify):**
```toml
[build]
builder = "nixpacks"
buildCommand = "npm ci && npm run build"

[deploy]
startCommand = "node dist/index.js"
healthcheckPath = "/health"
healthcheckTimeout = 300
restartPolicyType = "on_failure"
restartPolicyMaxRetries = 5
```

**Python (FastAPI):**
```toml
[build]
builder = "nixpacks"
buildCommand = "pip install -r requirements.txt"

[deploy]
startCommand = "uvicorn app.main:app --host 0.0.0.0 --port $PORT"
healthcheckPath = "/health"
healthcheckTimeout = 300
restartPolicyType = "on_failure"
restartPolicyMaxRetries = 5
```

**Python (Django):**
```toml
[build]
builder = "nixpacks"
buildCommand = "pip install -r requirements.txt && python manage.py collectstatic --noinput && python manage.py migrate"

[deploy]
startCommand = "gunicorn myproject.wsgi:application --bind 0.0.0.0:$PORT --workers 3"
healthcheckPath = "/health/"
healthcheckTimeout = 300
restartPolicyType = "on_failure"
restartPolicyMaxRetries = 5
```

**Go:**
```toml
[build]
builder = "nixpacks"
buildCommand = "go build -o /app/server ./cmd/server"

[deploy]
startCommand = "/app/server"
healthcheckPath = "/health"
healthcheckTimeout = 300
restartPolicyType = "on_failure"
restartPolicyMaxRetries = 5
```

**Next.js (standalone output):**
```toml
[build]
builder = "nixpacks"
buildCommand = "npm ci && npm run build"

[deploy]
startCommand = "node .next/standalone/server.js"
healthcheckPath = "/"
healthcheckTimeout = 300
restartPolicyType = "on_failure"
restartPolicyMaxRetries = 5
```

For Next.js standalone mode, ensure `next.config.js` includes:
```js
module.exports = {
  output: 'standalone',
};
```

**Docker-based (custom Dockerfile):**
```toml
[build]
builder = "dockerfile"
dockerfilePath = "Dockerfile"

[deploy]
healthcheckPath = "/health"
healthcheckTimeout = 300
restartPolicyType = "on_failure"
restartPolicyMaxRetries = 5
```

#### 2C: Nixpacks Configuration

Railway uses Nixpacks by default. Override auto-detection with a `nixpacks.toml` when needed:

```toml
# nixpacks.toml — explicit runtime control
[phases.setup]
nixPkgs = ["nodejs-18_x", "python311"]

[phases.install]
cmds = ["npm ci"]

[phases.build]
cmds = ["npm run build"]

[start]
cmd = "node dist/index.js"
```

**When to use nixpacks.toml vs railway.toml:**

| Scenario | Use |
|----------|-----|
| Override build/start commands | `railway.toml` (simpler) |
| Need specific system packages (ffmpeg, imagemagick) | `nixpacks.toml` |
| Multi-language project (Node + Python) | `nixpacks.toml` |
| Custom Nix packages or phases | `nixpacks.toml` |
| Healthcheck and restart policy | `railway.toml` (only place) |

#### 2D: Procfile (Alternative)

Railway also supports Heroku-style Procfiles as a fallback:

```procfile
web: node dist/index.js
worker: node dist/worker.js
```

Priority order: `railway.toml` > `nixpacks.toml` > `Procfile` > auto-detection.

### Step 3: Service Architecture

#### 3A: Monorepo Handling

For monorepos with multiple services in subdirectories, configure each service with a root directory override in the Railway dashboard or via `railway.toml` in each subdirectory.

**Example monorepo structure:**
```
my-monorepo/
├── apps/
│   ├── api/
│   │   ├── railway.toml
│   │   ├── package.json
│   │   └── src/
│   ├── web/
│   │   ├── railway.toml
│   │   ├── package.json
│   │   └── src/
│   └── worker/
│       ├── railway.toml
│       ├── package.json
│       └── src/
├── packages/
│   └── shared/
├── package.json
└── turbo.json
```

**Per-service railway.toml (apps/api/railway.toml):**
```toml
[build]
builder = "nixpacks"
buildCommand = "cd ../.. && npm ci && npx turbo run build --filter=api"
watchPatterns = ["apps/api/**", "packages/shared/**"]

[deploy]
startCommand = "node apps/api/dist/index.js"
healthcheckPath = "/health"
restartPolicyType = "on_failure"
restartPolicyMaxRetries = 5
```

In the Railway dashboard, set the **Root Directory** for each service:
- API service: `apps/api`
- Web service: `apps/web`
- Worker service: `apps/worker`

**Watch patterns** ensure a service only redeploys when its own code (or shared dependencies) change, not on every commit to the monorepo.

#### 3B: Multi-Service Projects

Railway projects can contain multiple services that communicate via internal networking.

**Creating services via CLI:**
```bash
# Add a PostgreSQL database to the project
railway add --database postgres

# Add Redis
railway add --database redis

# Add a new empty service (for a worker, cron, etc.)
railway service --new
```

**Internal networking between services:**

Railway provides internal DNS for service-to-service communication within the same project. Each service gets an internal hostname: `<service-name>.railway.internal`.

```bash
# From the API service, connect to an internal worker service:
# http://worker.railway.internal:8080/process

# PostgreSQL internal connection (auto-populated by Railway):
# postgresql://postgres:password@postgres.railway.internal:5432/railway
```

**Reference variables** (see Step 4) let services discover each other automatically.

#### 3C: Database Add-ons

Railway provides managed database instances:

| Database | Add Command | Default Port |
|----------|-------------|-------------|
| PostgreSQL | `railway add --database postgres` | 5432 |
| MySQL | `railway add --database mysql` | 3306 |
| Redis | `railway add --database redis` | 6379 |
| MongoDB | `railway add --database mongo` | 27017 |

Railway auto-injects connection variables into your service:

| Variable | Example |
|----------|---------|
| `DATABASE_URL` | `postgresql://postgres:abc@postgres.railway.internal:5432/railway` |
| `REDIS_URL` | `redis://default:xyz@redis.railway.internal:6379` |
| `PGHOST`, `PGPORT`, `PGUSER`, `PGPASSWORD`, `PGDATABASE` | Individual PostgreSQL components |

**Database best practices:**
- Always use the internal hostname (`*.railway.internal`) for service-to-service connections — it avoids egress charges and is faster.
- Use the public hostname only for external tools (pgAdmin, TablePlus, etc.) and only when needed.
- Railway databases are persistent by default with automatic backups on paid plans.

### Step 4: Environment Variables & Secrets

#### 4A: Setting Variables via CLI

```bash
# Set a single variable
railway variables set NODE_ENV=production

# Set multiple variables at once
railway variables set \
  NODE_ENV=production \
  JWT_SECRET=your-secret-here \
  CORS_ORIGIN=https://myapp.com

# List all variables for the current service
railway variables

# Delete a variable
railway variables delete MY_OLD_VAR
```

#### 4B: Bulk Variable Import

```bash
# Import from a .env file (do NOT commit this file to git)
railway variables set $(cat .env | grep -v '^#' | xargs)
```

**Critical: Never commit `.env` files to git. Use `.gitignore`:**
```
.env
.env.local
.env.production
.env.*.local
```

#### 4C: Shared Variables

Shared variables are available to ALL services in a project. Set them in the Railway dashboard under Project Settings > Shared Variables, or via the CLI:

```bash
# Shared variables are best set via the dashboard
# They appear in every service automatically
# Common shared variables:
#   APP_NAME=myapp
#   ENVIRONMENT=production
#   LOG_LEVEL=info
```

#### 4D: Reference Variables

Reference variables let one service reference another service's variables using Railway's `${{ }}` syntax. Set these in the Railway dashboard:

```
# In your API service, reference the database service:
DATABASE_URL = ${{ Postgres.DATABASE_URL }}

# Reference another service's port:
WORKER_URL = http://worker.railway.internal:${{ Worker.PORT }}

# Reference a shared variable:
APP_NAME = ${{ shared.APP_NAME }}
```

Reference variables are resolved at deploy time and keep services loosely coupled.

#### 4E: Per-Environment Variables

Railway supports multiple environments (production, staging, etc.). Variables can differ per environment:

```bash
# Switch to staging environment
railway environment staging

# Set a staging-specific variable
railway variables set DATABASE_URL=postgresql://postgres:dev@localhost:5432/staging

# Switch back to production
railway environment production
```

### Step 5: Custom Domains & Networking

#### 5A: Railway-Provided Domain

Every service with an exposed port gets a free `*.up.railway.app` domain:

```bash
# Generate a Railway domain for the current service
railway domain
```

This outputs something like: `myapp-production.up.railway.app`

#### 5B: Custom Domain Setup

```bash
# Add a custom domain
railway domain --set myapp.com

# Add a subdomain
railway domain --set api.myapp.com
```

**DNS configuration required:**

| Record Type | Name | Value |
|-------------|------|-------|
| CNAME | `api` | `<your-railway-domain>.up.railway.app` |
| CNAME | `www` | `<your-railway-domain>.up.railway.app` |
| CNAME | `@` (root) | Use CNAME flattening or ALIAS if your DNS provider supports it |

**For root domains (`myapp.com` without `www`):**
- Cloudflare: Use CNAME flattening (set CNAME on `@`, Cloudflare handles it)
- Route53: Use ALIAS record
- Other providers: Some don't support CNAME on root — use a `www` redirect instead

Railway automatically provisions and renews SSL/TLS certificates via Let's Encrypt once DNS propagates.

#### 5C: Healthcheck Configuration

Always configure healthchecks so Railway can verify your service is running:

```toml
# railway.toml
[deploy]
healthcheckPath = "/health"
healthcheckTimeout = 300
```

**Implement the healthcheck endpoint in your application:**

Node.js (Express):
```js
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok', timestamp: Date.now() });
});
```

Python (FastAPI):
```python
@app.get("/health")
async def health():
    return {"status": "ok"}
```

Go (net/http):
```go
http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
    w.WriteHeader(http.StatusOK)
    w.Write([]byte(`{"status":"ok"}`))
})
```

**Deep healthcheck (verify database connectivity):**
```js
app.get('/health', async (req, res) => {
  try {
    await db.raw('SELECT 1');
    res.status(200).json({ status: 'ok', db: 'connected' });
  } catch (err) {
    res.status(503).json({ status: 'degraded', db: 'disconnected' });
  }
});
```

**Healthcheck timeout:** Railway waits up to `healthcheckTimeout` seconds (default 300) for the first successful healthcheck response after a deploy. If it times out, the deploy is marked as failed and the previous version remains active. Increase this value for services with slow startup (e.g., Java/Spring Boot apps that need 60+ seconds to initialize).

#### 5D: Internal Networking

Services within the same Railway project communicate over a private network. No ports are exposed to the public internet for internal traffic.

```
# Internal DNS format:
<service-name>.railway.internal:<port>

# Examples:
api.railway.internal:3000
worker.railway.internal:8080
redis.railway.internal:6379
```

**Important:** The `PORT` environment variable is auto-set by Railway for services that need to accept external HTTP traffic. For internal-only services (workers, cron jobs), you can set your own port or skip exposing one entirely.

### Step 6: Deployment Strategies

#### 6A: Auto-Deploy from GitHub

The most common setup — Railway deploys automatically when you push to a branch:

1. Connect your GitHub repo in the Railway dashboard
2. Select the branch to auto-deploy (typically `main` or `production`)
3. Every push to that branch triggers a build and deploy

```bash
# Your normal git workflow triggers deploys:
git add .
git commit -m "feat: add user registration"
git push origin main
# Railway detects the push and starts building
```

**Branch-to-environment mapping:**

| Branch | Railway Environment | Purpose |
|--------|-------------------|---------|
| `main` | Production | Live traffic |
| `staging` | Staging | Pre-production testing |
| `develop` | Development | Internal testing |

Configure this in Railway dashboard under Service Settings > Source.

#### 6B: Manual CLI Deploys

Deploy directly from your local machine without pushing to GitHub:

```bash
# Deploy the current directory to Railway
railway up

# Deploy with verbose output
railway up --verbose

# Deploy and detach (don't tail logs)
railway up --detach
```

`railway up` uploads your source code directly to Railway, bypassing GitHub. Useful for:
- Quick iterations during development
- Projects not connected to GitHub
- Hotfixes that need immediate deployment

#### 6C: Preview Environments (PR Deploys)

Railway can create ephemeral environments for every pull request:

1. Enable PR deploys in Railway dashboard under Service Settings
2. Each PR gets its own isolated environment with:
   - Separate URL (`pr-123.up.railway.app`)
   - Copied environment variables from the source environment
   - Its own database instance (if configured)
3. The environment is automatically destroyed when the PR is closed

**PR deploy flow:**
```
Open PR → Railway creates preview environment → Build & deploy → Get preview URL
Merge PR → Railway destroys preview environment
```

#### 6D: Rollbacks

If a deploy breaks production, roll back immediately:

```bash
# View recent deployments
railway logs --deployment

# Rollback to a previous deployment via the Railway dashboard:
# Project > Service > Deployments > Click on previous successful deploy > Rollback
```

Railway keeps deployment history, so you can roll back to any previous successful deployment from the dashboard. The rollback is near-instant because it reuses the previously built image.

**Zero-downtime deployments:** Railway performs rolling deploys by default. The new instance must pass its healthcheck before the old instance is stopped. If the healthcheck fails, the deploy is aborted and the old instance continues serving traffic.

#### 6E: Deploy Hooks (Webhooks)

Trigger deploys from external systems (CI/CD, Slack bots, etc.):

1. Get a deploy webhook URL from Railway dashboard (Service Settings > Deploy Hooks)
2. POST to the webhook URL to trigger a deploy:

```bash
curl -X POST https://backboard.railway.app/deploy-hook/YOUR_HOOK_TOKEN
```

Useful for:
- Triggering deploys from GitHub Actions after tests pass
- ChatOps-style deploys from Slack
- Scheduled deploys via cron

### Step 7: Monitoring & Observability

#### 7A: Railway Logs

```bash
# Tail live logs from the current service
railway logs

# Tail logs with timestamps
railway logs --timestamps

# View logs for a specific deployment
railway logs --deployment <deployment-id>
```

**Structured logging recommendation:** Output JSON logs so Railway's log viewer can parse fields:

```js
// Use structured logging in production
const log = (level, message, meta = {}) => {
  console.log(JSON.stringify({
    level,
    message,
    timestamp: new Date().toISOString(),
    ...meta,
  }));
};

log('info', 'Server started', { port: process.env.PORT });
log('error', 'Database connection failed', { error: err.message });
```

```python
import json, sys
from datetime import datetime

def log(level: str, message: str, **meta):
    print(json.dumps({
        "level": level,
        "message": message,
        "timestamp": datetime.utcnow().isoformat(),
        **meta
    }), file=sys.stdout, flush=True)

log("info", "Server started", port=os.environ.get("PORT"))
```

#### 7B: Railway Metrics

Railway provides built-in metrics in the dashboard:

- **CPU usage**: Percentage of allocated vCPU
- **Memory usage**: Current RSS vs allocated memory
- **Network I/O**: Inbound and outbound traffic
- **Disk usage**: For services with persistent volumes

Access metrics: Railway dashboard > Project > Service > Metrics tab.

**Setting resource limits:**
Railway uses usage-based pricing. Set limits to prevent runaway costs:

```bash
# Via dashboard: Service Settings > Resource Limits
# Memory limit: 512MB, 1GB, 2GB, 4GB, 8GB
# vCPU limit: 0.5, 1, 2, 4, 8 vCPUs
```

#### 7C: Alerting

Railway provides basic alerting for:
- Deploy failures (email notification)
- Service crashes and restarts
- Resource limit breaches

For advanced alerting, integrate external monitoring:

**Sentry (error tracking):**
```bash
# Set Sentry DSN as an environment variable
railway variables set SENTRY_DSN=https://abc@o123.ingest.sentry.io/456
```

```js
// Initialize in your app
const Sentry = require('@sentry/node');
Sentry.init({ dsn: process.env.SENTRY_DSN });
```

**Uptime monitoring (external):**
- Better Uptime, UptimeRobot, or Checkly pointed at your healthcheck endpoint
- Alert on HTTP status != 200 or response time > threshold

**Custom metrics with Prometheus (advanced):**
```js
// Expose /metrics endpoint for external scraping
const promClient = require('prom-client');
promClient.collectDefaultMetrics();

app.get('/metrics', async (req, res) => {
  res.set('Content-Type', promClient.register.contentType);
  res.end(await promClient.register.metrics());
});
```

#### 7D: Railway Run (One-off Commands)

Execute one-off commands in the Railway environment (database migrations, seeds, etc.):

```bash
# Run a migration
railway run npx prisma migrate deploy

# Run a database seed
railway run node scripts/seed.js

# Open a shell with Railway environment variables loaded
railway shell

# Run a Python management command
railway run python manage.py migrate
railway run python manage.py createsuperuser
```

`railway run` executes the command locally but with all Railway environment variables injected. This means the command runs on your machine but connects to Railway's databases and services.

### Step 8: Output Summary

After completing deployment setup, report:

```
--- RAILWAY DEPLOY --------------------------------

-- PROJECT --------------------------------------
Name: [project-name]
Environment: [production/staging]
Region: [us-west1/us-east4/eu-west1]

-- SERVICES -------------------------------------
[service-name]    [language/framework]    [status]
[database]        [PostgreSQL/Redis]      [provisioned]

-- CONFIGURATION --------------------------------
Build: [nixpacks/dockerfile]
Deploy: [auto-deploy from main / manual CLI]
Healthcheck: [/health — configured]

-- DOMAINS --------------------------------------
Railway: [app].up.railway.app
Custom: [domain.com — DNS pending/active]
SSL: [auto-provisioned]

-- ENVIRONMENT VARIABLES ------------------------
[count] variables set
Secrets: [secured]
Shared: [count] shared variables

-- NEXT STEPS -----------------------------------
1. Verify healthcheck endpoint responds: curl https://[domain]/health
2. Confirm DNS propagation: dig [domain] CNAME
3. Set up monitoring (Sentry, uptime checks)
4. Test rollback procedure
5. Configure PR preview environments (optional)
```

## Anti-Patterns

- **Committing `.env` files to git**: Use `railway variables set` to manage secrets. Never store secrets in source control.
- **Using public database URLs for internal service communication**: Always use `*.railway.internal` hostnames for service-to-service connections within the same project. Public URLs add latency and may incur egress charges.
- **Skipping healthchecks**: Without a healthcheck path, Railway cannot verify your service is running. A broken deploy will replace the working version with no automatic rollback.
- **Hardcoding PORT**: Always use `process.env.PORT` or `$PORT`. Railway dynamically assigns the port for your service.
- **Running database migrations in the build step**: Migrations should run in the start command or via `railway run`, not during the build phase. Builds may run in environments without database access.
- **Ignoring watch patterns in monorepos**: Without `watchPatterns`, every commit to any subdirectory triggers a rebuild of every service, wasting build minutes and causing unnecessary downtime.
- **Using `railway up` for production**: CLI deploys bypass version control. Use GitHub auto-deploy for production and reserve `railway up` for development and testing.
- **Not setting resource limits**: Railway's usage-based pricing means a memory leak or CPU spike can generate unexpected costs. Always set memory and CPU limits for production services.
- **Running long-running processes as the start command without a process manager**: For Node.js workers, consider using a process manager or ensure your application handles SIGTERM gracefully for clean shutdowns during deploys.

## Escalation

Hand off when:
- Kubernetes or container orchestration beyond Railway's service model is needed
- Multi-region deployment with geographic routing is required (Railway currently supports single-region per project)
- Compliance requirements demand specific infrastructure certifications (SOC2, HIPAA) beyond Railway's current offerings
- Traffic exceeds Railway's scaling limits and requires dedicated infrastructure — see hetzner-setup
- Complex networking requirements (VPN tunnels, VPC peering, static IPs) exceed Railway's networking model
- GPU workloads or specialized hardware access is needed

## Inputs

- Application source code (GitHub repo or local directory)
- Language, runtime, and framework
- Required services (databases, caches, queues)
- Environment variables and secrets
- Custom domain (optional)
- Deployment strategy preference (auto-deploy vs manual)
- Monorepo structure details (if applicable)

## Outputs

- `railway.toml` configuration file
- `nixpacks.toml` (if custom system packages needed)
- Environment variables configured in Railway
- Custom domain with SSL provisioned
- Healthcheck endpoint implemented and configured
- Deployment pipeline (auto-deploy or CLI workflow)
- Monitoring and logging setup guidance
- Rollback procedure documented

## Level History

- **Lv.1** — Base: Full deployment workflow covering Railway CLI setup, project configuration (railway.toml, nixpacks.toml, Procfile), service architecture (monorepo, multi-service, database add-ons), environment variable management (shared, reference, per-environment), custom domains with SSL, deployment strategies (auto-deploy, CLI, PR previews, rollbacks, deploy hooks), monitoring and observability (logs, metrics, alerting, one-off commands), structured output summary. (Origin: MemStack v3.3, Mar 2026)
