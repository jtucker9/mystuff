---
name: scope-of-work
description: "Use when the user says 'scope of work', 'SOW', 'define scope', 'project scope', or is defining project boundaries, deliverables, and acceptance criteria for a formal engagement. Do NOT use for proposals (see proposal-writer), contracts (see contract-template), or invoicing (see invoice-generator)."
---

# 📐 Scope of Work — Project Boundary Definition
*Define project boundaries, deliverables, acceptance criteria, work breakdown structure, and change management for formal engagements — the document that prevents "but I thought that was included."*

## Activation

When this skill activates, output:

`📐 Scope of Work — Defining project boundaries...`

| Context | Status |
|---------|--------|
| **User says "scope of work", "SOW", "define scope", "project scope"** | ACTIVE |
| **User says "write SOW", "scope document", "project boundaries"** | ACTIVE |
| **User wants to define deliverables and acceptance criteria for a project** | ACTIVE |
| **User has a signed proposal and needs a formal scope document** | ACTIVE |
| **User is experiencing scope creep and needs to formalize boundaries** | ACTIVE |
| **User wants a project proposal (includes scope but is sales-facing)** | DORMANT — see proposal-writer |
| **User wants a legal contract or service agreement** | DORMANT — see contract-template |
| **User wants to generate an invoice** | DORMANT — see invoice-generator |
| **User wants a project plan/roadmap without formal scope boundaries** | DORMANT — see roadmap-builder |
| **User is discussing scope conceptually, not building a document** | DORMANT — do not activate |

## Protocol

### Step 1: Gather Inputs

Ask the user for the following. Accept partial inputs and use sensible defaults or mark as TBD. A SOW with clear boundaries and some TBDs is better than no SOW at all.

**Required:**
- **Project name**: Formal name for the engagement (e.g., "Acme Corp Website Redesign")
- **Client name / organization**: Who is receiving the work
- **Project type**: Web development, mobile app, SaaS platform, consulting engagement, marketing campaign, data migration, system integration, etc.
- **High-level description**: 2-5 sentences describing what the project will accomplish

**Strongly recommended:**
- **Stakeholders**: Key contacts on both sides — decision maker, project sponsor, technical lead, subject matter experts, who has final approval authority
- **Constraints**: Budget ceiling, hard deadlines, regulatory requirements, technology mandates, team size limitations
- **Existing documentation**: Discovery notes, proposals already sent, prior SOWs, technical specs, wireframes, requirements lists
- **Relationship context**: Is this a new engagement or continuation? Does a proposal or contract already exist?

**Optional (improves precision):**
- **Prior project history**: Has this project been attempted before? What happened?
- **Organizational context**: Industry, company size, technical maturity, internal team capabilities
- **Risk factors**: Known risks, political dynamics, competing priorities, vendor dependencies
- **Success definition**: How will the client know this project succeeded? Who evaluates that?

If the user provides only a brief description, extract what you can and proceed. Flag assumptions explicitly in the output.

### Step 2: Project Overview

Build the foundational context that frames every subsequent section. This is the "why" before the "what."

#### 2.1 — Background & Context

Establish what led to this project. Reference discovery notes, prior conversations, or the proposal if one exists.

```
PROJECT BACKGROUND

[Client Name] is [undertaking / initiating / requesting] [project type]
to address [core business need]. [1-2 sentences of context: what exists
today, what prompted this project, what the strategic driver is.]

This Scope of Work defines the boundaries, deliverables, acceptance
criteria, and change management process for [Project Name]. It serves
as the authoritative reference for what is and is not included in this
engagement.

Effective Date:     [Date]
Reference:          SOW-[YYYY]-[NNN]
Related Documents:  [Proposal PROP-YYYY-NNN, Contract, etc.]
```

#### 2.2 — Objectives

Define 3-7 specific, measurable objectives. Each objective should answer: "What will be true when this project is complete that is not true today?"

```
PROJECT OBJECTIVES

1. [Verb] [measurable outcome] by [date or milestone]
   Measurement: [How this will be verified]

2. [Verb] [measurable outcome] by [date or milestone]
   Measurement: [How this will be verified]

3. [Verb] [measurable outcome] by [date or milestone]
   Measurement: [How this will be verified]

4. [Verb] [measurable outcome] by [date or milestone]
   Measurement: [How this will be verified]
```

**Objective quality test:** If an objective cannot be answered with "yes, this was achieved" or "no, it was not" at project close, rewrite it until it can.

#### 2.3 — Success Metrics

Quantified criteria that determine whether the project delivered value. These differ from objectives — objectives define what gets built, success metrics define what impact it has.

```
SUCCESS METRICS

| Metric                | Current State | Target State | Measurement Method     | Timeline     |
|-----------------------|---------------|--------------|------------------------|--------------|
| [e.g., Page load time]| [3.2 seconds] | [< 1.5 sec]  | [Lighthouse audit]     | [At launch]  |
| [e.g., Conversion rate]| [2.1%]       | [> 4.0%]     | [Google Analytics]     | [90 days]    |
| [e.g., Support tickets]| [120/week]   | [< 40/week]  | [Zendesk dashboard]    | [60 days]    |
| [e.g., Manual process] | [4 hours]    | [< 15 min]   | [Time tracking]        | [At launch]  |
```

#### 2.4 — Assumptions & Dependencies

Document everything assumed to be true. Assumptions that prove false are the #1 source of scope disputes.

```
ASSUMPTIONS

1. [Client] will provide [specific assets/access/data] by [date]
2. [Client]'s existing [system/platform/API] supports [capability]
3. The project team will have access to [environment/tool/resource]
4. Content (copy, images, media) will be provided by [Client] unless
   explicitly listed as a deliverable below
5. [Client] will designate a single point of contact with authority to
   approve deliverables within [X] business days
6. Third-party services ([name]) will be available and functional
   throughout the project duration
7. [Any technology, regulatory, or business assumption]

If any assumption proves invalid, both parties will reassess scope,
timeline, and budget through the Change Management process (Step 7).

DEPENDENCIES

| Dependency                  | Owner      | Required By    | Impact if Late          |
|-----------------------------|------------|----------------|-------------------------|
| [Brand assets and style guide]| [Client] | [Phase 1 end]  | [Design phase delayed]  |
| [API documentation]         | [Client]   | [Phase 2 start]| [Integration blocked]   |
| [Staging environment access]| [Provider] | [Week 3]       | [Testing delayed]       |
| [Content for 12 pages]      | [Client]   | [Phase 3 start]| [Launch delayed]        |
| [Third-party vendor setup]  | [Vendor]   | [Week 4]       | [Integration blocked]   |
```

### Step 3: Scope Definition

This is the core of the SOW. Precision here prevents disputes later. Every gray area resolved now is a conflict avoided during delivery.

#### 3.1 — In-Scope Deliverables

List every deliverable with its acceptance criteria. Group by phase or functional area. Each deliverable must be specific enough that both parties agree on whether it was delivered.

```
IN-SCOPE DELIVERABLES

Phase 1 — [Phase Name, e.g., Discovery & Planning]
──────────────────────────────────────────────────
  D1.1  [Deliverable name]
        Description: [What it is, in concrete terms]
        Format:      [Document, code, design file, etc.]
        Acceptance:  [Specific criteria — see Step 6]

  D1.2  [Deliverable name]
        Description: [What it is]
        Format:      [Format]
        Acceptance:  [Criteria]

Phase 2 — [Phase Name, e.g., Design & Architecture]
──────────────────────────────────────────────────
  D2.1  [Deliverable name]
        Description: [What it is]
        Format:      [Format]
        Acceptance:  [Criteria]

  D2.2  [Deliverable name]
        Description: [What it is]
        Format:      [Format]
        Acceptance:  [Criteria]

Phase 3 — [Phase Name, e.g., Development]
──────────────────────────────────────────────────
  D3.1  [Deliverable name]
        Description: [What it is]
        Format:      [Format]
        Acceptance:  [Criteria]

Phase 4 — [Phase Name, e.g., Testing & Launch]
──────────────────────────────────────────────────
  D4.1  [Deliverable name]
        Description: [What it is]
        Format:      [Format]
        Acceptance:  [Criteria]
```

**Deliverable naming rules:**
- Use nouns, not verbs: "User authentication system" not "Build authentication"
- Be specific about quantity: "12 responsive page templates" not "page templates"
- Specify format: "Figma source files" not "design files"
- Include version/state: "Production-deployed API" not just "API"

#### 3.2 — Out-of-Scope Items

Explicitly list what is NOT included. This section is as important as in-scope — possibly more so. Items here often come from discovery conversations where the client mentioned something that was deprioritized.

```
OUT OF SCOPE

The following items are explicitly excluded from this engagement.
They may be addressed in a future phase or separate SOW.

  ✗ [Item 1 — e.g., Mobile native app development (web responsive only)]
  ✗ [Item 2 — e.g., Content writing, copywriting, or translation]
  ✗ [Item 3 — e.g., Ongoing maintenance after [X]-day warranty period]
  ✗ [Item 4 — e.g., Migration of historical data prior to [date]]
  ✗ [Item 5 — e.g., SEO optimization beyond technical fundamentals]
  ✗ [Item 6 — e.g., Third-party service costs (hosting, licenses, APIs)]
  ✗ [Item 7 — e.g., Training beyond [N] sessions included above]
  ✗ [Item 8 — e.g., Integration with [system] — API not available]
  ✗ [Item 9 — e.g., Custom reporting beyond [N] standard reports]
  ✗ [Item 10 — e.g., Hardware procurement or infrastructure setup]

If the client wishes to add any excluded item during the project,
the Change Management process (Section 7) applies.
```

#### 3.3 — Scope Boundary Decision Tree

For common gray areas, pre-decide whether they are in or out. This prevents mid-project debates over items that "obviously should have been included."

```
SCOPE BOUNDARY DECISIONS

Use this tree when a question arises about whether something is in scope:

Is the item explicitly listed in Section 3.1 (In-Scope Deliverables)?
├── YES → In scope. Deliver it.
└── NO → Is it explicitly listed in Section 3.2 (Out of Scope)?
    ├── YES → Out of scope. Change request required.
    └── NO → Is it necessary for an in-scope deliverable to function?
        ├── YES → Is the effort less than [4 hours / 0.5 days]?
        │   ├── YES → Include it. Log it as a scope note for the record.
        │   └── NO → Change request required. Estimate impact first.
        └── NO → It is out of scope by default. Change request required.

COMMON GRAY AREAS PRE-DECIDED:

| Gray Area                           | Decision    | Rationale                                |
|-------------------------------------|-------------|------------------------------------------|
| Browser testing beyond [listed set] | OUT         | Each additional browser adds QA effort    |
| Minor content edits during build    | IN (< 1 hr) | Normal iteration, not a change request    |
| Adding a new page/screen            | OUT         | New deliverable requires scope change     |
| Bug fixes during development        | IN          | Part of standard QA                       |
| Bug fixes after acceptance signoff  | OUT*        | Warranty covers defects, not new requests |
| Performance optimization            | IN (basic)  | Meets stated metrics; beyond that = OUT   |
| Accessibility (WCAG AA)             | [IN/OUT]    | Decide at project start, document here    |
| Email/notification templates        | [IN/OUT]    | Decide based on project requirements      |
| Data seeding / sample content       | IN (minimal)| Enough to demonstrate functionality       |
| Production deployment               | [IN/OUT]    | Decide based on hosting arrangement       |
| Documentation                       | IN (user)   | Technical docs = OUT unless listed        |
| Training                            | IN ([N] sessions) | Additional sessions billed separately |

* Warranty-period defects (bugs in accepted work) are covered.
  New feature requests submitted as "bugs" are change requests.
```

### Step 4: Work Breakdown Structure

Decompose the project into phases, milestones, tasks, and effort estimates. This bridges the gap between "what we will deliver" (Step 3) and "when we will deliver it" (Step 5).

#### 4.1 — Phase & Milestone Overview

```
WORK BREAKDOWN STRUCTURE

Phase 1 — [Discovery & Planning]
  Milestone: M1 — Requirements Approved
  Duration:  [X] weeks
  Effort:    [X] person-days
  ┌────────────────────────────────────────────────────────────┐
  │ Task          Description              Effort  Depends On  │
  │ ─────         ───────────              ──────  ──────────  │
  │ T1.1          Stakeholder interviews   [2d]    —           │
  │ T1.2          Requirements document    [3d]    T1.1        │
  │ T1.3          Technical assessment     [2d]    —           │
  │ T1.4          Project plan finalize    [1d]    T1.2, T1.3  │
  │ T1.5          Client review & approval [2d]    T1.4        │
  └────────────────────────────────────────────────────────────┘

Phase 2 — [Design & Architecture]
  Milestone: M2 — Design Approved
  Duration:  [X] weeks
  Effort:    [X] person-days
  ┌────────────────────────────────────────────────────────────┐
  │ Task          Description              Effort  Depends On  │
  │ ─────         ───────────              ──────  ──────────  │
  │ T2.1          [Task description]       [Xd]    M1          │
  │ T2.2          [Task description]       [Xd]    T2.1        │
  │ T2.3          [Task description]       [Xd]    T2.1        │
  │ T2.4          Client review & approval [Xd]    T2.2, T2.3  │
  └────────────────────────────────────────────────────────────┘

Phase 3 — [Development / Execution]
  Milestone: M3 — Core Build Complete
  Duration:  [X] weeks
  Effort:    [X] person-days
  ┌────────────────────────────────────────────────────────────┐
  │ Task          Description              Effort  Depends On  │
  │ ─────         ───────────              ──────  ──────────  │
  │ T3.1          [Task description]       [Xd]    M2          │
  │ T3.2          [Task description]       [Xd]    T3.1        │
  │ T3.3          [Task description]       [Xd]    T3.1        │
  │ T3.4          [Task description]       [Xd]    T3.2, T3.3  │
  │ T3.5          Integration testing      [Xd]    T3.4        │
  └────────────────────────────────────────────────────────────┘

Phase 4 — [Testing & Launch]
  Milestone: M4 — Project Accepted
  Duration:  [X] weeks
  Effort:    [X] person-days
  ┌────────────────────────────────────────────────────────────┐
  │ Task          Description              Effort  Depends On  │
  │ ─────         ───────────              ──────  ──────────  │
  │ T4.1          QA / regression testing  [Xd]    M3          │
  │ T4.2          Client UAT              [Xd]    T4.1        │
  │ T4.3          Bug fixes from UAT       [Xd]    T4.2        │
  │ T4.4          Production deployment    [Xd]    T4.3        │
  │ T4.5          Handoff & documentation  [Xd]    T4.4        │
  └────────────────────────────────────────────────────────────┘

EFFORT SUMMARY

  Phase 1:    [X] person-days
  Phase 2:    [X] person-days
  Phase 3:    [X] person-days
  Phase 4:    [X] person-days
  Buffer:     [X] person-days ([15-20]% of total)
  ──────────────────────────────
  Total:      [X] person-days
```

#### 4.2 — Effort Estimation Guidance

Apply these heuristics when estimating effort:

```
ESTIMATION RULES

1. Decompose until each task is 0.5 - 5 days of effort. Anything
   larger should be broken into subtasks.

2. Add buffer at the PHASE level, not the task level:
   - Known technology, experienced team:  15% buffer
   - Some unknowns or new technology:     20% buffer
   - Significant unknowns or first time:  25-30% buffer

3. Client-dependent tasks (reviews, approvals, content delivery)
   get their own line items with explicit durations. These are
   NOT buffered — they are on the client's timeline.

4. Do not conflate elapsed time with effort:
   - Effort = person-days of work
   - Duration = calendar days including wait states
   - A 2-day effort task may span 5 calendar days if it requires
     a client review in the middle

5. Integration and testing tasks are commonly underestimated by
   50-100%. Double your initial gut estimate for these.

6. Include "overhead" tasks that consume real time:
   - Project management and status reporting
   - Environment setup and configuration
   - Code reviews and internal QA
   - Client communication and meeting preparation
```

#### 4.3 — Dependency Map

Visualize the critical path and inter-task dependencies:

```
DEPENDENCY MAP (Critical Path in CAPS)

  T1.1 ──→ T1.2 ──→ T1.4 ──→ M1 ──→ T2.1 ──→ T2.2 ──→ T2.4 ──→ M2
  T1.3 ──────────↗             │        └──→ T2.3 ──↗
                                │
  M2 ──→ T3.1 ──→ T3.2 ──→ T3.4 ──→ T3.5 ──→ M3 ──→ T4.1 ──→ T4.2
                    └──→ T3.3 ──↗                       └──→ T4.3 ──→ T4.4

  CRITICAL PATH: T1.1 → T1.2 → T1.4 → M1 → T2.1 → T2.2 → T2.4 → M2
                 → T3.1 → T3.2 → T3.4 → T3.5 → M3 → T4.1 → T4.2
                 → T4.3 → T4.4 → M4

  Critical path duration: [X] weeks
  Total project float:    [X] days (tasks that can slip without
                          affecting the end date)
```

### Step 5: Timeline & Milestones

Convert the WBS into a calendar-based timeline with clear gates.

#### 5.1 — Gantt-Style Text Timeline

```
PROJECT TIMELINE

Start:    [Date]
End:      [Date]
Duration: [X] weeks

Week  1   2   3   4   5   6   7   8   9  10  11  12
      ├───┼───┼───┼───┼───┼───┼───┼───┼───┼───┼───┤
P1    ████████░░                                       Discovery
P2              ██████████░░                           Design
P3                          ████████████████░░         Development
P4                                          ████████░░ Test & Launch

Gates:    ▲M1      ▲M2                  ▲M3      ▲M4
          Req      Design               Build    Accept
          Approved Approved             Complete Complete

░ = Buffer / contingency time
▲ = Client approval gate (blocks next phase)
```

#### 5.2 — Milestone Definitions

Each milestone must have measurable entry and exit criteria. No milestone is "done" until both parties agree.

```
MILESTONE DEFINITIONS

M1 — Requirements Approved
  Date:    [Target date]
  Entry:   All stakeholder interviews complete, requirements
           document drafted
  Exit:    Client signs off on requirements document. No
           outstanding questions in the requirements log.
  Gate:    Client approval required within [5] business days.
           If not received, project timeline shifts accordingly.
  Artifact: Signed requirements document (PDF with signature)

M2 — Design Approved
  Date:    [Target date]
  Entry:   All design deliverables (D2.1 - D2.N) presented
           to client
  Exit:    Client approves final design direction after no
           more than [2] revision rounds.
  Gate:    Client approval required within [5] business days.
  Artifact: Approved design files with signed approval email

M3 — Core Build Complete
  Date:    [Target date]
  Entry:   All development tasks (T3.1 - T3.N) complete,
           internal QA passed
  Exit:    Staging environment live, all in-scope features
           functional, no critical or high-severity bugs
  Gate:    Internal QA sign-off. Client demo scheduled.
  Artifact: Staging URL, QA test results, known issues log

M4 — Project Accepted
  Date:    [Target date]
  Entry:   Client UAT complete, all critical/high bugs resolved,
           all deliverables submitted
  Exit:    Client signs formal acceptance document. Warranty
           period begins.
  Gate:    Client acceptance required within [10] business days
           of final deliverable submission.
  Artifact: Signed acceptance document, handoff package
```

#### 5.3 — Client Review & Approval Gates

```
APPROVAL GATES

| Gate | Phase Transition | Approver          | SLA           | If Missed              |
|------|------------------|-------------------|---------------|------------------------|
| G1   | P1 → P2          | [Project Sponsor] | [5] biz days  | Timeline shifts by delay|
| G2   | P2 → P3          | [Decision Maker]  | [5] biz days  | Timeline shifts by delay|
| G3   | P3 → P4          | [Technical Lead]  | [3] biz days  | Demo rescheduled       |
| G4   | P4 → Close       | [Project Sponsor] | [10] biz days | Auto-accepted per terms|

APPROVAL PROCESS:
1. Provider submits deliverable(s) with a formal review request
2. Client has [SLA] business days to review
3. Client responds with: APPROVED, APPROVED WITH COMMENTS, or
   REVISION REQUESTED (with specific feedback)
4. If REVISION REQUESTED: provider addresses feedback and
   resubmits. Each resubmission resets the review clock.
5. Maximum [2] revision rounds per deliverable (additional
   rounds are change requests)
6. If client does not respond within SLA + [5] grace days,
   the deliverable is deemed accepted ("silent approval")
```

#### 5.4 — Buffer Allocation Strategy

```
BUFFER STRATEGY

Buffer is allocated at the phase level and consumed only for
genuine unknowns — not for scope additions or client delays.

| Phase   | Base Effort | Buffer % | Buffer Days | Total    |
|---------|-------------|----------|-------------|----------|
| Phase 1 | [X] days    | [15]%    | [X] days    | [X] days |
| Phase 2 | [X] days    | [15]%    | [X] days    | [X] days |
| Phase 3 | [X] days    | [20]%    | [X] days    | [X] days |
| Phase 4 | [X] days    | [15]%    | [X] days    | [X] days |
| Project | —           | —        | [X] days    | [X] days |

Buffer consumption rules:
• Buffer is consumed automatically — no change request needed
• If > 50% of phase buffer is consumed, provider notifies client
  with explanation and impact assessment
• If 100% of phase buffer is consumed, remaining risk shifts
  to project-level buffer
• If project-level buffer is consumed, a formal scope/timeline
  reassessment occurs via Change Management (Section 7)
• Buffer is NEVER available for scope additions — that is what
  the change request process is for
```

### Step 6: Acceptance Criteria

Define what "done" means at every level of the project. Ambiguous acceptance criteria are the root cause of projects that are "90% done" for months.

#### 6.1 — Definition of Done (per deliverable)

```
ACCEPTANCE CRITERIA MATRIX

| Deliverable | Criteria                                  | Verification Method   | Accepted By     |
|-------------|-------------------------------------------|-----------------------|-----------------|
| D1.1        | [Specific, testable criterion]            | [How it's verified]   | [Who approves]  |
|             | [Second criterion if needed]              |                       |                 |
| D1.2        | [Specific, testable criterion]            | [How it's verified]   | [Who approves]  |
| D2.1        | [Specific, testable criterion]            | [How it's verified]   | [Who approves]  |
| D2.2        | [Specific, testable criterion]            | [How it's verified]   | [Who approves]  |
| D3.1        | [Functional requirement met]              | [Test case / demo]    | [Who approves]  |
|             | [Performance target met]                  | [Benchmark test]      |                 |
|             | [No critical or high bugs]                | [QA report]           |                 |
| D4.1        | [UAT passed by client]                    | [UAT signoff form]    | [Who approves]  |
```

**Criteria writing rules:**
- Every criterion must be binary: pass or fail, yes or no
- Use measurable language: "loads in under 2 seconds" not "loads fast"
- Specify the environment: "on Chrome, Firefox, and Safari latest" not "all browsers"
- Include negative criteria: "does NOT expose user data in API responses"
- Define edge cases: "handles 0 items, 1 item, and 10,000+ items"

#### 6.2 — Testing & QA Requirements

```
TESTING REQUIREMENTS

Internal QA (Provider responsibility):
  ✓ Unit test coverage: [X]% minimum on business logic
  ✓ Integration tests for all API endpoints / data flows
  ✓ Cross-browser testing: [Chrome, Firefox, Safari, Edge — latest]
  ✓ Responsive testing: [Mobile 375px, Tablet 768px, Desktop 1280px+]
  ✓ Performance: Page load < [X]s, API response < [X]ms
  ✓ Security: OWASP Top 10 basic checks, no exposed secrets
  ✓ Accessibility: [WCAG 2.1 AA / not in scope — decide here]
  ✓ All critical and high-severity bugs resolved before UAT

Client UAT (Client responsibility):
  ✓ Provider delivers UAT test plan with scenarios
  ✓ Client executes scenarios in staging environment
  ✓ Client logs issues via [agreed channel — email, Jira, etc.]
  ✓ Provider triages issues as bug (fix included) or feature
    request (change request required)
  ✓ UAT duration: [X] business days
  ✓ UAT is considered passed when: [all critical scenarios pass /
    no critical bugs remain / client provides written signoff]

BUG SEVERITY DEFINITIONS:

| Severity | Definition                                     | SLA          |
|----------|------------------------------------------------|--------------|
| Critical | System unusable, data loss, security breach     | Fix within 24h|
| High     | Major feature broken, no workaround              | Fix within 3d |
| Medium   | Feature impaired but workaround exists           | Fix in next release |
| Low      | Cosmetic, minor inconvenience                    | Backlog      |
```

#### 6.3 — Client Sign-Off Process

```
SIGN-OFF PROCESS

For each phase milestone and final project acceptance:

1. Provider submits deliverables with:
   - Deliverable inventory (checklist of what's included)
   - Acceptance criteria status (pass/fail for each criterion)
   - Known issues log (if any, with severity and plan)
   - Review instructions (how to evaluate the deliverable)

2. Client reviews within [SLA] business days

3. Client responds using one of three outcomes:
   a) ACCEPTED — Deliverable meets all criteria. Phase complete.
   b) CONDITIONALLY ACCEPTED — Minor issues noted. Provider
      addresses within [3] business days. No re-review needed.
   c) REJECTED — Specific criteria not met. Provider revises
      and resubmits. This counts as a revision round.

4. Revision rounds:
   - [2] revision rounds included per deliverable
   - Each round addresses specific, written feedback only
   - Additional rounds require a change request
   - "I'll know it when I see it" feedback is not actionable
     — provider will request specific criteria

5. Acceptance finality:
   - Once a deliverable is ACCEPTED, reopening it for changes
     requires a change request
   - Final project acceptance triggers warranty period start
   - No deliverable is considered accepted until formal written
     confirmation (email is sufficient)
```

### Step 7: Change Management

Scope changes are inevitable. This process ensures they are controlled, visible, and agreed upon — not silently absorbed.

#### 7.1 — Change Request Process

```
CHANGE REQUEST PROCESS

Any modification to in-scope deliverables, timeline, or requirements
after the relevant milestone approval constitutes a Change Request.

PROCESS:

1. IDENTIFY — Either party identifies a potential change
   ↓
2. DOCUMENT — Requestor submits a Change Request Form:
   ┌─────────────────────────────────────────────────────┐
   │ CHANGE REQUEST FORM                                 │
   │                                                     │
   │ CR Number:     CR-[NNN]                             │
   │ Date:          [Date]                               │
   │ Requested By:  [Name, Role]                         │
   │ Priority:      [Critical / High / Medium / Low]     │
   │                                                     │
   │ Description:                                        │
   │ [What is being requested, in specific terms]        │
   │                                                     │
   │ Reason:                                             │
   │ [Why this change is needed — business justification]│
   │                                                     │
   │ Affected Deliverables:                              │
   │ [Which in-scope items are impacted]                 │
   │                                                     │
   │ Requested Completion: [Date or milestone]           │
   └─────────────────────────────────────────────────────┘
   ↓
3. ASSESS — Provider evaluates impact within [3] business days:
   ┌─────────────────────────────────────────────────────┐
   │ IMPACT ASSESSMENT                                   │
   │                                                     │
   │ Effort impact:    [+X person-days]                  │
   │ Timeline impact:  [+X days / no change / [detail]]  │
   │ Budget impact:    [+$X,XXX / included in buffer /   │
   │                    requires additional budget]       │
   │ Risk impact:      [New risks introduced]            │
   │ Dependencies:     [Other tasks/phases affected]     │
   │                                                     │
   │ Recommendation:   [Accept / Defer / Reject]         │
   │ Alternatives:     [If any — simpler approach, etc.] │
   └─────────────────────────────────────────────────────┘
   ↓
4. DECIDE — Client approves or rejects based on impact assessment
   ↓
5. EXECUTE — If approved:
   - SOW addendum issued with updated scope, timeline, budget
   - Change logged in Change Register
   - Work proceeds on approved change

CHANGE REGISTER:

| CR#  | Date       | Description          | Impact    | Status    |
|------|------------|----------------------|-----------|-----------|
| CR-001| [Date]    | [Brief description]  | [+Xd, +$X]| [Status] |
| CR-002| [Date]    | [Brief description]  | [+Xd, +$X]| [Status] |
```

#### 7.2 — Scope Creep Prevention

```
SCOPE CREEP PREVENTION RULES

1. NO VERBAL SCOPE CHANGES
   All scope changes must be documented in writing. "Can you also
   just quickly add..." is not a valid change request. The response
   is: "We'd love to include that. Let me document it as a change
   request so we can assess the impact."

2. WEEKLY SCOPE CHECK
   During status meetings, both parties review:
   - Any new requests received this week
   - Whether current work matches the SOW
   - Any assumption that has changed
   - Buffer consumption status

3. CHANGE REQUEST THRESHOLD
   Changes estimated at less than [4 hours] may be absorbed at
   the provider's discretion (goodwill budget). This is a courtesy,
   not an entitlement — the provider tracks cumulative goodwill
   hours. If cumulative goodwill exceeds [2 days], future minor
   changes require formal CRs.

4. "NICE TO HAVE" PARKING LOT
   Items discussed but not committed go into a Parking Lot list.
   They are not in scope, not promised, and not expected. They
   are candidates for future phases or change requests.

5. FEATURE vs. BUG DISTINCTION
   - BUG: Delivered work does not meet its documented acceptance
     criteria. Fix is included.
   - FEATURE: Work that was never in scope, or changes to already-
     accepted deliverables. Change request required.
   - GRAY AREA: Provider documents their assessment and both
     parties agree before work begins.
```

#### 7.3 — Re-Estimation Triggers

```
RE-ESTIMATION TRIGGERS

A formal re-estimation of timeline and/or budget is triggered when
ANY of the following occur:

  ▸ An assumption documented in Section 2.4 proves invalid
  ▸ A dependency is delayed by more than [5] business days
  ▸ Cumulative approved change requests exceed [15]% of original effort
  ▸ Phase buffer is 100% consumed
  ▸ A critical technology or integration fails and requires rearchitecture
  ▸ Key team member becomes unavailable for more than [10] business days
  ▸ Client changes decision maker or project sponsor mid-project
  ▸ Regulatory or compliance requirements change after M1

RE-ESTIMATION PROCESS:
  1. Provider issues a Re-Estimation Notice explaining the trigger
  2. Both parties meet within [3] business days to assess
  3. Provider presents revised timeline, effort, and budget
  4. Options: accept revised plan, reduce scope to fit original
     budget/timeline, or pause/cancel the project
  5. Agreed path forward documented as SOW Addendum
```

### Step 8: Output

Assemble the complete SOW document and present it. The output is a single markdown document ready for client delivery (convert to PDF via Pandoc, Google Docs, or Word).

```
━━━ SCOPE OF WORK: [Project Name] ━━━━━━━━━━━

── DOCUMENT DETAILS ──────────────────────────
Client:         [Client Name / Organization]
Provider:       [Provider Name / Company]
Project:        [Project Name]
Reference:      SOW-[YYYY]-[NNN]
Date:           [Date]
Version:        1.0
Related Docs:   [Proposal PROP-YYYY-NNN, Contract, etc.]

── TABLE OF CONTENTS ─────────────────────────
1. Project Overview
   1.1 Background & Context
   1.2 Objectives
   1.3 Success Metrics
   1.4 Assumptions & Dependencies
2. Scope Definition
   2.1 In-Scope Deliverables
   2.2 Out-of-Scope Items
   2.3 Scope Boundary Rules
3. Work Breakdown Structure
   3.1 Phase & Milestone Overview
   3.2 Effort Summary
   3.3 Dependency Map
4. Timeline & Milestones
   4.1 Project Timeline
   4.2 Milestone Definitions
   4.3 Approval Gates
   4.4 Buffer Strategy
5. Acceptance Criteria
   5.1 Definition of Done
   5.2 Testing & QA Requirements
   5.3 Client Sign-Off Process
6. Change Management
   6.1 Change Request Process
   6.2 Scope Creep Prevention
   6.3 Re-Estimation Triggers
7. Appendices
   A. Change Request Form Template
   B. Acceptance Sign-Off Template
   C. Parking Lot (Future Phase Candidates)

── COMPLETE SOW DOCUMENT ─────────────────────
[Full SOW text, all sections assembled per Steps 2-7]

── ASSUMPTIONS LOG ───────────────────────────
• [Assumptions made due to missing inputs]
• [Items flagged for client clarification before signing]
• [Defaults applied where client input was not available]

── PRE-DELIVERY CHECKLIST ────────────────────
□ All deliverables listed with specific acceptance criteria
□ Out-of-scope items reviewed with client (no surprises)
□ Effort estimates reviewed by delivery team (not just PM)
□ Timeline accounts for known holidays and team availability
□ Buffer percentages appropriate for project risk level
□ Approval gate SLAs agreed with client decision maker
□ Change request process reviewed with client
□ Silent approval clause understood by both parties
□ All stakeholders named — no "TBD" contacts remaining
□ Related documents (proposal, contract) cross-referenced
□ Client receives SOW in advance of contract signing
□ Both parties sign or formally acknowledge the SOW
```

**Format options:**
- **Markdown** (default): Ready for conversion to PDF or import into Google Docs / Word
- **If the user requests a specific format**: Adapt output accordingly, but always keep a markdown master copy

After presenting the SOW, offer:

> "Want me to adjust the deliverables, modify the timeline, add or remove phases, refine acceptance criteria, or generate a matching contract to accompany this SOW?"

## Complete SOW Template

Below is a ready-to-fill template with all sections and placeholder content. Copy this template and replace bracketed items with project-specific details.

```markdown
# SCOPE OF WORK

**Project:** [Project Name]
**Client:** [Client Name / Organization]
**Provider:** [Provider Name / Company]
**Reference:** SOW-[YYYY]-[NNN]
**Date:** [Date]
**Version:** 1.0

---

## 1. Project Overview

### 1.1 Background & Context

[Client Name] is undertaking [project type] to address [core business
need]. [2-3 sentences of background context explaining what exists today,
what triggered this project, and the strategic importance.]

This Scope of Work defines the boundaries, deliverables, acceptance
criteria, and change management process for [Project Name].

### 1.2 Objectives

1. [Objective 1 — measurable outcome with target date]
2. [Objective 2 — measurable outcome with target date]
3. [Objective 3 — measurable outcome with target date]
4. [Objective 4 — measurable outcome with target date]

### 1.3 Success Metrics

| Metric          | Current   | Target    | Method          | Timeline   |
|-----------------|-----------|-----------|-----------------|------------|
| [Metric 1]      | [Current] | [Target]  | [How measured]  | [When]     |
| [Metric 2]      | [Current] | [Target]  | [How measured]  | [When]     |
| [Metric 3]      | [Current] | [Target]  | [How measured]  | [When]     |

### 1.4 Assumptions

1. [Assumption about client-provided resources]
2. [Assumption about technology or infrastructure]
3. [Assumption about timeline and availability]
4. [Assumption about third-party services]
5. Client will designate a single point of contact with approval
   authority who responds within [X] business days.

### 1.5 Dependencies

| Dependency              | Owner    | Required By  | Impact if Late       |
|-------------------------|----------|--------------|----------------------|
| [Dependency 1]          | [Owner]  | [Date]       | [Impact]             |
| [Dependency 2]          | [Owner]  | [Date]       | [Impact]             |
| [Dependency 3]          | [Owner]  | [Date]       | [Impact]             |

---

## 2. Scope Definition

### 2.1 In-Scope Deliverables

**Phase 1 — [Phase Name]**

| ID   | Deliverable              | Format       | Acceptance Criteria         |
|------|--------------------------|--------------|------------------------------|
| D1.1 | [Deliverable name]       | [Format]     | [Specific pass/fail criteria]|
| D1.2 | [Deliverable name]       | [Format]     | [Specific pass/fail criteria]|

**Phase 2 — [Phase Name]**

| ID   | Deliverable              | Format       | Acceptance Criteria         |
|------|--------------------------|--------------|------------------------------|
| D2.1 | [Deliverable name]       | [Format]     | [Specific pass/fail criteria]|
| D2.2 | [Deliverable name]       | [Format]     | [Specific pass/fail criteria]|

**Phase 3 — [Phase Name]**

| ID   | Deliverable              | Format       | Acceptance Criteria         |
|------|--------------------------|--------------|------------------------------|
| D3.1 | [Deliverable name]       | [Format]     | [Specific pass/fail criteria]|
| D3.2 | [Deliverable name]       | [Format]     | [Specific pass/fail criteria]|

**Phase 4 — [Phase Name]**

| ID   | Deliverable              | Format       | Acceptance Criteria         |
|------|--------------------------|--------------|------------------------------|
| D4.1 | [Deliverable name]       | [Format]     | [Specific pass/fail criteria]|
| D4.2 | [Deliverable name]       | [Format]     | [Specific pass/fail criteria]|

### 2.2 Out of Scope

The following items are explicitly excluded from this engagement:

- [Out-of-scope item 1]
- [Out-of-scope item 2]
- [Out-of-scope item 3]
- [Out-of-scope item 4]
- [Out-of-scope item 5]
- Ongoing maintenance beyond [X]-day warranty period
- Third-party service costs (hosting, licenses, APIs)
- Content creation unless listed as a deliverable above

### 2.3 Scope Boundary Rules

Items not listed in Section 2.1 or 2.2 are out of scope by default.
Minor supporting tasks (< [4] hours) necessary for an in-scope
deliverable to function may be absorbed at the provider's discretion.
All other additions require a Change Request (Section 6).

---

## 3. Work Breakdown Structure

### 3.1 Phase Overview

**Phase 1 — [Phase Name] ([X] weeks)**

| Task  | Description             | Effort | Depends On |
|-------|-------------------------|--------|------------|
| T1.1  | [Task description]      | [Xd]   | —          |
| T1.2  | [Task description]      | [Xd]   | T1.1       |
| T1.3  | [Task description]      | [Xd]   | T1.2       |

**Phase 2 — [Phase Name] ([X] weeks)**

| Task  | Description             | Effort | Depends On |
|-------|-------------------------|--------|------------|
| T2.1  | [Task description]      | [Xd]   | M1         |
| T2.2  | [Task description]      | [Xd]   | T2.1       |
| T2.3  | [Task description]      | [Xd]   | T2.1       |

**Phase 3 — [Phase Name] ([X] weeks)**

| Task  | Description             | Effort | Depends On |
|-------|-------------------------|--------|------------|
| T3.1  | [Task description]      | [Xd]   | M2         |
| T3.2  | [Task description]      | [Xd]   | T3.1       |
| T3.3  | [Task description]      | [Xd]   | T3.2       |

**Phase 4 — [Phase Name] ([X] weeks)**

| Task  | Description             | Effort | Depends On |
|-------|-------------------------|--------|------------|
| T4.1  | [Task description]      | [Xd]   | M3         |
| T4.2  | [Task description]      | [Xd]   | T4.1       |
| T4.3  | [Task description]      | [Xd]   | T4.2       |

### 3.2 Effort Summary

| Phase   | Base Effort | Buffer | Total   |
|---------|-------------|--------|---------|
| Phase 1 | [X] days    | [X] d  | [X] d   |
| Phase 2 | [X] days    | [X] d  | [X] d   |
| Phase 3 | [X] days    | [X] d  | [X] d   |
| Phase 4 | [X] days    | [X] d  | [X] d   |
| **Total** | **[X] days** | **[X] d** | **[X] d** |

---

## 4. Timeline & Milestones

### 4.1 Project Timeline

Total duration: [X] weeks
Start date: [Date]
End date: [Date]

| Week | Phase                | Key Activities              | Client Actions        |
|------|----------------------|-----------------------------|-----------------------|
| 1-2  | [Phase 1]            | [Activities]                | [Required from client]|
| 3-4  | [Phase 2]            | [Activities]                | [Required from client]|
| 5-8  | [Phase 3]            | [Activities]                | [Required from client]|
| 9-10 | [Phase 4]            | [Activities]                | [Required from client]|

### 4.2 Milestones

| ID | Milestone                | Target Date | Exit Criteria              | Approver       |
|----|--------------------------|-------------|----------------------------|----------------|
| M1 | [Milestone name]         | [Date]      | [What must be true]        | [Who approves] |
| M2 | [Milestone name]         | [Date]      | [What must be true]        | [Who approves] |
| M3 | [Milestone name]         | [Date]      | [What must be true]        | [Who approves] |
| M4 | Project Accepted         | [Date]      | All deliverables accepted  | [Who approves] |

### 4.3 Approval Gates

Client approval is required at each milestone before the next phase
begins. Approval SLA: [5] business days. Delays in approval shift
subsequent milestones by an equivalent period.

---

## 5. Acceptance & Quality

### 5.1 Testing Requirements

- [Testing requirement 1 — e.g., unit test coverage > X%]
- [Testing requirement 2 — e.g., cross-browser testing]
- [Testing requirement 3 — e.g., performance benchmarks]
- [Testing requirement 4 — e.g., security checks]

### 5.2 Client UAT

Provider will deliver a UAT test plan. Client will execute UAT within
[X] business days in the staging environment. Issues are categorized
as bugs (included) or feature requests (change request required).

### 5.3 Sign-Off

Each milestone requires written client approval (email is sufficient).
[2] revision rounds are included per deliverable. If no response is
received within [SLA + 5] business days, the deliverable is deemed
accepted.

---

## 6. Change Management

### 6.1 Change Request Process

1. Requestor documents the change (description, reason, priority)
2. Provider assesses impact within [3] business days
3. Client approves or rejects based on impact assessment
4. If approved: SOW addendum issued, work proceeds
5. All changes logged in the Change Register

### 6.2 Scope Creep Prevention

- No verbal scope changes — all modifications in writing
- Weekly scope check during status meetings
- Changes under [4] hours may be absorbed (goodwill); cumulative
  goodwill capped at [2] days before formal CRs required
- "Parking Lot" list maintained for future-phase candidates

### 6.3 Re-Estimation Triggers

A formal re-estimation is triggered when: an assumption proves invalid,
a dependency is delayed > [5] days, cumulative CRs exceed [15]% of
original effort, or phase buffer is fully consumed.

---

## 7. Signatures

By signing below, both parties acknowledge and agree to the scope,
deliverables, timeline, acceptance criteria, and change management
process defined in this document.

**Client:**
Name: ___________________________
Title: ___________________________
Date: ___________________________
Signature: ___________________________

**Provider:**
Name: ___________________________
Title: ___________________________
Date: ___________________________
Signature: ___________________________

---

## Appendix A: Change Request Form

| Field              | Value                              |
|--------------------|------------------------------------|
| CR Number          | CR-[NNN]                           |
| Date               |                                    |
| Requested By       |                                    |
| Priority           | Critical / High / Medium / Low     |
| Description        |                                    |
| Reason             |                                    |
| Affected Items     |                                    |
| Effort Impact      |                                    |
| Timeline Impact    |                                    |
| Budget Impact      |                                    |
| Decision           | Approved / Deferred / Rejected     |
| Decided By         |                                    |
| Decision Date      |                                    |

## Appendix B: Acceptance Sign-Off Form

| Field              | Value                              |
|--------------------|------------------------------------|
| Deliverable ID     |                                    |
| Deliverable Name   |                                    |
| Phase              |                                    |
| Submitted Date     |                                    |
| Criteria Met       | Yes / No / Partial                 |
| Issues Noted       |                                    |
| Decision           | Accepted / Conditional / Rejected  |
| Reviewer Name      |                                    |
| Review Date        |                                    |
| Signature          |                                    |

## Appendix C: Parking Lot

| Item | Source | Priority | Estimated Effort | Notes |
|------|--------|----------|------------------|-------|
|      |        |          |                  |       |
```

## Anti-Patterns

| Do NOT | Do Instead |
|--------|------------|
| List deliverables without acceptance criteria | Every deliverable has specific, testable pass/fail criteria |
| Use vague language like "as needed" or "various" | Specify quantities, formats, and boundaries explicitly |
| Skip the out-of-scope section | Exclusions prevent more disputes than inclusions |
| Assume the client understands technical terms | Define terms or use client-facing language |
| Bundle effort estimates as a single lump sum | Decompose to phase and task level for transparency |
| Set milestones without measurable exit criteria | Every milestone has a binary pass/fail gate |
| Allow verbal scope changes | All changes documented in writing, no exceptions |
| Buffer at the task level (padding every estimate) | Buffer at the phase level with explicit allocation |
| Treat the SOW as static after signing | SOW is a living document managed via change requests |
| Write acceptance criteria after the fact | Define criteria before work begins, not when reviewing |
| Skip the dependency map for "simple" projects | Even small projects have client dependencies that cause delays |
| Conflate effort (person-days) with duration (calendar days) | Always distinguish effort from elapsed time |
| Use "ASAP" or "TBD" for milestone dates | Every milestone has a target date, even if approximate |
| Include pricing in the SOW | Pricing belongs in the proposal or contract — the SOW defines scope only |
| Combine SOW with the contract | SOW is a referenced attachment to the contract, not embedded in it |

**SOW Length Guidelines:**

| Project Size | SOW Length | Focus Areas |
|-------------|-----------|-------------|
| Under $10K | 3-5 pages | Deliverables, acceptance criteria, timeline, exclusions |
| $10K - $50K | 5-10 pages | Full SOW with WBS, milestones, change management |
| $50K - $200K | 10-20 pages | Comprehensive with detailed WBS, risk, approval gates |
| $200K+ | 20-40 pages | Full SOW + appendices, RACI, detailed task decomposition |

## Escalation

| Situation | Action |
|-----------|--------|
| Client refuses to define out-of-scope items | Explain that undefined boundaries guarantee disputes. Offer to draft the exclusion list for their review. If they still refuse, add a clause: "Items not explicitly listed as in-scope are out of scope by default." |
| Stakeholders disagree on deliverables | Facilitate a scope alignment meeting. Document each stakeholder's requirements and have the project sponsor prioritize. The SOW reflects the sponsor's decisions. |
| Client wants to start work before SOW is signed | Strongly advise against it. If they insist, issue a Letter of Intent covering the first phase only, with a clause that the full SOW must be signed before Phase 2 begins. |
| Scope is too uncertain to define deliverables | Recommend a paid Discovery phase (1-2 weeks) that produces a detailed SOW as its deliverable. The Discovery SOW is short (2-3 pages) with the full SOW as the output. |
| Client's expectations exceed stated budget/timeline | Present the WBS and effort estimates transparently. Offer options: reduce scope to fit constraints, extend timeline, or increase budget. Do not silently absorb the gap. |
| Change requests are coming faster than delivery | Pause new CRs. Conduct a scope reset meeting. Re-baseline the SOW with all approved changes incorporated. Resume with a clean document. |
| Client treats every issue as a "bug" to avoid change requests | Reference the bug vs. feature distinction in Section 7.2. If a pattern develops, escalate to the project sponsor with the cumulative impact. |
| Multiple SOW versions are circulating | Implement version control: every SOW revision gets a version number (1.0, 1.1, 2.0). Only the latest signed version is authoritative. Addenda reference the base version. |
| Provider realizes mid-project that a deliverable was underscoped | Issue a Re-Estimation Notice per Section 7.3. Absorb the cost if it was a provider estimation error, but adjust the timeline. If assumptions changed, use the formal process. |

## Inputs

- Project name and description
- Client name, organization, and key stakeholders
- Project type and domain
- Constraints (budget, timeline, regulatory, technology)
- Existing documentation (proposals, discovery notes, prior SOWs)
- Deliverable list with desired formats and standards
- Known risks, dependencies, and assumptions
- Success criteria and measurement methods
- Client's approval process and decision-making structure
- Provider's team structure and availability

## Outputs

- Complete Scope of Work document in markdown
- Project overview with objectives, success metrics, and assumptions
- In-scope deliverables with acceptance criteria per item
- Explicit out-of-scope exclusions list
- Scope boundary decision tree for gray areas
- Work breakdown structure with task decomposition and effort estimates
- Dependency map with critical path identification
- Gantt-style timeline with milestone definitions
- Client approval gates with SLAs and escalation rules
- Buffer allocation strategy by phase
- Testing and QA requirements with severity definitions
- Client sign-off process with revision round limits
- Change request process with impact assessment template
- Scope creep prevention rules
- Re-estimation triggers and process
- Ready-to-use appendix templates (Change Request Form, Acceptance Sign-Off Form, Parking Lot)
- Pre-delivery checklist for SOW review

## Level History

- **Lv.1** — Base: 8-step SOW protocol covering input gathering (project details, stakeholders, constraints, existing documentation), project overview (background, objectives with measurement methods, success metrics with current/target states, assumptions and dependency tracking), scope definition (in-scope deliverables with per-item acceptance criteria, explicit out-of-scope exclusions, scope boundary decision tree with pre-decided gray areas table), work breakdown structure (phase/milestone/task decomposition, effort estimation heuristics with buffer allocation rules, dependency map with critical path visualization), timeline and milestones (Gantt-style text timeline, milestone definitions with entry/exit criteria and artifacts, client approval gates with SLAs and silent-approval clause, buffer allocation strategy with consumption rules), acceptance criteria (definition of done matrix, testing/QA requirements with bug severity definitions, client sign-off process with revision round limits and finality rules), change management (5-step change request process with CR form and impact assessment templates, scope creep prevention with goodwill budget and parking lot, re-estimation triggers with formal process), complete SOW template with all sections and appendices (CR form, acceptance sign-off, parking lot). Anti-patterns table with SOW length guidelines by project size, escalation guide for 9 scenarios, comprehensive inputs/outputs lists. (Origin: MemStack v3.2, Mar 2026)
