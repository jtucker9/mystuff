---
name: competitor-analysis
description: "Use when the user says 'competitor analysis', 'competitive analysis', 'compare competitors', 'competitor research', 'market analysis', or wants to understand their competitive landscape. Do NOT use for setting your own pricing (see pricing-strategy), writing ad copy targeting competitors (see facebook-ad/google-ad), or general market research without specific competitors to compare."
---


# Competitor Analysis -- Competitive Intelligence Report
*Analyze competitors' pricing, positioning, features, and weaknesses to find your strategic advantage.*

## Activation

When this skill activates, output:

`Competitor Analysis -- Building your competitive intelligence report...`

| Context | Status |
|---------|--------|
| **User says "competitor analysis", "competitive analysis"** | ACTIVE |
| **User wants to compare their product against competitors** | ACTIVE |
| **User asks about market positioning or competitive gaps** | ACTIVE |
| **User wants to set their own pricing (not compare)** | DORMANT -- see pricing-strategy |
| **User wants ad copy targeting competitor audiences** | DORMANT -- see facebook-ad or google-ad |

## Instructions

### Step 1: Gather Inputs

Ask the user for:
- **Your product**: What do you sell? Key features, price, positioning
- **Competitor URLs**: 3-5 competitor websites to analyze
- **Your differentiation**: What do you believe makes you different? (optional)
- **Target market**: Who are you both competing for?

**Gate**: Do not proceed without at least the product description and 2 competitor names/URLs.

### Step 2: Analyze Each Competitor

For each competitor, extract and assess:

**Company Profile**: Name, URL, estimated size, target audience, brand positioning (premium/budget/niche/mass-market), unique selling proposition.

**Product/Service**: Core offering, key features, pricing model and price points, free tier availability, strengths, weaknesses.

**Messaging**: Homepage headline, proof elements (testimonials, case studies, numbers), tone, trust signals.

**Gate**: If you cannot find pricing or feature data for a competitor, flag it explicitly and note assumptions.

### Step 3: Feature Comparison Matrix

Build a side-by-side feature matrix covering all competitors plus the user's product. Mark features as: Y (included), N (missing), BEST (best-in-class), PLANNED (roadmap).

### Step 4: Pricing Comparison

Build a pricing table showing lowest/mid/top tiers and free tier availability. Include a value-per-dollar analysis: which product delivers the most features per dollar at each tier?

### Step 5: Weakness Identification

Identify exploitable gaps across five dimensions:
- **Feature gaps**: Features competitors lack that the audience wants
- **Service gaps**: Support quality, onboarding, documentation
- **Price gaps**: Underserved price points
- **Audience gaps**: Segments competitors ignore
- **Messaging gaps**: Claims nobody is making that would resonate

Rank each by: impact (high/medium/low) x difficulty to exploit (easy/medium/hard).

**Gate**: Every weakness must cite a specific observable source (competitor page, review, pricing page). No speculation without labeling it.

### Step 6: SEO Overlap Analysis

Identify keyword and content competitive dynamics:
- Shared keywords both parties rank for
- Competitor keywords you miss
- Uncontested keyword opportunities
- Content gaps and advantages

### Step 7: Strategic Recommendations

Deliver 3-5 prioritized action items, each with rationale and expected impact. Present the full report in the structured output format: positioning summary, competitor profiles, feature matrix, pricing analysis, exploitable weaknesses (ranked), SEO opportunities, and recommendations.

## Examples

**Example 1 -- SaaS project management tool**
User: "Run a competitor analysis. We're TaskFlow, $15/mo project management for freelancers. Compare against Asana, Trello, and Monday."
Output: Profiles for each competitor, feature matrix (subtasks, time tracking, invoicing, templates), pricing table showing TaskFlow undercuts all three at the freelancer tier, weakness identification (none offer built-in invoicing), 3 strategic recommendations.

**Example 2 -- Local service business**
User: "Competitive analysis for my dog grooming business in Austin. Competitors: Bark & Bath, Pampered Paws, Austin Pet Spa."
Output: Profiles with pricing per service type, feature matrix (mobile grooming, breed specialization, loyalty programs), messaging analysis from their websites and Google reviews, weakness identification (no competitor offers subscription plans), local SEO overlap.

## Common Issues

- **Competitor data is stale or hidden**: Flag clearly, note the date of last observable data, and label inferences as assumptions.
- **Too many competitors dilute the analysis**: Cap at 5 competitors max. If the user provides more, ask them to prioritize or split into two reports.
- **Confusing competitive analysis with market sizing**: This skill compares specific named competitors. For TAM/SAM/SOM or broad market research, redirect to financial-model.

## Anti-Patterns

- Listing features without assessing relative strength or weakness
- Copying competitor marketing copy verbatim instead of analyzing it
- Making pricing recommendations (that is pricing-strategy territory)
- Treating all competitors as equally important instead of ranking by threat level
- Speculating about competitor revenue or internal strategy without evidence
- Producing a report without actionable recommendations at the end

## Level History

- **Lv.1** -- Base: Multi-competitor profiling, feature comparison matrix, pricing value analysis, messaging and proof audit, weakness identification with impact/difficulty ranking, SEO overlap analysis, strategic recommendations output. (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** -- Guide alignment: Added negative triggers, validation gates, examples, common issues, anti-patterns. Renamed Protocol to Instructions. Removed emoji from titles. (Origin: MemStack v3.3, Mar 2026)
