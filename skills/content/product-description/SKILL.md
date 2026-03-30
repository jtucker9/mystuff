---
name: product-description
description: "WHAT: Write conversion-optimized e-commerce product listing copy with benefit-driven headlines, feature bullets, storytelling, and platform-specific SEO. WHEN: 'product description', 'product listing', 'product copy', 'Amazon listing', 'Shopify description', 'Etsy listing', e-commerce copy requests. NOT: pricing strategy (see pricing-strategy), full sales funnels (see sales-funnel), website SEO not tied to a product page (see seo-geo)."
---

# Product Description — E-Commerce Listing Copy

## Activation

| Context | Status |
|---------|--------|
| User says "product description", "product listing", "product copy" | ACTIVE |
| User wants Amazon, Shopify, Etsy, or e-commerce listing copy | ACTIVE |
| User mentions product features, benefits, or listing optimization | ACTIVE |
| User wants pricing strategy (not copy) | DORMANT — see pricing-strategy |
| User wants a full sales funnel | DORMANT — see sales-funnel |
| User wants website SEO (not product listing) | DORMANT — see seo-geo |

## Instructions

### Step 1: Gather Inputs

Collect before writing:

| Input | Required | Notes |
|-------|----------|-------|
| Product name + category | Yes | |
| Top 5-7 features/specs | Yes | |
| Target buyer (demographics, pain points) | Yes | |
| Price point | Yes | Informs positioning language |
| Platform (Amazon/Shopify/Etsy/own site) | Yes | Determines format constraints |
| Competitors + unique selling point | Yes | |
| Target keyword | Optional | Skill can suggest if omitted |

**Gate:** Do not proceed until product name, features, target buyer, and platform are confirmed.

### Step 2: Write Headline

Lead with the primary benefit, not the product name.

**Formulas:** `[Product] — [Primary Benefit]` | `[Benefit] + [Product Category]` | `[Product]: [Outcome]` | `[Adjective] [Product] for [Audience]`

**Platform constraints:**

| Platform | Max Length | Rule |
|----------|-----------|------|
| Amazon | 200 chars (80 visible mobile) | Keywords in first 80 chars |
| Shopify | No limit (H1) | Primary keyword + benefit |
| Etsy | 140 chars | Long-tail keywords, specific descriptors |
| Own site | No limit | SEO title tag 60 chars or less |

Include target keyword naturally. Never keyword-stuff.

**Gate:** Headline must contain the primary keyword and a clear buyer benefit.

### Step 3: Write Benefit-Driven Bullets

Convert features to benefits using: `[FEATURE] -> [What this means for the buyer]`.

- Lead with benefit, follow with feature (invert the spec sheet)
- Amazon: 5-7 bullets (500 chars each). Shopify: 3-5. Etsy: 3-4.
- Include one trust bullet (guarantee, support, certification)
- Each bullet should preemptively answer an objection
- Bold first few words for scannability (where platform allows)
- Use action verbs or title case for scannable openers

**Gate:** Every bullet must contain a buyer-facing benefit, not just a raw spec.

### Step 4: Write Storytelling Paragraph

Structure: Problem (pain point) -> Transformation (life with product) -> Credibility (social proof) -> Close (reinforce decision).

Decision rules:
- Use "you" language throughout — it is about the buyer, not the product
- Be specific: "saves 45 minutes every morning" not "saves time"
- Address the emotional benefit alongside the functional one
- 100-200 words. One paragraph = one idea.
- Sensory and emotional language: describe what the buyer sees, feels, hears, or experiences — never just what the product "has"

**Gate:** Story must reference a specific pain point and a specific outcome.

### Step 5: Specs + SEO + Platform Format

**Specs:** Include only buyer-relevant specs. Always list what is in the box. Provide both imperial and metric for global sellers. Include certifications for trust.

**SEO by platform:**

- **Amazon:** Primary keyword in first 80 chars of title. 2-3 related keywords in bullets. Backend keywords (250 chars): synonyms, misspellings, translations. Decide A+ Content: recommend if brand-registered AND product has comparison-worthy features or lifestyle imagery.
- **Shopify:** URL slug = `/products/[primary-keyword]`. Meta title 60 chars or less: `[Product] — [Benefit] | [Brand]`. Meta description 155 chars or less with CTA. Product schema markup (price, availability, reviews).
- **Etsy:** First 160 chars of description act as meta description — front-load keywords. 13 tags, 20 chars each, long-tail phrases. Storytelling (craft/process) performs well.
- **General placement:** Title = primary keyword (must). Bullet 1 = primary keyword (should). Bullets 2-3 = secondary keywords (should). Description = primary + secondary + long-tail (must). Image alt text = primary keyword + visual description (should).

**Pricing context:** Reference the price point to calibrate language register. Premium products get aspirational language and exclusivity signals. Budget products emphasize value, durability, and comparison wins.

**Gate:** SEO section must include at least primary keyword, meta title, and meta description tailored to the declared platform.

### Step 6: Assemble + Deliver

Output the complete listing in platform-ready format:

```
HEADLINE: [platform-optimized title]
BULLETS: [benefit-led, platform count]
STORY: [100-200 word paragraph]
SPECS: [scannable table]
SEO: [primary/secondary keywords, meta title, meta description, backend keywords if Amazon]
CONVERSION NOTES: [primary objection addressed, trust signal, urgency element if applicable]
```

## Examples

**Example 1 — Amazon bullet (wireless earbuds, $49)**
`NOISE-CANCELING MICROPHONE — Crystal-clear calls even in noisy coffee shops. The dual-mic array isolates your voice so callers hear you, not the crowd.`
Why it works: Benefit leads (clear calls), feature follows (dual-mic), specific scenario (coffee shop), objection handled (background noise).

**Example 2 — Etsy title (handmade wallet, $65)**
`Minimalist Leather Wallet, Slim Card Holder for Men, RFID Blocking, Personalized Gift, Anniversary`
Why it works: Descriptive long-tail keywords, comma-separated for Etsy search, includes gift occasion for discovery.

## Common Issues

1. **Feature-dumping without benefits.** Every bullet must answer "so what?" for the buyer. Raw specs belong in the specs table, not the bullets.
2. **Wrong format for platform.** Amazon has strict character limits and backend keyword fields. Shopify uses HTML. Etsy weights title keywords heavily. Always check platform constraints before writing.
3. **Generic storytelling.** "This product will change your life" converts poorly. Use specific scenarios, specific numbers, and specific outcomes.

## Anti-Patterns

- Writing the same copy for all platforms — each has different search algorithms and format rules
- Keyword-stuffing the headline — degrades readability and triggers platform penalties
- Skipping the trust bullet — buyers need at least one risk-reducer (guarantee, warranty, certification)
- Using manufacturer spec-sheet language instead of buyer language
- Omitting pricing context — a $15 product and a $500 product require fundamentally different tone and positioning

## Escalation

- Product requires regulatory/compliance claims (FDA, medical, supplements) -> flag for legal review, do not write health claims
- User wants A/B test variants -> generate 2 headline + bullet variants with rationale for each, but recommend testing tools
- Multi-language listings -> write English first, flag that machine translation of product copy underperforms human localization

## Inputs

- Product name, category, key features (5-7)
- Target buyer profile (demographics, pain points)
- Price point
- Platform (Amazon, Shopify, Etsy, own site)
- Competitors and unique selling point
- Target keyword (optional)

## Outputs

- Benefit-led headline optimized for target platform
- Feature-to-benefit bullet points (platform-appropriate count)
- Storytelling paragraph (100-200 words)
- Technical specifications (scannable format)
- SEO optimization (keywords, meta tags, backend keywords where applicable)
- Platform-specific formatted listing, paste-ready
- Conversion notes (objection addressed, trust signal, urgency if applicable)

## Level History

- **Lv.1** — Base: 4 headline formulas by platform, feature-to-benefit bullet conversion, storytelling framework, spec template, platform-specific SEO (Amazon/Shopify/Etsy), platform formatting with character limits, paste-ready output. (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** — Compressed: Creator-level density rewrite. Added validation gates, pricing context calibration, sensory/emotional language rules, A+ Content decision criteria, anti-patterns, escalation paths. Reduced from 289 to 170 lines. (Origin: MemStack v3.2, Mar 2026)
