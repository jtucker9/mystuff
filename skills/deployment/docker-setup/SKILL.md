---
name: docker-setup
description: "Use when the user says 'Docker', 'Dockerfile', 'docker-compose', 'containerize', 'docker setup', or needs to containerize an application with optimized images and compose configs. Do NOT use for CI/CD pipelines (see ci-cd-pipeline) or serverless deployments (see netlify-deploy)."
---

# 🐳 Docker Setup — Containerization & Orchestration
*Generate optimized Dockerfiles, docker-compose configurations, and production-ready container setups with multi-stage builds, health checks, and security hardening.*

## Activation

When this skill activates, output:

`🐳 Docker Setup — Containerizing your application...`

| Context | Status |
|---------|--------|
| **User says "Docker", "Dockerfile", "containerize"** | ACTIVE |
| **User says "docker-compose", "multi-container"** | ACTIVE |
| **User wants CI/CD pipeline design** | DORMANT — see ci-cd-pipeline |
| **User wants static site deploy** | DORMANT — see netlify-deploy |

## Protocol

### Step 1: Gather Inputs

- **Application type**: Web server, API, worker, full-stack with DB?
- **Language/runtime**: Node.js, Python, Go, Rust, etc.
- **Services needed**: PostgreSQL, Redis, etc.?
- **Environment**: Development, production, or both?
- **Registry**: GHCR, Docker Hub, ECR, self-hosted?

### Step 2: Multi-Stage Dockerfiles

**Node.js (production optimized):**
```dockerfile
# Stage 1: Dependencies
FROM node:20-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --only=production

# Stage 2: Build
FROM node:20-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 3: Production
FROM node:20-alpine AS production
RUN addgroup -g 1001 appgroup && adduser -u 1001 -G appgroup -s /bin/sh -D appuser
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
COPY package.json ./
USER appuser
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1
CMD ["node", "dist/index.js"]
```

**Python (FastAPI/Django):**
```dockerfile
FROM python:3.12-slim AS base
RUN groupadd -r appgroup && useradd -r -g appgroup appuser
WORKDIR /app

FROM base AS deps
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

FROM base AS production
COPY --from=deps /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=deps /usr/local/bin /usr/local/bin
COPY . .
USER appuser
EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=3s CMD curl -f http://localhost:8000/health || exit 1
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

**Go (tiny final image):**
```dockerfile
FROM golang:1.22-alpine AS build
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /server ./cmd/server

FROM scratch
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /server /server
EXPOSE 8080
ENTRYPOINT ["/server"]
```

### Step 3: Docker Compose

**Development with hot reload:**
```yaml
# docker-compose.yml
services:
  app:
    build:
      context: .
      target: deps  # Use dependency stage for dev
    volumes:
      - .:/app
      - /app/node_modules  # Don't overwrite container node_modules
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/myapp
    depends_on:
      db:
        condition: service_healthy
    command: npm run dev

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: myapp
      POSTGRES_PASSWORD: postgres
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s

volumes:
  pgdata:
```

**Production:**
```yaml
# docker-compose.prod.yml
services:
  app:
    build:
      context: .
      target: production
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
    env_file:
      - .env.production
    restart: unless-stopped
    deploy:
      resources:
        limits:
          memory: 512M
          cpus: '0.5'
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "3"
```

### Step 4: Image Size Optimization

| Technique | Savings |
|-----------|---------|
| Alpine base images | 50-80% vs Debian |
| Multi-stage builds | 60-90% (no build tools in final) |
| `.dockerignore` | Prevents bloat from node_modules, .git |
| `--no-cache-dir` (pip) | 10-20% for Python |
| `CGO_ENABLED=0` + `scratch` (Go) | 95%+ (5-15MB final) |
| `npm ci --only=production` | 30-60% fewer node_modules |

**Essential .dockerignore:**
```
node_modules
.git
.env*
dist
coverage
.github
*.md
docker-compose*
Dockerfile*
.dockerignore
```

### Step 5: Security Hardening

- **Non-root user**: Always `USER appuser` in production images
- **Read-only filesystem**: `docker run --read-only` where possible
- **No unnecessary packages**: Don't install curl/wget in prod unless needed for healthcheck
- **Pin base image digests** for reproducibility: `FROM node:20-alpine@sha256:abc...`
- **Scan images**: `trivy image myapp:latest` or `docker scout cves myapp:latest`

### Step 6: Output

```
━━━ DOCKER SETUP ━━━━━━━━━━━━━━━━━━━━━━━━

── FILES GENERATED ───────────────────────
Dockerfile (multi-stage, optimized)
docker-compose.yml (development)
docker-compose.prod.yml (production)
.dockerignore

── IMAGE DETAILS ─────────────────────────
Base: [image]
Final size: ~[X]MB
Stages: [N]
User: non-root

── COMMANDS ──────────────────────────────
Dev:  docker compose up
Prod: docker compose -f docker-compose.prod.yml up -d
Build: docker build -t myapp .
Scan: trivy image myapp:latest
```

## Anti-Patterns

- **Running as root in containers**: Always create and switch to a non-root user.
- **Using `latest` tag in production**: Pin specific versions for reproducibility.
- **Copying everything with `COPY . .` without `.dockerignore`**: Bloats images with .git, node_modules, etc.
- **Installing dev dependencies in production image**: Use multi-stage builds to separate.
- **Hardcoding secrets in Dockerfile**: Use `env_file` or Docker secrets, never `ENV SECRET=value`.
- **Single-stage Dockerfiles**: Always use multi-stage for production. Build tools don't belong in runtime images.

## Escalation

Hand off when:
- Kubernetes orchestration is needed (Helm charts, pod autoscaling)
- Complex networking across multiple hosts (Docker Swarm, overlay networks)
- GPU workloads or specialized hardware access in containers
- Custom base images for compliance/security requirements

## Inputs
- Application type and language
- Required services (DB, cache, queue)
- Environment (dev/prod/both)
- Registry preference

## Outputs
- Multi-stage Dockerfile
- docker-compose.yml (dev and prod)
- .dockerignore
- Build and run commands
- Security scanning guidance

## Level History

- **Lv.1** — Base: Multi-stage Dockerfiles for Node/Python/Go, dev and prod compose configs, image optimization techniques, security hardening, .dockerignore templates. (Origin: MemStack v3.3, Mar 2026)
