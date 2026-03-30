---
name: local-seo
description: "Audit and optimize a business for local search and Google Maps visibility. WHEN: 'local SEO', 'Google Business Profile', 'GBP', 'local search', 'NAP consistency', 'local listings', 'Google Maps', 'local pack', 'map pack'. NOT WHEN: general/national SEO audit (site-audit), national keyword research (keyword-research), schema without local context (schema-markup), meta tags only (meta-tag-optimizer)."
---

# Local SEO — Local Search and Map Visibility

Produce a scored audit report with prioritized action items covering GBP, NAP, schema, content, reviews, citations, and local links.

## Activation

| Context | Status |
|---------|--------|
| User says "local SEO", "GBP", "local search", "NAP", "local listings", "Google Maps", "local pack" | ACTIVE |
| User wants to optimize a business for local visibility or manage citations/reviews | ACTIVE |
| General/national SEO audit | DORMANT — see site-audit |
| National keyword research, schema without local context, meta tags only | DORMANT — see respective skill |

## Inputs

| Field | Required | Notes |
|-------|----------|-------|
| Business name | Yes | Exact legal/trading name |
| Address | Yes | Full street, city, state, ZIP |
| Phone | Yes | Local number preferred |
| Website URL | Yes | Root domain |
| Business type | Yes | Industry vertical |
| Service area | No | Cities, counties, or radius beyond physical location |
| GBP status | No | Claimed? Verified? Review count/rating? |
| Locations count | No | Single or multi-location |
| Competitors | No | 2-3 local competitor names or URLs |
| Target keywords | No | Top 5-10 local search terms |

If only business name + website provided, proceed with defaults and note assumptions.

## Instructions

### Step 1: Gather Inputs and Validate

Collect required fields from the table above. Do not proceed without all five required fields.

**Gate:** All required inputs present. If multi-location, confirm count and whether each has a dedicated page.

### Step 2: Google Business Profile Audit

GBP is the single strongest local ranking factor. Audit in this priority order:

**Categories** — strongest on-profile signal:
- Primary category must be the most specific match (e.g., "Italian restaurant" not "Restaurant", "Personal injury attorney" not "Lawyer")
- Add every honestly applicable secondary category (up to 9)
- Research via top-3 competitor Maps listings or GMB category tools

**Attributes** — set all applicable: identity (owned-by), accessibility, service options, payments, amenities.

**Photos** — target 100+ total. Minimum: 3-5 exterior, 5-10 interior, 10-20 products/services. Geotag all. Upload 1+ per week.

**Posts** — minimum 1/week. Types: What's New, Offer, Event, Product. Posts expire after 7 days. Front-load value in first 100 chars. Always add CTA with UTM tracking.

**Profile completeness** — verify: name matches legal name exactly (no keyword stuffing), local phone number, accurate hours including holidays, 750-char description with primary keywords + location + services.

**Red flags:** Keywords in business name (suspension risk), virtual office/PO Box address, duplicate profiles.

**Gate:** GBP audit scored. Profile completeness percentage calculated. Category recommendations documented.

### Step 3: NAP Consistency Audit

NAP inconsistencies erode trust. Standardize to USPS format as canonical.

**Method:** Check website footer/contact page for NAP in text + structured data. Compare against all claimed citations. Business name, address format, and phone format must be identical everywhere — "Joe's Plumbing" vs "Joe's Plumbing LLC" are different entities to search engines.

**Citation tiers:**

| Tier | Platforms | Action |
|------|-----------|--------|
| Tier 1 (must own) | Google Business Profile, Apple Business Connect, Bing Places, Facebook, Yelp, BBB | Claim, verify, match NAP exactly |
| Tier 2 (citation volume) | Yellow Pages, Foursquare, Nextdoor, Manta, MapQuest, Superpages | Claim or submit via aggregators |
| Tier 3 (industry-specific) | Varies: healthcare (Healthgrades, Zocdoc), legal (Avvo, FindLaw), restaurants (TripAdvisor, OpenTable), home services (Angi, Thumbtack), real estate (Zillow), automotive (RepairPal) | Select by vertical, claim top 3-5 |

**Data aggregators** — submit correct NAP to Data Axle and Foursquare. Wait 2-4 weeks for propagation. Then audit Tier 1/2 manually. Re-audit quarterly.

**Gate:** Canonical NAP defined. Citation status table populated (claimed/unclaimed, NAP match yes/no). Inconsistency count tallied.

### Step 4: LocalBusiness Schema Markup

**@type selection** — never use generic `LocalBusiness`. Use the most specific subtype: `Plumber`, `Dentist`, `Restaurant`, `Attorney`, `HairSalon`, `AutoRepair`, `Hotel`, `VeterinaryCare`, `HVACBusiness`, `RealEstateAgent`, `InsuranceAgency`, `CafeOrCoffeeShop`, `HealthClub`, etc. Full list at schema.org/LocalBusiness.

**Required properties:** name, @type, @id, telephone (E.164), address (PostalAddress), geo (GeoCoordinates), url, openingHoursSpecification (full day names), areaServed, sameAs (social profiles), image, aggregateRating.

**Multi-location:** Organization wrapper on homepage with `department` array. Each location gets its own LocalBusiness schema on its dedicated page. One location per page.

**Service area business** (no storefront): Use GeoCircle or AdministrativeArea for areaServed. Omit street address from schema if hidden on GBP.

**Validate** with Google Rich Results Test after every change. Common errors: missing geo, generic @type, phone not E.164, abbreviated day names, NAP mismatch between schema and visible text.

**Gate:** Schema recommendation generated. Validation method confirmed with user.

### Step 5: Local Content Strategy

**Location pages** (multi-location) — one dedicated page per physical location with unique H1, 500-1000 words of genuinely unique content, embedded map, location-specific schema, NAP in text, local photos, area testimonials. URL pattern: `/locations/city-state/`.

**Service area pages** (single-location serving multiple cities) — each must have 300+ words of unique, location-specific content. Include specific neighborhoods, landmarks, local testimonials, area-specific service details. Doorway page warning: pages with only city names swapped will trigger manual action.

**Local keyword patterns:**

| Pattern | Example |
|---------|---------|
| `[service] in [city]` | "plumber in Austin" |
| `best [service] [city]` | "best dentist Austin" |
| `[service] [neighborhood]` | "plumber Mueller Austin" |
| `emergency [service] [city]` | "emergency plumber Austin" |
| `[service] cost in [city]` | "plumber cost in Austin" |

Do not target "near me" in content — it is a proximity signal, not a keyword.

**Gate:** Content gap list produced. Priority pages identified.

### Step 6: Review Management

Reviews are the second strongest local ranking factor.

**Acquisition methods** — ethical only: ask at point of delight, SMS/email follow-up 1-2 hours post-service, Google review shortcut link (`search.google.com/local/writereview?placeid=YOUR_PLACE_ID`), QR codes on receipts/cards, dedicated review page on website. Never incentivize, buy, review-gate, or solicit Yelp reviews specifically.

**Response approach:** Respond to every review within 24 hours. Include business name and service naturally (keyword signal). Keep under 200 words. Move negative conversations offline. Never argue or reveal customer details. Personalize each response.

**Velocity targets:**

| Stage | Target/month |
|-------|-------------|
| New (0-20 reviews) | 5-10 |
| Established (20-100) | 3-5 |
| Mature (100+) | 2-4 |
| Competitive market | Match top competitor's velocity |

Recency matters — Google weights recent reviews more heavily than total count.

**Platform priority:** 70% effort on Google, 20% on primary industry platform, 10% on everything else.

**Gate:** Current review velocity calculated. Competitor review comparison documented. Response rate assessed.

### Step 7: Generate Audit Report

Score each section out of 100: GBP, NAP Consistency, Schema, Local Content, Review Profile, Local Backlinks. Calculate overall score and letter grade. Prioritize actions as Critical / High / Medium / Low with impact and effort ratings. Include 90-day action plan: Week 1 critical fixes, Weeks 2-3 GBP + citations, Weeks 4-6 content, Weeks 7-8 reviews, Weeks 9-12 link building, ongoing weekly posts + monthly monitoring.

## Outputs

- Scored audit report with section scores (/100) and overall grade
- Prioritized action item list (Critical/High/Medium/Low with impact + effort)
- Citation status table (platform, claimed, NAP match, action needed)
- Schema markup recommendation (type + required properties)
- Content gap list with priority pages
- 90-day action plan with weekly milestones

## Examples

**Single-location service business:**
User provides plumber name + Austin address + website. Audit finds GBP unclaimed, no schema, 8 reviews. Report scores GBP 15/100, overall 28/100. Critical actions: claim GBP, add categories, submit to data aggregators. 90-day plan front-loads GBP claiming in week 1.

**Multi-location retail:**
User has 3 dental offices, shared website with no location pages. Audit finds NAP inconsistencies across 12 directories, generic LocalBusiness schema. Report recommends dedicated location pages with unique content, specific Dentist @type schema per page, aggregator submissions to fix NAP cascade.

## Common Issues

| Issue | Fix |
|-------|-----|
| GBP suspended after editing business name | Remove keyword stuffing from name; submit reinstatement appeal via GBP dashboard with proof of legal name |
| Schema present but not appearing in rich results | Validate with Rich Results Test — likely missing required properties (geo, openingHours) or NAP mismatch between schema and page text |
| Service area pages penalized as doorway pages | Rewrite with 300+ words genuinely unique per page — different testimonials, neighborhood references, local details |

## Anti-Patterns

| Anti-Pattern | Correct Approach |
|-------------|------------------|
| Keywords in GBP business name | Use exact legal/trading name only |
| Virtual office or PO Box address | Real physical location or service-area-business setup |
| Duplicate GBP listings | Merge duplicates; one listing per physical location |
| Identical location pages with city names swapped | Genuinely unique content per page (300+ words) |
| Buying fake reviews or incentivizing reviews | Organic acquisition through service quality + systematic asking |
| Soliciting Yelp reviews | Let Yelp reviews happen naturally; focus solicitation on Google |
| Generic LocalBusiness schema type | Most specific subtype (Plumber, Dentist, Attorney, etc.) |
| Targeting "near me" in page content | Target `[service] in [city]` patterns instead |
| Building content before GBP is optimized | GBP drives 40%+ of local signals — optimize it first |
| Submitting to hundreds of low-quality directories | Focus on 30-50 high-quality, relevant citations across tiers |

## Escalation

- **GBP suspended** — reinstatement appeals process is complex; may need specialist
- **10+ locations** — manual management unsustainable; recommend Yext, Rio SEO, or Uberall
- **Franchise/multi-brand** — franchise-specific GBP policies and complex schema relationships
- **Sustained fake review attacks** — legal intervention + systematic flagging with documentation
- **HIPAA/legal compliance** — review response restrictions require compliance officer review
- **International local SEO** — country-specific GBP, schema, and citation differences
- **Local Service Ads (LSAs)** — separate Google pay-per-lead product requiring distinct setup

## Level History

- **Lv.1** — Base: Full protocol with GBP optimization, NAP audit, schema templates, content strategy, review management, citation tiers, link building, audit report format. (Origin: MemStack v3.2, Feb 2026)
- **Lv.2** — Compressed: Decision-rules-only rewrite. Removed complete JSON-LD schemas, review response templates, outreach email templates, exhaustive directory URLs, link building sponsorship tables. Preserved GBP priorities, NAP method, @type selection rules, review strategy, content patterns, citation tiers, keyword patterns. (Origin: MemStack v3.3, Mar 2026)
