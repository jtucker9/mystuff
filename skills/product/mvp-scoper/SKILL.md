---
name: mvp-scoper
description: "Use when the user says 'MVP', 'minimum viable product', 'scope the MVP', 'strip to minimum', 'what to build first', or needs to ruthlessly cut a product idea down to its fastest-to-validate form. Do NOT use for full product requirements (see prd-writer), post-MVP roadmap planning (see roadmap-builder), or detailed feature specs (see feature-spec)."
---

# MVP Scoper -- Minimum Viable Product Definition

*Strip a product idea to its core hypothesis, define the smallest build that proves it, and plan the fastest path to validation.*

## Activation

When this skill activates, output:

`MVP Scoper -- Scoping your minimum viable product...`

| Context | Status |
|---------|--------|
| **User says "MVP", "minimum viable product", "scope the MVP"** | ACTIVE |
| **User wants to cut features to build faster** | ACTIVE |
| **User asks "what should I build first?"** | ACTIVE |
| **User wants a full PRD (not just MVP scope)** | DORMANT -- see prd-writer |
| **User wants a roadmap beyond MVP** | DORMANT -- see roadmap-builder |

## Instructions

### Step 1: Gather Inputs

Ask the user for:
- **Product idea**: What do you want to build? (2-3 sentences)
- **Target market**: Who is this for?
- **Timeline constraint**: How fast do you need to ship? (weeks/months)
- **Budget constraint**: Solo dev, small team, or funded team?
- **Validation goal**: What hypothesis are you testing?

**Gate**: Must have product idea and target market before proceeding.

### Step 2: Core Value Proposition

Force the one-sentence test: "[Product] helps [target user] to [solve problem] by [unique mechanism]." If the user cannot fill this in, the idea needs refinement before scoping.

Define the core loop: ONE repeated user action, ONE outcome that keeps them coming back. Strip everything that does not serve this loop.

**Gate**: If the user describes more than one core loop, they have multiple products. Pick one or split the scoping.

### Step 3: Feature Triage

Categorize every feature as IN / OUT / MAYBE with rationale:

Triage rules:
- Removing it does not prevent core value -> OUT
- Can be done manually instead of automated -> OUT
- Only 1 in 10 users would use it -> OUT
- Requires new integration -> OUT (unless it IS the core)
- Auth -> only if data must persist across sessions
- Admin dashboard -> OUT (use DB queries)
- Analytics -> OUT (use free tier tools)
- Email notifications -> OUT (unless core to the loop)

### Step 4: MVP vs V2 Scope

Present three tiers: MVP (ship this), V2 (ship after validation), Backlog (maybe never). Each V2 feature must have a trigger condition -- a specific metric or event that justifies adding it.

### Step 5: Tech Stack Recommendation

Recommend the fastest stack for the constraints. Principles: use what you know (learning = time), managed services over self-hosted, free tiers first, monolith over microservices.

### Step 6: Build Estimate

Per-feature effort estimate with complexity rating. Total with 1.5x buffer. Cost estimate covering hosting, services, domain, dev cost.

**Gate**: If total exceeds timeline constraint, return to Step 3 and cut more features.

### Step 7: Launch Criteria and Risk Assessment

Launch checklist: core loop works e2e, onboarding under X minutes, data persists, landing page exists, beta users lined up. Explicitly list what is NOT required (perfect UI, full error handling, automated tests, CI/CD, docs).

Risk table: likelihood, impact, mitigation for each risk. Include pre-validation questions: Can you sell it with a waitlist? Can you deliver value manually for 5 users? Have 10 people said "I'd pay for this"?

### Step 8: Assemble Output

Sections: Hypothesis, MVP Scope (IN/OUT), Tech Stack, Build Plan, Launch Criteria, Risks, Validation Plan (before build / after launch / decision point for persevere-pivot-kill).

## Examples

**Example 1 -- SaaS tool**:
User: "I want to build an AI meeting note-taker for remote teams." Output: Core loop = record meeting -> get summary. MVP IN: Chrome extension, transcription, summary. OUT: calendar sync, action item tracking, CRM integration. Stack: Next.js + Whisper API + Vercel. 3-week build.

**Example 2 -- Marketplace**:
User: "A marketplace connecting freelance CFOs with startups." Output: Core loop = post need -> get matched. MVP IN: profile creation, manual matching by founder, Stripe checkout. OUT: automated matching, chat, reviews. Stack: Webflow + Airtable + Zapier. 2-week build. Pre-validation: manually match 5 pairs first.

## Common Issues

- **User resists cutting features**: Reframe: "Would you rather launch in 6 months with everything or 3 weeks with the core and real user data?" Every deferred feature has a trigger condition for re-adding.
- **No clear hypothesis**: Without a testable hypothesis, the MVP has no success criteria. Push until you get "We believe [users] will [action] because [reason], measured by [signal]."
- **Tech stack bikeshedding**: Default to whatever the builder already knows. New tech = hidden weeks of learning. Override only if the product literally cannot be built with known tools.

## Anti-Patterns

- Including admin dashboards, analytics, or notification systems in MVP
- Building before pre-validating demand (waitlist, manual delivery, pre-sales)
- Choosing unfamiliar tech stacks to "do it right from the start"
- Scoping MVP at > 6 weeks for a solo dev or > 8 weeks for a small team
- Deferring all risk assessment to post-launch
- Treating MVP as "version 1 with all features" instead of the smallest testable build

## Level History

- **Lv.1** -- Base: Core value proposition forcing function, ruthless feature triage with cut rationale, MVP/V2/backlog scope boundaries with trigger conditions, speed-optimized tech stack recommendations, build estimates, launch criteria, risk assessment with pre-validation steps. (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** -- Guide compliance: Added negative triggers, validation gates, Examples, Common Issues, Anti-Patterns. Compressed from 233 to <200 lines. (Origin: MemStack v3.3, Mar 2026)
