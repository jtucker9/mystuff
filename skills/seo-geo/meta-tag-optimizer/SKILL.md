---
name: meta-tag-optimizer
description: "WHAT: Optimize title tags, meta descriptions, OG/Twitter cards, and technical meta tags for SERP visibility and CTR. WHEN: User says 'meta tags', 'title tag', 'meta description', 'optimize meta', 'SERP preview', or needs to write/rewrite HTML meta tags. NOT: Schema markup (schema-markup), full site audits (site-audit), keyword research (keyword-research), AI search/GEO (ai-search-visibility), local SEO (local-seo)."
---

# Meta Tag Optimizer

## Activation

Output: `Meta Tag Optimizer — Optimizing your meta tags...`

| Context | Status |
|---------|--------|
| "meta tags", "title tag", "meta description", "optimize meta", "SERP preview" | ACTIVE |
| Open Graph, Twitter Card, canonical, robots, hreflang tags | ACTIVE |
| Bulk meta tag optimization (10+ pages) | ACTIVE |
| Schema markup / structured data | DORMANT — schema-markup |
| Full site audit / keyword research only | DORMANT — site-audit / keyword-research |

## Instructions

### Step 1: Gather Inputs

Required: URL(s) or page list, target keywords per page, brand name.
Helpful: page type, current meta tags, industry/niche, brand separator (default `|`), tone, character limit preference.

If only a URL is provided, fetch current tags with `curl`, infer page type and keywords, note assumptions.

**Gate:** Do not proceed without URL, keywords, and brand name.

### Step 2: Title Tag Optimization

**Character/pixel limits:**
- Desktop: ~580px / 50-60 chars. Mobile: ~920px / 55-70 chars. Truncation adds "..."
- Target 50-60 chars including brand suffix. Front-load primary keyword — truncation cuts right.

**Keyword placement rules:**
- Primary keyword first or near-first (survives truncation, stronger signal)
- One primary keyword per title; secondary only if natural
- Brand name at end after separator
- Never duplicate exact keywords

**Title formulas by page type:**
- **Homepage:** `[Primary Keyword] — [Value Proposition] | [Brand]`
- **Product:** `[Product Name] — [Key Benefit] | [Brand]`
- **Blog/Article:** `[Primary Keyword]: [Compelling Hook] | [Brand]`
- **Category:** `[Category Keyword] — [Qualifier] [Count/Range] | [Brand]`
- **Service:** `[Service Keyword] in [Location] — [Trust Signal] | [Brand]`
- **Landing:** `[Action Verb] [Primary Keyword] — [Urgency/Benefit] | [Brand]`

**Power word categories** (one per title max): Urgency, Value, Curiosity, Trust, Numbers, Specificity, Negative.

**Gate:** Validate each title: 50-60 chars, keyword in first 50, brand present, no duplicates, no ALL CAPS (except brand acronyms), no keyword stuffing, accurate to page content.

### Step 3: Meta Description Optimization

**Limits:** Desktop ~920px / 120-160 chars. Mobile ~680px / 100-120 chars. Target 120-155 chars.

**3-part anatomy:**
1. **Keyword-Rich Hook** (first 40-60 chars) — establishes relevance, gets bolded in SERP
2. **Unique Value Proposition** (next 40-60 chars) — differentiates from other results
3. **Call to Action** (final 20-40 chars) — reason to click now

**CTA types:** Direct action ("Shop now"), Learn more ("Read the guide"), Discover, Social proof ("Join 10K+ teams"), Urgency, Value ("Free template included").

**Gate:** Validate: 120-155 chars, contains primary keyword, has CTA, reads as natural sentence, no duplicates across site, no quotation marks in content attribute, accurate to page.

### Step 4: Open Graph and Twitter Card Tags

**Required OG properties:** `og:title`, `og:description`, `og:image`, `og:url`, `og:type`, `og:site_name`.

**OG rules:**
- `og:title` — optimize for social not search, no brand suffix needed, max 60-90 chars
- `og:description` — more conversational than meta description, max 200 chars visible
- `og:image` — minimum 1200x630px (1.91:1), JPG/PNG, max 8MB, absolute URL. Specify width/height to prevent layout shift.
- `og:url` — canonical absolute URL
- `og:type` — `website` (homepage), `article` (posts), `product` (products)

**Twitter Card types:**
- `summary` — small square image (min 144x144, rec 600x600). For articles, docs.
- `summary_large_image` — wide hero (min 300x157, rec 1200x628). For visual content, launches.

**Required Twitter properties:** `twitter:card`, `twitter:site`, `twitter:title`, `twitter:description`, `twitter:image`.

**Validation tools:** Facebook Debugger, Twitter Card Validator, LinkedIn Post Inspector, metatags.io, opengraph.xyz.

**Gate:** All required OG and Twitter properties present. Image meets minimum dimensions. URLs are absolute.

### Step 5: Technical Meta Tags

**Canonical** — every indexable page gets a self-referencing canonical. Use preferred protocol/domain/trailing-slash. Never chain canonicals (A->B->C). Never point to 4xx/5xx or noindexed pages. Paginated pages canonicalize to themselves, not page 1.

**Robots** — `index,follow` is default. Use `noindex` for: thank-you pages, internal search results, thin tag/archive pages, staging, login/account pages. Never accidentally noindex money pages.

**Viewport** — `width=device-width, initial-scale=1` on every page. Never disable zoom (`user-scalable=no`).

**Hreflang** — bidirectional (A references B AND B references A). Include `x-default`. All URLs must return 200. Use ISO 639-1 + optional ISO 3166-1 codes. For large sites, implement via XML sitemap.

**Gate:** Canonical present and valid. Robots directive intentional. Viewport correct. Hreflang bidirectional if multilingual.

### Step 6: SERP Preview and Testing

**Truncation rules:**

| Element | Desktop | Mobile |
|---------|---------|--------|
| Title | ~60 chars / 580px | ~55-60 chars (wraps 2 lines) |
| Description | ~155-160 chars / 920px | ~120 chars / 680px |
| Display URL | Full breadcrumb | Truncated with "..." |

Simulate at mobile limits. If critical info lost at truncation, restructure.

**A/B testing protocol:**
1. Baseline CTR from GSC (28-day window)
2. Change one variable at a time (title OR description)
3. Wait 2-4 weeks for recrawl + statistical data
4. Keep if CTR improved 10%+ with stable impressions
5. Then test the other variable

**Gate:** Mobile-truncated version still communicates core message and keyword.

### Step 7: Bulk Optimization

**Priority scoring formula:**
```
Score = Monthly Impressions x CTR Gap x Business Value
  CTR Gap = Avg CTR for position minus current CTR
  Business Value: Money page=3.0, Lead gen=2.5, Blog=1.0, Utility=0.5
```

**Tiers:** P0 (top 10 by impressions, below-avg CTR) -> this week. P1 (positions 4-10) -> 2 weeks. P2 (positions 11-20) -> 1 month. P3 (<100 impressions) -> batch. Skip noindex/zero-impression/utility pages.

After implementation, submit for recrawl via GSC URL Inspection or sitemap resubmission.

**Gate:** Pages tiered before optimization begins. P0 pages done first.

### Step 8: Output

Deliver per-page: optimized HTML tags, character counts, keyword placement confirmation, OG image verification. For bulk: before/after summary with page counts, avg lengths, and estimated CTR impact.

## Examples

**Single page optimization request:**
User provides URL + keyword. Fetch current tags, identify page type, generate title (formula-matched), description (3-part anatomy), OG/Twitter tags, canonical. Validate all gates. Output with character counts.

**Bulk optimization request:**
User provides sitemap or URL list. Score and tier all pages. Optimize P0 first. Deliver spreadsheet-format output with old/new titles, old/new descriptions, lengths, status. Summary: pages audited, optimized, skipped, estimated CTR lift, 2-4 week monitoring plan.

## Common Issues

**Google rewrites my title tag** — Title is keyword-stuffed, doesn't match page content, or has mismatched brand format. Fix: one primary keyword, accurate to content, consistent separator.

**Meta description not showing in SERP** — Google generates its own when description is missing, irrelevant to query, or too short. Fix: write query-relevant description at 120-155 chars with keyword match.

**OG image shows as tiny thumbnail on Facebook** — Image below 600x315px. Fix: use minimum 1200x630px, specify `og:image:width` and `og:image:height`.

## Anti-Patterns

- Keyword-stuffing titles ("SEO Tools - Best SEO Tools for SEO")
- Same title/description across multiple pages
- Using `og:type=website` for everything
- Quotation marks inside meta description content attribute (causes SERP truncation)
- Canonicalizing paginated pages to page 1
- Adding `noindex` to money pages without realizing it
- Disabling viewport zoom (`user-scalable=no`)
- Chaining canonicals (A -> B -> C instead of A -> C)

## Escalation

- If keyword strategy is unclear or missing, escalate to **keyword-research** skill first
- If page needs structured data beyond meta tags, hand off to **schema-markup**
- If audit reveals site-wide crawl/indexation issues, escalate to **site-audit**
- If meta tags look fine but CTR is still low after 4+ weeks, consider rich results via schema or content quality issues

## Inputs

| Input | Required | Notes |
|-------|----------|-------|
| URL(s) or page list | Yes | Single URL, list, or sitemap |
| Target keywords per page | Yes | Primary + optional secondary |
| Brand name | Yes | For title tag suffix |
| Page type | No | Auto-detected if omitted |
| Current meta tags | No | Fetched via curl if omitted |
| Brand separator | No | Default: `\|` |
| Tone / industry | No | Calibrates word choice |

## Outputs

- Optimized HTML meta tags per page (title, description, canonical, OG, Twitter, robots)
- Character/pixel count validation per tag
- SERP preview (desktop + mobile truncation)
- For bulk: priority-scored spreadsheet, before/after summary, estimated CTR impact

## Level History

- **Lv.1** — Base: Title tag rules (char/pixel limits, keyword placement, formulas by page type, power words), meta description rules (limits, 3-part anatomy, CTA patterns), OG/Twitter card specs (required properties, image dimensions, card types), technical meta tags (canonical, robots, viewport, hreflang), SERP truncation rules, priority scoring formula, A/B testing protocol, bulk optimization workflow. (Origin: MemStack v3.0, Feb 2026)
- **Lv.2** — Compression: Removed full HTML templates, SERP ASCII art, CMS guides, bulk spreadsheet formats. Retained all decision rules and validation gates. (Origin: MemStack v3.3, Mar 2026)
