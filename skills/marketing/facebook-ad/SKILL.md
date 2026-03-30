---
name: facebook-ad
description: "Use when the user says 'facebook ad', 'FB ad', 'Meta ad', 'Instagram ad', 'social ad', or wants ad copy for Facebook/Instagram Ads Manager. Do NOT use for Google search ads (see google-ad), organic social media posts, influencer outreach, or general social media strategy."
---


# Facebook Ad -- Meta Ads Copy and Strategy
*Generate 3 ready-to-load ad variants with targeting, creative direction, and A/B test plan.*

## Activation

When this skill activates, output:

`Facebook Ad -- Generating Meta ad variants...`

| Context | Status |
|---------|--------|
| **User says "facebook ad", "FB ad", "Meta ad", "Instagram ad"** | ACTIVE |
| **User wants social media ad copy with targeting** | ACTIVE |
| **User mentions Ads Manager or ad sets** | ACTIVE |
| **User wants Google search ads** | DORMANT -- see google-ad |
| **User wants organic social content (not paid)** | DORMANT |

## Instructions

### Step 1: Gather Inputs

Ask the user for:
- **Product/service**: What are you advertising?
- **Target audience**: Age, interests, pain points, demographics
- **Monthly budget**: Total ad spend
- **Campaign objective**: Traffic, leads, conversions, or awareness
- **Landing page URL**: Where does the ad send people? (optional)

**Gate**: Do not proceed without product description, target audience, and campaign objective. Budget can default to "flexible" if not provided.

### Step 2: Write 3 Ad Variants

Generate three distinct ad approaches. For each variant, provide:
- **Primary text** (above fold; first 125 chars are visible before "See more")
- **Headline** (40 chars max)
- **Description**: Supporting detail
- **CTA button**: Learn More / Shop Now / Sign Up / Get Offer / See How / Get Started

**Variant A -- Storytelling**: Open with a relatable story hook that stops the scroll. Connect narrative to product, soft CTA.

**Variant B -- Problem-Solution**: State the pain point bluntly in the first 125 chars. Agitate. Present product as solution. Hard CTA.

**Variant C -- Social Proof**: Open with a specific result, metric, or customer quote. Expand with context. Invite similar results.

**Gate**: Every headline must be under 40 characters. Every primary text must front-load the hook in the first 125 characters. Verify before proceeding.

### Step 3: Audience Targeting

For each variant, recommend:
- **Core targeting**: 3-5 interests, behaviors, or demographics
- **Custom audiences**: Website visitors, email list, video viewers
- **Lookalike audiences**: 1%, 3%, 5% from best customers
- **Exclusions**: Existing customers, irrelevant segments
- **Placement**: Feed, Stories, Reels, or Automatic

### Step 4: Creative Direction

For each variant, describe the visual concept:
- **Format**: Single image, carousel, or video
- **Visual concept**: What the image/video shows, mood, colors
- **Text overlay**: On-image text (keep under 20% of image area)
- **Aspect ratios**: 1:1 for feed, 9:16 for Stories/Reels

### Step 5: A/B Test Plan and Budget

**Testing sequence** (4 weeks):
1. Week 1: Test creative (same copy, different visuals) -- find winning visual
2. Week 2: Test copy (winning creative, different variants) -- find winning message
3. Week 3: Test audience (winning creative + copy, different targeting) -- find best audience
4. Week 4: Scale winning combination, test new angles

**Budget split**:
- Testing phase (weeks 1-2): Equal split across variants, $5-10/day per ad set minimum
- Scaling phase: 70% to winner, 30% to new tests
- Retargeting reserve: 20% of total budget for warm audiences

**Gate**: If monthly budget is under $300, recommend testing only 2 variants instead of 3 and extending test phases.

### Step 6: Output

Present all 3 ad sets in Ads Manager-ready format with primary text, headline, description, CTA button, audience targeting, creative direction, and placement for each. Include the test plan and budget allocation as a separate section.

## Examples

**Example 1 -- E-commerce product launch**
User: "Write FB ads for our new noise-canceling earbuds, $49. Target remote workers 25-45. $1500/mo budget, goal is conversions."
Output: 3 variants (storytelling: "The meeting that changed everything...", problem-solution: "Still hearing your neighbor's dog during calls?", social proof: "4.8 stars from 2,000+ remote workers"). Each with targeting (interests: remote work, WFH, noise cancellation), carousel creative direction, 4-week test plan at $375/week.

**Example 2 -- Local service business**
User: "Meta ads for my Austin dog grooming mobile service. $500/mo, want leads."
Output: 3 variants with geo-targeted audience (Austin metro, 25mi radius, pet owners), single-image creative direction featuring before/after shots, lead form CTA, adjusted 2-variant test plan for lower budget.

## Common Issues

- **Primary text too long above the fold**: The first 125 characters must contain the complete hook. Everything after "See more" has a steep drop-off in readership.
- **Headline exceeds 40 characters**: Meta truncates long headlines on mobile. Always verify character count.
- **Budget too low for 3-variant testing**: Below $300/mo, reduce to 2 variants and extend test windows to get statistically meaningful data.

## Anti-Patterns

- Writing ad copy that reads like a product spec sheet instead of stopping the scroll
- Using the same targeting for all three variants (defeats the purpose of testing)
- Recommending Lookalike audiences when the user has no existing customer data to seed from
- Ignoring placement differences (what works in Feed often fails in Stories)
- Setting daily budgets below $5/ad set (insufficient for Meta's learning phase)
- Suggesting organic content strategies (this skill is paid ads only)

## Level History

- **Lv.1** -- Base: 3-variant ad generation (storytelling, problem-solution, social proof), audience targeting with lookalikes, creative direction briefs, A/B test sequence, budget allocation strategy, Ads Manager-ready output format. (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** -- Guide alignment: Added negative triggers, validation gates between steps, examples, common issues, anti-patterns. Renamed Protocol to Instructions. Removed emoji from titles. Fleshed out budget gating logic. (Origin: MemStack v3.3, Mar 2026)
