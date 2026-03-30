---
name: ci-cd-pipeline
description: "Design CI/CD pipelines with lint/test/build/deploy stages, environment promotion, caching, and rollback. WHEN: 'CI/CD', 'GitHub Actions', 'pipeline', 'continuous integration', 'continuous deployment', 'automate deploys'. NOT WHEN: one-time manual deploys (see railway-deploy, netlify-deploy), Docker setup without pipeline context (see docker-setup)."
---

# CI/CD Pipeline

## Activation

| Context | Status |
|---------|--------|
| User says "CI/CD", "GitHub Actions", "pipeline", "automate deploys" | ACTIVE |
| User wants automated testing and deployment on push/merge | ACTIVE |
| One-time manual deploy to Railway/Netlify | DORMANT -- see railway-deploy, netlify-deploy |
| Docker setup without pipeline orchestration | DORMANT -- see docker-setup |

When active, output: `CI/CD Pipeline -- Designing your automated pipeline...`

## Instructions

### Step 1: Gather Requirements

Collect before proceeding. Block if tech stack or deploy target is unknown.

- **CI platform**: GitHub Actions (default for GitHub repos), GitLab CI (for GitLab repos), CircleCI (if team already uses it). Do not suggest switching platforms without reason.
- **Tech stack**: Language, framework, package manager, test runner.
- **Deploy target**: Railway, Netlify, GHCR/Docker registry, SSH to VPS, AWS.
- **Environments**: Solo/small = main->prod. Small team = main->staging(auto)->prod(manual). Larger team = feature->dev(auto)->staging(on merge)->prod(manual). Enterprise = add QA + canary gates.
- **Monorepo**: If yes, use path filters on workflow triggers and per-package caching.

GATE: All five inputs confirmed before Step 2.

### Step 2: Design Pipeline Stages

Fixed stage order: **lint -> test -> build -> deploy -> verify**. Never reorder. Each stage gates the next -- failure stops the pipeline.

- **Lint**: Linter + type checker for the stack. Runs first because it is fastest and catches the most trivial failures.
- **Test**: Unit + integration. Use service containers for databases. Upload coverage as artifact.
- **Build**: Compile/bundle. Upload build artifact for deploy stages. Skip rebuild in deploy jobs.
- **Deploy**: Staging auto-deploys on main. Prod requires manual approval via GitHub Environments (or equivalent).
- **Verify**: Smoke test the deployed URL. Health check with retry loop (5 attempts, 10s interval). Failure triggers alert, not auto-rollback.

GATE: Stage list and trigger branches confirmed before Step 3.

### Step 3: Caching Strategy

Cache by lockfile hash. Rules:

- **npm/pnpm/yarn**: Use `actions/setup-node` built-in cache. Key on `package-lock.json` / `pnpm-lock.yaml` / `yarn.lock`.
- **pip**: Use `actions/setup-python` built-in cache. Key on `requirements*.txt`.
- **Go**: Use `actions/setup-go` built-in cache. Key on `go.sum`.
- **Rust**: Use `Swatinem/rust-cache`. Key on `Cargo.lock`.
- **Docker layers**: Use `cache-from: type=gha` and `cache-to: type=gha,mode=max` with `docker/build-push-action`.

If cache miss rate exceeds ~30%, the key is wrong. Verify lockfile path and hash scope.

GATE: Cache config validated (correct lockfile path exists) before Step 4.

### Step 4: Secret Management

- Store all secrets in CI platform's secret store (Settings -> Secrets for GitHub, CI/CD Variables for GitLab). Never in workflow files.
- Use environment-scoped secrets for staging vs prod credentials.
- Prefer `GITHUB_TOKEN` (auto-generated, scoped) over PATs wherever possible.
- Pin third-party actions to commit SHA, not version tag. Supply chain attacks use tag hijacking.
- Rotate secrets on a schedule. Do not wait for compromise.

GATE: Secret list documented and confirmed with user before Step 5.

### Step 5: Deployment Strategy

Decision tree:

- **Solo/small project, low traffic**: Rolling deploy (default). Push new version, old dies. Acceptable downtime.
- **User-facing app, needs zero downtime**: Blue-green. Deploy to inactive slot, swap traffic. Requires two target environments or platform support (Railway, AWS).
- **High-traffic, risk-averse**: Canary. Route 5-10% traffic to new version, monitor error rates, promote or rollback. Requires load balancer with traffic splitting.

If the user does not express a preference, default to rolling for simplicity.

### Step 6: Environment Promotion and Branch Protection

- **Branch protection on main**: Require PR, require CI pass, require 1+ review (team projects). No direct push.
- **Promotion flow**: Feature branch -> PR -> main (triggers staging deploy) -> manual approval -> prod deploy.
- **Concurrency control**: Use `concurrency` groups keyed on workflow + ref. Cancel in-progress runs on new pushes to same branch.
- **Notification integration**: Post deploy status to Slack/Discord/Teams via webhook step at end of deploy job. Include: environment, version/SHA, deploy URL, status.

### Step 7: Rollback

- Tag every successful production deploy: `deploy-YYYYMMDD-HHMMSS`.
- Rollback = re-run the deploy job for the previous tag. Use `workflow_dispatch` with a `rollback_tag` input.
- Do NOT auto-rollback on smoke test failure. Alert the team and let humans decide. Auto-rollback causes cascading failures when the health endpoint itself is the problem.

### Step 8: Output

Deliver: workflow YAML file(s), secret configuration checklist, rollback procedure, smoke test config. Write files directly to `.github/workflows/` (or equivalent). Do not dump YAML into chat and ask the user to copy it.

## Examples

**1. Node.js SaaS, GitHub Actions, Railway deploy**
Lint (eslint + tsc) -> Test (vitest, Postgres service container) -> Build (vite) -> Deploy staging (Railway, auto on main) -> Deploy prod (Railway, manual approval). Cache: setup-node with npm. Secrets: RAILWAY_TOKEN (env-scoped). Rollback: Railway dashboard revert or redeploy previous tag.

**2. Python API, GitLab CI, Docker + SSH to VPS**
Lint (ruff + mypy) -> Test (pytest, coverage) -> Build (docker build, push to registry) -> Deploy staging (SSH, docker compose pull + up) -> Deploy prod (manual trigger). Cache: pip cache dir keyed on requirements.txt. Secrets: GitLab CI/CD Variables (SSH_KEY, REGISTRY_TOKEN, protected + masked). Rollback: pin docker-compose to previous image SHA.

## Common Issues

- **Slow pipelines**: 90% of the time it is missing cache or redundant `npm ci` across jobs. Use artifacts to pass build output between jobs instead of rebuilding.
- **Flaky tests blocking deploy**: Do not add `continue-on-error`. Fix the test or quarantine it in a separate non-blocking job. Flaky tests that gate deploys erode trust in the pipeline.
- **Secrets not available in PR from fork**: GitHub does not expose secrets to fork PRs (security). Use `pull_request_target` with extreme caution or skip deploy steps on fork PRs.

## Anti-Patterns

- Deploying on push to main without test gate.
- Using `@latest` or `@v4` for third-party actions instead of pinning to SHA.
- Hardcoding secrets in workflow files or echoing them in logs.
- No concurrency control -- parallel deploys to the same environment race.
- Skipping staging -- even solo projects benefit from a staging smoke test.
- Monolithic single-job workflows -- split into jobs so failures are isolated and cacheable stages can parallelize.

## Escalation

Hand off when:
- Multi-region deployment with traffic-weighted canary requires service mesh configuration.
- Compliance mandates audit trails or signed attestations on every pipeline execution.
- Self-hosted runners need network/security hardening beyond standard setup.
- Pipeline must orchestrate across multiple repositories with cross-repo triggers.

## Inputs

- Tech stack (language, framework, package manager, test runner)
- CI platform preference
- Deploy target(s) and environment count
- Monorepo structure (if applicable)

## Outputs

- Workflow YAML files written to repo
- Secret configuration checklist
- Rollback procedure
- Smoke test configuration

## Level History

- **Lv.1** -- Base: Multi-stack templates, environment strategy, caching, secrets, 4 deploy targets, rollback, smoke tests. (Origin: MemStack v3.3, Mar 2026)
- **Lv.2** -- Compressed: Decision-rule format, removed full YAML examples, added validation gates, deployment strategy decision tree, branch protection rules, notification integration, common issues. (Origin: MemStack v3.4, Mar 2026)
