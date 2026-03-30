---
name: site-audit
description: "Comprehensive SEO health audit with weighted scoring. WHEN: 'SEO audit', 'site audit', 'check SEO', 'audit my site', 'technical SEO', 'why am I not ranking', indexing/crawl issues, ranking drops. NOT: keyword research alone (keyword-research), schema generation (schema-markup), meta tags only (meta-tag-optimizer), local SEO only (local-seo), AI search/GEO (ai-search-visibility), app performance (performance-audit)."
---

# Site Audit — Comprehensive SEO Health Check

Systematically audit technical SEO, on-page optimization, content quality, off-page signals, and local presence. Produce a scored report with a prioritized 90-day action plan.

## Activation

| Context | Status |
|---------|--------|
| "SEO audit", "site audit", "check SEO", "audit my site" | ACTIVE |
| "technical SEO", "crawl my site", "why am I not ranking" | ACTIVE |
| Indexing issues, crawl errors, ranking drops | ACTIVE |
| Keyword research only | DORMANT — keyword-research |
| Schema markup generation | DORMANT — schema-markup |
| Meta tag optimization only | DORMANT — meta-tag-optimizer |
| Local SEO specifically | DORMANT — local-seo |
| AI search / GEO optimization | DORMANT — ai-search-visibility |

## Instructions

### Step 1: Gather Inputs

Required: **Site URL**. Optional but improves depth: CMS/stack, target keywords (5-10), competitor URLs (2-3), GSC export, traffic data, business type, geographic target, known issues, priority (quick scan vs deep dive).

**Gate:** If only URL provided, proceed with defaults and note assumptions. Do not proceed without a URL.

### Step 2: Technical SEO (30% weight)

Audit each sub-category, score 0-100, average for composite:

- **Crawlability** — robots.txt (exists, no accidental blocks, sitemap directive), XML sitemap (valid, no 404/redirect URLs, referenced in robots.txt, under 50k/50MB limits, accurate lastmod), canonical tags (present, absolute, self-referencing, no loops)
- **Indexability** — meta robots / X-Robots-Tag (no accidental noindex on important pages), indexed count vs sitemap count alignment
- **Site Speed** — Core Web Vitals: LCP <2.5s good / >4.0s poor, INP <200ms good / >500ms poor, CLS <0.1 good / >0.25 poor. Supporting: TTFB <800ms, FCP <1.8s, TBT <200ms. Run Lighthouse 3-5 times, take median.
- **Mobile** — viewport meta, no user-scalable=no, 16px+ base font, 48px+ tap targets, no horizontal scroll, responsive images, no intrusive interstitials
- **SSL/HTTPS** — HTTP->HTTPS 301 redirect, valid cert, no mixed content, HSTS header
- **Structured Data** — JSON-LD present and valid per business type (LocalBusiness, Product, Article, SoftwareApplication, etc.)
- **Internal Linking** — no orphan pages, depth <= 3 clicks, no broken links, descriptive anchors, breadcrumbs
- **Redirects** — no chains >1 hop, 301 not 302 for canonical, no loops
- **Duplicate Content** — www/non-www consolidated, trailing slash consistent, parameters canonicalized

**Gate:** If critical blocking issues found (noindex on homepage, site-wide redirect loop), flag immediately before continuing.

### Step 3: On-Page SEO (25% weight)

- **Title Tags** — unique per page, 50-60 chars, keyword near front, brand included
- **Meta Descriptions** — present, 120-160 chars, keyword + CTA, unique
- **Heading Hierarchy** — single H1 with keyword, logical H1>H2>H3, no skipping
- **Keyword Placement** — title (critical), H1 (critical), first 100 words (high), URL slug (high), meta desc (medium), H2/H3 (medium), alt text (medium), body 1-3% density natural (medium)
- **Image Optimization** — descriptive alt text, WebP/AVIF formats, lazy loading (not on LCP image), explicit width/height
- **URL Structure** — short, hyphens, keywords, lowercase, no parameters/session IDs
- **Content Length** — blog 1500-2500w, product 500-1000w, category 300-500w, landing 1000-2000w, homepage/about 500-1000w
- **Keyword Cannibalization** — detect multiple pages targeting same keyword; resolve via merge+301, intent differentiation, or canonical

**Gate:** Confirm keyword targets before evaluating placement. Without targets, on-page scoring is unreliable.

### Step 4: Content Quality (20% weight)

- **Thin Content** — flag indexable pages <200 words; expand, consolidate via 301, or noindex
- **Content Freshness** — blog published within 6 months, evergreen updated within 12 months, visible dates
- **E-E-A-T Signals** — Experience (first-hand evidence, original photos, case studies), Expertise (author credentials, technical depth), Authoritativeness (citations, industry recognition), Trustworthiness (contact info, address, privacy policy, accurate claims). Check: author bylines + bio pages, about page, contact with physical address, trust signals, cited sources (especially YMYL)
- **Topical Authority** — map content into topic clusters, evaluate coverage depth, identify gaps in cluster completeness, compare against competitors
- **Content Gaps** — compare sitemap/content against 2-3 competitors; prioritize missing topics by search volume and business relevance

### Step 5: Off-Page Signals (15% weight)

Requires backlink tools (Ahrefs, Semrush, Moz) for depth. Recommend if unavailable.

- **Backlink Profile** — Domain Rating/Authority (20+ new, 40+ established), referring domain growth trend, backlink:domain ratio (100:1 = spammy), dofollow ratio (60-80% healthy, >95% suspicious), steady link velocity
- **Referring Domain Quality** — Tier 1 (DR 70+, editorial), Tier 2 (DR 40-69, relevant), Tier 3 (DR 20-39), Tier 4 (DR <20), Toxic (spam/PBN/link farms — disavow candidates)
- **Anchor Text Distribution** — Branded 30-50%, naked URL 15-25%, generic 10-20%, exact match 5-10% (>15% = Penguin risk), partial match 10-20%
- **Toxic Links** — unrelated industries, PBNs, foreign spam, hacked sites, comment spam; prepare disavow file if found
- **Competitor Comparison** — benchmark DR, referring domains, edu/gov links, DR 50+ links, linkable content volume

### Step 6: Local SEO (10% weight)

Skip if not a local business. Redistribute weight: +5% Technical, +5% Content.

- **Google Business Profile** — claimed, verified, accurate name/categories/hours, photos, posts, reviews responded to
- **NAP Consistency** — Name/Address/Phone identical on website, GBP, and all directories
- **Local Schema** — LocalBusiness (specific subtype) with address, telephone, openingHours, geo, areaServed
- **Citations** — verify presence in top directories (Yelp, BBB, Apple Maps, Bing Places, industry-specific)

**Gate:** All six sections scored before proceeding to action plan.

### Step 7: Score and Prioritize

**Scoring rubric (weighted average):**

| Section | Weight |
|---------|--------|
| Technical SEO | 30% |
| On-Page SEO | 25% |
| Content Quality | 20% |
| Off-Page Signals | 15% |
| Local SEO | 10% |

**Grade thresholds:**

| Score | Grade | Meaning |
|-------|-------|---------|
| 90-100 | A | Excellent — minor polish only |
| 80-89 | B | Good — few meaningful improvements |
| 70-79 | C | Average — clear opportunities |
| 60-69 | D | Below average — significant gaps |
| 0-59 | F | Poor — fundamental issues |

**Impact/effort matrix for prioritization:**
- Quick Wins (high impact, low effort) — do first
- Major Projects (high impact, high effort) — plan and schedule
- Fill-ins (low impact, low effort) — do when free
- Deprioritize (low impact, high effort) — revisit later

Impact scale: Critical (10) blocking/penalties, High (7-9) significant ranking lift, Medium (4-6) moderate lift, Low (1-3) minor/indirect.
Effort scale: Quick (1-2) <1hr, Easy (3-4) 1-4hr, Moderate (5-7) 1-3 days, Major (8-10) 1+ weeks.

### Step 8: Output Report

Deliver: overview, overall score with grade, section scores, issues table (critical/high/medium/low with impact+effort), quick wins list, content gaps, competitor comparison, 90-day action plan, tool recommendations.

**90-day timeline:**

| Phase | Timeframe | Focus |
|-------|-----------|-------|
| Phase 1: Critical Fixes | Week 1 | Indexing blocks, penalties, broken redirects |
| Phase 2: Quick Wins | Weeks 2-3 | Titles, metas, alt text, canonicals, robots.txt |
| Phase 3: Content | Weeks 4-8 | Fill gaps, expand thin pages, update stale content |
| Phase 4: Authority | Ongoing | Link building, digital PR, citations |
| Phase 5: Optimization | Monthly | Monitor, refine, A/B test, expand clusters |

## Examples

**Quick scan request:**
User: "Audit example.com, just a quick scan." Gather URL only, sample 5-10 representative pages across types, score all categories, flag critical issues, deliver condensed report. Note limitations of sample size.

**Deep dive with data:**
User: "Full audit of example.com, here's my GSC export and target keywords." Use GSC data to validate index coverage and crawl errors against sitemap. Cross-reference target keywords with title/H1/content placement. Score all categories with higher confidence. Full competitor backlink comparison.

## Common Issues

- **Scores look good but rankings are poor:** Off-page signals (backlinks) likely the bottleneck — technical health doesn't compensate for low authority.
- **GSC shows "Crawled — currently not indexed":** Content quality issue, not crawlability. Improve E-E-A-T signals and content depth on affected pages.
- **CWV pass in Lighthouse but fail in field data:** Lab vs field data divergence. Field data (CrUX) reflects real user conditions. Optimize for real-world device/network distribution, not lab conditions.

## Anti-Patterns

| Anti-Pattern | Correct Approach |
|-------------|------------------|
| Auditing only the homepage | Sample across page types — 90% of issues are on interior pages |
| Checking desktop only | Mobile-first indexing — audit mobile first |
| Obsessing over keyword density | Semantic understanding — focus on natural placement and topic coverage |
| Ignoring Core Web Vitals | Confirmed ranking signals — measure LCP, INP, CLS |
| Running Lighthouse once | 10-20% variance — run 3-5 times, take median |
| Treating all pages equally | Weight findings by page business value |
| Auditing without target keywords | Establish targets first or on-page scoring is meaningless |
| Ignoring competitor context | Scores mean nothing without SERP benchmarks |
| Recommending everything at once | Phase over 90 days — overwhelming kills execution |
| Using outdated metrics (DA, keyword density, EMDs) | Use CWV, E-E-A-T, topical authority |

## Escalation

Hand off to specialist or recommend paid tools when:
- 10,000+ pages (need full crawl tools: Screaming Frog, Sitebulb, Lumar)
- Manual action in GSC (experienced SEO practitioner required)
- Site migration needed (domain/CMS/URL restructure — high-risk)
- International SEO with hreflang (complex, easy to misconfigure)
- Backlink disavow recommended (incorrect disavow harms more than helps)
- YMYL niche (health/finance/legal — stricter E-E-A-T requirements)
- JS rendering issues suspected (specialized tools needed)
- Client needs ongoing rank tracking (recommend Ahrefs, Semrush, SE Ranking)

## Inputs

- Site URL (required)
- CMS / tech stack (helpful)
- Target keywords (5-10 terms)
- Competitor URLs (2-3)
- GSC data export (if available)
- Analytics traffic data (if available)
- Business type and geographic target
- Known issues or recent changes

## Outputs

- Overall score (0-100) with letter grade (A-F)
- Section scores with weighted breakdown (Technical 30%, On-Page 25%, Content 20%, Off-Page 15%, Local 10%)
- Issues table with severity, impact, and effort ratings
- Quick wins list
- Content gap analysis
- Competitor comparison
- 90-day phased action plan
- Tool recommendations

## Level History

- **Lv.1** — Full implementation: 8-step SEO audit — technical, on-page, content, off-page, local, scoring, prioritization, report output. (Origin: MemStack skill replacement, Mar 2026)
- **Lv.2** — Compressed: Removed curl/grep commands, detailed report templates, and backlink analysis tables. Retained scoring rubric, grade thresholds, audit category checklists (names only), E-E-A-T signals, backlink quality signals, impact/effort matrix, 90-day timeline. Decision-rule density. (Origin: MemStack compression, Mar 2026)
