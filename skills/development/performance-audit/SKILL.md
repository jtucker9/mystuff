---
name: performance-audit
description: "Use when the user says 'performance audit', 'why is it slow', 'optimize performance', 'page speed', 'Core Web Vitals', 'lighthouse', 'load time', or reports slow pages/APIs/queries. Do NOT use for code reviews (code-reviewer), security audits (api-audit), refactoring for maintainability (refactor-planner), or schema design (database-architect)."
---

# Performance Audit — Full-Stack Performance Diagnosis

## Activation

| Context | Status |
|---------|--------|
| "performance audit", "why is it slow", "optimize", "page speed", "Core Web Vitals", "lighthouse" | ACTIVE |
| Slow API responses, long page loads, jank, timeouts | ACTIVE |
| Performance monitoring or budget setup | ACTIVE |
| Code quality review (not speed) | DORMANT — code-reviewer |
| Security scanning | DORMANT — api-audit |
| Refactor for maintainability | DORMANT — refactor-planner |
| Database schema design | DORMANT — database-architect |

## Instructions

### Step 1: Gather Inputs

Collect before proceeding — do not assume defaults without asking: target (URL/local/both), scope (frontend/backend/full-stack), pain points (what feels slow), traffic profile, tech stack, budget constraints (infra changes allowed or code-only).

**Gate**: Must have target + scope + stack before Step 2.

#### CWV Thresholds (defaults if user has no targets)

| Metric | Good | Needs Work | Poor |
|--------|------|------------|------|
| LCP | < 2.5s | 2.5-4.0s | > 4.0s |
| INP | < 200ms | 200-500ms | > 500ms |
| CLS | < 0.1 | 0.1-0.25 | > 0.25 |
| TTFB | < 800ms | 800ms-1.8s | > 1.8s |
| FCP | < 1.8s | 1.8-3.0s | > 3.0s |
| TBT | < 200ms | 200-600ms | > 600ms |
| API p95 | < 200ms | 200-500ms | > 500ms |
| DB query | < 50ms | 50-200ms | > 200ms |

### Step 2: Measure Baseline

Run Lighthouse (minimum 3 runs for statistical reliability) and/or collect RUM data. Record LCP, INP, CLS, TTFB, FCP, TBT, Lighthouse score, API p95.

**Gate**: Baseline numbers recorded before analyzing. Never optimize without measuring first.

### Step 3: Frontend Analysis

Classify every finding by severity (see below). Focus on decision points, not mechanics.

#### Frontend Red Flags

- Any single JS chunk > 250KB gzipped — needs code splitting
- `node_modules` > 60% of bundle — review dependencies
- Duplicate packages in bundle — deduplicate
- Full library imports when one function is used — named imports
- `<script>` without `async`/`defer`/`type="module"` — render-blocking
- Images > 100KB without modern format (WebP/AVIF) — optimize
- Images without explicit `width`/`height` — CLS source
- LCP image without `fetchpriority="high"` — preload it
- Fonts not using `font-display: swap` — FOIT risk
- Lists > 100 items rendered without virtualization — virtualize

**Gate**: Bundle size checked and image audit complete before moving to backend.

### Step 4: Backend Analysis

#### N+1 Detection Signals

- ORM `findMany`/`findUnique` without `include`/`select` (Prisma)
- `.objects.` without `select_related`/`prefetch_related` (Django)
- `await` inside `for`/`forEach`/`.map` loops touching the DB
- `lazy=` without `'joined'`/`'subquery'` (SQLAlchemy)

#### Connection Pool Sizing

- Pool `max` should be ~(2 * CPU cores) + disk spindles for PostgreSQL
- Monitor: if `waitingCount > 0` frequently, pool is undersized
- `connectionTimeoutMillis` should fail fast (3-5s), not hang
- `statement_timeout` prevents runaway queries (10-30s typical)

#### Caching Decision Tree

```
Same data for all users?
  YES -> HTTP cache headers (Cache-Control, ETag)
    Static content (images, CSS, JS)? -> CDN + long max-age + immutable
    Dynamic content? -> stale-while-revalidate or short max-age
  NO -> Expensive to compute?
    YES -> Redis/Memcached with TTL
      Changes frequently? -> Short TTL (30s-5min) + invalidation on write
      Stable data? -> Long TTL (1h-24h) + explicit invalidation
    NO -> In-memory LRU or skip caching
```

**Gate**: Top 3 slowest queries identified and caching strategy decided before Step 5.

### Step 5: Monitoring Setup

#### RUM vs Synthetic

| Approach | Use For | Limitation |
|----------|---------|------------|
| RUM (web-vitals lib) | Real user experience, field data, geographic variance | Needs traffic to be meaningful |
| Synthetic (Lighthouse CI) | Regression detection in CI, reproducible baselines | Lab conditions != real users |
| Use both | RUM for truth, synthetic for gating PRs | — |

#### Performance Budgets in CI

Define in `lighthouse-budget.json` or bundler config: LCP 2500ms, TBT 200ms, CLS 0.1, JS total 300KB gz, images 500KB, third-party requests 10. Block PRs that exceed budgets. Alert (not block) at 80% of budget.

#### Alerting Thresholds

| Metric | Warning | Critical |
|--------|---------|----------|
| LCP p75 | > 2.5s | > 4.0s |
| INP p75 | > 200ms | > 500ms |
| CLS p75 | > 0.1 | > 0.25 |
| TTFB p95 | > 800ms | > 1.8s |
| API p95 | > 500ms | > 2s |
| Error rate | > 1% | > 5% |
| JS bundle | > 300KB gz | > 500KB gz |

### Step 6: Output Scorecard

Compile findings into: baseline table, severity-classified findings with file:line references, prioritized fix list (ordered by impact-to-effort ratio), projected improvement after fixes, monitoring setup plan.

For each Critical/High finding: location, metric impact, evidence, suggested fix direction, estimated improvement.

**Gate**: Every finding has a severity, estimated impact, and effort level.

#### Severity Classification

| Level | Label | Criteria | Typical Improvement |
|-------|-------|----------|---------------------|
| P0 | Critical | Blocks interaction, timeouts, >5s LCP, memory crash | 2-10x |
| P1 | High | Noticeable lag, >2.5s LCP, >200ms INP, CLS >0.25 | 30-70% |
| P2 | Medium | Suboptimal but functional, missed budget, unnecessary work | 10-30% |
| P3 | Low | Minor optimization, polish-level | 5-15% |
| P4 | Info | Already optimized, monitoring suggestion | Preventive |

## Examples

**Example 1: E-commerce slow page load**
User reports 6s load on product pages. Baseline: LCP 5.8s, TBT 900ms. Root cause: 1.4MB unoptimized hero image + 800KB unsplit JS bundle + N+1 on product reviews. Fix order: image (30min, -2s LCP), code split (4h, -1.5s LCP), eager-load reviews (1h, -400ms TTFB).

**Example 2: SaaS dashboard API timeout**
Dashboard API returns 504 after 30s. Baseline: p95 12s. Root cause: unindexed `WHERE created_at > X` on 2M-row analytics table + no connection pooling (opening new connection per request). Fix: composite index on (tenant_id, created_at) + pool with max=20. Projected: p95 from 12s to 180ms.

## Common Issues

| Issue | Fix |
|-------|-----|
| Lighthouse scores vary wildly between runs | Run minimum 3x, use median; prefer field data (CrUX/RUM) over lab |
| Bundle analyzer shows no obvious waste but bundle is still large | Check for CSS-in-JS runtime, polyfills, or source maps shipped to production |
| Redis cache added but no improvement | Verify cache hit rate; likely the slow path is uncached (user-specific data, cache key mismatch) |

## Anti-Patterns

| Anti-Pattern | Correct Approach |
|-------------|------------------|
| Optimizing without measuring | Profile first — baseline, fix top bottleneck, re-measure |
| Caching everything | Cache selectively by read/write ratio and data sensitivity |
| Adding indexes to every column | Index only WHERE/JOIN/ORDER BY columns with high selectivity |
| Splitting every component | Route-level first; only split components >50KB and conditionally rendered |
| Lazy-loading above-fold content | Only lazy-load below-fold; preload above-fold assets |
| Disabling SSR to "fix" performance | Fix the SSR bottleneck (slow data fetch), don't remove SSR |
| Over-memoizing (useMemo/useCallback on trivial ops) | Only memoize >1ms computations or callbacks to memoized children |
| Cache-Control: no-store everywhere | Use appropriate TTLs; `immutable` for hashed assets |
| Optimizing Lighthouse score instead of user experience | Field metrics (CrUX, RUM) over lab scores; Lighthouse is a guide |
| Horizontal scaling before vertical optimization | Optimize code first; scale infra only after code is efficient |

## Escalation

- **Infra scaling** (auto-scaling, replicas, multi-region) -> DevOps
- **DB internals** (query planner, partitioning, vacuum) -> DBA
- **CDN/edge** (complex invalidation, edge compute) -> Platform engineer
- **Rendering pipeline** (compositing, GPU, paint) -> Frontend perf specialist
- **Third-party scripts** dominating TBT/INP -> Product/marketing negotiation
- **Memory profiling** (heap snapshots, detached DOM) -> Chrome DevTools Memory panel

## Inputs

Target URL or project path, scope (frontend/backend/full-stack), pain points, tech stack, traffic profile, current metrics + targets, budget constraints (infra changes allowed?).

## Outputs

Performance baseline with evidence, severity-classified findings (file:line refs), detailed write-ups for Critical/High findings, prioritized fix list (impact/effort), projected improvement, performance budget config, monitoring recommendations (RUM + synthetic + alerting).

## Level History

- **Lv.1** — Base: 7-step audit covering CWV (LCP/INP/CLS/TTFB/FCP/TBT), frontend (bundle, images, fonts, render-blocking, framework-specific), backend (queries, N+1, connection pooling, caching, API profiling), network (HTTP/2, compression, CDN, resource hints, service workers), monitoring (RUM, synthetic, budgets, alerting), scorecard output. Anti-patterns, escalation, severity classification. (Origin: MemStack v3.3, Mar 2026)
- **Lv.2** — Compressed: Removed implementation code (Lighthouse CLI, webpack configs, React patterns, Express middleware, SQL queries, YAML workflows). Retained decision rules, thresholds, red flags, detection signals, caching decision tree, monitoring strategy. Added validation gates between steps. (Origin: MemStack v3.4, Mar 2026)
