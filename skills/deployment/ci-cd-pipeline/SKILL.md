---
name: ci-cd-pipeline
description: "Use when the user says 'CI/CD', 'GitHub Actions', 'pipeline', 'continuous integration', 'continuous deployment', 'automate deploys', 'workflow', or needs automated build, test, and deployment pipelines. Do NOT use for one-time manual deployments (see railway-deploy, netlify-deploy)."
---

# ⚙️ CI/CD Pipeline — Automated Build, Test & Deploy
*Design and implement CI/CD pipelines with lint, test, build, and deploy stages, environment management, caching, and rollback strategies.*

## Activation

When this skill activates, output:

`⚙️ CI/CD Pipeline — Designing your automated pipeline...`

| Context | Status |
|---------|--------|
| **User says "CI/CD", "GitHub Actions", "pipeline"** | ACTIVE |
| **User wants automated testing/deployment** | ACTIVE |
| **User wants one-time manual deploy to Railway** | DORMANT — see railway-deploy |
| **User wants Netlify-specific deploy** | DORMANT — see netlify-deploy |
| **User wants Docker setup** | DORMANT — see docker-setup |

## Protocol

### Step 1: Gather Inputs

- **CI platform**: GitHub Actions (default), GitLab CI, CircleCI?
- **Tech stack**: Language, framework, package manager
- **Test suite**: Unit, integration, e2e? Test runner?
- **Deploy target**: Railway, Netlify, AWS, Hetzner, Docker registry?
- **Environments**: dev/staging/prod? Or just prod?
- **Monorepo?**: Single app or multiple packages?

### Step 2: Pipeline Architecture

```
Standard pipeline stages:
┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐
│   Lint   │──▶│   Test   │──▶│  Build   │──▶│  Deploy  │──▶│  Verify  │
│          │   │          │   │          │   │ (staging) │   │ (smoke)  │
└──────────┘   └──────────┘   └──────────┘   └──────────┘   └──────────┘
                                                   │
                                             ┌─────▼─────┐
                                             │  Deploy   │
                                             │  (prod)   │
                                             │ [manual]  │
                                             └───────────┘
```

**Environment strategy decision tree:**
```
How many environments do you need?
├── Solo dev / small project → Just `main` → prod (direct deploy)
├── Small team → `main` → staging (auto) → prod (manual approval)
├── Larger team → feature branches → dev (auto) → staging (auto on merge) → prod (manual)
└── Enterprise → feature → dev → QA → staging → canary → prod (gated)
```

### Step 3: GitHub Actions Workflows

**Node.js / TypeScript:**
```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
      - run: npm ci
      - run: npm run lint
      - run: npm run typecheck

  test:
    runs-on: ubuntu-latest
    needs: lint
    services:
      postgres:
        image: postgres:16
        env:
          POSTGRES_PASSWORD: test
          POSTGRES_DB: testdb
        ports: ['5432:5432']
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
      - run: npm ci
      - run: npm test -- --coverage
        env:
          DATABASE_URL: postgresql://postgres:test@localhost:5432/testdb
      - uses: actions/upload-artifact@v4
        if: always()
        with:
          name: coverage
          path: coverage/

  build:
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'npm'
      - run: npm ci
      - run: npm run build
      - uses: actions/upload-artifact@v4
        with:
          name: build
          path: dist/

  deploy-staging:
    runs-on: ubuntu-latest
    needs: build
    if: github.ref == 'refs/heads/main'
    environment: staging
    steps:
      - uses: actions/checkout@v4
      - uses: actions/download-artifact@v4
        with:
          name: build
          path: dist/
      # Deploy to your target (Railway, Netlify, etc.)
      - run: echo "Deploy to staging"

  deploy-prod:
    runs-on: ubuntu-latest
    needs: deploy-staging
    if: github.ref == 'refs/heads/main'
    environment:
      name: production
      url: https://yourapp.com
    steps:
      - uses: actions/checkout@v4
      - uses: actions/download-artifact@v4
        with:
          name: build
          path: dist/
      - run: echo "Deploy to production"
```

**Python / FastAPI:**
```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  lint-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.12'
          cache: 'pip'
      - run: pip install -r requirements.txt -r requirements-dev.txt
      - run: ruff check .
      - run: mypy .
      - run: pytest --cov=app --cov-report=xml
      - uses: actions/upload-artifact@v4
        with:
          name: coverage
          path: coverage.xml

  build-push:
    needs: lint-test
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: docker/setup-buildx-action@v3
      - uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - uses: docker/build-push-action@v5
        with:
          push: true
          tags: ghcr.io/${{ github.repository }}:${{ github.sha }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

**Go:**
```yaml
name: CI
on: [push, pull_request]

jobs:
  ci:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-go@v5
        with:
          go-version: '1.22'
      - run: go vet ./...
      - run: staticcheck ./...
      - run: go test -race -coverprofile=coverage.out ./...
      - run: go build -o bin/app ./cmd/server
```

### Step 4: Caching Strategies

| Ecosystem | Cache Key | Cache Path |
|-----------|-----------|------------|
| npm | `hashFiles('**/package-lock.json')` | `~/.npm` (setup-node handles) |
| pip | `hashFiles('**/requirements*.txt')` | `~/.cache/pip` |
| Go | `hashFiles('**/go.sum')` | `~/go/pkg/mod` |
| Rust | `hashFiles('**/Cargo.lock')` | `~/.cargo/registry`, `target/` |
| Docker | `type=gha` | GitHub Actions cache backend |

**Docker layer caching (critical for speed):**
```yaml
- uses: docker/build-push-action@v5
  with:
    cache-from: type=gha
    cache-to: type=gha,mode=max
```

### Step 5: Secret Management

```yaml
# Define secrets in: Settings → Secrets and variables → Actions
# Reference in workflow:
env:
  DATABASE_URL: ${{ secrets.DATABASE_URL }}
  API_KEY: ${{ secrets.API_KEY }}

# Environment-specific secrets:
# Settings → Environments → staging/production → Add secret
# Referenced the same way but only available in jobs with that environment
```

**Rules:**
- Never echo secrets in logs: `echo ${{ secrets.X }}` is masked but avoid it
- Pin third-party actions to SHA, not tag: `uses: actions/checkout@abc123` not `@v4`
- Use `GITHUB_TOKEN` (auto-generated) where possible instead of PATs
- Rotate secrets on schedule, not just when compromised

### Step 6: Deployment Targets

**Railway:**
```yaml
deploy:
  steps:
    - uses: railwayapp/railway-github-link@v1
      with:
        railway_token: ${{ secrets.RAILWAY_TOKEN }}
```

**Netlify:**
```yaml
deploy:
  steps:
    - run: npx netlify-cli deploy --prod --dir=dist
      env:
        NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
        NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
```

**Docker Registry (GHCR):**
```yaml
deploy:
  steps:
    - uses: docker/login-action@v3
      with:
        registry: ghcr.io
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}
    - uses: docker/build-push-action@v5
      with:
        push: true
        tags: ghcr.io/${{ github.repository }}:latest
```

**SSH to VPS (Hetzner, DigitalOcean):**
```yaml
deploy:
  steps:
    - uses: appleboy/ssh-action@v1
      with:
        host: ${{ secrets.SERVER_HOST }}
        username: deploy
        key: ${{ secrets.SSH_PRIVATE_KEY }}
        script: |
          cd /opt/app
          git pull origin main
          docker compose up -d --build
```

### Step 7: Rollback Strategy

```yaml
# Tag every successful deploy
- run: |
    git tag "deploy-$(date +%Y%m%d-%H%M%S)"
    git push origin --tags

# Rollback = redeploy previous tag
# Manual trigger with version input:
on:
  workflow_dispatch:
    inputs:
      rollback_tag:
        description: 'Tag to rollback to'
        required: true
```

**Smoke test after deploy:**
```yaml
verify:
  needs: deploy
  steps:
    - run: |
        for i in 1 2 3 4 5; do
          STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://yourapp.com/health)
          if [ "$STATUS" = "200" ]; then echo "✅ Health check passed"; exit 0; fi
          echo "Attempt $i: got $STATUS, retrying..."
          sleep 10
        done
        echo "❌ Health check failed after 5 attempts"
        exit 1
```

### Step 8: Output

```
━━━ CI/CD PIPELINE ━━━━━━━━━━━━━━━━━━━━━━

── ARCHITECTURE ──────────────────────────
Stages: lint → test → build → deploy-staging → deploy-prod
Platform: GitHub Actions
Environments: staging (auto), production (manual approval)

── WORKFLOW FILES ─────────────────────────
.github/workflows/ci.yml
[complete YAML]

── SECRETS REQUIRED ──────────────────────
[list of secrets to configure]

── CACHING ───────────────────────────────
[cache strategy and expected speedup]

── ROLLBACK ──────────────────────────────
[rollback procedure]
```

## Anti-Patterns

- **Deploying on every push to main without tests**: Always gate deploys behind passing tests.
- **Using `@latest` or `@main` for third-party actions**: Pin to SHA for supply chain security.
- **Storing secrets in workflow files**: Use GitHub Secrets, never hardcode.
- **No concurrency control**: Multiple deploys racing causes issues. Use `concurrency` groups.
- **Skipping staging**: Even for small apps, deploy to staging first and smoke test.
- **Massive monolithic workflows**: Split into reusable workflows for maintainability.

## Escalation

Hand off when:
- Complex multi-region deployment with blue/green or canary strategies
- Compliance requires audit trails on all pipeline executions
- Self-hosted runners need network/security configuration
- Pipeline needs to orchestrate across multiple repositories

## Inputs
- Tech stack and test framework
- CI platform preference
- Deploy target(s)
- Environment strategy
- Monorepo structure (if applicable)

## Outputs
- Complete workflow YAML files
- Secret configuration list
- Caching strategy
- Rollback procedure
- Smoke test configuration

## Level History

- **Lv.1** — Base: Multi-stack workflow templates (Node, Python, Go, Rust), environment strategy decision tree, caching by ecosystem, secret management, deployment to 4 targets (Railway, Netlify, GHCR, SSH), rollback strategy, smoke tests. (Origin: MemStack v3.3, Mar 2026)
