---
name: roadmap-builder
description: "Use when the user says 'roadmap', 'product roadmap', 'feature roadmap', 'quarterly plan', 'now next later', or needs to plan product development across a time horizon. Do NOT use for MVP scoping (see mvp-scoper), sprint-level story planning (see user-story-generator), or project task management (see work skill)."
---

# Roadmap Builder -- Strategic Product Roadmap

*Create a now/next/later roadmap with quarterly milestones, resource allocation, and stakeholder-ready presentation.*

## Activation

When this skill activates, output:

`Roadmap Builder -- Planning your product roadmap...`

| Context | Status |
|---------|--------|
| **User says "roadmap", "product roadmap", "quarterly plan"** | ACTIVE |
| **User wants to plan features across a time horizon** | ACTIVE |
| **User mentions now/next/later or OKRs for product** | ACTIVE |
| **User wants to scope just the MVP** | DORMANT -- see mvp-scoper |
| **User wants sprint-level task planning** | DORMANT -- see user-story-generator |
| **User wants project task management** | DORMANT -- see work skill |

## Instructions

### Step 1: Gather Inputs

Ask the user for:
- **Product vision**: Where is this going in 12-18 months?
- **Current state**: What exists? What stage? (MVP, growth, mature)
- **Team capacity**: How many engineers/designers? Full-time or part-time?
- **Time horizon**: 3, 6, or 12 months?
- **Key constraints**: Tech debt, migrations, compliance deadlines?
- **Stakeholder priorities**: What does leadership care most about?

**Gate**: Must have product vision, current state, and team capacity before proceeding.

### Step 2: Define Themes

Organize around 3-5 strategic themes (Growth, Retention, Revenue, Platform, Expansion). Each theme ties to a business metric. No theme exists "because it's interesting."

### Step 3: Map Features to Themes

Score each feature: Impact (1-5) x Confidence (1-5) / Effort (1-5, inverted where 5=trivial). Rank by score. Top items go to "Now."

**Gate**: Every feature must map to exactly one theme. Orphan features indicate a missing theme or a feature that should not exist.

### Step 4: Quarterly Milestones

Break into quarters with objective, key result, deliverables (feature, owner, est. weeks), and milestone statement. Rule: Q1 is detailed, Q2 is planned, Q3+ is directional. Do not fake precision for the future.

### Step 5: Dependencies and Sequencing

Map what blocks what. Identify the critical path -- the longest chain of dependent work. This determines your actual timeline. Flag any feature blocked by more than 2 dependencies.

### Step 6: Resource Allocation

Map team capacity to milestones per quarter. Rules: plan to 70-80% capacity, no person on > 2 projects/quarter, design leads engineering by 2-4 weeks, 15-20% capacity reserved for tech debt.

**Gate**: If total estimated effort exceeds 80% capacity for any quarter, cut scope or extend timeline.

### Step 7: Risk Flags

Risk table with probability, impact, contingency. For each high-impact risk, define a trigger (how you will know) and action (what you will do).

### Step 8: Stakeholder View

Present Now/Next/Later format: NOW = commitments (do not include anything you might cut), NEXT = plans (scope may change), LATER = direction (explicitly "subject to change", never with dates). Update monthly.

### Step 9: Assemble Output

Dual output: Stakeholder View (Now/Next/Later) + Detailed Plan (quarterly milestones, themes/metrics, dependencies, resource allocation, risks).

## Examples

**Example 1 -- Growth-stage SaaS**:
User: "Roadmap for our project management tool, 5 engineers, 6-month horizon." Output: 4 themes (Growth: integrations, Retention: collaboration features, Revenue: enterprise tier, Platform: performance). Q1: Slack integration + real-time cursors. Q2: SSO + audit log + enterprise pricing. Critical path: SSO blocks enterprise tier.

**Example 2 -- Post-MVP consumer app**:
User: "Just launched our fitness app, 2 devs, what next for 3 months?" Output: 3 themes (Retention: streaks + push notifications, Growth: social sharing, Platform: crash fixes). Now: crash fixes + streaks. Next: push notifications. Later: social sharing. One dev on platform, one on features.

## Common Issues

- **Everything is "Now"**: If > 40% of features are in "Now", the roadmap is a wishlist. Force rank by ICE score and move bottom half to "Next."
- **No critical path identified**: Without dependencies mapped, the team discovers blockers mid-sprint. Walk through each Q1 feature asking "what must exist before this can start?"
- **Resource over-allocation**: Planning at 100% capacity guarantees missed deadlines. Bugs, support requests, and sick days are real. Enforce the 70-80% rule.

## Anti-Patterns

- Putting dates on "Later" items -- creates false commitments
- Planning Q3-Q4 with the same detail as Q1
- Assigning one person to 3+ projects in the same quarter
- Building a roadmap without stakeholder priority input
- Skipping the Now/Next/Later stakeholder view and only showing the detailed plan
- Treating the roadmap as fixed rather than a living document updated monthly

## Level History

- **Lv.1** -- Base: Theme-driven roadmap with ICE priority scoring, quarterly milestone planning, dependency graphing with critical path, resource allocation at 70-80% capacity, Now/Next/Later stakeholder format, risk flags with triggers and contingencies. Dual output: stakeholder view + detailed plan. (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** -- Guide compliance: Added negative triggers, validation gates, Examples, Common Issues, Anti-Patterns. Compressed from 239 to <200 lines. (Origin: MemStack v3.3, Mar 2026)
