---
name: schema-markup
description: "Add, fix, or audit schema.org JSON-LD structured data for rich results. Triggers: 'add schema', 'schema markup', 'JSON-LD', 'structured data', 'rich results', 'rich snippets'. NOT for meta tags (meta-tag-optimizer), full SEO audits (site-audit), or AI search (ai-search-visibility)."
---

# Schema Markup — Structured Data & Rich Results

## Activation

When this skill activates, output:

`Schema Markup — Adding structured data to your pages...`

| Context | Status |
|---------|--------|
| User says "add schema", "JSON-LD", "structured data", "rich results" | ACTIVE |
| User has Search Console structured data errors | ACTIVE |
| User wants full SEO audit (not just schema) | DORMANT — see site-audit |
| User wants meta tag optimization only | DORMANT — see meta-tag-optimizer |
| User wants AI search / GEO optimization | DORMANT — see ai-search-visibility |

## Instructions

### Step 1: Gather inputs

Required: **website URL**, **page types** needing schema. Optional: business type, current schema status, target rich results, CMS/tech stack, business details, product details.

If only a URL is provided, fetch it to inspect existing markup and infer page type. Note assumptions.

**Gate:** Do not proceed without URL + at least one page type identified.

### Step 2: Select schema types

Map each page type using the selection matrix. A single page often needs multiple types layered together.

| Page Type | Primary Schema | Supporting Schema | Rich Result |
|-----------|---------------|-------------------|-------------|
| Homepage | `Organization` / `LocalBusiness` | `WebSite` + `SearchAction`, `BreadcrumbList` | Sitelinks search box, knowledge panel |
| About | `Organization` / `Person` | `BreadcrumbList` | Knowledge panel |
| Blog post | `Article` / `BlogPosting` | `BreadcrumbList`, `Person` (author) | Article carousel |
| Product | `Product` | `Offer`, `AggregateRating`, `Review`, `BreadcrumbList` | Stars, price, availability |
| FAQ | `FAQPage` | `Question` + `Answer`, `BreadcrumbList` | FAQ accordion (restricted*) |
| How-to | `HowTo` | `HowToStep`, `HowToTool`, `HowToSupply` | How-to steps (restricted*) |
| Recipe | `Recipe` | `AggregateRating`, `NutritionInformation`, `VideoObject` | Recipe card |
| Event | `Event` | `Place`, `Offer`, `Organization` | Event listing |
| Course | `Course` | `CourseInstance`, `Organization`, `Offer` | Course listing |
| Video | `VideoObject` | `BreadcrumbList`, `Organization` | Video carousel |
| Software | `SoftwareApplication` | `Offer`, `AggregateRating` | Software snippet |
| Job posting | `JobPosting` | `Organization`, `Place`, `MonetaryAmount` | Google for Jobs |
| Local business | `LocalBusiness` (use specific subtype) | `PostalAddress`, `GeoCoordinates`, `OpeningHoursSpecification` | Local pack |
| Service | `Service` | `Organization`, `Offer`, `AggregateRating` | No dedicated rich result |
| Breadcrumbs | `BreadcrumbList` | `ListItem` | Breadcrumb trail in SERP |

*Always add `BreadcrumbList` to every page* — highest-ROI type, improves every search result appearance.

Decision shortcut: Homepage with physical location -> `LocalBusiness` subtype instead of `Organization`.

**Gate:** Confirm selected types with user before generating JSON-LD.

### Step 3: Generate JSON-LD

Format: JSON-LD in `<head>`. Always use `@graph` to bundle multiple types per page with `@id` cross-references.

**@graph / @id pattern:** Each entity gets `@id` using `https://domain.com/path/#type` (e.g., `/#organization`, `/blog/post/#article`). Related entities reference each other via `{ "@id": "..." }`. This tells Google how entities connect across the page and site.

**Required vs recommended properties per type:**

- **Article**: Required: `headline`, `image`, `datePublished`, `author`. Recommended: `dateModified`, `publisher`, `description`.
- **Product**: Required: `name`, `offers` (price + priceCurrency + availability), `review` or `aggregateRating`. Recommended: `image`, `brand`, `sku`, `shippingDetails`, `returnPolicy`.
- **FAQPage**: Required: `mainEntity[]` with `Question` + `acceptedAnswer`.
- **HowTo**: Required: `name`, `step[]` with `HowToStep`. Recommended: `image`, `totalTime`, `estimatedCost`, `supply`, `tool`.
- **Recipe**: Required: `name`, `image`, `recipeIngredient`, `recipeInstructions`. Recommended: `aggregateRating`, `nutrition`, `prepTime`, `cookTime`, `video`.
- **Event**: Required: `name`, `startDate`, `location`. Recommended: `endDate`, `offers`, `eventStatus`, `eventAttendanceMode`, `performer`.
- **VideoObject**: Required: `name`, `thumbnailUrl`, `uploadDate`. Recommended: `description`, `duration`, `contentUrl`.
- **LocalBusiness**: Required: `name`, `address`. Recommended: `telephone`, `openingHoursSpecification`, `geo`, `aggregateRating`.
- **BreadcrumbList**: Required: `itemListElement[]` with `ListItem` (position, name). Recommended: `item` (URL for each except last).
- **JobPosting**: Required: `title`, `description`, `datePosted`, `hiringOrganization`, `jobLocation`. Recommended: `baseSalary`, `employmentType`.
- **WebSite + SearchAction**: Required: `potentialAction` with `SearchAction` + `query-input`.

Rule: include ALL required properties. Add recommended only when backed by real page content. Never fabricate data.

**Gate:** Validate every block against Google Rich Results Test before proceeding.

### Step 4: Communicate rich result restrictions

Google deprecation notes — always inform the user:

- **FAQPage** (Aug 2023): Restricted to authoritative government/health sites. Most sites will NOT see FAQ accordions even with valid schema. Still useful for Bing/Yandex.
- **HowTo** (Aug 2023): Removed from mobile, significantly reduced on desktop. Schema still valid but visual impact diminished.
- **Self-serving reviews**: AggregateRating on your own business (not a specific product) will not produce rich results.

Structured data still benefits knowledge graph and non-Google engines even when Google does not render a visible rich result.

### Step 5: CMS placement guidance

JSON-LD goes in `<head>` on every platform. Platform-specific considerations:

- **WordPress (Yoast/Rank Math)**: Both auto-generate Organization, WebSite, Article, BreadcrumbList. Add custom types via their schema filter APIs (`wpseo_schema_graph_pieces` / `rank_math/json_ld`). Do not duplicate what the plugin already outputs.
- **Shopify**: Themes include basic Product + BreadcrumbList in `product.liquid`. Check for duplicates before adding custom schema. Add Organization to `theme.liquid` for homepage only.
- **Next.js / React**: Render JSON-LD via `<script type="application/ld+json" dangerouslySetInnerHTML>`. Site-wide schema (Organization, WebSite) in root layout. Per-page schema generated from page data.
- **Static sites / SSGs**: JSON-LD directly in `<head>`. For Hugo/Jekyll/Eleventy, create a partial that generates from front matter.
- **Custom CMS**: Build a server-side schema helper that generates JSON-LD from the same data source as the visible page. Never hardcode schema on dynamic pages.

**Gate:** Confirm CMS approach matches user's stack before delivering implementation instructions.

### Step 6: Deliver output

Provide to the user:
1. Complete JSON-LD blocks customized with their actual data
2. CMS-specific implementation instructions
3. Rich result eligibility summary with honest Google status notes
4. Implementation priority: Tier 1 (BreadcrumbList, Organization/WebSite, Product) > Tier 2 (Article, LocalBusiness, Recipe, Event) > Tier 3 (VideoObject, Course, Software, JobPosting) > Tier 4 (FAQPage, HowTo)
5. Monitoring setup (see Step 7)

### Step 7: Set up monitoring

**Search Console reports to check monthly:**
- Enhancements section: valid/warning/invalid items per rich result type
- Security & Manual Actions: structured data penalties
- Performance > Search Appearance: CTR for pages with rich results vs without

**Schema drift detection** — schema drifts when page content changes but structured data stays static. Common drift: price, availability, dateModified, aggregateRating, FAQ questions. For dynamic sites, always generate schema from the same data source as the visible page.

**Quarterly maintenance:** Re-validate all types, check Search Console for new errors, review Google docs for deprecations/new required fields, spot-check 5-10 pages for content-schema sync.

## Examples

**Example 1 — E-commerce homepage**: User has a Shopify store. Apply `Organization` + `WebSite` + `SearchAction` on homepage via `theme.liquid`. Verify Shopify theme is not already injecting a competing Organization block. Add `BreadcrumbList` to all templates.

**Example 2 — Blog with articles**: User runs a Next.js blog. Generate `Article` schema in each post's page component from post data (title, author, dates, image). Add `Person` with `@id` for author, cross-reference via `@graph`. Site-wide `Organization` + `WebSite` in root layout.

## Common Issues

| Error | Fix |
|-------|-----|
| `Missing field "image"` on Article/Recipe | Add `image` with valid URL, min 1200px wide for Article |
| `Missing field "author"` on Article | Add `author` with `@type: Person` and `name` |
| `Invalid URL in "item"` on BreadcrumbList | Use full `https://` absolute URLs, not relative paths |
| `Price not found` on Product | Add both `price` and `priceCurrency` to the Offer |
| `Invalid ISO 8601 date` | Use `2026-03-15` or `2026-03-15T09:00:00-05:00`, not human-readable dates |
| `Duplicate @id` | Ensure every `@id` is unique using the `URL/#type` fragment pattern |
| `Self-serving review` | Move rating to a specific product/service, not the Organization itself |
| `Multiple entities of same type` | Consolidate into one using `@graph` with `@id` references |
| `Review has no reviewed item` | Nest Review inside parent item or use `itemReviewed` |

## Anti-Patterns

| Anti-Pattern | Why It Fails |
|--------------|-------------|
| Schema for invisible content | FAQ/HowTo for content not visible on page — violates guidelines, triggers manual action |
| Hardcoded schema on dynamic pages | Price/availability/ratings go stale — generate server-side from same data source |
| Self-serving reviews | Business rating itself produces no rich results |
| Duplicate schema types on one page | Two competing Organization or Product blocks cause warnings — consolidate with @graph |
| Fabricated data | Fake reviews/ratings/prices trigger manual actions |
| Schema on irrelevant pages | Product schema on About page — match types to actual content |
| Microdata/RDFa mixed with JSON-LD | Standardize on JSON-LD only |
| Orphaned @id references | Every `{ "@id": "..." }` must have a matching entity definition |
| Over-nesting (5+ levels deep) | Use @id references to flatten; keep entities at @graph root |
| Missing dateModified on Article | Google uses it for freshness signals — always include |

## Escalation

| Scenario | Action |
|----------|--------|
| Manual action for structured data spam | Review GSC details, remove violating schema, submit reconsideration |
| Schema requires server-side dynamic generation | Recommend developer or plugin — do not suggest client-side JS injection (unreliable for Googlebot) |
| Multi-location business (10+ locations) | Recommend structured data plugin or API-driven approach |
| E-commerce with thousands of products | Recommend Yoast/Rank Math WooCommerce, Shopify built-in, or product feed pipeline |
| Knowledge panel disputes | Requires Google Business Profile verification + entity reconciliation, beyond schema alone |
| User requests unsupported rich result type | Set expectations — e.g., featured snippets are not triggered by schema |

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| Website URL | Yes | Site receiving structured data |
| Page types | Yes | Which pages need schema |
| Business type | No | Organization category for type selection |
| Current schema status | No | Existing markup and known errors |
| Target rich results | No | Desired SERP enhancements |
| CMS / tech stack | No | Platform for implementation instructions |
| Business details | No | Name, address, phone, logo, social profiles |
| Product details | No | Price, SKU, brand, availability, reviews |

## Outputs

| Output | Format |
|--------|--------|
| JSON-LD blocks | Code — valid, customized, ready for `<head>` |
| Implementation guide | CMS-specific deployment instructions |
| Rich result eligibility | Per-type Google support status with restrictions noted |
| Priority roadmap | Tier 1-4 ranked by impact |
| Monitoring plan | GSC reports + drift detection + quarterly checklist |

## Level History

- **Lv.1** — Base: Schema type selection, JSON-LD format guidance, basic validation workflow, CMS injection patterns. (Origin: MemStack v2.0, Feb 2026)
- **Lv.2** — Production: @graph/@id cross-referencing, rich result eligibility matrix with required/recommended properties, Google FAQ/HowTo deprecation notes (Aug 2023), validation errors table, CMS placement guidance, schema drift detection, anti-patterns, escalation paths. (Origin: MemStack v3.2, Mar 2026)
- **Lv.3** — Compressed: Removed 10 complete JSON-LD examples, CMS code snippets, automated testing scripts, validation tool walkthroughs. Retained decision rules, selection matrix, property requirements, deprecation notes, error fixes, monitoring approach. (Origin: MemStack v3.3, Mar 2026)
