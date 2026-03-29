---
name: proposal-writer
description: "Use when the user says 'write proposal', 'create proposal', 'client proposal', 'project proposal', 'pitch', or is preparing a project proposal for a client or freelance engagement. Do NOT use for contracts (see contract-template), invoices (see invoice-generator), or scope documents (see scope-of-work)."
---

# 📋 Proposal Writer — Client Proposal Generator
*Create persuasive, professionally structured project proposals for freelance and agency engagements — from discovery through pricing to close.*

## Activation

When this skill activates, output:

`📋 Proposal Writer — Drafting your proposal...`

| Context | Status |
|---------|--------|
| **User says "write proposal", "create proposal", "project proposal"** | ACTIVE |
| **User says "pitch", "bid on project", "proposal for [client]"** | ACTIVE |
| **User has discovery call notes and wants to formalize a proposal** | ACTIVE |
| **User wants to quote a project with deliverables and timeline** | ACTIVE |
| **User wants a contract/legal agreement** | DORMANT — see contract-template |
| **User wants an invoice for completed work** | DORMANT — see invoice-generator |
| **User wants a formal scope document only** | DORMANT — see scope-of-work |
| **User wants pricing strategy advice (not a specific proposal)** | DORMANT — see pricing-strategy |

## Protocol

### Step 1: Gather Inputs

Ask the user for the following. Accept partial inputs and fill gaps with sensible defaults or mark as TBD:

**Required:**
- **Client name**: Company or individual receiving the proposal
- **Project type**: Web development, mobile app, branding, marketing, consulting, SaaS build, etc.
- **Scope summary**: High-level description of what they need (1-3 sentences is fine)
- **Budget range**: Client's stated budget, or your target price

**Strongly recommended:**
- **Timeline**: Desired start date, deadline, or duration
- **Discovery call notes**: Key quotes, pain points mentioned, goals stated, objections raised
- **Competitive situation**: Are they evaluating other vendors? What alternatives exist?

**Optional (enhances quality):**
- **Decision maker**: Who signs off? Are there multiple stakeholders?
- **Existing relationship**: New client or past engagement? Referral source?
- **Technical constraints**: Existing platforms, required integrations, compliance requirements
- **Your differentiators**: What makes you the right fit vs. competitors?

If the user provides only a brief description, proceed with what you have and note assumptions clearly. A shipped proposal with assumptions beats a perfect proposal never sent.

### Step 2: Client Situation Analysis

Before writing, build a structured understanding of the client's position. This analysis drives every section of the proposal.

**Problem Statement:**
Define the core problem in the client's language, not yours. Use their words from discovery notes when available.

```
Current State:    [What they have now — the pain, the gap, the broken thing]
Desired State:    [What they want — the outcome, the transformation]
Gap:              [What's missing — the capability, resource, or solution they lack]
Cost of Inaction: [What happens if they do nothing — lost revenue, competitive risk,
                   operational drag, missed opportunity]
```

**Success Criteria:**
Define 3-5 measurable outcomes that will make this project a success. These become the anchors for your Proposed Solution section.

```
1. [Metric] moves from [current] to [target] within [timeframe]
2. [Capability] is live and functional by [date]
3. [Process] reduces from [current duration] to [target duration]
4. [Revenue/savings] of $[amount] within [months] of launch
5. [Qualitative] — [stakeholder] can [do thing] without [current friction]
```

**Competitive Positioning:**
If the client is evaluating multiple vendors, identify your advantages:

| Factor | You | Typical Competitor |
|--------|-----|--------------------|
| Discovery depth | Deep understanding of their problem | Template proposal, surface-level |
| Relevant experience | [specific similar projects] | Generalist portfolio |
| Communication | [your cadence/style] | Weekly status emails only |
| Risk mitigation | [your approach] | Fixed bid, hope for the best |
| Post-launch | [your support model] | Handoff and done |

### Step 3: Proposal Structure

Generate the proposal with these sections in order. Each section has a specific purpose — do not skip sections, but adapt length to the project scale.

#### 3.1 — Cover Page

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
              PROJECT PROPOSAL
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Project Title]

Prepared for:    [Client Name / Company]
Prepared by:     [Your Name / Company]
Date:            [Date]
Valid until:      [Expiration Date — typically 30 days]
Reference:       PROP-[YYYY]-[NNN]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

#### 3.2 — Executive Summary

One page maximum. This is often the only section a decision maker reads before jumping to the price. It must:

1. Acknowledge the client's problem in their language
2. State your proposed solution in one sentence
3. Highlight the key outcome/transformation
4. State the investment range and timeline
5. End with confidence — why you are the right partner

Template:

```
EXECUTIVE SUMMARY

[Client Name] is [facing / experiencing / looking to solve] [problem
statement in their words]. This is [costing / risking / preventing]
[specific impact — revenue, time, opportunity].

We propose [solution summary in one sentence — what you will build /
deliver / transform]. This will [primary outcome] within [timeline],
enabling [Client Name] to [desired state].

The total investment is [$X,XXX – $XX,XXX], delivered over [X weeks/
months] in [N] phases. [Your Name/Company] brings [key differentiator]
to this engagement, including [relevant experience or credential].

We are confident this project will [measurable outcome], and we look
forward to partnering with [Client Name] to make it happen.
```

**Rules for executive summaries:**
- Lead with their problem, not your capabilities
- Use "we" and "you/your", never "I" (even for solopreneurs — it signals professionalism)
- Include a number: dollar amount, percentage improvement, or timeline
- No jargon. If the decision maker is non-technical, keep it non-technical

#### 3.3 — Problem Statement

Expand the situation analysis into a narrative. This section proves you understand their world.

```
THE CHALLENGE

[2-3 paragraphs expanding on the current state, the pain, and the
consequences of inaction. Reference specific details from the discovery
call. Use their language and quote them if appropriate.]

Key Findings from Our Discovery:
• [Finding 1 — specific pain point or bottleneck]
• [Finding 2 — missed opportunity or competitive gap]
• [Finding 3 — operational inefficiency or risk]
• [Finding 4 — stakeholder frustration or unmet need]

The cost of maintaining the status quo is approximately $[X,XXX] per
[month/quarter] in [lost revenue / wasted time / missed opportunities /
operational overhead]. More critically, [competitive or strategic risk
if they delay].
```

#### 3.4 — Proposed Solution

Connect your solution directly to the problems identified. Every feature or deliverable should trace back to a finding or success criterion.

```
OUR APPROACH

[1-2 paragraphs describing the overall approach at a strategic level.
Why this approach? Why not alternatives?]

Solution Components:

┌──────────────────────────────────────────┐
│  [Component 1 Name]                      │
│  Addresses: [Finding #]                  │
│  [2-3 sentence description of what this  │
│  component does and why it matters]      │
├──────────────────────────────────────────┤
│  [Component 2 Name]                      │
│  Addresses: [Finding #]                  │
│  [2-3 sentence description]             │
├──────────────────────────────────────────┤
│  [Component 3 Name]                      │
│  Addresses: [Finding #]                  │
│  [2-3 sentence description]             │
└──────────────────────────────────────────┘
```

#### 3.5 — Scope & Deliverables

Be explicit about what is included AND what is not. Ambiguity here is where projects go sideways.

```
SCOPE & DELIVERABLES

Included in this engagement:

Phase 1 — [Phase Name]:
  ✓ [Deliverable 1.1 — specific, tangible output]
  ✓ [Deliverable 1.2]
  ✓ [Deliverable 1.3]

Phase 2 — [Phase Name]:
  ✓ [Deliverable 2.1]
  ✓ [Deliverable 2.2]
  ✓ [Deliverable 2.3]

Phase 3 — [Phase Name]:
  ✓ [Deliverable 3.1]
  ✓ [Deliverable 3.2]

NOT included (available as add-ons):
  ✗ [Out-of-scope item 1 — with estimated cost if requested]
  ✗ [Out-of-scope item 2]
  ✗ [Out-of-scope item 3]
  ✗ Ongoing maintenance beyond [X]-day warranty period
  ✗ Content creation / copywriting (unless specified above)
  ✗ Third-party service costs (hosting, domains, APIs)
```

#### 3.6 — Timeline & Milestones

Visual timeline with clear milestones and client dependencies.

```
TIMELINE

Total duration: [X] weeks / months
Start date:     [Date or "Upon contract signing"]

Week/Month  Phase              Milestone                    Client Action
──────────  ─────              ─────────                    ─────────────
1-2         Discovery &        Kickoff complete,            Provide brand assets,
            Planning           requirements documented      stakeholder access

3-5         Design &           Design concepts approved,    Review & approve
            Architecture       technical architecture set   designs within 5 days

6-10        Development        Core build complete,         Weekly feedback on
                               staging environment live     staging demos

11-12       Testing &          QA complete, launch          Final content,
            Launch             checklist signed off         UAT signoff

13+         Support &          [X]-day warranty period,     Report issues via
            Optimization       performance monitoring       agreed channel

Client Dependencies:
Timely feedback is critical. Delays in client review/approval will
shift subsequent milestones by an equivalent period. We will flag
any dependency risk within 24 hours of identifying it.
```

### Step 4: Solution Design

For technical projects, add depth to the Proposed Solution section. For non-technical projects (branding, marketing, consulting), adapt this to methodology and approach.

**Approach Overview:**
```
We follow a [methodology name — Agile, phased waterfall, design sprint,
etc.] approach because [reason specific to this project]:

• [Benefit 1 of this approach for their situation]
• [Benefit 2]
• [Benefit 3]
```

**Technology Recommendations** (for technical projects):

| Layer | Recommendation | Rationale |
|-------|---------------|-----------|
| Frontend | [Framework] | [Why — performance, team familiarity, ecosystem] |
| Backend | [Framework/Language] | [Why — scalability, cost, speed of development] |
| Database | [DB choice] | [Why — data model fit, scaling needs, cost] |
| Hosting | [Platform] | [Why — reliability, cost, deployment speed] |
| Integrations | [List] | [Why each is needed and what it replaces] |

Only recommend technologies you can defend. If the client has existing infrastructure, default to compatibility over novelty.

**Phased Delivery Plan:**

```
Phase 1 — Foundation (Weeks 1-3)
  Goal: Validated requirements + technical infrastructure
  Delivers: Project plan, design system, dev environment, CI/CD
  Client sees: Kickoff presentation, requirements doc for approval
  Risk gate: Requirements signoff before Phase 2 begins

Phase 2 — Core Build (Weeks 4-8)
  Goal: Primary functionality live in staging
  Delivers: [Core features], [data models], [integrations]
  Client sees: Weekly demos, staging URL for testing
  Risk gate: Core functionality approved before Phase 3

Phase 3 — Polish & Launch (Weeks 9-12)
  Goal: Production-ready, launched
  Delivers: QA, performance optimization, launch, monitoring
  Client sees: Final UAT environment, launch day support
  Risk gate: UAT signoff before production deployment
```

**Risk Mitigation:**

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|------------|
| Scope creep | High | Timeline + budget | Change order process, weekly scope reviews |
| Client feedback delays | Medium | Timeline | Defined SLA for approvals, auto-extension clause |
| Technical unknowns | Medium | Budget | Spike/prototype in Phase 1 before committing |
| Integration failures | Low | Timeline | Early integration testing, fallback options identified |
| Key person unavailable | Low | Timeline | Knowledge sharing, documented decisions |

### Step 5: Pricing Strategy

Choose the right pricing model based on project type and client relationship.

**Decision Tree:**

```
Is the scope clearly defined with fixed deliverables?
├── YES → Can you estimate with <20% variance?
│   ├── YES → FIXED PRICE (safest for both parties)
│   └── NO → FIXED PRICE WITH CONTINGENCY (add 15-25% buffer)
└── NO → Is the client comfortable with uncertainty?
    ├── YES → TIME & MATERIALS with cap
    │         (hourly/daily rate, not-to-exceed ceiling)
    └── NO → PHASED FIXED PRICE
              (fixed price per phase, scope next phase after each)
```

**Value-Based Pricing Check:**
Before defaulting to cost-plus, ask: *What is this project worth to the client?*

```
If the project will generate $500K/year in new revenue...
  → A $50K project fee is 10% of year-one value = easy ROI
  → A $25K fee is leaving money on the table
  → Frame the price against the value, not your hours

If the project saves 20 hours/week at $75/hr...
  → Annual savings: $78,000
  → A $30K project fee pays for itself in 5 months
  → Lead with the savings math in the Investment section
```

**Package Tiers — Good / Better / Best:**

When appropriate, offer three options. The middle tier should be your target.

```
INVESTMENT OPTIONS

                 Essential         Professional       Premium
                 ─────────         ────────────       ───────
Scope            Core features     Core + [extras]    Full vision
                 only              + [optimization]   + [strategic]

Timeline         [X] weeks         [X+2] weeks        [X+4] weeks

Deliverables     [list key         [everything in     [everything in
                 items]            Essential, plus     Professional,
                                   additional items]  plus add-ons]

Support          30-day warranty   60-day warranty    90-day warranty
                                   + 2 training       + 4 training
                                   sessions            sessions +
                                                       monthly review

Investment       $[X,XXX]          $[X,XXX]           $[XX,XXX]
                                   ← RECOMMENDED →

Most clients choose Professional because [reason — best balance of
scope and value].
```

**Pricing Psychology:**
- Present the highest tier first (top-down anchoring)
- Mark the middle tier as "RECOMMENDED" or "MOST POPULAR"
- The lowest tier should feel incomplete but not insulting
- The highest tier should feel aspirational but not absurd
- Price gap between tiers: the jump from Essential to Professional should be smaller than Professional to Premium (e.g., $5K / $8K / $15K, not $5K / $10K / $15K)
- Always present as "investment", never "cost" or "fee"

**Payment Milestones:**

```
PAYMENT SCHEDULE

For [Professional / selected tier]:

  Milestone                        Amount       Due
  ─────────                        ──────       ───
  Contract signing                 [25-50]%     Upon signing
  [Phase 1] completion             [25]%        [Date/milestone]
  [Phase 2] completion             [25]%        [Date/milestone]
  Final delivery & acceptance      [remainder]  [Date/milestone]

  Total:                           $[X,XXX]

Notes:
• All amounts due within [15] days of invoice
• Work pauses if payment is overdue by more than [15] days
• Add-on work billed at $[XXX]/hour upon written approval
```

### Step 6: Social Proof Integration

Select and integrate proof elements that are relevant to THIS client's project and industry. Generic proof is worse than no proof.

**Case Studies** (include 1-2, directly relevant):

```
RELEVANT WORK

── [Project Name] — [Client Name or Industry] ──────────

Challenge:  [1-2 sentences — similar to this client's problem]
Solution:   [1-2 sentences — similar to what you're proposing]
Results:    • [Metric 1: specific number — e.g., "47% increase
              in conversion rate"]
            • [Metric 2: specific number — e.g., "Launched in
              8 weeks, 2 weeks ahead of schedule"]
            • [Metric 3: qualitative — e.g., "Became their
              primary lead generation channel"]

"[Direct quote from that client about working with you.]"
 — [Name], [Title], [Company]
```

**Selection criteria for case studies:**
- Same industry or adjacent? Include it.
- Same project type (website, app, rebrand)? Include it.
- Similar budget range? Mention the scale.
- Same pain point (scaling, modernizing, launching)? Lead with it.
- None of the above? Use your strongest result regardless, but bridge it: "While in a different industry, the technical challenges were identical..."

**Additional Proof Elements** (include what you have):

```
CREDENTIALS & RECOGNITION

• [X] years of experience in [relevant specialty]
• [XX]+ projects delivered for clients including [notable names]
• [Certification, award, or recognition]
• Average project rating: [X.X/5] across [N] client reviews
• Technologies: [relevant certifications — AWS, Google, etc.]
• Published / speaking: [relevant articles, talks, if applicable]
```

Only include proof you can back up. Inflated claims destroy trust faster than modest honesty builds it.

### Step 7: Terms & Close

Clear, fair terms protect both parties and prevent awkward conversations later.

```
TERMS & CONDITIONS

1. PAYMENT
   • Payment schedule as outlined in the Investment section
   • Late payments incur a [1.5]% monthly fee on outstanding balance
   • Work pauses after [15] days of non-payment

2. REVISIONS & CHANGES
   • Each phase includes [2] rounds of revisions on deliverables
   • Additional revisions billed at $[XXX]/hour
   • Scope changes require a written Change Order with adjusted
     timeline and investment, approved by both parties before work begins
   • We will proactively flag potential scope changes before they happen

3. INTELLECTUAL PROPERTY
   • Upon full payment, all custom work product transfers to [Client]
   • [Provider] retains rights to pre-existing tools, frameworks,
     and libraries (licensed to [Client] for use in the project)
   • Open-source components remain under their respective licenses

4. TIMELINE GUARANTEE
   • We commit to the timeline outlined in this proposal, assuming
     timely client feedback per the stated dependencies
   • Client delays in providing feedback, assets, or approvals will
     shift milestones by an equivalent period
   • If we miss a deadline due to our own delay, we will [provide
     X days of additional support / apply a discount of X%]

5. CONFIDENTIALITY
   • Both parties agree to keep project details, pricing, and
     proprietary information confidential
   • Portfolio use: We may reference this project in our portfolio
     with your written approval

6. CANCELLATION
   • Either party may cancel with [15] days written notice
   • Client pays for all work completed through cancellation date
   • Deposits are non-refundable after work begins

7. WARRANTY
   • [30/60/90]-day warranty on defects in delivered work
   • Does not cover issues caused by third-party changes,
     client modifications, or new requirements
```

**Next Steps & Close:**

```
NEXT STEPS

To move forward:

  1. Review this proposal and send any questions to
     [your email] — we're happy to clarify anything

  2. Choose your preferred package (Essential / Professional /
     Premium) or let us know if you'd like a custom scope

  3. Sign the attached agreement and submit the initial
     deposit of $[X,XXX]

  4. We'll schedule a kickoff call within [3] business days
     of receiving the signed agreement

This proposal is valid until [DATE — 30 days from issue].
After this date, pricing and availability may change.

We're excited about the opportunity to work with [Client Name]
on [project type], and we're confident in the results we can
deliver together.

[Your Name]
[Title]
[Company]
[Phone] | [Email]
[Website]
```

**Expiration date rules:**
- Standard: 30 days
- High-demand periods: 14 days (creates urgency without pressure)
- Enterprise/complex: 45-60 days (they need internal approval time)
- Never "no expiration" — open-ended proposals signal low demand

### Step 8: Output

Assemble the complete proposal and present it. The output is a single markdown document ready for PDF conversion (via a tool like Pandoc, Google Docs, or the KDP Format skill adapted for proposals).

```
━━━ PROPOSAL: [Project Title] ━━━━━━━━━━━━━

── PROPOSAL DETAILS ───────────────────────
Client:     [Client Name]
Project:    [Project Title]
Reference:  PROP-[YYYY]-[NNN]
Date:       [Date]
Valid:      [Expiration Date]

── SECTIONS ───────────────────────────────
1. Executive Summary
2. The Challenge
3. Our Approach
4. Scope & Deliverables
5. Timeline & Milestones
6. Investment
7. Relevant Work
8. Terms & Conditions
9. Next Steps

── COMPLETE PROPOSAL ──────────────────────
[Full proposal text, all sections assembled]

── ASSUMPTIONS & NOTES ────────────────────
• [Any assumptions made due to missing inputs]
• [Items flagged for client clarification]
• [Recommendations for follow-up before sending]

── SEND CHECKLIST ─────────────────────────
□ Proofread for client name spelling and project details
□ Verify all pricing math is correct
□ Confirm availability for stated timeline
□ Attach portfolio pieces or case study links
□ Include contract/agreement as separate attachment
□ Set calendar reminder for follow-up on [expiration - 7 days]
□ Convert to PDF before sending (markdown is your draft)
```

**Format options:**
- **Markdown** (default): Ready for conversion to PDF or import into Google Docs
- **If the user requests a specific format**: Adapt output accordingly, but always keep a markdown master copy

After presenting the proposal, offer:

> "Want me to adjust the pricing tiers, add/remove a section, change the tone, or generate a contract to accompany this proposal?"

## Anti-Patterns

| Do NOT | Do Instead |
|--------|------------|
| Lead with your bio or company history | Lead with the client's problem |
| Use "I" throughout (even as a solopreneur) | Use "we" — it signals a professional operation |
| List features without connecting to client outcomes | Every feature maps to a problem or goal |
| Send a generic proposal with [BRACKETS] unfilled | Fill every field or mark TBD with a note |
| Price without anchoring to value delivered | Always frame investment against ROI or cost-of-inaction |
| Include irrelevant case studies to pad length | 1 relevant case study beats 5 generic ones |
| Write 20+ pages for a $5K project | Scale proposal length to project size (see below) |
| Skip the "not included" section | Exclusions prevent scope disputes later |
| Set no expiration date | Always include a validity period |
| Badmouth competitors in the proposal | Differentiate on your strengths, not their weaknesses |

**Proposal Length Guidelines:**

| Project Size | Proposal Length | Sections to Emphasize |
|-------------|----------------|----------------------|
| Under $5K | 2-4 pages | Exec summary, scope, price, next steps |
| $5K - $25K | 5-8 pages | Full proposal, 1 case study, tiered pricing |
| $25K - $100K | 8-15 pages | Full proposal, 2 case studies, risk mitigation, phased plan |
| $100K+ | 15-25 pages | Comprehensive, multiple case studies, org chart, detailed phases |

## Escalation

| Situation | Action |
|-----------|--------|
| Client's budget is far below your minimum | State your minimum, offer a reduced-scope Essential tier, or refer to someone in their range |
| Client wants a proposal but won't share budget | Provide tiered options (Good/Better/Best) so they self-select; state: "Most projects like this range from $X to $Y" |
| Multiple decision makers with conflicting priorities | Include a brief stakeholder alignment section; ask who has final sign-off |
| Client asks for free spec work in the proposal | Keep proposal at strategy level; detailed specifications are a paid deliverable (Phase 1) |
| Client wants to negotiate after proposal sent | Have your walk-away number pre-defined; negotiate scope (not rate) when possible |
| Client ghosts after receiving proposal | Follow up at Day 3, Day 7, Day 14, Day 21 (then close the loop) |
| Proposal is for a referral partner's client | Include a note about the referral relationship; adjust tone to be less "sales" and more "collaboration" |

## Inputs
- Client name and company
- Project type and scope summary
- Budget range (stated or estimated)
- Timeline requirements
- Discovery call notes (pain points, goals, quotes)
- Competitive situation (other vendors, alternatives)
- Decision maker and stakeholder info
- Technical constraints and existing infrastructure
- Your differentiators, case studies, and credentials

## Outputs
- Complete proposal document in markdown
- Cover page with reference number and expiration date
- Executive summary (1 page, client-problem-first)
- Problem statement with cost-of-inaction analysis
- Proposed solution with components mapped to findings
- Scope and deliverables with explicit exclusions
- Visual timeline with milestones and client dependencies
- Tiered pricing (Good/Better/Best) with payment schedule
- Relevant case studies with metrics and testimonials
- Terms covering payment, revisions, IP, timeline, and cancellation
- Clear next steps with specific actions and expiration date
- Send checklist for pre-submission review

## Level History

- **Lv.1** — Base: 8-step proposal protocol covering input gathering, client situation analysis (current/desired state, cost of inaction, success criteria), full proposal structure (cover, executive summary, problem statement, solution, scope with exclusions, timeline with dependencies, investment with tiered pricing, case studies, terms, next steps), solution design with technology recommendations and risk mitigation, pricing strategy decision tree (fixed/hourly/value-based) with Good/Better/Best tiers and psychology techniques, social proof integration with case study templates, terms and close with revision policy and IP ownership, markdown output with send checklist. Anti-patterns table, escalation guide for 7 common scenarios, proposal length guidelines by project size. (Origin: MemStack v3.2, Mar 2026)
