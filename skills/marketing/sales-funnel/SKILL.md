---
name: sales-funnel
description: "Use when the user says 'sales funnel', 'funnel', 'conversion funnel', 'customer journey', 'funnel strategy', or wants to map awareness-to-retention flow for a product. Do NOT use for writing ad copy (use facebook-ad/google-ad), designing only a lead magnet without funnel context (use lead-magnet), or planning a product launch timeline (use launch-plan)."
---

# Sales Funnel -- Full-Funnel Conversion Architecture
*Map the complete customer journey from stranger to repeat buyer with copy hooks and conversion targets.*

## Activation

When this skill activates, output:

`Sales Funnel -- Mapping your conversion architecture...`

| Context | Status |
|---------|--------|
| **User says "sales funnel", "funnel", "conversion funnel"** | ACTIVE |
| **User wants to map customer journey stages** | ACTIVE |
| **User asks about lead magnets or tripwires in funnel context** | ACTIVE |
| **User is writing ad copy (not funnel structure)** | DORMANT -- see facebook-ad or google-ad |
| **User is planning a launch (not funnel design)** | DORMANT -- see launch-plan |
| **User wants only a lead magnet (no funnel)** | DORMANT -- see lead-magnet |

## Instructions

### Step 1: Gather Inputs

Ask the user for:
- **Product/service**: What are you selling?
- **Price point**: What does it cost? (or price range for tiered)
- **Target audience**: Who is the ideal buyer? Demographics, psychographics
- **Primary traffic source**: Where do visitors come from? (organic, paid, social, referral)

**Gate:** Do not proceed until product and price point are known. Audience and traffic can be inferred if needed.

### Step 2: Select Funnel Type

**Decision logic by price point and product:**

| Price Range | Product Type | Funnel Type | Key Difference |
|-------------|-------------|-------------|----------------|
| <$50 | Digital product, e-commerce | Direct sale funnel | No tripwire needed, short nurture |
| $50-$500 | Courses, SaaS, services | Tripwire funnel | Low-cost offer ($7-47) bridges to core |
| $500-$5K | High-ticket service, program | Application funnel | Nurture + call booking replaces checkout |
| $5K+ | Enterprise, consulting | Relationship funnel | Long nurture, multiple touchpoints, proposal |

- If product has recurring revenue (SaaS, membership) --> add free trial or freemium stage
- If audience is cold (paid traffic) --> longer nurture sequence needed
- If audience is warm (organic, referral) --> can compress consideration stage

**Gate:** User confirms funnel type before building stages.

### Step 3: Map the 5-Stage Funnel

Build each stage with specific content, CTA, and target metric:

| Stage | Goal | Content | CTA | Target Metric |
|-------|------|---------|-----|---------------|
| **Awareness** | Attract strangers | Blog, social, SEO, ads | Click / Follow | CTR, reach |
| **Interest** | Capture contact info | Lead magnet, free resource | Opt-in | Opt-in rate: 25-40% |
| **Consideration** | Build trust and desire | Email nurture, case studies, demos | Book call / Try free | Open rate, demo requests |
| **Conversion** | Close the sale | Sales page, checkout, 1:1 call | Buy now | Conv rate: 1-5% |
| **Retention** | Keep, expand, refer | Onboarding, support, loyalty | Refer / Upgrade | LTV, churn, NPS |

Customize content type per stage based on the funnel type selected in Step 2.

### Step 4: Design Top-of-Funnel (Lead Magnet)

Select lead magnet based on audience:

- **B2B / High-ticket**: Free assessment, ROI calculator, industry report
- **B2C / E-commerce**: Discount code, style guide, quiz
- **SaaS**: Free trial, template library, mini-course
- **Info products**: Cheat sheet, checklist, sample chapter

Deliver: title, format, estimated creation time, opt-in page headline.

**Gate:** Lead magnet must be directly related to the core offer. If it attracts the wrong audience, redesign.

### Step 5: Design Middle-of-Funnel

**Tripwire offer** (for $50-$500 funnels): Low-cost offer ($7-$47) that converts leads into buyers. Must deliver immediate value and bridge to the core offer.

**Nurture sequence** (for all funnels): 3-7 emails over 7-14 days.
- Emails 1-2: Deliver value, build credibility
- Emails 3-4: Story/proof, case studies
- Emails 5-6: Bridge gap, introduce core offer
- Email 7: Direct offer with FAQ and objection handling

**Objection handling** for core offer:
- Price objection --> ROI framing or payment plan
- Trust objection --> Social proof, guarantee, case study
- Timing objection --> Cost of delay, urgency element

### Step 6: Design Post-Purchase Strategy

- **Immediate**: Thank-you page with upsell (order bump or one-time offer)
- **Week 1**: Onboarding sequence -- help them get first win
- **Week 2-4**: Cross-sell complementary product
- **Month 2+**: Referral program, loyalty rewards, case study request
- **Ongoing**: Re-engagement campaigns for inactive customers

### Step 7: Output Funnel Diagram

```
AWARENESS  -->  [Traffic Source]
    |           Content: ___, CTA: ___, Target: ___ visitors/mo
    v
INTEREST   -->  [Lead Magnet: ___]
    |           Opt-in rate: ___%, Target: ___ leads/mo
    v
CONSIDER   -->  [Tripwire: $___ ___] (if applicable)
    |           Nurture: ___ emails over ___ days
    v
CONVERT    -->  [Core Offer: $___ ___]
    |           Conv rate: ___%, Revenue target: $___/mo
    v
RETAIN     -->  [Upsell: ___]
                Upsell rate: ___%, LTV target: $___
```

Include copy hooks (headline/angle) for each stage transition.

## Examples

**Example 1: SaaS tripwire funnel**
Input: "$99/mo project management tool for agencies, traffic from Google Ads."
Output: Awareness (Google Ads targeting "agency project management") --> Interest (Free template pack, 30% opt-in) --> Consider ($17 mini-course "Agency Ops in a Week") --> Convert (14-day free trial to $99/mo) --> Retain (quarterly business review upsell to $199/mo tier).

**Example 2: High-ticket application funnel**
Input: "$3,000 SEO consulting package, traffic from LinkedIn content."
Output: Awareness (LinkedIn posts on SEO wins) --> Interest (Free SEO audit report, 25% opt-in) --> Consider (5-email case study sequence + strategy call booking) --> Convert (1:1 strategy call with proposal) --> Retain (retainer upsell + referral program).

## Common Issues

- **High traffic, zero opt-ins**: Lead magnet is misaligned with the audience's immediate problem. Match the magnet to a pain point they already feel, not one you want to educate them about.
- **Good opt-ins, no sales**: Nurture sequence is too short or too passive. Ensure at least one email directly addresses objections and makes a clear offer.
- **Tripwire cannibalizes core offer**: Tripwire delivers too much value at the low price. The tripwire should solve one small problem, not the whole problem.

## Anti-Patterns

- Skipping the consideration stage and going straight from opt-in to sales pitch
- Building a funnel without knowing the core offer's conversion rate first
- Using the same funnel structure for a $27 ebook and a $5,000 service
- Designing the funnel bottom-up (starting with retention instead of awareness)
- Adding more than 5 stages (overcomplication reduces execution likelihood)
- Writing nurture emails that only provide value without ever making an offer

## Inputs
- Product name and description
- Price point(s)
- Target audience profile
- Primary traffic source

## Outputs
- Funnel type recommendation with rationale
- 5-stage funnel map with content, CTAs, and metrics per stage
- Lead magnet recommendation with opt-in copy
- Tripwire offer design (if applicable)
- Core offer positioning with objection handling
- Post-purchase upsell/cross-sell strategy
- Visual funnel diagram with conversion targets

## Level History

- **Lv.1** -- Base: 5-stage funnel architecture (awareness to retention), lead magnet selection matrix, tripwire design, core offer positioning with objection handling, post-purchase expansion strategy, funnel diagram template with conversion targets. (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** -- Guide alignment: Added negative triggers, funnel type decision logic by price point, validation gates, nurture sequence structure, examples, common issues, anti-patterns. Renamed Protocol to Instructions. Removed emoji from title. (Origin: Anthropic skill guide alignment, Mar 2026)
