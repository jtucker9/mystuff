---
name: site-audit
description: "Use when the user says 'SEO audit', 'site audit', 'check SEO', 'audit my site', 'technical SEO', or is evaluating a website's search engine optimization health. Do NOT use for keyword research alone (see keyword-research) or schema markup generation (see schema-markup)."
---

# 🔎 Site Audit — Comprehensive SEO Health Check
*Systematically audit a website's technical SEO, on-page optimization, content quality, off-page signals, and local presence — producing a scored report with a prioritized action plan.*

## Activation

When this skill activates, output:

`🔎 Site Audit — Auditing your site's SEO health...`

| Context | Status |
|---------|--------|
| **User says "SEO audit", "site audit", "check SEO", "audit my site"** | ACTIVE |
| **User says "technical SEO", "crawl my site", "why am I not ranking"** | ACTIVE |
| **User wants a full website health check for search engines** | ACTIVE |
| **User asks about indexing issues, crawl errors, or ranking drops** | ACTIVE |
| **User wants keyword research only** | DORMANT — see keyword-research |
| **User wants schema markup generated** | DORMANT — see schema-markup |
| **User wants meta tag optimization only** | DORMANT — see meta-tag-optimizer |
| **User wants local SEO specifically** | DORMANT — see local-seo (but Step 6 includes a quick local check) |
| **User wants AI search / GEO optimization** | DORMANT — see ai-search-visibility |
| **User wants application performance profiling** | DORMANT — see performance-audit |

## Scoring Rubric

Every audit section receives a score from 0-100. The overall score is a weighted average:

| Section | Weight | What It Measures |
|---------|--------|-----------------|
| Technical SEO | 30% | Crawlability, indexability, speed, mobile, SSL, structure |
| On-Page SEO | 25% | Titles, metas, headings, keywords, images, URLs |
| Content Quality | 20% | Depth, freshness, E-E-A-T, topical authority, gaps |
| Off-Page Signals | 15% | Backlinks, referring domains, anchor text, toxicity |
| Local SEO | 10% | GBP, NAP, local schema, citations (0 if not applicable — weight redistributed) |

**Grade thresholds:**

| Score | Grade | Meaning |
|-------|-------|---------|
| 90-100 | A | Excellent — minor polish only |
| 80-89 | B | Good — a few meaningful improvements available |
| 70-79 | C | Average — clear optimization opportunities |
| 60-69 | D | Below average — significant gaps hurting rankings |
| 0-59 | F | Poor — fundamental issues blocking search performance |

## Protocol

### Step 1: Gather Inputs

Ask the user for the following. Items marked **(required)** must be answered before proceeding; others are optional but improve audit depth.

- **Site URL** (required): The root domain to audit (e.g., `https://example.com`)
- **CMS / Tech stack**: WordPress, Shopify, Next.js, custom, etc.?
- **Target keywords**: Top 5-10 keywords or phrases they want to rank for
- **Primary competitors**: 2-3 competitor URLs for comparison
- **Google Search Console access**: Can they share a GSC export or screenshot? (Helps with real crawl/index data)
- **Google Analytics / current traffic**: Approximate monthly organic sessions, top landing pages
- **Business type**: Local business, e-commerce, SaaS, content/media, B2B services?
- **Geographic target**: Local (city/region), national, or international?
- **Known issues**: Any recent ranking drops, manual actions, or migration history?
- **Priority**: Speed of audit — quick scan (1-2 hours) or deep dive (full day)?

**If the user provides only a URL**, proceed with reasonable defaults and note assumptions in the report.

### Step 2: Technical SEO

Technical SEO is the foundation. If search engines cannot crawl and index the site correctly, nothing else matters.

#### 2a: Crawlability — robots.txt

```bash
# Fetch and analyze robots.txt
curl -s https://example.com/robots.txt

# Check for common mistakes:
# - Disallow: / (blocks entire site)
# - Missing sitemap reference
# - Blocking CSS/JS files (prevents rendering)
# - Wildcard rules that accidentally block important paths
```

**What to check:**
- [ ] `robots.txt` exists and returns 200
- [ ] Does NOT contain `Disallow: /` (unless intentional staging site)
- [ ] Does NOT block CSS, JS, or image directories needed for rendering
- [ ] Contains `Sitemap:` directive pointing to XML sitemap
- [ ] No conflicting rules (e.g., Allow and Disallow for same path)
- [ ] Separate rules per user-agent if needed (Googlebot, Bingbot, etc.)

**Scoring:**
- robots.txt present and correct: 100
- Present but minor issues (missing sitemap reference): 80
- Present but blocking important resources: 40
- Missing entirely: 60 (not fatal — defaults to allow-all, but shows neglect)
- Blocking entire site unintentionally: 0

#### 2b: Crawlability — XML Sitemap

```bash
# Fetch sitemap (common locations)
curl -s https://example.com/sitemap.xml | head -50
curl -s https://example.com/sitemap_index.xml | head -50

# Count URLs in sitemap
curl -s https://example.com/sitemap.xml | grep -c "<loc>"

# Check for sitemap in robots.txt
curl -s https://example.com/robots.txt | grep -i sitemap

# Validate sitemap HTTP status
curl -s -o /dev/null -w "%{http_code}" https://example.com/sitemap.xml
```

**What to check:**
- [ ] Sitemap exists and returns 200 with valid XML
- [ ] All listed URLs return 200 (no 404s, no redirects)
- [ ] Sitemap URLs match canonical versions (HTTPS, www vs non-www consistent)
- [ ] Sitemap is referenced in robots.txt
- [ ] Sitemap file size < 50MB and < 50,000 URLs per file (Google limits)
- [ ] Sitemap index used for large sites with sub-sitemaps
- [ ] `<lastmod>` dates are accurate (not all the same date)
- [ ] No noindex pages listed in sitemap (contradiction)

#### 2c: Crawlability — Canonical Tags

```bash
# Check canonical tag on homepage
curl -s https://example.com/ | grep -i "canonical"

# Check a sample of interior pages
for page in "/" "/about" "/blog" "/contact" "/products"; do
  echo "=== $page ==="
  curl -s "https://example.com$page" | grep -i "canonical"
done

# Check HTTP header canonicals (sometimes sent via Link header)
curl -sI https://example.com/ | grep -i "link.*canonical"
```

**What to check:**
- [ ] Every page has a `<link rel="canonical">` tag
- [ ] Canonical URLs are absolute (not relative)
- [ ] Canonical points to self (self-referencing) unless intentionally consolidating
- [ ] No canonical loops or chains
- [ ] Canonical matches the protocol and www-preference
- [ ] Paginated pages canonical to self (NOT to page 1, per modern Google guidance)

#### 2d: Indexability

```bash
# Check meta robots tag
curl -s https://example.com/ | grep -i "meta.*robots"

# Check X-Robots-Tag HTTP header
curl -sI https://example.com/ | grep -i "x-robots-tag"

# Check a sample of pages for noindex
for page in "/" "/about" "/blog" "/contact" "/privacy"; do
  echo "=== $page ==="
  curl -s "https://example.com$page" | grep -i "noindex"
  curl -sI "https://example.com$page" | grep -i "x-robots-tag"
done

# Estimate indexed pages via site: operator (manual check)
# Search: site:example.com in Google
# Compare indexed count vs sitemap count
```

**What to check:**
- [ ] Important pages do NOT have `noindex` meta tag or `X-Robots-Tag: noindex`
- [ ] Intentional noindex on pages that should not rank (admin, thank-you, login)
- [ ] No accidental noindex from CMS settings or staging environment leftovers
- [ ] Number of indexed pages (from GSC or `site:` search) roughly matches sitemap count
- [ ] No "Crawled — currently not indexed" issues in GSC (if available)

#### 2e: Site Speed — Core Web Vitals

```bash
# Lighthouse CLI audit (requires Chrome/Chromium installed)
npx lighthouse https://example.com \
  --output=json \
  --chrome-flags="--headless --no-sandbox" \
  --only-categories=performance \
  --quiet 2>/dev/null | jq '{
    performance_score: (.categories.performance.score * 100),
    LCP: .audits["largest-contentful-paint"].displayValue,
    FCP: .audits["first-contentful-paint"].displayValue,
    TBT: .audits["total-blocking-time"].displayValue,
    CLS: .audits["cumulative-layout-shift"].displayValue,
    SI:  .audits["speed-index"].displayValue,
    TTFB: .audits["server-response-time"].displayValue
  }'

# If Lighthouse not available, use PageSpeed Insights API (free, no key for basic)
curl -s "https://www.googleapis.com/pagespeedonline/v5/runPagespeedTest?url=https://example.com&strategy=mobile" | jq '{
  performance_score: (.lighthouseResult.categories.performance.score * 100),
  LCP: .lighthouseResult.audits["largest-contentful-paint"].displayValue,
  CLS: .lighthouseResult.audits["cumulative-layout-shift"].displayValue,
  FCP: .lighthouseResult.audits["first-contentful-paint"].displayValue
}'

# Quick TTFB check (no Lighthouse needed)
curl -s -o /dev/null -w "TTFB: %{time_starttransfer}s\nTotal: %{time_total}s\n" https://example.com

# Check page weight and request count
curl -s -o /dev/null -w "Download size: %{size_download} bytes\n" https://example.com
```

**Core Web Vitals thresholds (Google's):**

| Metric | Good | Needs Improvement | Poor |
|--------|------|-------------------|------|
| **LCP** (Largest Contentful Paint) | < 2.5s | 2.5-4.0s | > 4.0s |
| **INP** (Interaction to Next Paint) | < 200ms | 200-500ms | > 500ms |
| **CLS** (Cumulative Layout Shift) | < 0.1 | 0.1-0.25 | > 0.25 |

**Supporting metrics:**

| Metric | Good | Needs Improvement | Poor |
|--------|------|-------------------|------|
| **TTFB** | < 800ms | 800ms-1.8s | > 1.8s |
| **FCP** | < 1.8s | 1.8-3.0s | > 3.0s |
| **Total Blocking Time** | < 200ms | 200-600ms | > 600ms |

**Speed scoring:**
- All CWV "Good": 100
- All CWV "Good" except one "Needs Improvement": 80
- Mixed results: 60
- Any CWV "Poor": 40
- Multiple CWV "Poor": 20

#### 2f: Mobile-Friendliness

```bash
# Lighthouse mobile audit (default is mobile emulation)
npx lighthouse https://example.com \
  --output=json \
  --chrome-flags="--headless --no-sandbox" \
  --quiet 2>/dev/null | jq '{
    viewport_meta: .audits["viewport"].score,
    font_size: .audits["font-size"].score,
    tap_targets: .audits["tap-targets"].score
  }'

# Check viewport meta tag
curl -s https://example.com/ | grep -i "viewport"

# Check for mobile-specific issues
curl -s https://example.com/ | grep -i "user-scalable=no"
# user-scalable=no is an accessibility anti-pattern
```

**What to check:**
- [ ] `<meta name="viewport" content="width=device-width, initial-scale=1">` present
- [ ] No `user-scalable=no` or `maximum-scale=1` (accessibility issue)
- [ ] Text readable without zooming (>= 16px base font)
- [ ] Tap targets at least 48x48px with adequate spacing
- [ ] No horizontal scrolling on mobile widths
- [ ] Responsive images (srcset or CSS-based)
- [ ] No intrusive interstitials (Google penalizes these on mobile)

#### 2g: SSL / HTTPS

```bash
# Check HTTPS redirect
curl -sI http://example.com | grep -i "location"
# Should redirect to https://

# Check SSL certificate details
echo | openssl s_client -servername example.com -connect example.com:443 2>/dev/null | openssl x509 -noout -dates -subject -issuer

# Check for mixed content (HTTP resources on HTTPS page)
curl -s https://example.com/ | grep -oP 'http://[^"'"'"'\s>]+' | head -20

# Check HSTS header
curl -sI https://example.com/ | grep -i "strict-transport-security"
```

**What to check:**
- [ ] HTTP redirects to HTTPS (301, not 302)
- [ ] SSL certificate is valid and not expiring within 30 days
- [ ] No mixed content (HTTP resources loaded on HTTPS pages)
- [ ] HSTS header present (`Strict-Transport-Security`)
- [ ] All internal links use HTTPS
- [ ] Sitemap and canonical URLs use HTTPS

#### 2h: Structured Data Validation

```bash
# Extract JSON-LD structured data from a page
curl -s https://example.com/ | grep -oP '<script type="application/ld\+json">.*?</script>' | sed 's/<[^>]*>//g' | jq .

# Check multiple pages for structured data presence
for page in "/" "/about" "/blog/first-post" "/products/example" "/contact"; do
  echo "=== $page ==="
  HAS_JSONLD=$(curl -s "https://example.com$page" | grep -c "application/ld+json")
  HAS_MICRO=$(curl -s "https://example.com$page" | grep -c "itemscope")
  echo "JSON-LD blocks: $HAS_JSONLD | Microdata: $HAS_MICRO"
done

# Validate with Google's Rich Results Test (manual)
# https://search.google.com/test/rich-results?url=https://example.com

# Validate with Schema.org validator (manual)
# https://validator.schema.org/?url=https://example.com
```

**Common schema types to check for by business type:**

| Business Type | Expected Schema Types |
|---------------|----------------------|
| Local business | LocalBusiness, OpeningHours, GeoCoordinates |
| E-commerce | Product, Offer, AggregateRating, BreadcrumbList |
| Blog / Content | Article, BlogPosting, Person (author), BreadcrumbList |
| SaaS | SoftwareApplication, FAQPage, Organization |
| Service business | Service, Organization, FAQPage, Review |
| All sites | WebSite (with SearchAction), Organization, BreadcrumbList |

#### 2i: Internal Linking Structure

```bash
# Count internal links on homepage
curl -s https://example.com/ | grep -oP 'href="https://example\.com[^"]*"' | wc -l
curl -s https://example.com/ | grep -oP 'href="/[^"]*"' | wc -l

# Check for orphan pages (pages not linked from anywhere)
# This requires a full crawl — recommend Screaming Frog, Sitebulb, or:
# Compare sitemap URLs against internally linked URLs

# Check navigation depth (pages should be within 3 clicks of homepage)
# Automated crawl needed for full analysis

# Find broken internal links on a single page
curl -s https://example.com/ | grep -oP 'href="(/[^"]*)"' | while read -r link; do
  URL="https://example.com$(echo $link | tr -d '"' | sed 's/href=//')"
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
  if [ "$STATUS" != "200" ]; then
    echo "BROKEN [$STATUS]: $URL"
  fi
done
```

**What to check:**
- [ ] No orphan pages (every important page linked from at least one other page)
- [ ] Reasonable crawl depth (important pages within 3 clicks of homepage)
- [ ] No broken internal links (404s)
- [ ] Logical hierarchy (homepage > category > subcategory > page)
- [ ] Breadcrumb navigation present and consistent
- [ ] Anchor text for internal links is descriptive (not "click here")
- [ ] Key pages have sufficient internal link equity

#### 2j: Redirect Chains

```bash
# Follow redirects and show the chain
curl -sIL https://example.com 2>/dev/null | grep -E "^HTTP/|^location:" | paste - -

# Check common redirect chain sources
for url in "http://example.com" "http://www.example.com" "https://www.example.com" "https://example.com"; do
  echo "=== $url ==="
  curl -sIL "$url" 2>/dev/null | grep -E "^HTTP/|^[Ll]ocation:"
  echo ""
done

# Check for redirect loops
curl -sIL --max-redirs 10 https://example.com/old-page 2>&1 | tail -5
```

**What to check:**
- [ ] No redirect chains longer than 1 hop (A->B OK, A->B->C bad)
- [ ] All redirects are 301 (permanent), not 302 (temporary) for canonical consolidation
- [ ] HTTP -> HTTPS is a single 301
- [ ] www -> non-www (or vice versa) is a single 301
- [ ] No redirect loops
- [ ] Old URLs from site migrations properly 301 to new locations

#### 2k: Duplicate Content

```bash
# Check www vs non-www (should resolve to same content via redirect)
diff <(curl -sL https://example.com/ | md5sum) <(curl -sL https://www.example.com/ | md5sum)

# Check trailing slash consistency
diff <(curl -sL https://example.com/about | md5sum) <(curl -sL https://example.com/about/ | md5sum)

# Check for parameter-based duplicates
curl -s "https://example.com/products?sort=price" | grep -i "canonical"
curl -s "https://example.com/products?page=1" | grep -i "canonical"

# Check for HTTP vs HTTPS serving same content (should redirect)
curl -sI http://example.com/ | head -5
```

**What to check:**
- [ ] www and non-www resolve to same version (one redirects to the other)
- [ ] Trailing slash is consistent (either always or never — pick one)
- [ ] URL parameters do not create duplicate indexable pages
- [ ] Canonical tags consolidate duplicate variations
- [ ] Pagination handled correctly (rel=canonical to self, or noindex after a threshold)
- [ ] Print/AMP/mobile versions have canonical to main version
- [ ] No substantively duplicate pages with different URLs

**Technical SEO section scoring:** Average all sub-section scores for the Technical SEO composite (weight: 30%).

---

### Step 3: On-Page SEO

On-page SEO ensures each page is optimized for its target keywords and provides clear signals to search engines.

#### 3a: Title Tags

```bash
# Extract title tag from pages
for page in "/" "/about" "/blog" "/products" "/contact"; do
  TITLE=$(curl -s "https://example.com$page" | grep -oP '<title[^>]*>.*?</title>' | sed 's/<[^>]*>//g')
  LENGTH=${#TITLE}
  echo "$page | $LENGTH chars | $TITLE"
done
```

**Checklist:**
- [ ] Every page has a unique `<title>` tag
- [ ] Title length: 50-60 characters (Google truncates at ~60)
- [ ] Primary keyword appears in the title, preferably near the front
- [ ] Brand name included (typically at the end: "Page Title | Brand")
- [ ] No duplicate titles across the site
- [ ] Titles are compelling (not just keyword-stuffed) — they're the headline in SERPs
- [ ] Homepage title includes primary brand keyword + value proposition

**Scoring:**
- All titles unique, optimal length, keyword-positioned: 100
- Minor issues (a few too long, brand missing on some): 80
- Multiple duplicates or missing titles: 50
- Most pages missing or identical titles: 20

#### 3b: Meta Descriptions

```bash
# Extract meta descriptions
for page in "/" "/about" "/blog" "/products" "/contact"; do
  DESC=$(curl -s "https://example.com$page" | grep -oP '<meta\s+name="description"\s+content="[^"]*"' | sed 's/.*content="//;s/"$//')
  LENGTH=${#DESC}
  echo "$page | $LENGTH chars | $DESC"
done
```

**Checklist:**
- [ ] Every important page has a meta description
- [ ] Length: 120-160 characters (Google truncates at ~160)
- [ ] Includes target keyword naturally
- [ ] Contains a call-to-action or value proposition (meta descriptions are ad copy for organic)
- [ ] No duplicate meta descriptions across the site
- [ ] Not auto-generated garbage (some CMS plugins produce poor defaults)

#### 3c: Heading Hierarchy (H1-H6)

```bash
# Analyze heading structure on a page
curl -s https://example.com/ | grep -oP '<h[1-6][^>]*>.*?</h[1-6]>' | sed 's/<[^>]*>//g' | cat -n

# Check for multiple H1s
for page in "/" "/about" "/blog" "/products"; do
  H1_COUNT=$(curl -s "https://example.com$page" | grep -ioP '<h1[^>]*>' | wc -l)
  echo "$page | H1 count: $H1_COUNT"
done
```

**Checklist:**
- [ ] Exactly one `<h1>` per page
- [ ] H1 contains the primary keyword for that page
- [ ] H1 is different from the `<title>` tag (related but not identical)
- [ ] Heading hierarchy is logical (H1 > H2 > H3, no skipping levels)
- [ ] Subheadings (H2, H3) include secondary/related keywords
- [ ] Headings are descriptive, not generic ("Our Services" -> "Web Development Services in Austin")

#### 3d: Keyword Placement

Evaluate keyword placement across the page for target keyword(s):

| Location | Priority | Check |
|----------|----------|-------|
| Title tag | Critical | Keyword within first 60 chars |
| H1 heading | Critical | Primary keyword present |
| First 100 words | High | Keyword appears in opening paragraph |
| URL slug | High | Keyword in URL path |
| Meta description | Medium | Keyword present for bolding in SERPs |
| H2/H3 subheadings | Medium | Secondary keywords in subheadings |
| Image alt text | Medium | Keyword in at least one image alt |
| Body content | Medium | Natural keyword density 1-3% (NOT keyword stuffing) |
| Internal link anchors | Low | Other pages link to this page using the keyword |

#### 3e: Image Optimization & Alt Text

```bash
# Find images without alt text
curl -s https://example.com/ | grep -oP '<img[^>]*>' | grep -v 'alt='
curl -s https://example.com/ | grep -oP '<img[^>]*>' | grep 'alt=""'

# Check image file sizes (large images kill page speed)
curl -s https://example.com/ | grep -oP 'src="([^"]*\.(jpg|jpeg|png|webp|gif))"' | head -10

# Check for modern formats (WebP/AVIF)
curl -s https://example.com/ | grep -oP 'src="[^"]*"' | grep -c "\.webp"
curl -s https://example.com/ | grep -oP 'src="[^"]*"' | grep -c "\.avif"

# Check for lazy loading
curl -s https://example.com/ | grep -c 'loading="lazy"'
```

**Checklist:**
- [ ] All images have descriptive `alt` text (not empty, not "image1.jpg")
- [ ] Alt text includes keywords where natural (not stuffed)
- [ ] Images use modern formats (WebP or AVIF) with fallbacks
- [ ] Images are properly sized (not 4000px wide scaled down in CSS)
- [ ] Lazy loading applied to below-the-fold images (`loading="lazy"`)
- [ ] Above-the-fold hero/LCP image is NOT lazy-loaded (harms LCP)
- [ ] Images have explicit `width` and `height` attributes (prevents CLS)

#### 3f: URL Structure

```bash
# Analyze URL patterns from sitemap
curl -s https://example.com/sitemap.xml | grep -oP '<loc>[^<]*</loc>' | sed 's/<[^>]*>//g' | head -30
```

**Checklist:**
- [ ] URLs are short, descriptive, and readable
- [ ] URLs use hyphens (not underscores or spaces)
- [ ] URLs include target keywords where natural
- [ ] No unnecessary parameters, session IDs, or tracking codes in indexable URLs
- [ ] Consistent structure (e.g., `/blog/post-title`, `/products/category/product-name`)
- [ ] No stop words unless needed for readability
- [ ] Lowercase only (no mixed case causing duplicates)

#### 3g: Content Length Analysis

```bash
# Estimate word count on key pages (strip HTML, count words)
for page in "/" "/about" "/blog/first-post" "/products"; do
  WORDS=$(curl -s "https://example.com$page" | sed 's/<[^>]*>//g' | tr -s ' \n' ' ' | wc -w)
  echo "$page | ~$WORDS words"
done
```

**Benchmarks by page type:**

| Page Type | Minimum | Recommended | Notes |
|-----------|---------|-------------|-------|
| Blog post | 800 | 1,500-2,500 | Longer for competitive keywords |
| Product page | 300 | 500-1,000 | Unique descriptions, not manufacturer copy |
| Category page | 200 | 300-500 | Intro text + products, not thin |
| Landing page | 500 | 1,000-2,000 | Depends on intent — transactional can be shorter |
| Homepage | 300 | 500-1,000 | Clear value proposition + supporting content |
| About page | 300 | 500-1,000 | E-E-A-T signal — establish credibility |

#### 3h: Keyword Cannibalization Detection

Keyword cannibalization occurs when multiple pages on the same site target the same keyword, causing them to compete against each other in search results.

**Detection method:**
1. Get the site's top pages from GSC (or estimate from sitemap/content)
2. For each target keyword, check if more than one page is optimized for it
3. Look for pages with similar titles, H1s, and content topics

```bash
# Find potential cannibalization by checking titles for repeated keywords
curl -s https://example.com/sitemap.xml | grep -oP '<loc>[^<]*</loc>' | sed 's/<[^>]*>//g' | while read url; do
  TITLE=$(curl -s "$url" | grep -oP '<title[^>]*>.*?</title>' | sed 's/<[^>]*>//g')
  echo "$url | $TITLE"
done | sort -t'|' -k2 | uniq -D -f1
# Review output for pages with identical or near-identical titles
```

**Resolution strategies:**
- Merge thin competing pages into one comprehensive page (301 redirect the losers)
- Differentiate intent (one page informational, one transactional)
- Use canonical tags if pages must both exist
- Adjust internal linking to concentrate equity on the preferred page

**On-Page SEO section scoring:** Average all sub-section scores for the On-Page SEO composite (weight: 25%).

---

### Step 4: Content Quality

Content quality directly influences E-E-A-T (Experience, Expertise, Authoritativeness, Trustworthiness) — Google's quality framework.

#### 4a: Thin Content Pages

Identify pages with insufficient content to rank or provide value:

```bash
# Find pages with very low word counts
curl -s https://example.com/sitemap.xml | grep -oP '<loc>[^<]*</loc>' | sed 's/<[^>]*>//g' | head -50 | while read url; do
  WORDS=$(curl -s "$url" | sed 's/<style[^>]*>.*<\/style>//g; s/<script[^>]*>.*<\/script>//g; s/<[^>]*>//g' | tr -s ' \n' ' ' | wc -w)
  if [ "$WORDS" -lt 300 ]; then
    echo "THIN [$WORDS words]: $url"
  fi
done
```

**What to check:**
- [ ] No indexable pages with < 200 words of unique body content
- [ ] Category/tag archive pages have intro text, not just links
- [ ] Product pages have unique descriptions (not manufacturer boilerplate)
- [ ] No auto-generated doorway pages
- [ ] Paginated pages add value (not just splitting content for ad impressions)

**Action:** Thin pages should be expanded with valuable content, consolidated via 301 redirects, or noindexed.

#### 4b: Content Freshness

```bash
# Check for date signals on blog/content pages
curl -s https://example.com/blog/ | grep -oP '(20[0-9]{2}[-/][01][0-9][-/][0-3][0-9]|January|February|March|April|May|June|July|August|September|October|November|December\s+[0-9]{1,2},?\s+20[0-9]{2})'

# Check sitemap lastmod dates
curl -s https://example.com/sitemap.xml | grep -oP '<lastmod>[^<]*</lastmod>' | sed 's/<[^>]*>//g' | sort | head -10
curl -s https://example.com/sitemap.xml | grep -oP '<lastmod>[^<]*</lastmod>' | sed 's/<[^>]*>//g' | sort -r | head -10
```

**What to check:**
- [ ] Blog/content published within the last 6 months (shows active site)
- [ ] Evergreen pages updated within the last 12 months
- [ ] Publication dates and "last updated" dates visible to users
- [ ] No outdated information (old prices, discontinued products, dead links)
- [ ] Content calendar exists (at least 2-4 new pieces per month for content-driven sites)

#### 4c: E-E-A-T Signals

E-E-A-T cannot be measured with a crawl tool — it requires manual evaluation:

| Signal | What to Look For | Score Impact |
|--------|-----------------|--------------|
| **Experience** | First-hand experience evident in content (personal anecdotes, original photos, case studies) | High for YMYL |
| **Expertise** | Author credentials, detailed technical accuracy, depth of coverage | High |
| **Authoritativeness** | Industry recognition, citations by others, speaking/publication history | Medium |
| **Trustworthiness** | Contact info, physical address, privacy policy, secure site, accurate claims | High for YMYL |

**Checklist:**
- [ ] Author bylines on content with link to author bio page
- [ ] Author bio pages with credentials, photo, social links
- [ ] About page with company history, team, mission
- [ ] Contact page with physical address, phone, email (not just a form)
- [ ] Privacy policy and terms of service pages
- [ ] Trust signals: testimonials, case studies, certifications, awards
- [ ] Sources cited for factual claims (especially YMYL content: health, finance, legal)
- [ ] No factual errors, outdated information, or misleading claims

#### 4d: Topical Authority Mapping

Topical authority means covering a subject comprehensively across multiple interlinked pages, not just one keyword per page.

**Assessment method:**
1. List all content pages by topic cluster
2. For each cluster, evaluate: number of pages, depth of coverage, internal linking between them
3. Compare against competitors — do they cover sub-topics you're missing?

```
── TOPICAL AUTHORITY MAP ──────────────────

Cluster: "Home Renovation"
  /blog/kitchen-remodel-cost          ✓ Pillar page
  /blog/kitchen-countertop-materials  ✓ Supporting
  /blog/kitchen-cabinet-styles        ✓ Supporting
  /blog/kitchen-lighting-guide        ✗ MISSING — competitors cover this
  /blog/kitchen-layout-mistakes       ✗ MISSING — competitors cover this
  Internal links between cluster:     3/6 possible connections made
  Authority score:                    60/100

Cluster: "Bathroom Renovation"
  /blog/bathroom-remodel-guide        ✓ Pillar page
  (no supporting pages)               ✗ Thin cluster
  Authority score:                    25/100
```

#### 4e: Content Gap Analysis vs Competitors

Compare the site's content coverage against 2-3 competitors:

**Manual method (when no API access):**
1. Review competitor sitemaps for topic coverage
2. Search `site:competitor.com` for their ranking content
3. Identify topics competitors cover that the target site does not
4. Prioritize gaps by search volume and business relevance

```bash
# Fetch competitor sitemaps for comparison
curl -s https://competitor1.com/sitemap.xml | grep -oP '<loc>[^<]*</loc>' | sed 's/<[^>]*>//g' > /tmp/competitor1_urls.txt
curl -s https://example.com/sitemap.xml | grep -oP '<loc>[^<]*</loc>' | sed 's/<[^>]*>//g' > /tmp/target_urls.txt

# Compare URL patterns and content topics
wc -l /tmp/competitor1_urls.txt /tmp/target_urls.txt
```

**Content gap report format:**

```
── CONTENT GAPS ───────────────────────────

Topic                        You    Comp A   Comp B   Est. Search Vol   Priority
"kitchen remodel financing"   ✗      ✓        ✓        2,400/mo         HIGH
"bathroom tile trends 2026"   ✗      ✓        ✗        1,800/mo         HIGH
"how to hire a contractor"    ✗      ✓        ✓        5,200/mo         MEDIUM
"DIY vs professional remodel" ✗      ✗        ✓        900/mo           LOW
```

**Content Quality section scoring:** Average sub-section scores (weight: 20%).

---

### Step 5: Off-Page Signals

Off-page SEO evaluates the site's authority and reputation through external signals, primarily backlinks.

> **Note:** Full backlink analysis requires tools like Ahrefs, Semrush, Moz, or Majestic. Without API access, this section uses free alternatives and manual checks. Recommend the user access these tools for comprehensive data.

#### 5a: Backlink Profile Overview

```bash
# Quick external link check using free tools
# Option 1: Check referring pages via Google (limited)
# Search: link:example.com (deprecated but sometimes shows results)

# Option 2: Use free tier of backlink checkers
# - Ahrefs Webmaster Tools (free, limited): https://ahrefs.com/webmaster-tools
# - Moz Link Explorer (free, 10 queries/mo): https://moz.com/link-explorer
# - Ubersuggest (free tier available): https://neilpatel.com/ubersuggest/

# Check if the site appears in major directories/aggregators
for domain in "wikipedia.org" "crunchbase.com" "bbb.org" "yelp.com"; do
  echo "=== $domain ==="
  curl -s "https://www.google.com/search?q=site:${domain}+%22example.com%22" -H "User-Agent: Mozilla/5.0" | grep -c "example.com" || echo "Manual check needed"
done
```

**Metrics to collect (from backlink tools):**

| Metric | Healthy Range | Warning Signs |
|--------|--------------|---------------|
| Domain Rating / Authority | 20+ for new sites, 40+ for established | Sudden drops indicate lost links |
| Referring Domains | Growing over time | Flat or declining = stagnation |
| Total Backlinks | More than referring domains (natural) | 100:1 backlink:domain ratio = spammy |
| Dofollow vs Nofollow | 60-80% dofollow | >95% dofollow is suspicious |
| Link velocity | Steady growth | Spikes followed by drops = purchased links |

#### 5b: Referring Domain Quality

**Evaluate the quality distribution of referring domains:**

| Quality Tier | Characteristics | Examples |
|-------------|-----------------|----------|
| **Tier 1 (Elite)** | DR 70+, relevant, editorial | Major publications, industry leaders |
| **Tier 2 (Strong)** | DR 40-69, relevant, natural | Industry blogs, local news, partners |
| **Tier 3 (Average)** | DR 20-39, somewhat relevant | Small blogs, directories, forums |
| **Tier 4 (Low)** | DR < 20, irrelevant or thin | New sites, low-quality directories |
| **Toxic** | Spam, PBN, link farms, adult/gambling | Disavow candidates |

#### 5c: Anchor Text Distribution

**Healthy anchor text profile:**

| Anchor Type | Healthy % | Risk If Over-Optimized |
|-------------|----------|----------------------|
| Branded ("Example Co") | 30-50% | Low risk |
| Naked URL ("example.com") | 15-25% | Low risk |
| Generic ("click here", "learn more") | 10-20% | Low risk |
| Exact match keyword ("best kitchen remodeling") | 5-10% | HIGH risk if >15% — Penguin penalty signal |
| Partial match ("kitchen remodel guide") | 10-20% | Medium risk if >25% |
| Image (no text, alt tag used) | 5-10% | Low risk |

**Red flag:** If exact-match keyword anchors exceed 15% of total anchors, the site may be at risk for a Google Penguin algorithmic penalty.

#### 5d: Toxic Link Identification

**Signs of toxic backlinks:**
- Links from sites in completely unrelated industries (adult, gambling, pharma for a home renovation site)
- Links from known Private Blog Networks (PBNs) — thin content, same hosting, interlinking patterns
- Links from sites with foreign-language content unrelated to the business
- Links from hacked sites or pages with injected content
- Excessive links from comment spam, forum signatures, or article directories
- Links from sites with Google penalties

**Action:** If toxic links are found, prepare a Google Disavow file:
```
# Disavow file format (upload to Google Search Console)
# https://search.google.com/search-console/disavow-links

# Individual URLs
https://spamsite.com/page-linking-to-us

# Entire domains
domain:toxicsite.com
domain:spamblog.net
```

#### 5e: Competitor Backlink Comparison

Compare the target site's link profile against 2-3 competitors:

```
── BACKLINK COMPARISON ────────────────────

Metric                  You        Comp A      Comp B      Gap
Domain Rating           25         48          52          -23 to -27
Referring Domains       120        890         1,240       -770 to -1,120
Backlinks (total)       340        4,200       6,800       Significant gap
Links from .edu/.gov    0          3           7           Missing authority signals
Links from DR 50+       2          34          51          Key gap
Top anchor keyword      12%        6%          8%          You: over-optimized
Content with links      8 pages    45 pages    62 pages    Need more linkable assets
```

**Off-Page Signals section scoring:** Based on available data (weight: 15%).

---

### Step 6: Local SEO Quick Check

**Only perform this section if the business serves a geographic area.** If the site is a SaaS product, purely online business, or has no physical location, skip this section and redistribute its 10% weight to Technical SEO (+5%) and Content Quality (+5%).

#### 6a: Google Business Profile

**Manual checks (GBP cannot be crawled programmatically):**
- [ ] Google Business Profile claimed and verified
- [ ] Business name matches website exactly (no keyword stuffing in GBP name)
- [ ] Correct primary and secondary categories selected
- [ ] Business hours accurate and up to date
- [ ] High-quality photos uploaded (exterior, interior, team, products)
- [ ] Business description present and keyword-optimized
- [ ] Products/services listed
- [ ] Google Posts active (at least monthly)
- [ ] Q&A section monitored
- [ ] Reviews being responded to (both positive and negative)

#### 6b: NAP Consistency

NAP = Name, Address, Phone. Must be consistent across all listings.

```bash
# Check NAP on the website
curl -s https://example.com/contact | grep -oP '(\(\d{3}\)\s*\d{3}[-.\s]?\d{4}|\d{3}[-.\s]\d{3}[-.\s]\d{4})'
curl -s https://example.com/ | grep -oP '(\(\d{3}\)\s*\d{3}[-.\s]?\d{4}|\d{3}[-.\s]\d{3}[-.\s]\d{4})'

# Check footer for address
curl -s https://example.com/ | grep -i "address\|street\|suite\|floor\|city\|state\|zip"
```

**Checklist:**
- [ ] NAP is consistent on every page of the website (usually in footer)
- [ ] NAP matches Google Business Profile exactly
- [ ] NAP matches across major directories (Yelp, BBB, Yellow Pages, industry-specific)
- [ ] Phone number is local (not toll-free, unless that's the primary business number)
- [ ] Address format is consistent (no "St." vs "Street" vs "st" variations)

#### 6c: Local Schema Markup

```bash
# Check for LocalBusiness schema
curl -s https://example.com/ | grep -oP '<script type="application/ld\+json">.*?</script>' | sed 's/<[^>]*>//g' | jq 'select(.["@type"] | test("Business|Store|Restaurant|Hotel|Medical|Legal|Financial"; "i"))' 2>/dev/null
```

**Required properties for LocalBusiness schema:**
- [ ] `@type` — Specific subtype (e.g., `Plumber`, `Restaurant`, not just `LocalBusiness`)
- [ ] `name` — Matches GBP and NAP
- [ ] `address` — Full `PostalAddress` object
- [ ] `telephone` — Matches NAP
- [ ] `openingHours` or `openingHoursSpecification`
- [ ] `geo` — `GeoCoordinates` with lat/long
- [ ] `url` — Canonical website URL
- [ ] `image` — Business photos
- [ ] `areaServed` — Service area if applicable

#### 6d: Citation Sources

Top citation sources to verify (varies by country and industry):

**US General:**
Google Business Profile, Yelp, BBB, Yellow Pages, Apple Maps, Bing Places, Facebook, Foursquare/Swarm, Nextdoor, Angi (HomeAdvisor)

**Industry-specific examples:**
- Restaurants: TripAdvisor, OpenTable, Zomato, DoorDash
- Healthcare: Healthgrades, Zocdoc, Vitals, WebMD
- Legal: Avvo, FindLaw, Justia
- Real Estate: Zillow, Realtor.com, Redfin

**Local SEO section scoring:** Average sub-section scores (weight: 10%, or 0% if not applicable).

---

### Step 7: Prioritized Action Plan

After completing Steps 2-6, compile all findings into a prioritized action plan using the Impact/Effort matrix:

#### Priority Matrix

```
                    LOW EFFORT                    HIGH EFFORT
              ┌─────────────────────┬─────────────────────┐
   HIGH       │                     │                     │
   IMPACT     │    🔥 QUICK WINS    │   📋 MAJOR PROJECTS │
              │    Do these first   │   Plan & schedule   │
              │                     │                     │
              ├─────────────────────┼─────────────────────┤
   LOW        │                     │                     │
   IMPACT     │    ✅ FILL-INS      │   ⏭️ DEPRIORITIZE   │
              │    Do when free     │   Revisit later     │
              │                     │                     │
              └─────────────────────┴─────────────────────┘
```

#### Impact Scoring Guide

| Impact Level | SEO Effect | Examples |
|-------------|-----------|----------|
| **Critical** (10) | Blocking indexing or causing penalties | Noindex on important pages, site-wide redirect loop, manual action |
| **High** (7-9) | Significant ranking improvement expected | Missing title tags, thin content on money pages, broken canonicals |
| **Medium** (4-6) | Moderate ranking improvement expected | Missing meta descriptions, image alt text gaps, internal linking gaps |
| **Low** (1-3) | Minor or indirect ranking effect | Schema markup additions, URL cleanup, minor speed improvements |

#### Effort Scoring Guide

| Effort Level | Time Required | Examples |
|-------------|---------------|----------|
| **Quick** (1-2) | < 1 hour | Fix a meta tag, add a 301 redirect, update robots.txt |
| **Easy** (3-4) | 1-4 hours | Write meta descriptions for 20 pages, add schema markup |
| **Moderate** (5-7) | 1-3 days | Create missing content pages, fix site speed issues, rebuild internal linking |
| **Major** (8-10) | 1+ weeks | Site migration, comprehensive content overhaul, link building campaign |

#### Timeline Recommendations

| Phase | Timeframe | Focus |
|-------|-----------|-------|
| **Phase 1: Critical Fixes** | Week 1 | Fix anything blocking indexing, fix penalties, fix broken redirects |
| **Phase 2: Quick Wins** | Weeks 2-3 | Title tags, meta descriptions, alt text, canonical fixes, robots.txt |
| **Phase 3: Content** | Weeks 4-8 | Fill content gaps, expand thin pages, update stale content |
| **Phase 4: Authority** | Ongoing | Link building, brand mentions, digital PR, citation building |
| **Phase 5: Optimization** | Monthly | Monitor rankings, refine pages, A/B test titles, expand clusters |

---

### Step 8: Output — Final Audit Report

Generate the complete report in this format:

```
━━━ SEO SITE AUDIT REPORT ━━━━━━━━━━━━━━━━━

── OVERVIEW ───────────────────────────────
Site:           [URL]
Date:           [audit date]
Auditor:        Claude (AI-assisted audit)
CMS:            [CMS/stack]
Pages Analyzed: [count]
Business Type:  [type]

── OVERALL SCORE ──────────────────────────

  ██████████████░░░░░░  72/100 (Grade: C)

  Technical SEO:    78/100  (weight: 30%)
  On-Page SEO:      65/100  (weight: 25%)
  Content Quality:  70/100  (weight: 20%)
  Off-Page Signals: 55/100  (weight: 15%)
  Local SEO:        82/100  (weight: 10%)

── CRITICAL ISSUES (Fix Immediately) ──────
ID   Issue                        Section       Impact   Effort
C1   Homepage has noindex tag     Indexability   10       1
C2   Redirect chain on /products  Redirects      8       2
C3   Missing SSL redirect         HTTPS          9       1

── HIGH PRIORITY ISSUES ───────────────────
ID   Issue                        Section       Impact   Effort
H1   12 pages missing title tags  On-Page        8       3
H2   No XML sitemap found         Crawlability   7       2
H3   LCP > 4.0s on mobile         Speed          8       5
H4   Thin content on 8 pages      Content        7       6

── MEDIUM PRIORITY ISSUES ─────────────────
ID   Issue                        Section       Impact   Effort
M1   23 images missing alt text   On-Page        5       3
M2   No structured data found     Technical      5       4
M3   Duplicate meta descriptions  On-Page        4       3
M4   Internal linking gaps        Technical      5       5

── LOW PRIORITY ISSUES ────────────────────
ID   Issue                        Section       Impact   Effort
L1   URL trailing slash inconsist Technical      2       2
L2   Missing breadcrumb schema    Technical      3       3
L3   About page < 300 words       Content        2       2

── QUICK WINS (Do This Week) ──────────────
1. [C1] Remove noindex tag from homepage (5 min fix, massive impact)
2. [C3] Add HTTP -> HTTPS 301 redirect (15 min fix)
3. [H2] Generate and submit XML sitemap (30 min fix)
4. [C2] Fix redirect chain to single 301 (15 min fix)

── CONTENT GAPS ───────────────────────────
[List topics competitors rank for that this site doesn't cover]

── COMPETITOR COMPARISON ──────────────────
Metric               You      Comp A    Comp B    Gap
Domain Authority      [x]      [y]       [z]      [diff]
Indexed Pages         [x]      [y]       [z]      [diff]
Blog Posts (6mo)      [x]      [y]       [z]      [diff]
Referring Domains     [x]      [y]       [z]      [diff]

── 90-DAY ACTION PLAN ─────────────────────
Week 1:     Critical fixes (C1-C3)
Weeks 2-3:  High priority fixes (H1-H4)
Weeks 4-6:  Medium priority fixes (M1-M4)
Weeks 7-12: Content creation for gaps + link building outreach
Ongoing:    Monthly re-audit, weekly content publishing

── TOOLS RECOMMENDED ──────────────────────
- Google Search Console (free) — crawl/index monitoring
- Google Analytics (free) — traffic tracking
- Ahrefs/Semrush (paid) — backlink monitoring + rank tracking
- Screaming Frog (free up to 500 URLs) — technical crawl
- PageSpeed Insights (free) — Core Web Vitals monitoring
```

---

## Anti-Patterns

| Anti-Pattern | Why It's Wrong | Correct Approach |
|-------------|----------------|------------------|
| Auditing only the homepage | 90% of SEO issues live on interior pages | Audit a representative sample across page types |
| Checking desktop only | Google uses mobile-first indexing | Always audit mobile performance first |
| Obsessing over keyword density | Google uses semantic understanding, not counting | Focus on natural keyword placement and topic coverage |
| Ignoring Core Web Vitals | CWV are confirmed ranking signals | Measure and improve LCP, INP, CLS |
| Auditing without target keywords | Can't evaluate on-page optimization without targets | Always establish target keywords before on-page audit |
| Treating all pages equally | Money pages deserve more attention than utility pages | Weight findings by the page's business value |
| Running Lighthouse once | Performance varies 10-20% between runs | Run 3-5 times and take median values |
| Ignoring competitor context | Scores mean nothing without relative comparison | Always benchmark against actual SERP competitors |
| Recommending everything at once | Overwhelming the client kills execution | Prioritize by impact/effort; phase over 90 days |
| Skipping the action plan | An audit without next steps is just criticism | Every finding must have a specific remediation step |
| Checking only technical SEO | Content and off-page often matter more for rankings | Full audit covers all five pillars |
| Using outdated metrics | DA/PA, keyword density, exact match domains | Use current Google signals: CWV, E-E-A-T, topical authority |

## Escalation

Hand off to a specialist or recommend paid tools when:
- The site has **10,000+ pages** — manual sampling is insufficient; use Screaming Frog, Sitebulb, or Lumar for full crawls
- The site has a **manual action** in Google Search Console — requires experienced SEO practitioner
- A **site migration** is needed (domain change, CMS switch, URL restructure) — high-risk operation requiring detailed planning
- **International SEO** with hreflang implementation — complex and easy to misconfigure
- **Backlink disavow** is recommended — incorrect disavow can harm more than help
- The site is in a **YMYL niche** (health, finance, legal) — E-E-A-T requirements are much stricter
- **JavaScript rendering issues** are suspected — requires specialized tools (e.g., rendertron, Google's URL Inspection)
- **Programmatic SEO** at scale — auto-generated pages need careful quality controls
- The client needs **ongoing rank tracking and reporting** — recommend Ahrefs, Semrush, or SE Ranking

## Inputs

- Site URL (required)
- CMS / tech stack (helpful)
- Target keywords (5-10 priority terms)
- Competitor URLs (2-3 for benchmarking)
- Google Search Console data export (if available)
- Google Analytics traffic data (if available)
- Business type and geographic target
- Known issues or recent changes (migrations, redesigns, ranking drops)

## Outputs

- Overall SEO health score (0-100) with letter grade
- Section-by-section scores with weighted breakdown
- Complete issues table with severity, impact, and effort ratings
- Technical SEO crawl findings (robots.txt, sitemap, canonicals, indexability, speed, mobile, SSL, structured data, internal links, redirects, duplicates)
- On-page optimization findings (titles, metas, headings, keywords, images, URLs, content length, cannibalization)
- Content quality assessment (thin content, freshness, E-E-A-T, topical authority, content gaps)
- Off-page signals overview (backlink profile, referring domains, anchor text, toxic links, competitor comparison)
- Local SEO quick check (if applicable)
- Prioritized action plan with impact/effort matrix
- Quick wins list (high impact, low effort fixes)
- 90-day phased timeline
- Tool recommendations for ongoing monitoring
- Competitor comparison table

## Level History

- **Lv.1** — Full implementation: Comprehensive 8-step SEO audit protocol covering technical SEO (crawlability, indexability, speed, mobile, SSL, structured data, internal linking, redirects, duplicate content), on-page SEO (titles, metas, headings, keywords, images, URLs, content length, cannibalization), content quality (thin content, freshness, E-E-A-T, topical authority, content gaps), off-page signals (backlink profile, referring domains, anchor text, toxic links, competitor comparison), local SEO quick check, prioritized action plan with impact/effort matrix, and scored audit report. Includes CLI commands, scoring rubrics, anti-patterns, and escalation criteria. (Origin: MemStack skill replacement, Mar 2026)
