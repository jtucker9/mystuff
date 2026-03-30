---
name: contract-template
description: "Generate professional service contracts. WHEN: 'contract', 'agreement', 'service agreement', 'NDA', 'freelance contract', 'retainer agreement'. NOT: invoices (invoice-generator), client onboarding processes (client-onboarding), SOW as standalone (scope-of-work)."
---

# Contract Template

## Activation

| Context | Status |
|---------|--------|
| User says "contract", "agreement", "service agreement", "NDA" | ACTIVE |
| User wants freelance, consulting, or retainer contract | ACTIVE |
| User asks about IP ownership, termination, or payment clauses | ACTIVE |
| User wants an invoice, not a contract | DORMANT — invoice-generator |
| User wants full client onboarding flow | DORMANT — client-onboarding |
| User wants a standalone scope-of-work document | DORMANT — scope-of-work |

Output on activation: `Contract Template — Drafting your service agreement...`

## Instructions

### Step 1: Gather Inputs

Collect from user (ask for missing):
- **Parties**: Provider name/company + Client name/company
- **Scope**: Deliverables, milestones, timeline (start/end)
- **Payment**: Amount, schedule, method
- **Work type**: Freelance / consulting / agency / SaaS dev
- **IP preference**: Client owns all / provider retains / split
- **Jurisdiction**: State or country for governing law

**Gate**: Must have at minimum parties, scope, and payment before proceeding.

### Step 2: Select Contract Type

| Type | When to Use | Key Differentiator |
|------|-------------|-------------------|
| Fixed-Price Service Agreement | Defined deliverables, clear end | Milestone-based payment, change order clause |
| Retainer Agreement | Ongoing monthly work | Monthly hours, rollover policy, overage rate |
| Consulting Agreement | Advisory/strategy (not building) | Hourly rate, expense reimbursement |
| NDA (Standalone) | Pre-engagement confidentiality only | Confidential info definition, duration, no payment terms |
| SaaS Development Agreement | Building a software product | Source code ownership, hosting, maintenance terms |

Decision: If user is unsure, default to Fixed-Price for project work, Retainer for ongoing relationships.

**Gate**: Contract type confirmed with user before drafting.

### Step 3: Assemble Required Clauses

Every contract (except standalone NDA) must include ALL of these sections:

1. **Parties & Effective Date** — Full legal names, addresses, emails
2. **Scope of Work** — Numbered deliverables, milestones with dates, change order provision ("written Change Order signed by both parties")
3. **Payment Terms** — See payment pattern selection below
4. **IP Ownership** — See IP decision tree below
5. **Confidentiality** — Mutual obligations, standard exclusions (public info, prior knowledge, independent development, court order), survival period (2-5 years)
6. **Termination** — See termination rules below
7. **Liability Cap** — Total liability capped at fees paid in preceding 12 months; exclude consequential/punitive damages
8. **Indemnification** — Provider indemnifies for IP infringement; Client indemnifies for use of deliverables and client-provided materials
9. **Dispute Resolution** — Arbitration (AAA/JAMS) OR litigation; always require 30-day good-faith negotiation first
10. **General Provisions** — Governing law, entire agreement, amendment process, severability, independent contractor status, force majeure
11. **Signatures** — Both parties with date lines

For standalone NDA: Include only Parties, Confidentiality (expanded), Term/Termination, Remedies, General Provisions, Signatures.

### Step 4: Apply Decision Trees

**Payment Patterns:**
- Fixed-price: Split across milestones (e.g., 30/30/40 or 50/50). Always include deposit on signing.
- Retainer: Monthly fee, specify included hours, rollover yes/no, overage rate.
- Consulting: Hourly rate + expense policy (require pre-approval above threshold).
- All types: Net-15 or Net-30 terms. Late fee of 1-1.5%/month. Provider may pause work if payment overdue 15+ days.

**IP Ownership Decision Tree:**
- Client is paying for custom work they'll own exclusively? -> Full Assignment (work-for-hire + assignment of residual rights). Provider retains portfolio use only with written consent.
- Provider wants to reuse components/methodology? -> License model. Provider retains ownership, grants perpetual non-exclusive license on full payment.
- SaaS or mixed (custom + provider tools)? -> Split. Client owns custom code/content. Provider retains pre-existing tools/frameworks with perpetual license to client. Open-source stays under original licenses.

**Termination Rules:**
- Convenience termination: 15-30 days written notice by either party.
- For-cause termination: Immediate if material breach uncured after 15 days written notice, or insolvency/bankruptcy.
- On termination: Client pays for work completed; Provider delivers all finished work product; Confidential info returned/destroyed within 10 days.
- Kill fee (provider protection): If client terminates without cause mid-project, client pays for completed work plus a kill fee (percentage of remaining value or 2 weeks of planned work). Negotiate this explicitly.

**Jurisdiction Considerations:**
- Default to provider's state/country if both parties are domestic.
- For international contracts: specify which country's law governs AND dispute forum location.
- Arbitration preferred for cross-border (easier enforcement via New York Convention).
- Always include severability clause — if one provision fails locally, the rest survives.

### Step 5: Generate and Present

Output the complete contract as formatted text. Then append:
- **Fill-in list**: Every bracketed placeholder that needs a value
- **Customization notes**: Which IP option chosen and why, dispute method, payment schedule summary, termination notice period + kill fee terms
- **Disclaimer**: "This template is for informational purposes only and does not constitute legal advice. Have an attorney review before signing."

**Gate**: Confirm with user that all placeholders have been addressed or flagged.

## Examples

**Example 1 — Freelance Web Project**: Fixed-Price Service Agreement. 3 milestones (design, development, launch). 40/30/30 payment split. Full IP assignment. 15-day termination notice. 25% kill fee on remaining value. Provider's state jurisdiction, litigation.

**Example 2 — Ongoing Marketing Retainer**: Retainer Agreement. 20 hrs/month at $150/hr, no rollover, $175/hr overage. Provider retains IP with perpetual license to client. 30-day termination notice, no kill fee. Arbitration (AAA), provider's state law.

## Common Issues

1. **Missing change order clause** — Without it, scope creep has no contractual remedy. Always include "written Change Order signed by both parties" in the scope section.
2. **IP ownership left vague** — "We'll figure it out later" causes disputes. Force an explicit selection from the three options before generating.
3. **No kill fee for provider** — If client can terminate without cause and only pay for completed work, provider loses pipeline income. Always discuss kill fee, even if set to zero by agreement.

## Anti-Patterns

- Generating a contract without confirming contract type first
- Using full IP assignment when provider has pre-existing tools incorporated (use split instead)
- Omitting the independent contractor clause (creates employment law risk)
- Setting confidentiality survival period to "perpetual" (many jurisdictions won't enforce; use 2-5 years)
- Skipping the good-faith negotiation period before arbitration/litigation

## Escalation

- User needs contracts for employment (not independent contractor) -> Advise consulting employment attorney; this skill covers service/contractor agreements only.
- User operates in regulated industry (healthcare, finance, government) -> Generate template but strongly recommend sector-specific legal review.
- User needs multi-party agreements (3+ parties) -> Generate bilateral template and advise attorney adaptation.
- Cross-border contract with complex tax implications -> Flag tax counsel need; generate contract with jurisdiction clause but note limitations.

## Inputs

- Party details (provider + client names, addresses, emails)
- Project scope, deliverables, milestones, timeline
- Payment amount, schedule, method
- Work type (freelance / consulting / retainer / SaaS)
- IP ownership preference
- Jurisdiction (state/country)

## Outputs

- Complete contract with all required clauses for selected type
- Fill-in placeholder list for customization
- Customization notes (IP option rationale, dispute method, payment summary, termination terms)
- Legal disclaimer

## Level History

- **Lv.1** — Base: 5 contract types, scope with change orders, payment schedules with late fees, 3-option IP ownership, confidentiality with exclusions, termination with kill fee, liability cap, indemnification, dual dispute resolution, fill-in output. (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** — Compressed: Creator-density rewrite. Replaced full contract template text with decision trees and assembly rules. Added validation gates, anti-patterns, escalation paths, jurisdiction considerations. Same coverage, ~55% fewer lines. (Origin: MemStack v3.2, Mar 2026)
