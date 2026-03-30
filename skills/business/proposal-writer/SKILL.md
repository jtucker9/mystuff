---
name: proposal-writer
description: "Generate structured client proposals with pricing, scope, and close. WHAT: Freelance/agency project proposals. WHEN: 'write proposal', 'create proposal', 'client proposal', 'project proposal', 'pitch', 'bid on project'. NOT: contracts (contract-template), invoices (invoice-generator), scope-only docs (scope-of-work), pricing advice without a specific deal (pricing-strategy)."
---

# Proposal Writer

## Activation

| Context | Status |
|---------|--------|
| User says "write/create proposal", "pitch", "bid on project" | ACTIVE |
| User has discovery notes and wants to formalize | ACTIVE |
| User wants to quote deliverables + timeline | ACTIVE |
| User wants a contract or legal agreement | DORMANT — contract-template |
| User wants an invoice | DORMANT — invoice-generator |
| User wants scope document only | DORMANT — scope-of-work |
| User wants pricing strategy advice (no specific deal) | DORMANT — pricing-strategy |

## Instructions

### Step 1: Gather Inputs

Collect: client name, project type, scope summary (1-3 sentences), budget range. Strongly recommended: timeline, discovery call notes (pain points, goals, quotes, objections), competitive situation. Optional: decision maker, existing relationship, technical constraints, your differentiators.

Proceed with partial inputs. Mark gaps as TBD. A shipped proposal with assumptions beats a perfect one never sent.

**Gate:** Must have client name + project type + scope summary to continue.

### Step 2: Client Situation Analysis

Build before writing. Every proposal section derives from this.

- **Current State / Desired State / Gap / Cost of Inaction** -- use client's language, not yours
- **Success Criteria** -- 3-5 measurable outcomes (metric from X to Y within Z)
- **Competitive Positioning** -- if multi-vendor eval, identify your advantages on: discovery depth, relevant experience, communication, risk mitigation, post-launch support

**Gate:** Problem statement must articulate cost of inaction with a number (dollars, hours, or risk). If you cannot quantify, state the qualitative risk explicitly.

### Step 3: Assemble Proposal

Sections in order. Every section has a purpose -- adapt length to project scale, never skip.

1. **Cover Page** -- project title, client, provider, date, validity period, reference (PROP-YYYY-NNN)
2. **Executive Summary** -- one page max. Lead with their problem, state solution in one sentence, key outcome, investment range, timeline, why you. Use "we" not "I". Include a number.
3. **The Challenge** -- expand situation analysis into narrative. Reference discovery specifics. End with cost-of-inaction figure.
4. **Our Approach** -- connect solution components back to findings. Every feature traces to a problem or success criterion.
5. **Scope & Deliverables** -- phased deliverables. Explicit exclusions ("NOT included") section is mandatory.
6. **Timeline & Milestones** -- visual timeline with client dependencies column. State that client delays shift milestones.
7. **Investment** -- pricing per Step 4 below.
8. **Relevant Work** -- 1-2 case studies per Step 5 below.
9. **Terms & Conditions** -- payment, revisions (N rounds per phase), IP transfer on full payment, timeline guarantee, confidentiality, cancellation (N days notice), warranty period.
10. **Next Steps** -- specific actions, expiration date, contact info.

**Gate:** Exclusions section must exist. No proposal ships without explicit "not included" items.

### Step 4: Pricing

**Pricing model decision tree:**

```
Scope clearly defined + fixed deliverables?
  YES -> Estimate with <20% variance?
    YES -> Fixed price
    NO  -> Fixed price + 15-25% contingency
  NO  -> Client comfortable with uncertainty?
    YES -> T&M with not-to-exceed cap
    NO  -> Phased fixed price (fixed per phase, scope next phase after each)
```

**Value-based check (always run before cost-plus default):**
Calculate project value to client (revenue generated or cost saved annually). Price as a fraction of year-one value. Lead with the ROI math in the Investment section: "Project pays for itself in N months."

**Good / Better / Best tiers** when appropriate. Middle tier = your target. Mark it RECOMMENDED. Price gap: Essential-to-Professional jump smaller than Professional-to-Premium. Present as "investment" never "cost." Lowest tier feels incomplete but not insulting; highest feels aspirational but not absurd.

**Payment milestones:**
- Under $10K: 50% upfront / 50% on delivery
- $10K-$50K: 25-50% signing / 25% phase completion / remainder on delivery
- $50K+: milestone-based, no more than 25% per milestone, work pauses if payment overdue by 15 days

### Step 5: Social Proof

Include 1-2 case studies directly relevant to THIS client's industry, project type, or pain point. Each: challenge (1-2 sentences), solution (1-2 sentences), results (2-3 specific metrics), client quote if available.

Selection priority: same industry > same project type > same scale > strongest result with a bridge sentence.

**Gate:** Generic/irrelevant case studies must be cut. One relevant study beats five generic ones.

### Step 6: Output

Assemble as single markdown document. Append:
- Assumptions list (anything inferred from missing inputs)
- Send checklist: proofread names, verify pricing math, confirm availability, attach portfolio links, convert to PDF, set follow-up reminder

Offer: "Want me to adjust tiers, add/remove a section, change tone, or generate an accompanying contract?"

## Examples

**Example 1 -- Small project, minimal inputs:**
User provides: "proposal for Acme Corp, redesign their landing page, budget around $3K, 2-week timeline." Produce 2-4 page proposal. Single-tier fixed price. One case study. Abbreviated terms. Expiration 30 days.

**Example 2 -- Mid-range project with discovery notes:**
User provides: client name, $25K budget, discovery call transcript, 3-month timeline, two competing vendors. Produce 8-12 page proposal. Three-tier pricing with value-based anchor. Two case studies. Full terms. Risk table. Expiration 30 days.

## Common Issues

| Issue | Fix |
|-------|-----|
| Proposal too long for project size | Scale: under $5K = 2-4pp, $5-25K = 5-8pp, $25-100K = 8-15pp, $100K+ = 15-25pp |
| Client won't share budget | Provide Good/Better/Best tiers so they self-select; state "most projects like this range $X-$Y" |
| Client ghosts after sending | Follow up: Day 3, Day 7, Day 14, Day 21, then close the loop |

## Anti-Patterns

| Do NOT | Do Instead |
|--------|------------|
| Lead with your bio or company history | Lead with client's problem |
| Use "I" (even as solopreneur) | Use "we" |
| List features without mapping to client outcomes | Every feature traces to a finding |
| Price without value anchor | Frame investment against ROI or cost-of-inaction |
| Skip exclusions section | Exclusions prevent scope disputes |
| Set no expiration | Standard 30 days; high-demand 14 days; enterprise 45-60 days |
| Badmouth competitors | Differentiate on your strengths |

## Escalation

| Situation | Action |
|-----------|--------|
| Budget far below your minimum | State minimum, offer reduced-scope Essential tier, or refer out |
| Multiple decision makers, conflicting priorities | Add stakeholder alignment section; identify final sign-off authority |
| Client wants free spec work in proposal | Keep at strategy level; detailed specs are paid Phase 1 deliverable |
| Negotiate after proposal sent | Negotiate scope, not rate; know your walk-away number |
| Referral partner's client | Adjust tone from "sales" to "collaboration"; note referral relationship |

## Inputs

- Client name, project type, scope summary (required)
- Budget range, timeline, discovery notes, competitive situation (recommended)
- Decision maker, technical constraints, differentiators, case studies (optional)

## Outputs

- Complete proposal in markdown (cover through next steps)
- Tiered pricing with payment schedule
- Explicit exclusions and assumptions
- Send checklist for pre-submission review

## Level History

- **Lv.1** -- Base: 8-step proposal protocol covering input gathering, client situation analysis, full proposal structure (10 sections), pricing decision tree (fixed/T&M/value-based) with Good/Better/Best tiers, payment milestones, social proof integration, terms, markdown output with send checklist. Anti-patterns, escalation guide, proposal length guidelines by project size. (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** -- Compressed: Reduced from 663 to ~130 lines. Removed full templates and copy blocks, retained decision rules, section order, pricing model tree, tier structure, payment patterns, length guidelines, ROI approach, follow-up timing. Added validation gates between steps. (Origin: MemStack v3.3, Mar 2026)
