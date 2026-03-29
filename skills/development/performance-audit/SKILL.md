---
name: performance-audit
description: "Use when the user says 'performance audit', 'why is it slow', 'optimize performance', 'page speed', 'Core Web Vitals', 'lighthouse', 'load time', or needs to diagnose and fix frontend or backend performance issues. Do NOT use for code reviews (see code-reviewer) or security audits (see api-audit)."
---

# ⚡ Performance Audit — Full-Stack Performance Diagnosis
*Diagnose and fix frontend, backend, and network performance bottlenecks with measured baselines, root-cause analysis, and a prioritized fix list with estimated impact.*

## Activation

When this skill activates, output:

`⚡ Performance Audit — Profiling your application...`

| Context | Status |
|---------|--------|
| **User says "performance audit", "why is it slow", "optimize performance"** | ACTIVE |
| **User says "page speed", "Core Web Vitals", "lighthouse", "load time"** | ACTIVE |
| **User reports slow API responses, long page loads, jank, or timeouts** | ACTIVE |
| **User wants to set up performance monitoring or budgets** | ACTIVE |
| **User wants a general code quality review** | DORMANT — see code-reviewer |
| **User wants security vulnerability scanning** | DORMANT — see api-audit |
| **User wants to refactor for maintainability, not speed** | DORMANT — see refactor-planner |
| **User wants database schema design, not query optimization** | DORMANT — see database-architect |

## Severity Classification

Every finding is assigned an impact level:

| Level | Label | Criteria | Typical Improvement |
|-------|-------|----------|---------------------|
| 🔴 | **Critical** | Blocks user interaction, causes timeouts, >5s LCP, memory crash | 2-10x improvement |
| 🟠 | **High** | Noticeable lag, >2.5s LCP, >200ms INP, layout shift >0.25 | 30-70% improvement |
| 🟡 | **Medium** | Suboptimal but functional, missed performance budget, unnecessary work | 10-30% improvement |
| 🟢 | **Low** | Minor optimization opportunity, polish-level improvement | 5-15% improvement |
| 🔵 | **Info** | Already optimized, best practice confirmation, or monitoring suggestion | Preventive |

## Protocol

### Step 1: Gather Inputs

Ask the user for any of the following that are unclear:

- **Target**: URL (production site), local development project, or both?
- **Scope**: Frontend only, backend only, or full-stack?
- **Pain points**: What feels slow? Page load, navigation, API calls, database queries, build times?
- **Traffic profile**: Approximate concurrent users, geographic distribution, peak hours?
- **Current metrics** (if known): Lighthouse score, LCP, FID/INP, CLS, TTFB, API p95 latency?
- **Target metrics**: What does "fast enough" mean for this project?
- **Tech stack**: Framework (Next.js, React, Vue, Express, FastAPI, etc.), hosting (Vercel, AWS, Railway), database (PostgreSQL, MongoDB, etc.)?
- **Budget constraints**: Can you add infrastructure (CDN, Redis, edge workers) or are fixes code-only?

**Recommended targets** (use as defaults if user has no specific goals):

| Metric | Good | Needs Work | Poor |
|--------|------|------------|------|
| **LCP** (Largest Contentful Paint) | < 2.5s | 2.5-4.0s | > 4.0s |
| **INP** (Interaction to Next Paint) | < 200ms | 200-500ms | > 500ms |
| **CLS** (Cumulative Layout Shift) | < 0.1 | 0.1-0.25 | > 0.25 |
| **TTFB** (Time to First Byte) | < 800ms | 800ms-1.8s | > 1.8s |
| **FCP** (First Contentful Paint) | < 1.8s | 1.8-3.0s | > 3.0s |
| **Speed Index** | < 3.4s | 3.4-5.8s | > 5.8s |
| **Total Blocking Time** | < 200ms | 200-600ms | > 600ms |
| **API p95 latency** | < 200ms | 200-500ms | > 500ms |
| **Database query time** | < 50ms | 50-200ms | > 200ms |

### Step 2: Core Web Vitals Assessment

Core Web Vitals are Google's user-centric performance metrics. They directly affect search ranking and user experience.

#### 2a: Measure with Lighthouse CLI

```bash
# Install Lighthouse globally if not present
npm list -g lighthouse || npm install -g lighthouse

# Full Lighthouse audit — generates HTML report
lighthouse https://example.com \
  --output=json --output=html \
  --output-path=./lighthouse-report \
  --chrome-flags="--headless --no-sandbox" \
  --only-categories=performance

# Extract key metrics from JSON report
cat lighthouse-report.json | jq '{
  performance_score: .categories.performance.score,
  LCP: .audits["largest-contentful-paint"].displayValue,
  FCP: .audits["first-contentful-paint"].displayValue,
  TBT: .audits["total-blocking-time"].displayValue,
  CLS: .audits["cumulative-layout-shift"].displayValue,
  SI:  .audits["speed-index"].displayValue,
  TTFB: .audits["server-response-time"].displayValue
}'

# Multiple runs for statistical reliability (performance varies per run)
for i in 1 2 3 4 5; do
  lighthouse https://example.com \
    --output=json --output-path=./run-$i.json \
    --chrome-flags="--headless --no-sandbox" \
    --only-categories=performance --quiet
  echo "Run $i: $(cat run-$i.json | jq '.categories.performance.score')"
done
```

#### 2b: Measure with Web-Vitals Library (Real User Monitoring)

Add this to the application's entry point to collect field data from real users:

```javascript
// npm install web-vitals
import { onLCP, onINP, onCLS, onFCP, onTTFB } from 'web-vitals';

function sendToAnalytics(metric) {
  const body = JSON.stringify({
    name: metric.name,
    value: metric.value,
    rating: metric.rating,    // 'good', 'needs-improvement', 'poor'
    delta: metric.delta,
    id: metric.id,
    navigationType: metric.navigationType,
    url: window.location.href,
    timestamp: Date.now(),
  });

  // Use sendBeacon for reliability (fires even on page unload)
  if (navigator.sendBeacon) {
    navigator.sendBeacon('/api/analytics/vitals', body);
  } else {
    fetch('/api/analytics/vitals', { body, method: 'POST', keepalive: true });
  }
}

onLCP(sendToAnalytics);
onINP(sendToAnalytics);
onCLS(sendToAnalytics);
onFCP(sendToAnalytics);
onTTFB(sendToAnalytics);
```

#### 2c: What Each Metric Means and How to Fix It

| Metric | Measures | Common Causes of Poor Score | Quick Wins |
|--------|----------|----------------------------|------------|
| **LCP** | Time until the largest visible element renders | Slow server, render-blocking resources, unoptimized images, client-side rendering | Preload hero image, use `fetchpriority="high"`, server-side render above-fold |
| **INP** | Worst-case input responsiveness throughout the page lifecycle | Long JavaScript tasks, heavy event handlers, excessive re-renders | Break up long tasks with `scheduler.yield()`, debounce handlers, reduce DOM size |
| **CLS** | Visual stability (unexpected layout shifts) | Images without dimensions, dynamic content injection, web fonts causing FOIT/FOUT | Set explicit `width`/`height` on images/video, use `font-display: swap`, reserve space for dynamic content |
| **TTFB** | Server response time | Slow database queries, no caching, distant server, cold starts | Add cache headers, use CDN, optimize queries, keep-alive connections |
| **FCP** | Time until first content appears | Render-blocking CSS/JS, large HTML document, slow server | Inline critical CSS, defer non-critical JS, compress HTML |
| **TBT** | Total time the main thread was blocked (>50ms tasks) | Large JS bundles, expensive computation, third-party scripts | Code-split, lazy-load, move computation to Web Worker |

### Step 3: Frontend Performance

#### 3a: Bundle Analysis

Identify oversized bundles and tree-shaking failures:

```bash
# Webpack — generate bundle stats
npx webpack --profile --json > stats.json
npx webpack-bundle-analyzer stats.json

# Next.js — built-in bundle analyzer
# Add to next.config.js:
# const withBundleAnalyzer = require('@next/bundle-analyzer')({ enabled: process.env.ANALYZE === 'true' })
ANALYZE=true npm run build

# Vite — visualize bundle
npx vite-bundle-visualizer

# Source map explorer (works with any bundler that outputs source maps)
npx source-map-explorer dist/assets/*.js --html result.html

# Quick size check of build output
du -sh dist/ build/ .next/ 2>/dev/null
find dist/ -name "*.js" -exec ls -lh {} \; | sort -k5 -h | tail -20
```

**Red flags in bundle analysis:**
- Any single chunk > 250KB (gzipped) — needs code splitting
- `node_modules` comprising > 60% of bundle — review dependencies
- Duplicate packages (e.g., two versions of `lodash`) — deduplicate
- Full library imports when only one function is used — switch to named imports

#### 3b: Code Splitting Patterns

```javascript
// BEFORE: Everything loaded upfront
import { HeavyChart } from './components/HeavyChart';
import { AdminPanel } from './components/AdminPanel';
import { PdfExporter } from './components/PdfExporter';

// AFTER: Load on demand
const HeavyChart = React.lazy(() => import('./components/HeavyChart'));
const AdminPanel = React.lazy(() => import('./components/AdminPanel'));
const PdfExporter = React.lazy(() => import('./components/PdfExporter'));

// Route-level splitting (React Router)
const routes = [
  { path: '/dashboard', lazy: () => import('./pages/Dashboard') },
  { path: '/admin',     lazy: () => import('./pages/Admin') },
  { path: '/reports',   lazy: () => import('./pages/Reports') },
];

// Next.js dynamic import with loading state
import dynamic from 'next/dynamic';
const Chart = dynamic(() => import('../components/Chart'), {
  loading: () => <ChartSkeleton />,
  ssr: false,  // Skip server-side render for client-only components
});
```

#### 3c: Image Optimization

```bash
# Find unoptimized images
find public/ src/ -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" | while read f; do
  SIZE=$(stat -f%z "$f" 2>/dev/null || stat -c%s "$f" 2>/dev/null)
  if [ "$SIZE" -gt 100000 ]; then
    echo "LARGE: $f ($(( SIZE / 1024 ))KB)"
  fi
done

# Check for images without width/height in HTML/JSX (causes CLS)
grep -rn '<img' --include="*.tsx" --include="*.jsx" --include="*.html" src/ | grep -v 'width\|height\|fill\|next/image\|Image'
```

**Image optimization checklist:**
- [ ] Use modern formats: WebP (30% smaller than JPEG) or AVIF (50% smaller)
- [ ] Serve responsive images with `srcset` and `sizes` attributes
- [ ] Lazy-load below-fold images: `loading="lazy"` or Intersection Observer
- [ ] Set explicit `width` and `height` attributes to prevent CLS
- [ ] Use `fetchpriority="high"` on the LCP image
- [ ] Compress at build time with sharp, imagemin, or squoosh
- [ ] Serve via CDN with auto-format negotiation (`Accept: image/avif,image/webp`)
- [ ] Use `<picture>` element for art direction across breakpoints

```html
<!-- Optimized image element -->
<picture>
  <source srcset="/hero.avif" type="image/avif">
  <source srcset="/hero.webp" type="image/webp">
  <img
    src="/hero.jpg"
    alt="Hero banner"
    width="1200" height="600"
    loading="eager"
    fetchpriority="high"
    decoding="async"
  >
</picture>
```

#### 3d: Font Loading Strategy

```css
/* Prevent FOIT (Flash of Invisible Text) */
@font-face {
  font-family: 'CustomFont';
  src: url('/fonts/custom.woff2') format('woff2');
  font-display: swap;           /* Show fallback immediately, swap when loaded */
  unicode-range: U+0000-00FF;   /* Only load Latin characters if that's all you need */
}
```

```html
<!-- Preload critical fonts (above-fold only) -->
<link rel="preload" href="/fonts/custom.woff2" as="font" type="font/woff2" crossorigin>

<!-- Reduce font file count: use variable fonts -->
<link rel="preload" href="/fonts/inter-variable.woff2" as="font" type="font/woff2" crossorigin>
```

**Font checklist:**
- [ ] Use `font-display: swap` (or `optional` for non-critical fonts)
- [ ] Preload only 1-2 critical font files (above-fold)
- [ ] Use WOFF2 format (best compression)
- [ ] Subset fonts to include only needed characters
- [ ] Self-host instead of Google Fonts (eliminates extra DNS + connection)
- [ ] Use `size-adjust` in `@font-face` to reduce CLS from font swap

#### 3e: Render-Blocking Resources

```bash
# Find render-blocking scripts (no async/defer)
grep -rn '<script' --include="*.html" --include="*.ejs" --include="*.hbs" src/ public/ | grep -v 'async\|defer\|type="module"'

# Find large CSS files loaded in <head> (blocks first paint)
find public/ src/ -name "*.css" -exec ls -lh {} \; | sort -k5 -h | tail -10

# Check for unused CSS
npx purgecss --css dist/assets/*.css --content dist/**/*.html dist/**/*.js --output purged/
# Compare sizes
du -sh dist/assets/*.css purged/*.css
```

**Fixes for render-blocking resources:**
- Inline critical CSS (above-fold styles) directly in `<head>`
- Load remaining CSS with `<link rel="preload" as="style" onload="this.rel='stylesheet'">`
- Add `async` or `defer` to all `<script>` tags (or use `type="module"` which defers by default)
- Move third-party scripts (analytics, chat widgets) to `defer` or load after `DOMContentLoaded`

#### 3f: React-Specific Optimizations

```bash
# Detect missing memoization on expensive components
grep -rn 'export default function\|export function\|export const' --include="*.tsx" src/components/ | grep -v 'memo\|React.memo'

# Detect inline object creation in JSX props (breaks React.memo / shallow compare)
grep -rn 'style=\{\{\|className=\{`' --include="*.tsx" --include="*.jsx" src/

# Detect large lists without virtualization
grep -rn '\.map(' --include="*.tsx" --include="*.jsx" src/ | head -30
```

**React performance patterns:**

```typescript
// PROBLEM: Component re-renders on every parent render
function ExpensiveList({ items, onSelect }) {
  return items.map(item => (
    <ExpensiveItem key={item.id} item={item} onSelect={() => onSelect(item.id)} />
  ));
}

// FIX 1: Memoize the child component
const ExpensiveItem = React.memo(({ item, onSelect }) => {
  // Only re-renders when item or onSelect changes (shallow compare)
  return <div onClick={onSelect}>{item.name}</div>;
});

// FIX 2: Stabilize callback references
function ExpensiveList({ items, onSelect }) {
  const handleSelect = useCallback((id) => onSelect(id), [onSelect]);
  return items.map(item => (
    <ExpensiveItem key={item.id} item={item} onSelect={handleSelect} />
  ));
}

// FIX 3: Memoize expensive computations
function Dashboard({ transactions }) {
  const summary = useMemo(() => {
    // Expensive: iterates thousands of transactions
    return transactions.reduce((acc, t) => ({
      total: acc.total + t.amount,
      count: acc.count + 1,
      avg: (acc.total + t.amount) / (acc.count + 1),
    }), { total: 0, count: 0, avg: 0 });
  }, [transactions]);

  return <SummaryCard data={summary} />;
}

// FIX 4: Virtualize long lists (only render visible items)
import { useVirtualizer } from '@tanstack/react-virtual';

function VirtualList({ items }) {
  const parentRef = useRef(null);
  const virtualizer = useVirtualizer({
    count: items.length,
    getScrollElement: () => parentRef.current,
    estimateSize: () => 50,    // Estimated row height in px
    overscan: 5,               // Render 5 extra items above/below viewport
  });

  return (
    <div ref={parentRef} style={{ height: '600px', overflow: 'auto' }}>
      <div style={{ height: `${virtualizer.getTotalSize()}px`, position: 'relative' }}>
        {virtualizer.getVirtualItems().map(virtualRow => (
          <div
            key={virtualRow.key}
            style={{
              position: 'absolute',
              top: 0,
              left: 0,
              width: '100%',
              height: `${virtualRow.size}px`,
              transform: `translateY(${virtualRow.start}px)`,
            }}
          >
            <ItemRow item={items[virtualRow.index]} />
          </div>
        ))}
      </div>
    </div>
  );
}
```

### Step 4: Backend Performance

#### 4a: Database Query Analysis

```sql
-- PostgreSQL: Identify slow queries (requires pg_stat_statements extension)
SELECT
  calls,
  round(total_exec_time::numeric, 2) AS total_ms,
  round(mean_exec_time::numeric, 2) AS avg_ms,
  round((100 * total_exec_time / sum(total_exec_time) OVER ())::numeric, 2) AS pct,
  substr(query, 1, 100) AS query_preview
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 20;

-- Analyze a specific slow query
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT u.*, COUNT(o.id) AS order_count
FROM users u
LEFT JOIN orders o ON o.user_id = u.id
WHERE u.created_at > '2025-01-01'
GROUP BY u.id
ORDER BY order_count DESC
LIMIT 50;
```

**What to look for in EXPLAIN ANALYZE output:**

| Pattern | Problem | Fix |
|---------|---------|-----|
| `Seq Scan` on large tables (>10K rows) | Missing index | Add index on WHERE/JOIN/ORDER BY columns |
| `Nested Loop` with high row counts | N+1 or missing join index | Add composite index, restructure query |
| `Sort` with `external merge Disk` | Sorting exceeds work_mem | Increase `work_mem` or add index matching ORDER BY |
| `Hash Join` with large `Buckets` | Large intermediate result | Add WHERE filters to reduce join input |
| `Rows Removed by Filter: 999000` (of 1000000) | Index not selective enough | Add more specific index or composite index |
| Actual rows >> Planned rows | Stale statistics | Run `ANALYZE tablename` |

```bash
# MySQL: Slow query log analysis
mysqldumpslow -s t /var/log/mysql/mysql-slow.log | head -30

# MongoDB: Profiler for slow operations
mongosh --eval "db.setProfilingLevel(1, { slowms: 100 })"
mongosh --eval "db.system.profile.find().sort({ts:-1}).limit(10).pretty()"
```

#### 4b: N+1 Query Detection

N+1 queries are the single most common backend performance killer in ORM-based applications.

```bash
# Find ORM queries inside loops
grep -rn -A5 'for.*await\|forEach.*await\|\.map.*async' --include="*.ts" --include="*.js" src/

# Prisma: findMany/findUnique without include
grep -rn 'findMany\|findUnique\|findFirst' --include="*.ts" src/ | grep -v 'include\|select'

# Django: QuerySet access inside loops
grep -rn '\.objects\.' --include="*.py" src/ | grep -v 'select_related\|prefetch_related'

# SQLAlchemy: relationship access without eager loading
grep -rn 'lazy=' --include="*.py" src/ | grep -v "lazy='joined'\|lazy='subquery'"
```

**N+1 fix patterns by ORM:**

```typescript
// Prisma — BEFORE (N+1)
const posts = await prisma.post.findMany();
for (const post of posts) {
  const author = await prisma.user.findUnique({ where: { id: post.authorId } });
}

// Prisma — AFTER (1 query with JOIN)
const posts = await prisma.post.findMany({
  include: { author: true },
});
```

```python
# Django — BEFORE (N+1)
for order in Order.objects.all():
    print(order.customer.name)     # Hits DB for each order

# Django — AFTER (2 queries total)
for order in Order.objects.select_related('customer').all():
    print(order.customer.name)     # Already loaded
```

#### 4c: Connection Pooling

```bash
# Check PostgreSQL active connections
psql -c "SELECT count(*) AS total, state FROM pg_stat_activity GROUP BY state;"

# Check if max_connections is being approached
psql -c "SHOW max_connections; SELECT count(*) FROM pg_stat_activity;"
```

**Connection pool configuration (Node.js with pg):**

```javascript
import { Pool } from 'pg';

const pool = new Pool({
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  max: 20,                    // Max concurrent connections
  idleTimeoutMillis: 30000,   // Close idle connections after 30s
  connectionTimeoutMillis: 5000, // Fail fast if pool is exhausted
  statement_timeout: 10000,   // Kill queries running > 10s
});

// Monitor pool health
pool.on('error', (err) => console.error('Pool error:', err));
setInterval(() => {
  console.log({
    total: pool.totalCount,
    idle: pool.idleCount,
    waiting: pool.waitingCount,
  });
}, 60000);
```

#### 4d: Caching Strategies

**Decision tree for choosing a cache layer:**

```
Is the data the same for all users?
├── YES → HTTP cache headers (Cache-Control, ETag)
│   └── Is it static content (images, CSS, JS)?
│       ├── YES → CDN with long max-age + immutable
│       └── NO → stale-while-revalidate or short max-age
├── NO → Is the data expensive to compute?
│   ├── YES → Redis / Memcached with TTL
│   │   └── Does it change frequently?
│   │       ├── YES → Short TTL (30s-5min) + cache invalidation on write
│   │       └── NO → Long TTL (1h-24h) + explicit invalidation
│   └── NO → In-memory cache (Map/LRU) or skip caching
```

**Redis caching pattern:**

```typescript
import Redis from 'ioredis';
const redis = new Redis(process.env.REDIS_URL);

async function getCachedOrFetch<T>(
  key: string,
  ttlSeconds: number,
  fetchFn: () => Promise<T>
): Promise<T> {
  // Try cache first
  const cached = await redis.get(key);
  if (cached) return JSON.parse(cached);

  // Cache miss — fetch from source
  const data = await fetchFn();
  await redis.setex(key, ttlSeconds, JSON.stringify(data));
  return data;
}

// Usage
app.get('/api/products', async (req, res) => {
  const products = await getCachedOrFetch(
    'products:all',
    300,  // 5 minutes
    () => prisma.product.findMany({ where: { active: true } })
  );
  res.json(products);
});

// Invalidate on write
app.post('/api/products', async (req, res) => {
  const product = await prisma.product.create({ data: req.validated });
  await redis.del('products:all');  // Bust cache
  res.status(201).json(product);
});
```

**HTTP Cache Headers:**

```javascript
// Express middleware for cache control
function cacheControl(maxAge, options = {}) {
  return (req, res, next) => {
    if (options.private) {
      res.set('Cache-Control', `private, max-age=${maxAge}`);
    } else if (options.immutable) {
      res.set('Cache-Control', `public, max-age=${maxAge}, immutable`);
    } else {
      res.set('Cache-Control', `public, max-age=${maxAge}, stale-while-revalidate=${maxAge * 2}`);
    }
    next();
  };
}

// Static assets with content hash in filename — cache forever
app.use('/assets', cacheControl(31536000, { immutable: true }), express.static('dist/assets'));

// API responses — short cache with background revalidation
app.get('/api/products', cacheControl(60), handler);

// User-specific data — private cache only
app.get('/api/me', cacheControl(0, { private: true }), handler);
```

#### 4e: API Response Time Profiling

```bash
# Measure endpoint response times
for endpoint in "/api/users" "/api/products" "/api/orders" "/api/dashboard"; do
  TIME=$(curl -s -o /dev/null -w "%{time_total}" \
    -H "Authorization: Bearer $TOKEN" \
    "https://api.example.com$endpoint")
  echo "$endpoint: ${TIME}s"
done

# Detailed timing breakdown
curl -s -o /dev/null -w "\
  DNS:        %{time_namelookup}s\n\
  Connect:    %{time_connect}s\n\
  TLS:        %{time_appconnect}s\n\
  TTFB:       %{time_starttransfer}s\n\
  Total:      %{time_total}s\n\
  Size:       %{size_download} bytes\n" \
  -H "Authorization: Bearer $TOKEN" \
  "https://api.example.com/api/dashboard"
```

**Server-side request timing middleware (Express):**

```javascript
// Log slow requests with timing breakdown
app.use((req, res, next) => {
  const start = process.hrtime.bigint();
  const timings = {};

  // Monkey-patch res.json to capture total time
  const originalJson = res.json.bind(res);
  res.json = (body) => {
    const duration = Number(process.hrtime.bigint() - start) / 1e6; // ms
    res.set('Server-Timing', `total;dur=${duration.toFixed(1)}`);

    if (duration > 500) {
      console.warn(`SLOW REQUEST: ${req.method} ${req.path} — ${duration.toFixed(0)}ms`, {
        query: req.query,
        timings,
      });
    }
    return originalJson(body);
  };

  // Expose timing helper for route handlers
  req.time = (label) => {
    const now = Number(process.hrtime.bigint() - start) / 1e6;
    timings[label] = now;
    return now;
  };

  next();
});
```

### Step 5: Network Performance

#### 5a: HTTP/2 and Protocol Optimization

```bash
# Check if server supports HTTP/2
curl -sI --http2 https://example.com | head -1
# Should show: HTTP/2 200

# Check if server supports HTTP/3 (QUIC)
curl -sI --http3 https://example.com 2>/dev/null | head -1

# Verify HTTPS (required for HTTP/2)
curl -sI https://example.com | grep -i "strict-transport-security"
```

#### 5b: Compression

```bash
# Check if gzip/brotli is enabled
curl -sI -H "Accept-Encoding: gzip, deflate, br" https://example.com | grep -i "content-encoding"
# Should show: content-encoding: br (or gzip)

# Compare compressed vs uncompressed response size
UNCOMPRESSED=$(curl -s https://example.com | wc -c)
COMPRESSED=$(curl -s -H "Accept-Encoding: gzip" --compressed https://example.com | wc -c)
echo "Uncompressed: $UNCOMPRESSED bytes, Compressed: $COMPRESSED bytes"
echo "Ratio: $(echo "scale=1; $COMPRESSED * 100 / $UNCOMPRESSED" | bc)%"
```

**Enable Brotli compression (Express):**

```javascript
import compression from 'compression';
import shrinkRay from 'shrink-ray-current'; // Brotli support

// shrink-ray supports Brotli + gzip with smart content-type detection
app.use(shrinkRay({
  brotli: { quality: 4 },  // 4 is a good speed/compression trade-off
}));

// Or basic gzip with the compression package
app.use(compression({
  threshold: 1024,          // Don't compress responses < 1KB
  filter: (req, res) => {
    if (req.headers['x-no-compression']) return false;
    return compression.filter(req, res);
  },
}));
```

#### 5c: CDN Configuration

**CDN checklist:**

- [ ] Static assets (JS, CSS, images, fonts) served from CDN edge
- [ ] Cache-Control headers set correctly for CDN caching
- [ ] Cache key includes only necessary query parameters (avoid cache fragmentation)
- [ ] Stale-while-revalidate configured for non-critical resources
- [ ] CDN purge/invalidation mechanism documented and tested
- [ ] Geographic coverage matches user base
- [ ] Origin shield enabled to reduce origin load

#### 5d: Resource Hints

```html
<!-- Preconnect: Establish early connections to critical third-party origins -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://cdn.example.com" crossorigin>
<link rel="preconnect" href="https://api.example.com">

<!-- Preload: Force early download of critical resources discovered late -->
<link rel="preload" href="/fonts/inter-variable.woff2" as="font" type="font/woff2" crossorigin>
<link rel="preload" href="/hero-image.webp" as="image" fetchpriority="high">
<link rel="preload" href="/critical.css" as="style">

<!-- Prefetch: Download resources for the NEXT navigation (low priority) -->
<link rel="prefetch" href="/dashboard.js">
<link rel="prefetch" href="/api/user/profile">

<!-- DNS Prefetch: Resolve DNS for origins you'll need soon -->
<link rel="dns-prefetch" href="https://analytics.example.com">
```

**When to use each hint:**

| Hint | Priority | Use Case |
|------|----------|----------|
| `preconnect` | High | Third-party origins used on this page (fonts, APIs, CDNs) |
| `preload` | High | Critical resources the browser discovers late (fonts in CSS, above-fold images) |
| `prefetch` | Low | Resources needed for the next likely navigation |
| `dns-prefetch` | Low | Origins you might need (broader than preconnect, cheaper) |
| `modulepreload` | High | ES modules needed for initial render |

#### 5e: Service Worker Caching Strategies

```javascript
// Workbox — production-grade service worker caching
import { registerRoute } from 'workbox-routing';
import { CacheFirst, StaleWhileRevalidate, NetworkFirst } from 'workbox-strategies';
import { ExpirationPlugin } from 'workbox-expiration';
import { CacheableResponsePlugin } from 'workbox-cacheable-response';

// Static assets — cache first (immutable with content hash)
registerRoute(
  ({ request }) => ['style', 'script', 'worker'].includes(request.destination),
  new CacheFirst({
    cacheName: 'static-assets',
    plugins: [
      new CacheableResponsePlugin({ statuses: [0, 200] }),
      new ExpirationPlugin({ maxEntries: 60, maxAgeSeconds: 30 * 24 * 60 * 60 }),
    ],
  })
);

// Images — cache first with size limit
registerRoute(
  ({ request }) => request.destination === 'image',
  new CacheFirst({
    cacheName: 'images',
    plugins: [
      new CacheableResponsePlugin({ statuses: [0, 200] }),
      new ExpirationPlugin({ maxEntries: 100, maxAgeSeconds: 7 * 24 * 60 * 60 }),
    ],
  })
);

// API calls — network first with cache fallback (for offline support)
registerRoute(
  ({ url }) => url.pathname.startsWith('/api/'),
  new NetworkFirst({
    cacheName: 'api-cache',
    plugins: [
      new ExpirationPlugin({ maxEntries: 50, maxAgeSeconds: 5 * 60 }),
    ],
    networkTimeoutSeconds: 3,  // Fall back to cache if network is slow
  })
);

// HTML pages — stale while revalidate (fast load + background update)
registerRoute(
  ({ request }) => request.mode === 'navigate',
  new StaleWhileRevalidate({
    cacheName: 'pages',
    plugins: [
      new CacheableResponsePlugin({ statuses: [0, 200] }),
    ],
  })
);
```

### Step 6: Monitoring Setup

#### 6a: Real User Monitoring (RUM) Dashboard

Build a lightweight RUM endpoint to collect web-vitals data from Step 2b:

```javascript
// Server endpoint to receive vitals
app.post('/api/analytics/vitals', express.json(), (req, res) => {
  const { name, value, rating, url, navigationType } = req.body;

  // Store in your analytics database (ClickHouse, TimescaleDB, BigQuery, etc.)
  analyticsQueue.push({
    metric: name,
    value: Math.round(value),
    rating,
    url,
    navigationType,
    userAgent: req.headers['user-agent'],
    timestamp: new Date(),
  });

  res.status(204).end();
});

// Aggregate for dashboards: p50, p75, p95 per metric per day
// SELECT
//   metric,
//   date_trunc('day', timestamp) AS day,
//   percentile_cont(0.50) WITHIN GROUP (ORDER BY value) AS p50,
//   percentile_cont(0.75) WITHIN GROUP (ORDER BY value) AS p75,
//   percentile_cont(0.95) WITHIN GROUP (ORDER BY value) AS p95
// FROM web_vitals
// WHERE timestamp > NOW() - INTERVAL '30 days'
// GROUP BY metric, day
// ORDER BY day DESC;
```

#### 6b: Synthetic Monitoring

Run Lighthouse on a schedule in CI to catch regressions before users do:

```yaml
# .github/workflows/lighthouse.yml
name: Lighthouse CI
on:
  pull_request:
    branches: [main]

jobs:
  lighthouse:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20 }
      - run: npm ci && npm run build

      - name: Run Lighthouse CI
        uses: treosh/lighthouse-ci-action@v11
        with:
          urls: |
            http://localhost:3000/
            http://localhost:3000/dashboard
            http://localhost:3000/products
          uploadArtifacts: true
          budgetPath: ./lighthouse-budget.json
```

#### 6c: Performance Budgets

Create a `lighthouse-budget.json` at the project root:

```json
[
  {
    "path": "/*",
    "timings": [
      { "metric": "largest-contentful-paint", "budget": 2500 },
      { "metric": "first-contentful-paint", "budget": 1800 },
      { "metric": "interactive", "budget": 3800 },
      { "metric": "total-blocking-time", "budget": 200 },
      { "metric": "cumulative-layout-shift", "budget": 0.1 }
    ],
    "resourceSizes": [
      { "resourceType": "script", "budget": 300 },
      { "resourceType": "stylesheet", "budget": 50 },
      { "resourceType": "image", "budget": 500 },
      { "resourceType": "total", "budget": 1000 }
    ],
    "resourceCounts": [
      { "resourceType": "third-party", "budget": 10 },
      { "resourceType": "script", "budget": 15 },
      { "resourceType": "total", "budget": 50 }
    ]
  }
]
```

**Bundle size budget in CI (webpack):**

```javascript
// webpack.config.js
module.exports = {
  performance: {
    maxAssetSize: 250000,        // 250KB per asset (uncompressed)
    maxEntrypointSize: 400000,   // 400KB per entry point
    hints: 'error',              // Fail the build if exceeded
  },
};
```

#### 6d: Alerting Thresholds

Set alerts when metrics degrade past thresholds:

| Metric | Warning | Critical | Alert Channel |
|--------|---------|----------|---------------|
| LCP p75 | > 2.5s | > 4.0s | Slack / PagerDuty |
| INP p75 | > 200ms | > 500ms | Slack / PagerDuty |
| CLS p75 | > 0.1 | > 0.25 | Slack |
| TTFB p95 | > 800ms | > 1.8s | Slack / PagerDuty |
| API p95 latency | > 500ms | > 2s | PagerDuty |
| Error rate | > 1% | > 5% | PagerDuty |
| JS bundle size | > 300KB gz | > 500KB gz | CI fail |
| Memory usage | > 80% heap | > 95% heap | PagerDuty |

### Step 7: Output — Performance Scorecard

Compile all findings into a scorecard and prioritized action plan.

#### Report Format

```
━━━ PERFORMANCE AUDIT REPORT ━━━━━━━━━━━━━━
Date: [audit date]
Target: [URL or project name]
Scope: [Frontend / Backend / Full-stack]
Stack: [Next.js + PostgreSQL + Redis, etc.]

── CURRENT BASELINE ──────────────────────
Metric              Current     Target      Status
LCP                 3.8s        < 2.5s      🟠 Needs Work
INP                 450ms       < 200ms     🔴 Poor
CLS                 0.05        < 0.1       🟢 Good
TTFB                1.2s        < 800ms     🟠 Needs Work
FCP                 2.1s        < 1.8s      🟡 Borderline
TBT                 850ms       < 200ms     🔴 Poor
Lighthouse Score    42          > 90        🔴 Poor
API p95             680ms       < 200ms     🔴 Poor

── FINDINGS ──────────────────────────────
Total findings: [N]
  🔴 Critical: [X]
  🟠 High: [Y]
  🟡 Medium: [Z]
  🟢 Low: [W]
  🔵 Info: [V]

── PRIORITIZED FIX LIST ──────────────────
Priority  Category     Finding                           Est. Impact    Effort
1         🔴 Backend   N+1 queries on /api/dashboard     -800ms TTFB    2h
2         🔴 Frontend  No code splitting — 1.2MB bundle  -2s LCP        4h
3         🟠 Frontend  Unoptimized hero image (2.4MB)    -1.5s LCP      30min
4         🟠 Backend   No Redis cache on product list    -400ms API     2h
5         🟠 Network   No compression (gzip/brotli)      -60% transfer  1h
6         🟡 Frontend  Missing font preload              -300ms FCP     15min
7         🟡 Frontend  Inline objects in JSX props        -200ms INP    1h
8         🟢 Network   No preconnect to API origin       -100ms TTFB   5min
9         🟢 Frontend  Images without width/height       CLS fix        30min
10        🔵 Monitor   No RUM — add web-vitals           Visibility     1h

── PROJECTED IMPROVEMENT ─────────────────
Metric              Current → Projected    Change
LCP                 3.8s → 1.6s            -58%
INP                 450ms → 120ms          -73%
TTFB                1.2s → 400ms           -67%
Lighthouse Score    42 → 88                +46 pts

── NEXT STEPS ────────────────────────────
1. Fix Critical items (items 1-2) — largest impact, do first
2. Fix High items (items 3-5) — significant gains, low-medium effort
3. Set up monitoring (item 10) — catch regressions going forward
4. Address Medium/Low items in next sprint
5. Re-audit after fixes to measure actual improvement
```

#### Detailed Finding Format

For each Critical and High finding, provide:

```markdown
### Finding #1: N+1 queries on dashboard endpoint

**Severity:** 🔴 Critical
**Category:** Backend — Database
**Location:** `src/api/routes/dashboard.ts:34-52`
**Metric Impact:** TTFB +800ms, API p95 +680ms

**Description:**
The `/api/dashboard` endpoint executes 1 query to fetch the user, then N queries
(one per project) to fetch project stats. With 50 projects, this generates 51
database round-trips per request.

**Evidence:**
```bash
# Enable query logging and count queries
DEBUG=knex:query node -e "
  const app = require('./src/app');
  // ... shows 51 queries for single dashboard load
"
```

**Current code:**
```typescript
const projects = await db.project.findMany({ where: { userId } });
for (const p of projects) {
  p.stats = await db.stat.findFirst({ where: { projectId: p.id } });
}
```

**Suggested fix:**
```typescript
const projects = await db.project.findMany({
  where: { userId },
  include: { stats: true },  // Single query with JOIN
});
```

**Estimated improvement:** TTFB from 1.2s to 400ms (-67%)
```

## Anti-Patterns

| Anti-Pattern | Why It's Wrong | Correct Approach |
|-------------|----------------|------------------|
| **Optimizing without measuring** | Guessing at bottlenecks wastes effort on non-issues | Always profile first — measure baseline, identify top bottleneck, fix, re-measure |
| **Caching everything** | Stale data bugs, memory pressure, complexity | Cache selectively based on read/write ratio and data sensitivity |
| **Adding indexes to every column** | Slows writes, wastes storage, index bloat | Index only columns used in WHERE, JOIN, ORDER BY with high selectivity |
| **Premature code splitting** | Too many chunks cause waterfall loading, worse performance | Split at route level first; only split components that are genuinely heavy (>50KB) and conditionally rendered |
| **Lazy-loading above-fold content** | Adds latency to content the user sees immediately | Only lazy-load below-fold images and deferred UI. Preload above-fold assets. |
| **Disabling SSR to "fix" performance** | Shifts all rendering to client, kills LCP and SEO | Fix the SSR bottleneck (slow data fetching, blocking queries) rather than removing SSR |
| **Over-memoizing in React** | `useMemo`/`useCallback` have overhead; trivial computations are faster without | Only memoize genuinely expensive computations (>1ms) or callbacks passed to memoized children |
| **Setting Cache-Control: no-store everywhere** | Forces full re-download on every request | Use appropriate TTLs with `stale-while-revalidate` for API data; `immutable` for hashed assets |
| **Fixing Lighthouse score instead of user experience** | Score gaming (preload everything, preconnect everything) can hurt real performance | Focus on field metrics (CrUX, RUM) over lab scores. Lighthouse is a guide, not a target. |
| **Horizontal scaling before vertical optimization** | Adding servers masks inefficient code and increases cost | First optimize queries, add caching, reduce bundle size. Scale infra only after code is efficient. |

## Escalation

Hand off to a specialist when:

- **Infrastructure scaling**: The application needs auto-scaling, load balancing, database read replicas, or multi-region deployment. Escalate to a DevOps/platform engineer.
- **Database internals**: Query plans indicate issues with the query planner itself, partition strategy, vacuum tuning, or replication lag. Escalate to a DBA.
- **CDN/edge configuration**: Complex cache invalidation, edge compute (Cloudflare Workers, Lambda@Edge), or geographic routing rules. Escalate to a platform engineer.
- **Browser rendering pipeline**: Compositing layer promotion, GPU acceleration, `will-change` usage, or paint-level debugging with Chrome DevTools Performance panel. Escalate to a frontend performance specialist.
- **Third-party script impact**: Analytics, tag managers, ad scripts, or chat widgets dominating TBT/INP. Requires negotiation with marketing/product teams.
- **Mobile-specific issues**: Performance on low-end Android devices, data-saver mode, or constrained network conditions requires dedicated device testing.
- **Memory profiling**: Heap snapshot analysis, detached DOM nodes, or long-running tab memory growth. Requires Chrome DevTools Memory panel expertise.

## Inputs

- Target URL or local project path
- Scope: frontend, backend, or full-stack
- Current pain points and user-reported symptoms
- Tech stack details (framework, hosting, database, CDN)
- Traffic profile (concurrent users, geography, peak times)
- Current performance metrics (if known)
- Target performance goals
- Budget constraints (infrastructure changes allowed?)

## Outputs

- Current performance baseline (Core Web Vitals + backend metrics with measurement evidence)
- Severity-classified findings list with file:line references
- Detailed write-up for each Critical/High finding with current code, suggested fix, and estimated impact
- Prioritized fix list ordered by impact-to-effort ratio
- Projected performance improvement after fixes
- Performance budget configuration (Lighthouse CI + bundler)
- Monitoring setup recommendations (RUM + synthetic + alerting)
- Before/after comparison plan for measuring actual improvement

## Level History

- **Lv.1** — Base: Full 7-step audit protocol covering Core Web Vitals assessment (LCP, INP, CLS, TTFB, FCP, TBT), frontend performance (bundle analysis, code splitting, image optimization, font loading, render-blocking resources, React-specific optimizations including memo/useMemo/useCallback/virtualization), backend performance (EXPLAIN ANALYZE, N+1 detection, connection pooling, caching strategies with Redis/HTTP headers, API response time profiling), network performance (HTTP/2, gzip/brotli compression, CDN configuration, preload/prefetch/preconnect resource hints, service worker caching strategies), monitoring setup (RUM with web-vitals, synthetic monitoring with Lighthouse CI, performance budgets, alerting thresholds), and performance scorecard output with prioritized fix list and projected improvement. Anti-patterns, escalation matrix, severity classification with impact estimates. (Origin: MemStack v3.3, Mar 2026)
