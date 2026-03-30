---
name: docker-setup
description: "Containerize applications with optimized multi-stage Dockerfiles, compose configs, and security hardening. Activates on 'Docker', 'Dockerfile', 'docker-compose', 'containerize'. NOT for CI/CD pipelines (ci-cd-pipeline), serverless deploys (netlify-deploy), or Kubernetes orchestration."
---

# Docker Setup

## Activation

| Context | Status |
|---------|--------|
| "Docker", "Dockerfile", "containerize", "docker-compose" | ACTIVE |
| CI/CD pipeline design | DORMANT — ci-cd-pipeline |
| Static site / serverless deploy | DORMANT — netlify-deploy |
| Kubernetes, Helm, Swarm orchestration | ESCALATE |

## Instructions

### Step 1: Gather Inputs

Determine before generating anything:
- **Runtime**: Node.js, Python, Go, Rust, etc.
- **App type**: Web server, API, worker, full-stack w/ DB
- **Services**: PostgreSQL, Redis, message queue, etc.
- **Environments**: Dev only, prod only, or both
- **Registry**: GHCR, Docker Hub, ECR, self-hosted

**Gate**: Do not proceed without runtime and app type confirmed.

### Step 2: Generate Multi-Stage Dockerfile

Three-stage pattern: `deps` -> `build` -> `production`.

| Stage | Purpose | What stays |
|-------|---------|------------|
| deps | Install production dependencies only | Runtime deps |
| build | Install all deps, compile/transpile | Build artifacts |
| production | Copy only runtime deps + artifacts | Minimal runtime |

Decision rules per runtime:
- **Node**: Alpine base, `npm ci --only=production` in deps, `npm ci` + `npm run build` in build, copy `node_modules` from deps + `dist` from build into production
- **Python**: Slim base, `pip install --no-cache-dir` in deps, copy `site-packages` + `bin` into production
- **Go**: Alpine build stage, `CGO_ENABLED=0` + `-ldflags="-s -w"`, final stage `FROM scratch` with CA certs copied

Every production stage must include: non-root user creation, `USER` directive, `EXPOSE`, `HEALTHCHECK`, `CMD`.

**Gate**: Verify Dockerfile builds clean (`docker build .`) before proceeding.

### Step 3: Generate Compose Configs

Dev vs prod compose differences:

| Concern | Development | Production |
|---------|-------------|------------|
| Build target | `deps` stage | `production` stage |
| Volumes | Bind-mount source + anonymous volume for `node_modules` | None (image is self-contained) |
| Command | `npm run dev` / hot-reload | Default CMD from Dockerfile |
| Restart | Not set | `unless-stopped` |
| Resource limits | Not set | `memory`, `cpus` under `deploy.resources.limits` |
| Logging | Default | `json-file` with `max-size` + `max-file` |
| Env | Inline `environment` | `env_file` reference |
| Ports (DB/cache) | Exposed to host | Internal only |

Service dependency ordering: use `depends_on` with `condition: service_healthy`. Every service (DB, cache) must define a `healthcheck`.

Healthcheck patterns:
- PostgreSQL: `pg_isready -U postgres`
- Redis: `redis-cli ping`
- App: `wget --spider http://localhost:PORT/health || exit 1`

**Gate**: `docker compose config` validates without errors.

### Step 4: Generate .dockerignore

Exclude: `node_modules`, `.git`, `.env*`, `dist`, `coverage`, `.github`, `*.md`, `docker-compose*`, `Dockerfile*`, `.dockerignore`.

### Step 5: Image Size Optimization

| Technique | Typical savings | When to apply |
|-----------|----------------|---------------|
| Alpine base images | 50-80% vs Debian | Always (unless native deps need glibc) |
| Multi-stage builds | 60-90% | Always for production |
| `--no-cache-dir` (pip) | 10-20% | Python projects |
| `CGO_ENABLED=0` + `scratch` | 95%+ (5-15MB final) | Go projects |
| `npm ci --only=production` | 30-60% fewer modules | Node projects |
| `.dockerignore` | Prevents context bloat | Always |

### Step 6: Security Hardening

Mandatory for every production image:
- **Non-root user**: Create group + user, `USER appuser` before CMD
- **Read-only filesystem**: Run with `--read-only` where possible
- **Pin base image digests**: `FROM node:20-alpine@sha256:abc...` for reproducibility
- **No unnecessary packages**: Skip curl/wget in prod unless healthcheck requires it
- **Scan images**: `trivy image myapp:latest` or `docker scout cves myapp:latest`
- **Never hardcode secrets**: Use `env_file` or Docker secrets, never `ENV SECRET=value`

**Gate**: `trivy image` scan shows no critical/high vulnerabilities.

## Examples

**1. Node.js API + Postgres**: 3-stage Dockerfile (deps/build/production) on `node:20-alpine`, compose with `db` (postgres:16-alpine) + `redis` (redis:7-alpine), healthchecks on all services, dev compose bind-mounts source with anonymous `node_modules` volume.

**2. Go microservice**: 2-stage Dockerfile (build on `golang:1.22-alpine`, production `FROM scratch`), CA certs copied from build stage, single-binary ~10MB image, no compose needed for standalone deploy.

## Common Issues

- **Build context too large**: Missing or incomplete `.dockerignore` — check that `.git` and `node_modules` are excluded.
- **Container exits immediately**: `CMD` runs a process that backgrounds itself — use exec form `["node", "app.js"]` not shell form.
- **Health check fails on startup**: Increase `--start-period` to give the app time to initialize before health checks count.

## Anti-Patterns

- Running as root in production containers
- Using `latest` tag in production (pin versions)
- `COPY . .` without `.dockerignore`
- Dev dependencies in production image (use multi-stage)
- Single-stage Dockerfiles for production
- Hardcoded secrets in Dockerfile `ENV` directives

## Escalation

Hand off when:
- Kubernetes orchestration needed (Helm charts, pod autoscaling)
- Complex multi-host networking (overlay networks, service mesh)
- GPU workloads or specialized hardware access
- Custom compliance base images required

## Inputs

- Application runtime and type
- Required services (DB, cache, queue)
- Target environments (dev/prod/both)
- Registry preference

## Outputs

- Multi-stage Dockerfile
- docker-compose.yml (dev) + docker-compose.prod.yml (prod) if both requested
- .dockerignore
- Build/run commands and scan guidance

## Level History

- **Lv.1** — Base: Multi-stage Dockerfiles for Node/Python/Go, dev and prod compose configs, image optimization techniques, security hardening, .dockerignore templates. (Origin: MemStack v3.3, Mar 2026)
- **Lv.2** — Compressed: Replaced full Dockerfile/compose examples with decision rules and pattern tables. Preserved multi-stage concept, optimization table, security rules, healthcheck patterns, dev/prod differences, dependency ordering. (Origin: MemStack v3.4, Mar 2026)
