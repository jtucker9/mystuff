---
name: pricing-strategy
description: "Use when the user says 'pricing strategy', 'how to price', 'pricing model', 'tier pricing', 'pricing table', 'what to charge', or needs help setting prices for a product or service. Do NOT use for competitor pricing research (use competitor-analysis), generating client quotes/proposals (use proposal-writer), or calculating project costs without pricing strategy context."
---

# Pricing Strategy -- Revenue-Optimized Pricing Design
*Analyze pricing models, design tier structures, and apply pricing psychology for maximum conversion and revenue.*

## Activation

When this skill activates, output:

`Pricing Strategy -- Designing your pricing architecture...`

| Context | Status |
|---------|--------|
| **User says "pricing strategy", "how to price", "pricing model"** | ACTIVE |
| **User wants to design tiers, set prices, or compare models** | ACTIVE |
| **User asks about pricing psychology or A/B testing prices** | ACTIVE |
| **User wants competitor pricing comparison** | DORMANT -- see competitor-analysis |
| **User wants to generate a client quote/proposal** | DORMANT -- see proposal-writer |

## Instructions

### Step 1: Gather Inputs

Ask the user for:
- **Product type**: SaaS, physical product, service, digital product, info product
- **Cost structure**: COGS, delivery cost, fixed costs, marginal cost per unit
- **Target market**: B2B or B2C? Enterprise or SMB? Price-sensitive or value-driven?
- **Competitor pricing**: What do alternatives cost? (or use competitor-analysis output)
- **Current pricing** (if any): What are you charging now? What's working/not?

**Gate:** Do not proceed until product type and target market are known. Cost structure can be estimated if unavailable.

### Step 2: Select Pricing Model

**Decision logic by product type:**

| Product Type | Default Model | Alternative If... |
|-------------|---------------|-------------------|
| SaaS (B2B) | Tiered subscription | Usage-based if value scales with consumption |
| SaaS (B2C) | Freemium + paid tier | Flat subscription if no natural free tier |
| Physical product | One-time purchase | Subscription if consumable/replenishable |
| Service | Project-based or retainer | Per-seat if team-based delivery |
| Digital product | One-time purchase | One-time + subscription if community included |
| Info product | One-time purchase | Tiered if multiple depth levels |
| API/Infrastructure | Usage-based | Per-seat if team collaboration tool |

Recommend top 1-2 models with justification specific to this product.

**Gate:** User confirms model before designing tiers.

### Step 3: Design Tier Structure

If tiered pricing is recommended, design 3 tiers (or recommend against tiers with rationale):

| | Starter | Professional | Enterprise |
|---|---------|-------------|------------|
| **Price** | $X/mo | $X/mo | Custom |
| **Target** | [who] | [who] | [who] |
| **Features** | [list] | [list] | [list] |
| **Limits** | [cap] | [cap] | Unlimited |
| **Support** | Email | Priority | Dedicated |

**Feature gating rules:**
- Gate by volume/scale, not by crippling the product
- Each tier must feel complete for its target user
- Middle tier = obvious "best value" (most popular tag)
- Enterprise tier anchors high value

### Step 4: Apply Pricing Psychology

Select applicable techniques:

- **Anchor pricing**: Add a tier that makes the target tier look better. $9 / **$29** / $49 -- the $49 makes $29 feel like a deal
- **Charm pricing**: .99/.97 for consumer (B2C); round numbers for premium/B2B ($500 signals confidence)
- **Price framing**: Annual billing as monthly equivalent; daily framing ("Less than $1/day"); ROI framing ("Saves 10hr/mo at your rate")
- **Comparison anchoring**: "vs $200/hr consultant" or "vs $X,000 lost to [problem] per year"

**Decision:** Use charm pricing for B2C <$100. Use round numbers for B2B or premium >$500.

### Step 5: Calculate Minimum Viable Price

```
Fixed costs (monthly)   = $______
Variable cost per unit  = $______
Target margin           = ____%
Break-even volume       = ______ units
Minimum price per unit  = $______ (covers costs + margin)
Market rate range       = $______ - $______
Recommended price       = $______ (aim for top 30% of market)
```

**Gate:** If recommended price is below floor price, flag the margin risk before proceeding.

### Step 6: A/B Test Plan

- **What to test**: Price point first, then tier structure, then psychology elements
- **Method**: Cohort or time-based splits (never show different prices to the same user)
- **Duration**: Minimum 2 weeks per test
- **Metrics**: Conversion rate AND revenue per visitor (not just signups)

### Step 7: Output

```
--- PRICING STRATEGY: [Product Name] ---
Model: [name] -- [rationale]
Tiers: [pricing table]
Psychology: [anchor, framing, charm techniques applied]
Floor price: $[X] | Recommended: $[X] | Market range: $[low]-$[high]
Revenue projections: Conservative [X%/N/$X], Moderate [X%/N/$X], Optimistic [X%/N/$X]
A/B test plan: [test 1], [test 2]
```

## Examples

**Example 1: SaaS pricing for B2B tool**
Input: "Project management SaaS, $200/mo avg competitor, targeting SMBs, 5-person teams."
Output: Tiered subscription -- Free (2 users) / Pro $29/seat/mo / Business $49/seat/mo. Anchor: Business makes Pro look like a deal. ROI framing: "Replaces $2K/mo in PM overhead."

**Example 2: Info product pricing**
Input: "Online course teaching SEO, competitors charge $200-$500, solo creator."
Output: One-time purchase at $297. Charm pricing ($297 not $300). Comparison anchor: "vs $150/hr SEO consultant." Add $47/mo community upsell for recurring revenue.

## Common Issues

- **All tiers convert equally**: Middle tier is not differentiated enough. Add a "Most Popular" badge and ensure its feature set is clearly superior to Starter.
- **Enterprise tier gets zero interest**: Price is too vague ("Contact us" without anchoring). Add a starting-at price or feature comparison that justifies the jump.
- **Revenue below projections despite good conversion**: Price is too low. Test a 20-30% increase -- conversion often drops less than expected.

## Anti-Patterns

- Pricing based on cost-plus alone without considering perceived value or market positioning
- Creating more than 4 tiers (causes decision paralysis)
- Showing monthly and annual prices with confusing math (annual should always show monthly equivalent)
- Launching without any price testing plan
- Copying competitor prices without understanding their cost structure or positioning
- Gating essential features in the free/starter tier to force upgrades (breeds resentment)

## Inputs
- Product type and description
- Cost structure (fixed + variable)
- Target market characteristics
- Competitor pricing (or competitor-analysis output)
- Current pricing (if exists)

## Outputs
- Pricing model recommendation with justification
- Tier structure with feature gating (if tiered)
- Pricing psychology techniques applied
- Minimum viable price calculation
- Revenue projections at 3 conversion scenarios
- A/B test plan for pricing validation

## Level History

- **Lv.1** -- Base: 7-model pricing analysis, tier structure design with feature gating, pricing psychology toolkit (anchoring, charm, framing), minimum viable price calculation, revenue projections, A/B test plan. (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** -- Guide alignment: Added negative triggers, validation gates, decision logic tables for model selection and psychology, examples, common issues, anti-patterns. Renamed Protocol to Instructions. Removed emoji from title. (Origin: Anthropic skill guide alignment, Mar 2026)
