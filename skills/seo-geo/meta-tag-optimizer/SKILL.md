---
name: meta-tag-optimizer
description: "Use when the user says 'meta tags', 'title tag', 'meta description', 'optimize meta', 'SERP preview', or needs to write or optimize HTML meta tags for better search visibility and click-through rates. Do NOT use for schema markup (see schema-markup) or full site audits (see site-audit)."
---

# Meta Tag Optimizer — SERP Visibility & CTR Optimization
*Write and optimize HTML meta tags for better search engine visibility and click-through rates — covering title tags, meta descriptions, Open Graph, technical meta tags, and SERP preview testing.*

## Activation

When this skill activates, output:

`Meta Tag Optimizer — Optimizing your meta tags...`

| Context | Status |
|---------|--------|
| **User says "meta tags", "title tag", "meta description", "optimize meta"** | ACTIVE |
| **User says "SERP preview", "search snippet", "click-through rate"** | ACTIVE |
| **User wants to write or rewrite title tags and descriptions** | ACTIVE |
| **User wants Open Graph or Twitter Card tags** | ACTIVE |
| **User wants canonical tags, robots meta, or hreflang guidance** | ACTIVE |
| **User wants to optimize meta tags for multiple pages in bulk** | ACTIVE |
| **User wants schema markup / structured data (JSON-LD)** | DORMANT — see schema-markup |
| **User wants a full site SEO audit** | DORMANT — see site-audit |
| **User wants keyword research only** | DORMANT — see keyword-research |
| **User wants AI search / GEO optimization** | DORMANT — see ai-search-visibility |
| **User wants local SEO / Google Business optimization** | DORMANT — see local-seo |

---

## Protocol

### Step 1: Gather Inputs

Ask the user for the following. Items marked **(required)** must be answered before proceeding; others improve output quality.

- **URL or page list** (required): The page(s) to optimize. Can be a single URL, a list of URLs, or a sitemap URL for bulk work.
- **Target keywords per page** (required): The primary and secondary keywords each page should rank for. If unknown, recommend running keyword-research first.
- **Brand name** (required): Used for title tag brand positioning (e.g., "Acme Corp", "ShopEase").
- **Page type**: Homepage, product, blog post, category/collection, service, landing page, about, contact, FAQ? Determines which template formulas apply.
- **Current meta tags** (helpful): Existing title tags and meta descriptions. Provide the HTML or let the skill fetch them:

```bash
# Fetch current meta tags from a live URL
URL="https://example.com"
echo "=== Title Tag ==="
curl -sL "$URL" | grep -oP '<title[^>]*>.*?</title>' | sed 's/<[^>]*>//g'
echo "=== Meta Description ==="
curl -sL "$URL" | grep -oP '<meta\s+name="description"\s+content="[^"]*"' | sed 's/.*content="//;s/"$//'
echo "=== Open Graph ==="
curl -sL "$URL" | grep -oP '<meta\s+property="og:[^"]*"\s+content="[^"]*"[^>]*/?' | head -10
echo "=== Twitter Card ==="
curl -sL "$URL" | grep -oP '<meta\s+name="twitter:[^"]*"\s+content="[^"]*"[^>]*/?' | head -10
echo "=== Canonical ==="
curl -sL "$URL" | grep -oP '<link\s+rel="canonical"\s+href="[^"]*"'
echo "=== Robots ==="
curl -sL "$URL" | grep -oP '<meta\s+name="robots"\s+content="[^"]*"'
```

- **Industry / niche**: Helps calibrate tone (B2B SaaS vs e-commerce vs local service).
- **Brand separator preference**: The character between page title and brand name. Common options: `|`, `—`, `-`, `:`. Default is `|`.
- **Tone**: Professional, casual, urgent, luxury, technical? Affects word choice in titles and descriptions.
- **Character limit preference**: Some teams prefer conservative limits (50 chars title, 120 chars description) for guaranteed no-truncation. Default uses Google's standard pixel-based thresholds.

**If the user provides only a URL**, fetch the current tags, infer the page type and keywords from the content, and proceed with reasonable defaults. Note assumptions in the output.

---

### Step 2: Title Tag Optimization

The `<title>` tag is the single most important on-page SEO element. It appears as the blue clickable headline in search results and browser tabs.

#### 2a: Character and Pixel Limits

Google truncates title tags based on **pixel width**, not character count. The display width varies by character (e.g., "W" is wider than "i").

| Display | Pixel Limit | Safe Character Range | Truncation Behavior |
|---------|------------|---------------------|---------------------|
| Desktop | ~580px | 50-60 characters | Truncated with "..." |
| Mobile | ~920px (wider viewport ratio) | 55-70 characters | More forgiving but still truncates |

**Rules:**
- Target **50-60 characters** including spaces and brand suffix
- Front-load the primary keyword — truncation cuts from the right
- If the title exceeds 60 characters, ensure the most important information is in the first 50
- Never rely on characters beyond position 60 being visible
- Google may rewrite your title tag if it considers it low quality, stuffed, or mismatched with the page content

#### 2b: Keyword Placement Rules

| Rule | Rationale | Example |
|------|-----------|---------|
| Primary keyword first or near-first | Earlier keywords carry slightly more weight; also survives truncation | "Project Management Software for Remote Teams \| Acme" |
| One primary keyword per title | Multiple keywords dilute relevance signals | NOT: "Project Management Software, Task Tracker, Team Tool" |
| Secondary keyword if it fits naturally | Adds ranking breadth without stuffing | "Best CRM Software for Small Business \| Acme" (primary: CRM software, secondary: small business) |
| Brand name at the end | Builds recognition without displacing keywords | "Cloud Hosting Plans & Pricing \| Acme" |
| Never duplicate exact keywords | Google treats this as spam | NOT: "SEO Tools - Best SEO Tools for SEO" |

#### 2c: Title Tag Formulas by Page Type

**Homepage:**
```
[Primary Keyword] — [Value Proposition] | [Brand]
```
Examples:
```html
<title>Project Management Software for Remote Teams | Acme</title>
<title>Custom Wedding Cakes in Austin, TX — Made Fresh Daily | Sweet Layers</title>
<title>Affordable Web Hosting — 99.9% Uptime Guarantee | CloudBase</title>
```

**Product Page:**
```
[Product Name] — [Key Benefit or Differentiator] | [Brand]
```
Examples:
```html
<title>ProTask Dashboard — Visual Project Tracking for Agile Teams | Acme</title>
<title>Organic Lavender Face Cream — Hydrating & Fragrance-Free | PureSkin</title>
<title>14" Laptop Stand — Adjustable Aluminum, Folds Flat | DeskCraft</title>
```

**Blog Post / Article:**
```
[Primary Keyword]: [Compelling Hook or Promise] | [Brand]
```
Examples:
```html
<title>How to Write a Business Plan: 9 Steps (With Free Template) | Acme</title>
<title>React vs Vue in 2026: Which Frontend Framework Wins? | DevBlog</title>
<title>10 Kitchen Remodel Mistakes That Cost Homeowners Thousands | RemodelPro</title>
```

**Category / Collection Page:**
```
[Category Keyword] — [Qualifier: Browse/Shop/Explore] [Count or Range] | [Brand]
```
Examples:
```html
<title>Women's Running Shoes — Shop 200+ Styles from $49 | ShoeVault</title>
<title>WordPress Hosting Plans — Managed, Fast & Secure | CloudBase</title>
<title>Living Room Furniture — Sofas, Tables & Storage | HomeStyle</title>
```

**Service Page:**
```
[Service Keyword] in [Location] — [Trust Signal] | [Brand]
```
Examples:
```html
<title>Emergency Plumbing in Austin, TX — 24/7, Licensed & Insured | AquaFix</title>
<title>Tax Preparation Services — CPA-Reviewed, Guaranteed Accuracy | TaxEase</title>
<title>Residential Roofing in Dallas — Free Estimates, 10-Year Warranty | RoofRight</title>
```

**Landing Page:**
```
[Action Verb] [Primary Keyword] — [Urgency/Benefit] | [Brand]
```
Examples:
```html
<title>Start Your Free Trial — Project Management Made Simple | Acme</title>
<title>Get a Free Roof Inspection — Same-Day Scheduling Available | RoofRight</title>
<title>Download the 2026 SEO Checklist — 47-Point Audit Template | RankLab</title>
```

#### 2d: Power Words and Emotional Triggers

Power words increase CTR by creating curiosity, urgency, or perceived value. Use sparingly — one per title maximum.

| Category | Power Words | When to Use |
|----------|------------|-------------|
| **Urgency** | Now, Today, Fast, Instant, Quick, Limited | Sales pages, time-sensitive offers |
| **Value** | Free, Affordable, Best, Top, Ultimate, Complete | Blog posts, comparisons, resource pages |
| **Curiosity** | Surprising, Secret, Hidden, Little-Known, Unexpected | Blog posts, editorial content |
| **Trust** | Proven, Guaranteed, Certified, Official, Trusted | Service pages, product pages |
| **Numbers** | 7 Steps, 10 Tips, 50+ Options, 2026 Guide | Listicles, how-to articles |
| **Specificity** | Exact, Step-by-Step, Complete, Definitive, In-Depth | Guides, tutorials, comprehensive content |
| **Negative** | Mistakes, Avoid, Stop, Never, Worst | Problem-aware blog posts, cautionary content |

**Example — before and after power words:**
```
Before: "Guide to Email Marketing"
After:  "Email Marketing: The Complete Guide for 2026 (With Templates)"

Before: "Project Management Tips"
After:  "7 Proven Project Management Tips That Save 10+ Hours/Week"

Before: "How to Lose Weight"
After:  "How to Lose Weight Fast: 5 Science-Backed Methods (No Fads)"
```

#### 2e: Title Tag Validation Checklist

- [ ] Length: 50-60 characters including brand suffix
- [ ] Primary keyword appears within the first 50 characters
- [ ] Brand name is present (typically after separator at the end)
- [ ] No duplicate title tags across the site
- [ ] No ALL CAPS words (except brand acronyms like "IBM")
- [ ] No keyword stuffing or repetition
- [ ] Compelling enough to earn a click over competing results
- [ ] Accurately describes the page content (Google penalizes misleading titles)
- [ ] Uses a consistent separator character across the site

---

### Step 3: Meta Description Optimization

The `<meta name="description">` tag does NOT directly affect rankings, but it significantly impacts click-through rate. Google displays it as the gray snippet text below the title in search results. If missing or poor, Google auto-generates one from page content — which is usually worse.

#### 3a: Character and Pixel Limits

| Display | Pixel Limit | Safe Character Range | Notes |
|---------|------------|---------------------|-------|
| Desktop | ~920px | 120-160 characters | Google often truncates at 155-160 |
| Mobile | ~680px | 100-120 characters | More aggressive truncation |

**Rules:**
- Target **120-155 characters** for guaranteed full display on desktop
- Front-load the most compelling information in the first 100 characters for mobile safety
- Google bolds keyword matches in the description — include target keywords naturally
- Ensure the description reads as a complete, coherent sentence (not a keyword list)
- Google may ignore your meta description and generate its own if it considers yours irrelevant to the search query

#### 3b: Meta Description Anatomy

Every high-performing meta description contains three components:

```
[Keyword-Rich Hook] + [Unique Value Proposition] + [Call to Action]
```

**Keyword-Rich Hook** (first 40-60 chars): Establishes relevance. Include the primary keyword. Google bolds matched terms.

**Unique Value Proposition** (next 40-60 chars): Differentiate from the 9 other results on the page. Answer "why this result?"

**Call to Action** (final 20-40 chars): Tell the searcher what to do. Creates a reason to click NOW.

#### 3c: CTA Patterns for Meta Descriptions

| CTA Type | Examples | Best For |
|----------|---------|----------|
| **Direct action** | "Get started free." / "Shop now." / "Book today." | Product, service, landing pages |
| **Learn more** | "Read the full guide." / "See all 50 tips." / "Learn how." | Blog posts, educational content |
| **Discover** | "Find out which is right for you." / "Discover the difference." | Comparison, category pages |
| **Social proof** | "Join 10,000+ teams." / "Trusted by Fortune 500 companies." | SaaS, B2B service pages |
| **Urgency** | "Limited spots available." / "Offer ends Friday." | Sales, event, promotion pages |
| **Value** | "Free template included." / "No credit card required." | Lead magnets, free trials |

#### 3d: Meta Description Templates by Page Type

**Homepage:**
```html
<meta name="description" content="[Brand] helps [audience] [achieve outcome] with [key feature/differentiator]. [CTA — e.g., Start your free trial today.]">
```
Example:
```html
<meta name="description" content="Acme helps remote teams ship projects faster with visual task boards, real-time collaboration, and automated workflows. Start your free trial today.">
```
Character count: 155

**Product Page:**
```html
<meta name="description" content="[Product] features [key benefit 1] and [key benefit 2]. [Differentiator — price, material, specs]. [CTA]">
```
Example:
```html
<meta name="description" content="ProTask Dashboard gives your team visual project tracking with drag-and-drop boards, Gantt charts, and time tracking built in. Try it free for 14 days.">
```
Character count: 153

**Blog Post:**
```html
<meta name="description" content="[What the reader will learn]. Covers [topic 1], [topic 2], and [topic 3]. [Value-add — templates, examples, data]. [CTA]">
```
Example:
```html
<meta name="description" content="Learn how to write a business plan in 9 clear steps. Covers market analysis, financial projections, and executive summaries. Free downloadable template included.">
```
Character count: 160

**Category Page:**
```html
<meta name="description" content="Browse [count]+ [products/items] in [category]. [Filter/sort options or brand names]. [Shipping/pricing incentive]. [CTA]">
```
Example:
```html
<meta name="description" content="Browse 200+ women's running shoes from Nike, Adidas, and Brooks. Filter by size, cushion type, and price. Free shipping on orders over $75. Shop now.">
```
Character count: 152

**Service Page:**
```html
<meta name="description" content="[Service] in [location] by [trust signal — licensed, certified, years experience]. [Key differentiator]. [CTA — free quote, call now]">
```
Example:
```html
<meta name="description" content="Licensed emergency plumbing in Austin, TX. Available 24/7 with 60-minute response times. No overtime charges on weekends. Call for a free estimate today.">
```
Character count: 155

**Landing Page:**
```html
<meta name="description" content="[Offer description] — [what's included]. [Social proof or trust signal]. [Urgency or CTA]">
```
Example:
```html
<meta name="description" content="Download the 2026 SEO Checklist — a 47-point audit template used by 5,000+ marketers. Covers technical SEO, content, and link building. Free instant download.">
```
Character count: 158

#### 3e: Meta Description Validation Checklist

- [ ] Length: 120-155 characters (aim for 150 sweet spot)
- [ ] Contains the primary keyword (for bold matching in SERPs)
- [ ] Includes a clear call-to-action
- [ ] Communicates unique value — answers "why click THIS result?"
- [ ] Reads as a natural sentence, not a keyword list
- [ ] No duplicate descriptions across the site
- [ ] No quotation marks within the content attribute (they cause truncation in SERPs)
- [ ] Accurately reflects page content (mismatches increase bounce rate)
- [ ] Compelling enough to compete with the other 9 organic results

---

### Step 4: Open Graph and Twitter Card Tags

Open Graph (OG) tags control how pages appear when shared on Facebook, LinkedIn, Slack, Discord, iMessage, and most social platforms. Twitter Card tags control Twitter/X previews. These tags do not affect SEO ranking but dramatically impact social CTR and referral traffic.

#### 4a: Essential Open Graph Tags

```html
<!-- Required OG tags -->
<meta property="og:title" content="How to Write a Business Plan in 9 Steps (Free Template)">
<meta property="og:description" content="Step-by-step guide to writing a business plan that investors actually read. Includes free downloadable template and real examples.">
<meta property="og:image" content="https://example.com/images/business-plan-guide-og.jpg">
<meta property="og:url" content="https://example.com/blog/how-to-write-business-plan">
<meta property="og:type" content="article">
<meta property="og:site_name" content="Acme Blog">

<!-- Optional but recommended -->
<meta property="og:locale" content="en_US">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
<meta property="og:image:alt" content="Business plan template with financial projections spreadsheet">
```

#### 4b: OG Tag Rules

| Tag | Rules | Common Mistakes |
|-----|-------|----------------|
| `og:title` | Can differ from `<title>` — optimize for social, not search. No brand suffix needed. Max 60-90 chars. | Using the exact `<title>` tag with "\| Brand" suffix looks awkward on social |
| `og:description` | More conversational than meta description. 2-3 sentences. Max 200 chars visible on most platforms. | Leaving empty — platform auto-scrapes random page text |
| `og:image` | **Minimum 1200x630px** (1.91:1 ratio). JPG or PNG. Max 8MB. Must be an absolute URL. | Using a tiny logo, relative path, or no image at all |
| `og:url` | Canonical URL of the page. Must be absolute (include https://). | Using a tracking URL or relative path |
| `og:type` | `website` for homepage, `article` for blog posts, `product` for products. | Using `website` for everything |

#### 4c: OG Image Specifications

| Platform | Recommended Size | Aspect Ratio | Notes |
|----------|-----------------|--------------|-------|
| Facebook | 1200x630px | 1.91:1 | Minimum 600x315px; below this, image displays as small thumbnail |
| LinkedIn | 1200x627px | 1.91:1 | Very similar to Facebook |
| Slack | 1200x630px | 1.91:1 | Also supports animated GIFs |
| Discord | 1200x630px | 1.91:1 | Embeds appear in chat |
| iMessage | 1200x630px | 1.91:1 | Preview card in message bubble |
| Pinterest | 1000x1500px | 2:3 (vertical) | Pinterest prefers tall images — use `pinterest:image` if needed |

**Image best practices:**
- Use **text on the image** sparingly — make it readable at small sizes
- Avoid text in the outer 10% margins (cropping varies by platform)
- Use high-contrast, visually distinct images — they compete for attention in feeds
- Host on the same domain or a CDN with proper CORS headers
- Always specify `og:image:width` and `og:image:height` — prevents layout shift on platforms

#### 4d: Twitter Card Tags

Twitter (X) uses its own meta tag namespace but falls back to OG tags if Twitter tags are missing.

**Summary Card (small image, text-heavy):**
```html
<meta name="twitter:card" content="summary">
<meta name="twitter:site" content="@acmecorp">
<meta name="twitter:title" content="How to Write a Business Plan in 9 Steps">
<meta name="twitter:description" content="Step-by-step guide with free template. Covers market analysis, financial projections, and pitch deck essentials.">
<meta name="twitter:image" content="https://example.com/images/business-plan-square.jpg">
```
- Image: minimum 144x144px, recommended 600x600px (1:1 ratio)
- Use for: articles, blog posts, general pages

**Summary Large Image (large hero image):**
```html
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:site" content="@acmecorp">
<meta name="twitter:creator" content="@authorhandle">
<meta name="twitter:title" content="How to Write a Business Plan in 9 Steps">
<meta name="twitter:description" content="Step-by-step guide with free template and real examples from funded startups.">
<meta name="twitter:image" content="https://example.com/images/business-plan-guide-og.jpg">
<meta name="twitter:image:alt" content="Business plan template layout with financial charts">
```
- Image: minimum 300x157px, recommended 1200x628px (1.91:1 ratio — same as OG)
- Use for: visual content, product launches, feature announcements, hero-driven posts

**When to use which card type:**

| Card Type | Best For | Image Style |
|-----------|---------|-------------|
| `summary` | Articles, documentation, reference pages | Logo or icon (square) |
| `summary_large_image` | Blog posts, product pages, announcements, visual content | Hero image (wide) |

#### 4e: Debugging Social Previews

After setting OG and Twitter tags, validate them before sharing:

| Platform | Debug Tool URL | What It Does |
|----------|---------------|-------------|
| Facebook | https://developers.facebook.com/tools/debug/ | Scrapes URL, shows OG preview, lets you clear cache |
| Twitter/X | https://cards-dev.twitter.com/validator | Shows card preview (may require login) |
| LinkedIn | https://www.linkedin.com/post-inspector/ | Scrapes URL, shows preview |
| General | https://metatags.io | Live preview across multiple platforms simultaneously |
| General | https://opengraph.xyz | Quick OG tag inspector and preview |

**Facebook cache clearing:** After updating OG tags, Facebook caches the old version. Use the Facebook Debugger to "Scrape Again" and force a refresh.

---

### Step 5: Technical Meta Tags

Technical meta tags control how search engines crawl, index, and process the page. They do not affect visual SERP appearance but are critical for correct indexability.

#### 5a: Canonical Tags

The canonical tag tells search engines which URL is the "official" version when duplicate or near-duplicate content exists at multiple URLs.

```html
<!-- Self-referencing canonical (every page should have one) -->
<link rel="canonical" href="https://example.com/blog/business-plan-guide">

<!-- Cross-domain canonical (syndicated content) -->
<link rel="canonical" href="https://original-site.com/original-article">
```

**Canonical rules:**
- [ ] Every indexable page has a self-referencing canonical tag
- [ ] Canonical URL uses the preferred protocol (https, not http)
- [ ] Canonical URL uses the preferred domain format (www or non-www, not both)
- [ ] Canonical URL includes or excludes trailing slash consistently
- [ ] Paginated pages: each page canonicalizes to itself (NOT to page 1)
- [ ] URL parameters (sorting, filtering) canonicalize to the clean base URL
- [ ] HTTP and HTTPS versions canonicalize to HTTPS
- [ ] Print/AMP/mobile versions canonicalize to the main version
- [ ] Never canonicalize to a page that returns 4xx or 5xx
- [ ] Never chain canonicals (A -> B -> C) — always point directly to the final URL

**Common canonical mistakes:**

| Mistake | Result | Fix |
|---------|--------|-----|
| Missing canonical on all pages | Google picks its own canonical, may choose wrong URL | Add self-referencing canonicals to every page |
| Canonical points to a redirect | Google may ignore or misinterpret | Point canonical to the final destination URL |
| Canonical points to a noindexed page | Contradictory signals — confuses Google | Never combine canonical with noindex on the target |
| Canonical on paginated pages points to page 1 | Pages 2+ are treated as duplicates and deindexed | Each paginated page should canonicalize to itself |

#### 5b: Robots Meta Tag

Controls whether search engines index the page and follow its links.

```html
<!-- Default (index + follow) — same as omitting the tag entirely -->
<meta name="robots" content="index, follow">

<!-- Do not index this page, but follow links on it -->
<meta name="robots" content="noindex, follow">

<!-- Index this page, but do not follow any links -->
<meta name="robots" content="index, nofollow">

<!-- Do not index, do not follow links -->
<meta name="robots" content="noindex, nofollow">

<!-- Do not show a cached copy in search results -->
<meta name="robots" content="noarchive">

<!-- Do not show this page in Google Discover -->
<meta name="robots" content="max-image-preview:none">

<!-- Control snippet length (characters) -->
<meta name="robots" content="max-snippet:160">

<!-- Google-specific: do not translate this page in search results -->
<meta name="googlebot" content="notranslate">
```

**When to use noindex:**

| Page Type | Robots Directive | Rationale |
|-----------|-----------------|-----------|
| Thank-you / confirmation pages | `noindex, nofollow` | No search value, post-conversion only |
| Internal search results pages | `noindex, follow` | Thin content, infinite URL variations |
| Tag/archive pages (if thin) | `noindex, follow` | Prevent thin content indexing, preserve link equity |
| Staging/dev environment | `noindex, nofollow` | Must never appear in search results |
| Login / account pages | `noindex, nofollow` | Private content, no search value |
| Paginated pages beyond page 5 | Consider `noindex, follow` | Diminishing value, but keep link flow |
| Legal boilerplate (privacy, terms) | `index, nofollow` or default | Low value but builds trust signals |

**Critical warning:** Adding `noindex` to important pages is a common and devastating mistake. Always verify robots directives on money pages, the homepage, and high-traffic landing pages.

#### 5c: Viewport Tag

Required for mobile-friendly rendering. Google uses mobile-first indexing — a missing or broken viewport tag can hurt mobile rankings.

```html
<!-- Standard viewport meta (include on every page) -->
<meta name="viewport" content="width=device-width, initial-scale=1">
```

**Do NOT do these:**
```html
<!-- BAD: Fixed width prevents responsive behavior -->
<meta name="viewport" content="width=1024">

<!-- BAD: Disabling zoom is an accessibility violation -->
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">

<!-- BAD: Missing entirely — browser assumes desktop width on mobile -->
<!-- (no viewport tag at all) -->
```

#### 5d: Charset and Content-Type

```html
<!-- UTF-8 (use this — it's the universal standard) -->
<meta charset="UTF-8">

<!-- Content-Type (legacy but still supported) -->
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
```

Place `<meta charset="UTF-8">` as the **first element** inside `<head>`, before `<title>` or any other meta tags. Browsers need to know the encoding before parsing any text content.

#### 5e: Hreflang for Internationalization

Hreflang tags tell search engines which language/region version of a page to show to users in different locales. Critical for sites with content in multiple languages or targeting multiple countries.

```html
<!-- Page available in English (US), Spanish (Spain), and French (France) -->
<link rel="alternate" hreflang="en-US" href="https://example.com/blog/business-plan">
<link rel="alternate" hreflang="es-ES" href="https://example.com/es/blog/plan-de-negocio">
<link rel="alternate" hreflang="fr-FR" href="https://example.com/fr/blog/plan-affaires">
<link rel="alternate" hreflang="x-default" href="https://example.com/blog/business-plan">
```

**Hreflang rules:**
- [ ] Every page in the set must reference ALL other versions (including itself)
- [ ] Use `x-default` for the fallback page (usually English or the primary language)
- [ ] Hreflang values use ISO 639-1 language codes and optional ISO 3166-1 region codes
- [ ] All hreflang URLs must return 200 (not redirects, not 404s)
- [ ] Hreflang is bidirectional — page A must reference page B, AND page B must reference page A
- [ ] For large sites, implement via XML sitemap instead of HTML tags (reduces page bloat)
- [ ] Do NOT use hreflang for regional variations of the same language unless content actually differs (e.g., US English vs UK English — only if spelling/pricing/content differs)

**Common language-region codes:**

| Code | Meaning |
|------|---------|
| `en` | English (any region) |
| `en-US` | English (United States) |
| `en-GB` | English (United Kingdom) |
| `es` | Spanish (any region) |
| `es-MX` | Spanish (Mexico) |
| `fr-CA` | French (Canada) |
| `de-AT` | German (Austria) |
| `pt-BR` | Portuguese (Brazil) |
| `zh-CN` | Chinese (Simplified, China) |
| `ja` | Japanese |

#### 5f: Referrer Policy

Controls how much referrer information is sent when users click links on your page.

```html
<!-- Recommended: Send origin (domain) only, not full URL path -->
<meta name="referrer" content="strict-origin-when-cross-origin">

<!-- Alternative: Send full referrer to same-origin, origin only to cross-origin -->
<meta name="referrer" content="origin-when-cross-origin">

<!-- Strict: Never send referrer (hides traffic source from analytics) -->
<meta name="referrer" content="no-referrer">
```

For most sites, `strict-origin-when-cross-origin` is the right default — it balances privacy with analytics functionality.

#### 5g: Complete Technical Meta Tag Template

```html
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="referrer" content="strict-origin-when-cross-origin">

  <title>How to Write a Business Plan: 9 Steps (Free Template) | Acme</title>
  <meta name="description" content="Learn how to write a business plan in 9 clear steps. Covers market analysis, financial projections, and executive summaries. Free downloadable template included.">

  <link rel="canonical" href="https://example.com/blog/how-to-write-business-plan">
  <meta name="robots" content="index, follow">

  <!-- Open Graph -->
  <meta property="og:title" content="How to Write a Business Plan in 9 Steps (Free Template)">
  <meta property="og:description" content="Step-by-step guide to writing a business plan that investors actually read. Includes free downloadable template and real examples.">
  <meta property="og:image" content="https://example.com/images/business-plan-guide-og.jpg">
  <meta property="og:image:width" content="1200">
  <meta property="og:image:height" content="630">
  <meta property="og:image:alt" content="Business plan template with financial projections spreadsheet">
  <meta property="og:url" content="https://example.com/blog/how-to-write-business-plan">
  <meta property="og:type" content="article">
  <meta property="og:site_name" content="Acme">

  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:site" content="@acmecorp">
  <meta name="twitter:title" content="How to Write a Business Plan in 9 Steps">
  <meta name="twitter:description" content="Step-by-step guide with free template and real examples from funded startups.">
  <meta name="twitter:image" content="https://example.com/images/business-plan-guide-og.jpg">
  <meta name="twitter:image:alt" content="Business plan template layout with financial charts">

  <!-- Hreflang (if multilingual) -->
  <link rel="alternate" hreflang="en-US" href="https://example.com/blog/how-to-write-business-plan">
  <link rel="alternate" hreflang="es-ES" href="https://example.com/es/blog/como-escribir-plan-negocio">
  <link rel="alternate" hreflang="x-default" href="https://example.com/blog/how-to-write-business-plan">
</head>
```

---

### Step 6: SERP Preview Testing

Before finalizing meta tags, preview how they will appear in actual search results. A compelling SERP snippet is the difference between a click and a scroll-past.

#### 6a: Text-Based SERP Preview Simulation

Generate a visual SERP preview for the user using text formatting:

```
━━━ GOOGLE SERP PREVIEW ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

── Desktop ────────────────────────────────────────────────────────

  example.com > blog > how-to-write-business-plan
  How to Write a Business Plan: 9 Steps (Free Template) | Acme
  Learn how to write a business plan in 9 clear steps. Covers
  market analysis, financial projections, and executive summaries.
  Free downloadable template included.

── Mobile ─────────────────────────────────────────────────────────

  example.com > blog > how-to-write-bus...
  How to Write a Business Plan: 9
  Steps (Free Template) | Acme
  Learn how to write a business plan in
  9 clear steps. Covers market analysis,
  financial projections, and executive...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

#### 6b: Desktop vs Mobile Truncation Rules

| Element | Desktop Limit | Mobile Limit | Truncation Symbol |
|---------|--------------|-------------|-------------------|
| Title tag | ~60 chars / 580px | ~55-60 chars (wraps to 2 lines) | "..." |
| Meta description | ~155-160 chars / 920px | ~120 chars / 680px | "..." |
| Display URL | Full breadcrumb path | Truncated path with "..." | "..." |

**Testing approach:**
1. Write the title and description at target length
2. Simulate truncation at mobile limits (title: 55 chars, description: 120 chars)
3. Verify the truncated version still communicates the core message and keyword
4. If critical information is lost at mobile truncation, restructure

#### 6c: Rich Result Impact on CTR

Rich results (star ratings, FAQ dropdowns, pricing, images) dramatically change SERP appearance and push standard results lower. Consider how your snippet competes:

| Rich Result Type | CTR Impact | How to Earn It |
|-----------------|-----------|----------------|
| FAQ rich result | +15-25% CTR | Add FAQPage schema markup |
| Star ratings | +20-35% CTR | Add Review or AggregateRating schema |
| Sitelinks | +10-20% CTR | Earned via site structure (not directly controllable) |
| Featured snippet | +30-50% CTR (but cannibalized from #1) | Structure content as direct answers to questions |
| Image pack | Variable | Optimize image alt text, file names, surrounding content |
| Video thumbnail | +15-30% CTR | Embed video with VideoObject schema |

**Note:** Rich results require schema markup (see schema-markup skill), not meta tags. But when auditing meta tags, note whether the page could benefit from schema to complement the meta tag optimization.

#### 6d: A/B Testing Approach for Titles and Descriptions

Google Search Console provides impression and click data per page, enabling data-driven meta tag testing.

**A/B testing protocol:**
1. **Baseline:** Record the current CTR for the page in GSC (use 28-day window)
2. **Change one variable at a time:** Update either the title tag OR the meta description, not both
3. **Wait 2-4 weeks** for Google to recrawl and for statistically meaningful data
4. **Compare:** Check the new CTR in GSC against the baseline
5. **Evaluate:** If CTR improved by 10%+ with stable impression volume, keep the change
6. **Iterate:** Test the other variable (title or description) next

**What to test:**

| Variable | Test A | Test B | What You Learn |
|----------|--------|--------|---------------|
| Keyword position | Keyword first in title | Keyword mid-title | Whether front-loading improves CTR |
| Numbers | "How to Write a Business Plan" | "9 Steps to Write a Business Plan" | Whether numbers increase clicks |
| Power words | "Guide to Email Marketing" | "The Complete Guide to Email Marketing" | Whether "complete" or "ultimate" improves CTR |
| Year inclusion | "SEO Best Practices" | "SEO Best Practices for 2026" | Whether freshness signals improve CTR |
| CTA style | "Learn more about..." | "Get the free template..." | Which CTA drives more clicks |
| Description length | 120 chars (mobile-safe) | 155 chars (desktop-optimized) | Whether longer descriptions hurt mobile CTR |

**Tools for SERP preview testing:**
- **Google Search Console** (free) — real impression and click data
- **SERPsim.com** — visual title/description preview tool
- **Mangools SERP Simulator** — character count and pixel width preview
- **Portent SERP Preview Tool** — quick desktop/mobile comparison

---

### Step 7: Bulk Optimization

When optimizing meta tags for many pages at once (10+), use a structured spreadsheet approach to ensure consistency, track progress, and enable team review.

#### 7a: Priority Scoring — Which Pages to Optimize First

Not all pages deserve equal optimization effort. Prioritize by potential impact:

```
Priority Score = (Monthly Impressions x Current CTR Gap x Business Value)

Where:
  Monthly Impressions = from GSC (higher = more visibility to gain from)
  Current CTR Gap = Industry average CTR for that position minus current CTR
                    (Position 1 avg ~28%, Position 5 avg ~6%, etc.)
  Business Value:
    Money page (product, pricing, demo) = 3.0
    Lead gen (service, landing page)    = 2.5
    Blog (informational, top-funnel)    = 1.0
    Utility (about, contact, legal)     = 0.5
```

**Tier the pages:**

| Priority | Criteria | Action |
|----------|----------|--------|
| P0 — Critical | Top 10 pages by impressions with below-average CTR | Optimize this week |
| P1 — High | Pages ranking positions 4-10 (first page, not top 3) | Optimize within 2 weeks |
| P2 — Medium | Pages ranking positions 11-20 (second page) | Optimize within 1 month |
| P3 — Low | Pages with <100 monthly impressions | Batch optimize when convenient |
| Skip | Pages with noindex, 0 impressions, or utility pages | Do not optimize |

#### 7b: Bulk Optimization Spreadsheet Format

Use this format for auditing and optimizing multiple pages:

```
━━━ META TAG OPTIMIZATION SPREADSHEET ━━━━━━━━━━━━━━━━━━━━━━━━━━

Columns:
| URL | Page Type | Priority | Target Keyword | Current Title | Title Length | New Title | New Title Length | Current Description | Desc Length | New Description | New Desc Length | Status |

Example rows:
| /                    | Homepage  | P0 | project management software | "Acme - Home"           | 11 | "Project Management Software for Remote Teams \| Acme" | 54 | (missing)        | 0   | "Acme helps remote teams ship projects faster with visual boards and automated workflows. Start free." | 101 | Done |
| /pricing             | Landing   | P0 | acme pricing                | "Pricing"               | 7  | "Acme Pricing Plans — Free, Pro & Enterprise \| Acme"  | 51 | "See our plans."  | 14  | "Compare Acme pricing plans. Free for up to 5 users, Pro from $12/mo, Enterprise custom. Start your free trial today." | 117 | Done |
| /blog/remote-tips    | Blog Post | P1 | remote work tips            | "Tips for Remote Work"  | 20 | "15 Remote Work Tips That Actually Boost Productivity (2026)" | 58 | "Remote work tips for your team" | 30 | "Discover 15 proven remote work tips from teams that have been fully distributed since 2020. Covers communication, async workflows, and focus time." | 148 | Done |
| /features            | Product   | P1 | project management features | "Features"              | 8  | "Project Management Features — Boards, Gantt, Time Tracking \| Acme" | 63 | (missing)        | 0   | "Explore Acme's project management features: Kanban boards, Gantt charts, time tracking, and 200+ integrations. See all features." | 127 | In Progress |
```

#### 7c: Before/After Comparison Report

After bulk optimization, generate a summary showing improvements:

```
━━━ META TAG OPTIMIZATION REPORT ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

── SUMMARY ────────────────────────────────────────────────────────
Pages audited:      47
Pages optimized:    32
Pages skipped:      15 (noindex, utility, or already optimized)
Date:               2026-03-29

── BEFORE vs AFTER ────────────────────────────────────────────────

Metric                          Before      After       Change
Pages with title tags           38/47       47/47       +9 pages
Avg title length                28 chars    52 chars    +24 chars
Pages with keyword in title     12/47       44/47       +32 pages
Pages with meta description     21/47       47/47       +26 pages
Avg description length          68 chars    142 chars   +74 chars
Pages with CTA in description   3/47        42/47       +39 pages
Pages with OG tags              5/47        47/47       +42 pages
Pages with Twitter Card tags    0/47        47/47       +47 pages
Duplicate titles                8 pairs     0           -8 pairs
Duplicate descriptions          14 pairs    0           -14 pairs

── PAGE-LEVEL CHANGES ─────────────────────────────────────────────

URL                  Old Title (len)              New Title (len)                Status
/                    "Acme - Home" (11)           "Project Management..." (54)   Optimized
/pricing             "Pricing" (7)                "Acme Pricing Plans..." (51)   Optimized
/blog/remote-tips    "Tips for Remote Work" (20)  "15 Remote Work Tips..." (58)  Optimized
...

── EXPECTED IMPACT ────────────────────────────────────────────────
Estimated CTR improvement: 15-30% average across optimized pages
Estimated additional monthly clicks: [calculated from GSC impressions x CTR delta]
Timeline to see results: 2-4 weeks after Google recrawls

── NEXT STEPS ─────────────────────────────────────────────────────
1. Implement the HTML changes (see implementation snippets below)
2. Submit updated URLs for recrawling in Google Search Console
3. Monitor CTR changes in GSC after 2-4 weeks
4. Run A/B tests on the top 5 pages by impressions (Step 6d)
5. Re-audit in 90 days to catch new pages and refresh seasonal content
```

#### 7d: Submitting Changes for Recrawl

After implementing meta tag changes, prompt Google to recrawl:

```bash
# Option 1: Request indexing via Google Search Console UI
# Go to: Search Console > URL Inspection > Enter URL > "Request Indexing"

# Option 2: Update sitemap lastmod dates and resubmit
# Edit sitemap.xml to update <lastmod> for changed pages
# Go to: Search Console > Sitemaps > Resubmit sitemap

# Option 3: For programmatic submission (Google Indexing API — limited to JobPosting and BroadcastEvent)
# Most sites use Option 1 or 2
```

---

### Step 8: Output

Deliver the optimized meta tags as ready-to-implement HTML snippets with a SERP preview for each page.

#### 8a: Per-Page Output Format

For each optimized page, output:

```
━━━ PAGE: /blog/how-to-write-business-plan ━━━━━━━━━━━━━━━━━━━━━

── Target Keyword: "how to write a business plan" ─────────────────
── Page Type: Blog Post ───────────────────────────────────────────

── SERP PREVIEW (Desktop) ─────────────────────────────────────────

  example.com > blog > how-to-write-business-plan
  How to Write a Business Plan: 9 Steps (Free Template) | Acme
  Learn how to write a business plan in 9 clear steps. Covers
  market analysis, financial projections, and executive summaries.
  Free downloadable template included.

── SERP PREVIEW (Mobile) ──────────────────────────────────────────

  example.com > blog > how-to-write-bus...
  How to Write a Business Plan: 9 Steps
  (Free Template) | Acme
  Learn how to write a business plan in 9
  clear steps. Covers market analysis,...

── HTML IMPLEMENTATION ────────────────────────────────────────────

<title>How to Write a Business Plan: 9 Steps (Free Template) | Acme</title>
<meta name="description" content="Learn how to write a business plan in 9 clear steps. Covers market analysis, financial projections, and executive summaries. Free downloadable template included.">
<link rel="canonical" href="https://example.com/blog/how-to-write-business-plan">
<meta property="og:title" content="How to Write a Business Plan in 9 Steps (Free Template)">
<meta property="og:description" content="Step-by-step guide to writing a business plan that investors actually read. Includes free downloadable template and real examples.">
<meta property="og:image" content="https://example.com/images/business-plan-guide-og.jpg">
<meta property="og:url" content="https://example.com/blog/how-to-write-business-plan">
<meta property="og:type" content="article">
<meta property="og:site_name" content="Acme">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:site" content="@acmecorp">
<meta name="twitter:title" content="How to Write a Business Plan in 9 Steps">
<meta name="twitter:description" content="Step-by-step guide with free template and real examples from funded startups.">
<meta name="twitter:image" content="https://example.com/images/business-plan-guide-og.jpg">

── METRICS ────────────────────────────────────────────────────────
Title length:       57 characters (within 50-60 target)
Description length: 160 characters (within 120-160 target)
Keyword in title:   Yes (position 1 — front-loaded)
Keyword in desc:    Yes (bolded in SERP)
CTA in description: Yes ("Free downloadable template included")
OG image size:      1200x630px (meets minimum)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

#### 8b: Implementation Instructions

Provide platform-specific guidance based on the user's CMS:

**WordPress (Yoast SEO / Rank Math):**
- Edit each page/post in WordPress
- Scroll to the SEO plugin section below the editor
- Paste the optimized title into the "SEO Title" field
- Paste the optimized description into the "Meta Description" field
- OG tags are auto-generated from these fields (or override in the "Social" tab)

**Shopify:**
- Navigate to the product/page/blog post editor
- Scroll to "Search engine listing preview" and click "Edit"
- Paste the title and description
- OG tags: Edit the theme's `theme.liquid` to add OG meta tags in the `<head>` section

**Next.js / React (App Router):**
```typescript
// app/blog/business-plan/page.tsx
export const metadata = {
  title: 'How to Write a Business Plan: 9 Steps (Free Template) | Acme',
  description: 'Learn how to write a business plan in 9 clear steps...',
  openGraph: {
    title: 'How to Write a Business Plan in 9 Steps (Free Template)',
    description: 'Step-by-step guide to writing a business plan...',
    images: [{ url: 'https://example.com/images/business-plan-guide-og.jpg', width: 1200, height: 630 }],
    url: 'https://example.com/blog/how-to-write-business-plan',
    type: 'article',
  },
  twitter: {
    card: 'summary_large_image',
    site: '@acmecorp',
    title: 'How to Write a Business Plan in 9 Steps',
    description: 'Step-by-step guide with free template...',
    images: ['https://example.com/images/business-plan-guide-og.jpg'],
  },
  alternates: {
    canonical: 'https://example.com/blog/how-to-write-business-plan',
  },
};
```

**Static HTML:**
- Open the HTML file in a code editor
- Replace or add the meta tags in the `<head>` section
- Use the complete template from Step 5g as a reference

#### 8c: Export Formats

Offer the deliverable in the format the user prefers:
- **HTML snippets** (default — copy-paste into source code or CMS)
- **CSV spreadsheet** (for bulk review, team collaboration, client handoff)
- **JSON** (for programmatic implementation or CMS API import)

---

## Anti-Patterns

| Anti-Pattern | Why It's Wrong | Correct Approach |
|-------------|----------------|------------------|
| Keyword stuffing in title tags | Google may rewrite your title or penalize the page. Users see it as spammy. | Use the primary keyword once, naturally, near the front |
| Identical meta descriptions across pages | Google ignores duplicate descriptions and auto-generates instead | Write unique descriptions for every indexable page |
| Missing meta descriptions entirely | Google auto-generates from page content — usually less compelling than a crafted snippet | Write a description for every page that gets search traffic |
| Using the exact `<title>` for `og:title` | Title tags have brand suffixes ("\| Brand") that look awkward on social | Write a separate og:title optimized for social sharing |
| Using a tiny logo as og:image | Social platforms show a small thumbnail instead of a rich preview card | Use a 1200x630px image designed for social previews |
| Quotation marks in meta description content | Google truncates descriptions at quotation marks in the content attribute | Use single quotes or rephrase to avoid quotes entirely |
| Writing descriptions as keyword lists | "SEO, meta tags, search engine optimization, SERP, title tags" is not compelling | Write a natural sentence with a hook, value proposition, and CTA |
| Setting noindex on money pages | Removes the page from search results entirely — catastrophic for revenue pages | Double-check robots directives on every high-value page |
| Changing title tags and descriptions simultaneously | Cannot isolate which change affected CTR — makes A/B testing meaningless | Change one variable at a time, wait 2-4 weeks between changes |
| Ignoring mobile truncation | 60%+ of searches happen on mobile where truncation is more aggressive | Always verify the mobile SERP preview, not just desktop |
| Using relative URLs in canonical or OG tags | Browsers may resolve them, but search engines and social platforms may not | Always use absolute URLs with protocol (https://) |
| Canonical tag pointing to a different page's content | Tells Google "this page is a duplicate of X" — deindexes your page | Self-referencing canonical unless the page truly IS a duplicate |
| Over-optimizing every page for the same keyword | Causes keyword cannibalization — pages compete against each other | Each page targets a unique primary keyword |
| Writing descriptions longer than 160 characters | Guaranteed truncation on desktop, severe truncation on mobile | Stay under 155 characters for desktop safety, lead with key info for mobile |

## Escalation

Hand off to a specialist or recommend paid tools when:
- The site has **500+ pages** needing meta tag optimization — manual optimization is impractical; recommend a CMS plugin with template-based generation (Yoast, Rank Math) or a programmatic approach
- **International SEO** with 5+ language/region combinations — hreflang implementation is complex and error-prone at scale; requires tooling like Ahrefs Site Audit or hreflang-checker.com
- **Dynamic meta tags** from a headless CMS or SPA (Single Page Application) — requires server-side rendering or prerendering setup to ensure search engines see the tags
- The site uses **JavaScript rendering** exclusively (React/Vue SPA without SSR) — search engines may not execute JS reliably; meta tags must be in the initial HTML response
- **Brand reputation management** — title tag and description optimization to suppress negative search results requires a broader ORM (Online Reputation Management) strategy
- **Regulatory compliance** — YMYL (health, finance, legal) sites may have restrictions on promotional language in meta descriptions
- The user needs **automated rank tracking and CTR monitoring** across hundreds of keywords — recommend Ahrefs, Semrush, SE Ranking, or AccuRanker
- **Google is rewriting title tags** despite well-optimized titles — may indicate deeper content-title misalignment that requires page content restructuring, not just tag changes

## Inputs

- URL or list of URLs to optimize (required)
- Target keywords per page (required, or inferred from page content)
- Brand name and preferred separator character
- Page types (homepage, product, blog, category, service, landing page)
- Current meta tags (fetched automatically if URL provided)
- Industry / niche and target audience
- Tone preference (professional, casual, urgent, luxury)
- CMS / tech stack (for implementation instructions)
- Google Search Console data (impressions, clicks, CTR — for prioritization)
- OG image URLs or assets (for social preview tags)
- Twitter/X handle (for Twitter Card tags)
- Language/region targets (for hreflang tags)

## Outputs

- Optimized title tags with character count and keyword position
- Optimized meta descriptions with character count, CTA, and keyword inclusion
- Open Graph tags (og:title, og:description, og:image, og:url, og:type, og:site_name)
- Twitter Card tags (card type, title, description, image, site handle)
- Technical meta tags (canonical, robots, viewport, charset, hreflang)
- SERP preview simulation (desktop and mobile) for each page
- Before/after comparison for existing pages
- Priority-scored page list for bulk optimization
- Bulk optimization spreadsheet (CSV or markdown table)
- HTML snippets ready for copy-paste implementation
- Platform-specific implementation instructions (WordPress, Shopify, Next.js, static HTML)
- A/B testing plan for the top pages by impressions
- Recrawl submission instructions

## Level History

- **Lv.1** — Full implementation: Comprehensive 8-step meta tag optimization protocol covering input gathering (URL scraping, keyword mapping, page type detection), title tag optimization (character/pixel limits, keyword placement rules, formulas for 6 page types, power words, emotional triggers, validation checklist), meta description optimization (character limits, 3-part anatomy, CTA patterns, templates for 6 page types, validation checklist), Open Graph tags (required and optional properties, image specifications per platform, og:type guidance), Twitter Card tags (summary vs summary_large_image, when to use each, debug tools), technical meta tags (canonical rules and common mistakes, robots directives with use-case table, viewport, charset, hreflang with language codes, referrer policy, complete template), SERP preview testing (text-based preview simulation, desktop vs mobile truncation, rich result impact, A/B testing protocol with variables), bulk optimization (priority scoring formula, spreadsheet format, before/after comparison report, recrawl submission), and output format (per-page HTML snippets with metrics, CMS-specific implementation instructions, export formats). Includes anti-patterns covering 14 common mistakes and escalation criteria for 8 specialist scenarios. (Origin: MemStack skill replacement, Mar 2026)
