---
name: google-ad
description: "Use when the user says 'google ad', 'search ad', 'PPC', 'Google Ads', 'AdWords', 'responsive search ad', or wants paid search campaign copy. Do NOT use for Facebook/Meta/Instagram ads (see facebook-ad), organic SEO (see site-audit), or display/video campaign creative."
---

# Google Ad -- Search Campaign Builder

Generate responsive search ads, keyword groups, and extensions ready to import into Google Ads.

## Activation

When this skill activates, output:

`Google Ad -- Building your search campaign...`

| Context | Status |
|---------|--------|
| User says "google ad", "search ad", "PPC", "Google Ads" | ACTIVE |
| User wants responsive search ad copy | ACTIVE |
| User mentions keywords, ad extensions, or Quality Score | ACTIVE |
| User wants Facebook/social ads | DORMANT -- see facebook-ad |
| User wants SEO (organic search, not paid) | DORMANT -- see seo-geo skills |
| User wants display or video ads only | DORMANT -- not covered here |

## Instructions

### Step 1: Gather Inputs

Ask the user for:
- **Product/service**: What are you advertising?
- **Target keywords**: 5-10 seed keywords (or let the skill suggest them)
- **Landing page URL**: Where does the ad send people?
- **Monthly budget**: Total Google Ads spend
- **Geographic targeting**: Country, region, or city (optional)
- **Competitor names**: For negative keyword planning (optional)

**Gate**: Do not proceed until product and at least 3 seed keywords are provided.

### Step 2: Write Responsive Search Ads

Generate assets for Google's responsive search ad format:

**15 Headlines** (max 30 characters each):
- H1-3: Primary keyword + benefit
- H4-6: Secondary keywords + differentiation
- H7-9: Social proof (numbers, awards, reviews)
- H10-12: CTA-focused (Get, Try, Start, Save)
- H13-15: Urgency/offer-focused (Limited, Free, Today)

**4 Descriptions** (max 90 characters each):
- D1: Value proposition + primary keyword
- D2: Features/benefits list
- D3: Social proof + trust signal
- D4: CTA + urgency element

Pin recommendations: Pin keyword-rich headline to position 1, CTA headline to position 3.

**Gate**: Verify every headline is 30 chars or fewer and every description is 90 chars or fewer before continuing.

### Step 3: Keyword Grouping

Organize keywords into tightly themed ad groups:

| Ad Group | Keywords | Match Type |
|----------|----------|------------|
| Brand | [brand name], [brand + product] | Exact |
| Product | [product type], [product category] | Phrase |
| Problem | [pain point], [problem phrase] | Phrase |
| Competitor | [competitor name + alternative] | Exact |
| Long-tail | [specific use case queries] | Broad (with monitoring) |

For each keyword provide exact `[keyword]`, phrase `"keyword"`, and broad match versions with estimated search volume tier (high/medium/low) and suggested max CPC bid range.

### Step 4: Negative Keywords

Build a negative keyword list by category:
- **Universal**: free, cheap, download, torrent, DIY, how to (if selling premium)
- **Job-related**: jobs, career, salary, hiring, intern
- **Informational**: what is, definition, wiki, tutorial (unless content marketing)
- **Competitor brand terms**: (if not running competitor campaigns)
- **Irrelevant modifiers**: industry-specific terms that attract wrong audience

### Step 5: Ad Extensions

Write all applicable extension types:
- **Sitelinks** (4-6): link text (25 chars), description lines (35 chars each), URL
- **Callouts** (4-6): short benefit phrases (25 chars each)
- **Structured Snippets** (2-3): header type + values
- **Other**: call, location, price, promotion extensions as applicable

**Gate**: Confirm sitelink text is 25 chars or fewer and description lines are 35 chars or fewer.

### Step 6: Landing Page Alignment Check

Audit the landing page against ad copy:
- Keyword presence in H1, H2, body
- Message match between page headline and ad headline
- CTA consistency between page and ad promise
- Flag load speed or mobile issues (affects Quality Score)

### Step 7: Output

Present the complete campaign in this format:

```
CAMPAIGN: [Product Name] Search

AD GROUP 1: [Theme]
Keywords: [list with match types]
Negative KWs: [list]
Headlines (15): H1-H15
Descriptions (4): D1-D4

EXTENSIONS
Sitelinks: [list]
Callouts: [list]
Snippets: [header]: [values]

LANDING PAGE NOTES
[alignment recommendations]

QUALITY SCORE TIPS
[actionable improvements]
```

## Examples

**Example 1 -- SaaS product**
User: "Google ad for my project management tool, $2000/month budget"
Output: 5 ad groups (brand, product, problem, competitor, long-tail), 15 headlines like "Manage Projects 2x Faster", 4 descriptions, sitelinks to Pricing/Features/Demo/Reviews, negative list filtering "free project management" and job seekers.

**Example 2 -- Local service**
User: "PPC campaign for my Denver plumbing company"
Output: 3 ad groups (emergency, residential, commercial), geo-targeted to Denver metro, headlines like "Denver Plumber | Same Day", call extension with business phone, location extension, negative list filtering DIY/career terms.

## Common Issues

| Issue | Fix |
|-------|-----|
| Headlines exceed 30-char limit | Count characters before output; split compound phrases into separate headlines |
| Ad groups too broad (mixed intent) | Split any ad group containing both informational and transactional keywords |
| Negative keywords block good traffic | Review negatives against target keywords; never add a negative that is also a target keyword |

## Anti-Patterns

- Stuffing all keywords into one ad group instead of theming by intent
- Writing headlines that read well but contain zero target keywords
- Using broad match without a negative keyword list
- Ignoring landing page alignment (tanks Quality Score regardless of ad quality)
- Setting identical bids across all ad groups instead of adjusting by intent value
- Writing generic callouts ("Great Service") instead of specific proof ("4.9 Stars | 2,000+ Reviews")

## Inputs
- Product/service description
- Target keywords (or seed terms)
- Landing page URL
- Monthly budget
- Geographic targeting (optional)

## Outputs
- 15 headlines + 4 descriptions (responsive search ad format)
- Keyword groups with match types across 4-5 ad groups
- Negative keyword list by category
- Ad extensions (sitelinks, callouts, structured snippets, others)
- Landing page alignment audit
- Quality Score optimization tips
- Campaign structure ready for Google Ads import

## Level History

- **Lv.1** -- Base: Responsive search ad generation (15 headlines + 4 descriptions), keyword grouping with match types, negative keyword lists, full ad extensions suite, landing page alignment audit, Quality Score optimization tips, import-ready campaign format. (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** -- Guide alignment: Added negative triggers to description, validation gates between steps, Examples, Common Issues, Anti-Patterns. Renamed Protocol to Instructions. Removed emoji from title. (Origin: MemStack v3.3, Mar 2026)
