---
name: railway-deploy
description: "Deploy applications to Railway.app — project config, service architecture, env vars, domains, and deployment strategies. Activate on 'deploy to Railway', 'railway deploy', 'railway setup'. Do NOT activate for Netlify, Vercel, Hetzner, Docker-only containerization, or CI/CD pipeline design."
---

# Railway Deploy

## Activation

| Context | Status |
|---------|--------|
| "deploy to Railway", "railway deploy", "railway setup" | ACTIVE |
| PaaS deployment for any Nixpacks-supported runtime | ACTIVE |
| Netlify, Vercel, static-only hosting | DORMANT — see netlify-deploy |
| VPS / bare-metal / self-managed infra | DORMANT — see hetzner-setup |
| Containerization without Railway target | DORMANT — see docker-setup |
| CI/CD pipeline design | DORMANT — see ci-cd-pipeline |

## Instructions

### Step 1: Classify the deployment

Determine three things before any configuration:

1. **Service topology**: Single service, monorepo (one repo, N services), or multi-service (separate repos)?
2. **Build strategy**: Nixpacks auto-detect sufficient, or Dockerfile/custom Nix packages required?
3. **Deploy trigger**: GitHub auto-deploy, CLI push, or webhook-driven?

Decision rules:
- Single service is the default. Only escalate to monorepo/multi-service if the user describes multiple independently-deployable units.
- Nixpacks covers Node, Python, Go, Rust, Java, Ruby, PHP out of the box. Use Dockerfile only when system dependencies exceed Nixpacks capabilities (e.g., native binaries, multi-stage builds with private registries). Use `nixpacks.toml` when you need specific system packages (ffmpeg, imagemagick) or multi-language runtimes but not full Docker control.
- GitHub auto-deploy is correct for production. `railway up` is for development/hotfixes only — it bypasses version control.

> Confirm the user's service topology, build strategy, and deploy trigger before proceeding.

### Step 2: Configure the build

**Config file priority**: `railway.toml` > `nixpacks.toml` > `Dockerfile` > `Procfile` > auto-detection. Only create the highest-priority file needed.

`railway.toml` decision rules:
- Always set `healthcheckPath`, `healthcheckTimeout`, `restartPolicyType`, and `restartPolicyMaxRetries` — these have no equivalent elsewhere.
- Set `buildCommand` only when Nixpacks auto-detection gets it wrong (monorepos, custom build pipelines).
- Set `startCommand` only when the default entrypoint is incorrect.
- For Dockerfile builds: set `builder = "dockerfile"` and `dockerfilePath`. The Dockerfile handles everything else.

`nixpacks.toml` decision rules:
- Only create when `railway.toml` build overrides are insufficient: custom Nix packages, multi-language phases, or explicit phase ordering.
- Do not duplicate settings that `railway.toml` already handles.

> Confirm the generated config matches the project's actual build/start commands before proceeding.

### Step 3: Configure service architecture

**Single service**: No special configuration beyond Step 2.

**Monorepo**: Each service needs a Root Directory set (dashboard or API) and `watchPatterns` in its `railway.toml`. Without watch patterns, every commit rebuilds every service. Build commands must reference the monorepo root for dependency resolution (e.g., `cd ../.. && npm ci && npx turbo run build --filter=api`).

**Multi-service**: Services communicate via internal DNS (`<service-name>.railway.internal:<port>`). Use reference variables (`${{ ServiceName.VARIABLE }}`) for service discovery — never hardcode internal URLs. The `PORT` env var is auto-assigned only for services accepting external HTTP; internal-only services define their own port.

**Database add-ons**: Always use `*.railway.internal` hostnames for service-to-database connections. Public hostnames add latency and egress cost. Railway auto-injects `DATABASE_URL`, `REDIS_URL`, and component variables — prefer these over manual connection strings.

> Confirm all inter-service references resolve correctly and watch patterns cover shared dependency paths.

### Step 4: Set environment variables

Three scopes, in order of specificity:
1. **Service variables** — scoped to one service in one environment. Set via CLI or dashboard.
2. **Shared variables** — available to all services in the project. Set in Project Settings.
3. **Reference variables** — `${{ Service.VAR }}` syntax, resolved at deploy time. Use for inter-service discovery.

Decision rules:
- Secrets (API keys, JWT secrets) go in service variables, never in code or shared scope unless every service genuinely needs them.
- Per-environment overrides: switch environment with `railway environment <name>` before setting variables. Production and staging must have independent secrets.
- Bulk import from `.env` is acceptable for initial setup but the `.env` file must be in `.gitignore`.

> Confirm no secrets are hardcoded in source and all environments have correct variable overrides.

### Step 5: Configure domains and networking

**Railway domain**: Auto-generated `*.up.railway.app` — sufficient for staging and development.

**Custom domain**: Requires CNAME record pointing to the Railway domain. Root domains (`example.com`) need CNAME flattening (Cloudflare) or ALIAS records (Route53) — not all DNS providers support this; fall back to `www` subdomain with redirect. SSL is auto-provisioned via Let's Encrypt after DNS propagation.

**Healthchecks are mandatory for production**. Without one, Railway cannot distinguish a crashed deploy from a slow start, and broken deploys replace working ones with no automatic rollback. Set `healthcheckTimeout` high enough for slow-starting runtimes (Java/Spring: 120-180s). Deep healthchecks (DB connectivity) catch more failures but risk false negatives during transient outages — use shallow checks for the Railway healthcheck path and deep checks on a separate diagnostic endpoint.

> Confirm DNS records are created and healthcheck endpoint returns 200 before marking deployment complete.

### Step 6: Deploy and validate

**Auto-deploy**: Connect GitHub repo, map branches to environments (main->production, staging->staging). Every push triggers build+deploy.

**Preview environments (PR deploys)**: Enable in service settings. Each PR gets an isolated environment with copied variables and its own URL. Destroyed on PR close. Useful but doubles resource usage — only enable for projects that need per-PR testing.

**Rollbacks**: Dashboard-only (Project > Service > Deployments > select previous > Rollback). Near-instant because Railway reuses the previously built image. Test the rollback procedure before you need it.

**Deploy hooks**: Webhook URLs for triggering deploys from external systems. Use when GitHub integration is insufficient (e.g., deploy after external CI passes).

**Zero-downtime**: Railway performs rolling deploys by default — the new instance must pass its healthcheck before the old one stops. If the healthcheck fails, the deploy aborts and the old instance continues.

> Confirm the first deployment succeeds, healthcheck passes, and the service is reachable at its domain.

### Step 7: Set up monitoring

Railway provides built-in CPU, memory, network, and disk metrics in the dashboard. This is sufficient for most projects.

Escalate to external monitoring when:
- Error tracking is needed beyond log inspection — add Sentry via `SENTRY_DSN` env var.
- Uptime SLA monitoring is required — point Better Uptime / UptimeRobot / Checkly at the healthcheck endpoint.
- Custom business metrics are needed — expose a `/metrics` endpoint for Prometheus scraping.

Set resource limits (memory, vCPU) in dashboard Service Settings to prevent runaway costs on usage-based billing.

Use `railway run <command>` for one-off operations (migrations, seeds, shells) — it executes locally with Railway env vars injected. Do not run migrations in the build step; builds may lack database access.

Use structured JSON logging so Railway's log viewer can parse fields. Always flush stdout (`flush=True` in Python, default in Node).

## Examples

**Single Next.js app with Postgres**: User says "deploy my Next.js app to Railway." Classify as single service, Nixpacks, GitHub auto-deploy. Create `railway.toml` with standalone output start command and healthcheck. Add Postgres addon, confirm `DATABASE_URL` auto-injected. Map `main` branch to production. Custom domain with CNAME.

**Monorepo API + Worker + Redis**: User has Turborepo with `apps/api` and `apps/worker`. Classify as monorepo, Nixpacks, GitHub auto-deploy. Two `railway.toml` files with watch patterns scoped to each app plus shared packages. Redis addon. Worker references API via `${{ API.PORT }}` on internal DNS. No custom domain on worker (internal-only).

## Common Issues

- **Deploy succeeds but service unreachable**: Missing `PORT` env var usage in app — Railway assigns the port dynamically, app must bind to `$PORT`.
- **Healthcheck timeout on first deploy**: `healthcheckTimeout` too low for the runtime's cold start — increase to 180-300s for Java/Spring, 60s for Node/Python.
- **Monorepo rebuilds everything on every commit**: Missing or incorrect `watchPatterns` in `railway.toml` — patterns must cover the service's own directory and any shared dependency paths.

## Anti-Patterns

- Committing `.env` files or hardcoding secrets in source — use `railway variables set`.
- Using public database URLs for internal service communication — always use `*.railway.internal`.
- Skipping healthchecks — broken deploys silently replace working ones.
- Running `railway up` for production deploys — bypasses version control and audit trail.
- Running database migrations in the build phase — builds may lack database network access.
- Not setting resource limits — usage-based billing means leaks generate unbounded cost.
- Ignoring watch patterns in monorepos — every commit rebuilds every service.

## Escalation

Hand off when the project requires: multi-region with geographic routing, Kubernetes orchestration, compliance certifications (SOC2/HIPAA), GPU workloads, VPN/VPC peering, static IPs, or traffic that exceeds Railway's scaling limits.

## Inputs

- Application source (GitHub repo or local directory)
- Language/runtime/framework
- Required services (databases, caches)
- Environment variables and secrets
- Custom domain (optional)
- Deployment strategy preference
- Monorepo structure (if applicable)

## Outputs

- `railway.toml` (and `nixpacks.toml` if needed)
- Environment variables configured per environment
- Custom domain with SSL provisioned
- Healthcheck endpoint configured and verified
- Deployment pipeline active (auto-deploy or CLI)
- Monitoring baseline established
- Rollback procedure validated

## Level History

- **Lv.1** — Base: Full deployment workflow — CLI setup, project config (railway.toml, nixpacks.toml, Procfile), service architecture (monorepo, multi-service, database add-ons), env var management (shared, reference, per-environment), custom domains with SSL, deployment strategies (auto-deploy, CLI, PR previews, rollbacks, deploy hooks), monitoring and observability, structured output summary. (Origin: MemStack v3.3, Mar 2026)
- **Lv.2** — Compressed: Rewritten as decision-framework skill. Removed tutorial code, CLI walkthroughs, and example configs. Added validation gates between steps, tightened anti-patterns, added common issues section. Creator-level density targeting expert users who need decision rules, not how-to. (Origin: MemStack v3.4, Mar 2026)
