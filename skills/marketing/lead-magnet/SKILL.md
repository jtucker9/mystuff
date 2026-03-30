---
name: lead-magnet
description: "Use when the user says 'lead magnet', 'opt-in', 'freebie', 'email list', 'list building', 'opt-in page', or wants to create a free resource to capture email subscribers. Do NOT use for full-funnel design (use sales-funnel), paid ad copy (use facebook-ad/google-ad), or email sequence writing without a lead magnet context (use email-sequence)."
---

# Lead Magnet -- Opt-In Asset and Delivery System
*Design a high-converting lead magnet with landing page copy, delivery emails, and nurture sequence.*

## Activation

When this skill activates, output:

`Lead Magnet -- Designing your lead capture system...`

| Context | Status |
|---------|--------|
| **User says "lead magnet", "opt-in", "freebie", "list building"** | ACTIVE |
| **User wants to grow their email list** | ACTIVE |
| **User wants landing page copy for a free resource** | ACTIVE |
| **User wants the full funnel (not just lead magnet)** | DORMANT -- see sales-funnel |
| **User wants paid ad copy to promote the lead magnet** | DORMANT -- see facebook-ad or google-ad |

## Instructions

### Step 1: Gather Inputs

Ask the user for:
- **Niche/industry**: What space are you in?
- **Audience pain points**: Top 3 problems your audience faces
- **Existing content**: Blog posts, videos, or tools to repurpose?
- **Core offer**: What paid product does the lead magnet lead toward?
- **Email platform**: ConvertKit, Mailchimp, Beehiiv, or other?

**Gate:** Do not proceed until niche, at least one pain point, and core offer are known.

### Step 2: Select Lead Magnet Format

Choose format based on audience and effort budget:

| Format | Best When | Est. Opt-in Rate | Effort |
|--------|-----------|-------------------|--------|
| Checklist | Audience wants quick wins, low trust barrier | 30-40% | Low |
| Template | Audience needs done-for-you starting points | 25-35% | Low-Med |
| Mini-course | Topic requires sequential learning (3-5 emails) | 20-30% | Medium |
| Tool/Calculator | Quantifiable problem, high perceived value | 35-50% | High |
| Report/Guide | Audience values data and authority | 15-25% | Medium |

**Decision logic:**
- Audience is time-poor and action-oriented --> Checklist or Template
- Problem is complex or sequential --> Mini-course
- Product is data-driven or financial --> Tool/Calculator
- Audience is research-heavy (B2B, enterprise) --> Report/Guide

Generate 3-5 options, recommend top pick with rationale.

**Gate:** User confirms format before designing content.

### Step 3: Design Content Outline

For the selected format, produce:
- Title (specific, outcome-focused -- not vague)
- Subtitle (what they will achieve)
- Format and length (PDF pages, email count, tool type)
- Section-by-section outline (3-7 sections) with key takeaway per section
- Estimated creation time

### Step 4: Write Opt-In Page Copy

**Headline** (8-12 words): `[Get/Download/Grab] + [Specific Outcome] + [Timeframe/Ease]`

**Subheadline** (15-20 words): Expand on promise, address skepticism.

**Bullet points** (3-5): Each starts with a benefit verb (Discover, Learn, Get, Unlock). Each promises a specific outcome.

**CTA button text**: Action words only -- "Send Me the Checklist", "Get Instant Access". Never "Submit".

**Form fields**: Email only (highest conversion). Add First Name only if segmentation is required.

**Gate:** Headline must pass the "would I click this?" test -- specific outcome, not generic.

### Step 5: Design 5-Email Delivery Sequence

| Email | Timing | Purpose | Subject Line Pattern |
|-------|--------|---------|---------------------|
| 1 -- Delivery | Day 0 | Deliver asset + quick-start tip | "Here's your [Name]" |
| 2 -- Quick Win | Day 2 | Most impactful action from asset | "Do this first with your [Name]" |
| 3 -- Story/Proof | Day 4 | Case study showing results | "How [Person] used this to [Result]" |
| 4 -- Bridge | Day 6 | Gap between free asset and full transformation | "The next step after [Topic]" |
| 5 -- Offer | Day 8 | Present core offer with FAQ | "Ready for [Full Outcome]?" |

Optional: Thank-you page tripwire offer ($7-$27) immediately after opt-in.

### Step 6: Platform Integration

Provide setup steps for the user's email platform:
- **ConvertKit**: Form --> Sequence --> Tag subscribers
- **Mailchimp**: Landing Page --> Automation --> Tags by engagement
- **Beehiiv/SendGrid**: Webhook for form submission, API integration, drip config

### Step 7: Output Summary

Present the complete spec in this structure:

```
--- LEAD MAGNET SPEC: [Title] ---
Concept: [type], [format], [length], [creation time]
Content: [section outline]
Opt-in Page: [headline, subheadline, bullets, CTA]
Delivery Sequence: [5 emails with subjects and timing]
Platform: [integration steps]
Benchmarks: opt-in [X%], open rate [X%], nurture-to-sale [X%]
```

## Examples

**Example 1: SaaS onboarding checklist**
Input: "I sell a $49/mo project management SaaS. Audience is freelancers."
Output: Checklist -- "The 10-Minute Setup That Makes Freelancers Look Like Agencies". PDF, 2 pages. Opt-in rate target: 35%. 5-email sequence bridging to free trial.

**Example 2: B2B industry report**
Input: "We sell $5K/mo marketing services to e-commerce brands."
Output: Report -- "2026 E-Commerce Ad Spend Benchmarks by Channel". PDF, 12 pages. Opt-in rate target: 20%. 5-email sequence bridging to strategy call booking.

## Common Issues

- **Low opt-in rate (<15%)**: Headline is too vague or generic. Rewrite with a specific, measurable outcome.
- **High opt-in, low open rate**: Delivery email lands in spam. Shorten subject line, avoid "free" in subject, use plain text format.
- **Nurture sequence ignored after Email 1**: Email 2 does not provide enough standalone value. Make each email useful even without the asset.

## Anti-Patterns

- Gating content behind too many form fields (name + email + phone + company = conversion killer)
- Making the lead magnet a sales pitch disguised as free content
- Sending the offer email (Email 5) before establishing any trust or value
- Creating a 30-page PDF when a 1-page checklist would convert better
- Using "Download Now" or "Submit" as CTA text
- Designing the lead magnet without knowing what paid offer it leads toward

## Inputs
- Niche/industry
- Audience pain points (top 3)
- Existing content inventory
- Core paid offer
- Email platform

## Outputs
- 3-5 lead magnet concepts ranked by conversion potential and effort
- Detailed content outline for top pick
- Opt-in page copy (headline, subheadline, bullets, CTA)
- 5-email delivery and nurture sequence
- Email platform integration guidance
- Performance benchmarks by lead magnet type

## Level History

- **Lv.1** -- Base: 5-concept suggestion matrix, opt-in page copywriting framework, 5-email delivery/nurture sequence, platform integration guidance, performance benchmarks by type. (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** -- Guide alignment: Added negative triggers, validation gates, decision logic for format selection, examples, common issues, anti-patterns. Renamed Protocol to Instructions. Removed emoji from title. (Origin: Anthropic skill guide alignment, Mar 2026)
