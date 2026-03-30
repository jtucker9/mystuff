---
name: prd-writer
description: "Use when the user says 'PRD', 'product requirements', 'product spec', 'requirements document', 'write a PRD', or needs a structured product requirements document for engineering handoff. Do NOT use for single-feature specs (see feature-spec), user story backlogs only (see user-story-generator), or MVP scoping (see mvp-scoper)."
---

# PRD Writer -- Product Requirements Document

*Generate a complete, engineering-ready PRD from problem statement to success metrics.*

## Activation

When this skill activates, output:

`PRD Writer -- Drafting your product requirements document...`

| Context | Status |
|---------|--------|
| **User says "PRD", "product requirements", "requirements document"** | ACTIVE |
| **User wants a full product spec for engineering handoff** | ACTIVE |
| **User mentions problem statement + user personas + features** | ACTIVE |
| **User wants a single feature spec (not full product)** | DORMANT -- see feature-spec |
| **User wants user stories only** | DORMANT -- see user-story-generator |
| **User wants to scope an MVP** | DORMANT -- see mvp-scoper |

## Instructions

### Step 1: Gather Inputs

Ask the user for:
- **Product name**
- **Problem statement**: What problem does it solve? (1-2 sentences)
- **Target user**: Who is the primary user?
- **Success metrics**: How will you know it is working?
- **Timeline** (optional): Target launch date
- **Existing context** (optional): Prior docs, wireframes, research

**Gate**: Must have product name, problem statement, and target user before proceeding.

### Step 2: Problem Section

Write: problem statement (2-3 sentences with who/how often/trigger), current alternatives table (alternative, how users solve it, why it falls short), cost of inaction (quantified where possible).

### Step 3: User Personas

Define 2-3 personas. Each: name and role, 3 goals, 3 frustrations, technical comfort (low/med/high), usage frequency (daily/weekly/monthly), one realistic quote.

**Gate**: Each persona must map to at least one Must Have feature in Step 5.

### Step 4: Solution Overview

- **One-liner**: what the product does
- **How it works**: 3-5 step high-level flow
- **Key differentiator**: why this beats alternatives
- **What it is NOT**: explicit out-of-scope statement

### Step 5: Feature Requirements (MoSCoW)

Prioritize features as Must Have, Should Have, Could Have, Won't Have (v1). For each Must Have: functional description, key user interaction, dependencies.

### Step 6: User Stories

Write stories for Must Have and Should Have features in standard format grouped by epic: "As a [persona], I want to [action] so that [benefit]. Acceptance: [testable criterion]."

### Step 7: Success Metrics

Define metrics table with target, measurement method, timeframe. Include leading indicators (engagement, activation) and lagging indicators (revenue, retention, NPS).

### Step 8: Technical Constraints and Assumptions

**Constraints**: platform, performance, compliance, integrations, browser/device support.
**Dependencies**: external services, team resources, infrastructure.
**Assumptions**: user behavior, feasibility, market conditions.
**Open Questions**: unresolved decisions needing stakeholder input.

**Gate**: Every open question must name a specific decision-maker or team responsible for resolving it.

### Step 9: Assemble Output

Present complete PRD with sections: Problem, Personas, Solution Overview, Requirements (MoSCoW), User Stories, Success Metrics, Constraints and Assumptions, Appendix.

## Examples

**Example 1 -- B2B SaaS**:
User: "PRD for a team standup bot that replaces daily meetings." Output: Problem (30 min/day wasted in standups x 8 engineers = 20 hrs/week), 2 personas (engineering manager, IC developer), MoSCoW with 4 Must Haves (async check-in, blocker flagging, digest, Slack integration), 12 user stories, success metrics (standup completion rate > 80%, meeting hours reduced 50%).

**Example 2 -- Consumer app**:
User: "PRD for a habit tracker with social accountability." Output: Problem (90% of habit apps abandoned in 2 weeks), 3 personas (new habit builder, accountability partner, group leader), MoSCoW with 5 Must Haves, Won't Have includes gamification and premium tier, metrics (D7 retention > 40%, pairs formed per user > 1).

## Common Issues

- **Problem statement is a solution in disguise**: "We need a dashboard" is not a problem. Push for the pain: "Managers spend 2 hours/week compiling reports from 3 different tools."
- **Too many Must Haves**: If > 7 features are Must Have, the PRD is a wishlist. Force rank: "If you could only ship 3 features, which 3?"
- **Personas without differentiation**: If two personas have the same goals and frustrations, merge them. Distinct personas require distinct needs.

## Anti-Patterns

- Writing the solution overview before defining the problem and personas
- Listing features without tying each to a specific persona
- Defining success metrics without measurement methods
- Leaving open questions without assigning owners
- Including implementation details (tech stack, architecture) in a PRD -- that belongs in technical design docs
- Skipping the "What it is NOT" section, leading to scope creep

## Level History

- **Lv.1** -- Base: Full PRD generation with problem analysis, user personas, solution overview, MoSCoW feature prioritization, user stories by epic, success metrics framework, technical constraints and assumptions. Engineering-handoff ready format. (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** -- Guide compliance: Added negative triggers, validation gates, Examples, Common Issues, Anti-Patterns. Compressed from 205 to <200 lines. (Origin: MemStack v3.3, Mar 2026)
