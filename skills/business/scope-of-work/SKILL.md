---
name: scope-of-work
description: "WHAT: Generate a formal SOW defining boundaries, deliverables, acceptance criteria, and change management. WHEN: User says 'scope of work', 'SOW', 'define scope', 'project scope', 'project boundaries'. NOT: proposals (proposal-writer), contracts (contract-template), invoices (invoice-generator), roadmaps without formal scope (roadmap-builder), conceptual scope discussions."
---

# Scope of Work -- Project Boundary Definition

## Activation

| Context | Status |
|---------|--------|
| "scope of work", "SOW", "define scope", "project scope", "write SOW" | ACTIVE |
| Signed proposal needs formal scope document | ACTIVE |
| Scope creep -- needs to formalize boundaries | ACTIVE |
| Proposal, contract, invoice, roadmap, conceptual discussion | DORMANT |

## Instructions

### Step 1: Gather Inputs

Required: project name, client name, project type, high-level description (2-5 sentences). Recommended: stakeholders (decision maker, sponsor, technical lead, approval authority), constraints (budget, deadlines, regulatory, tech mandates), existing docs. Optional: prior attempts, org context, risk factors, success definition.

Accept partial inputs. Flag assumptions explicitly. SOW with boundaries and TBDs beats no SOW.

**Gate:** At minimum project name + description before proceeding.

### Step 2: Scope Definition

Build three sections: in-scope deliverables (grouped by phase, each with format + acceptance criteria), out-of-scope exclusions, and scope boundary rules.

**Scope Boundary Decision Tree:**

```
Is item in Section 2.1 (In-Scope)?
 YES -> Deliver it.
 NO  -> Is item in Section 2.2 (Out of Scope)?
   YES -> Change request required.
   NO  -> Is it necessary for an in-scope deliverable to function?
     YES -> Effort < 4 hours? Include + log. Else change request.
     NO  -> Out of scope by default. Change request required.
```

**Pre-decided gray areas** (customize per project):

| Gray Area | Default | Rationale |
|-----------|---------|-----------|
| Browser testing beyond listed set | OUT | Each browser adds QA effort |
| Minor content edits during build | IN (< 1 hr) | Normal iteration |
| Adding a new page/screen | OUT | New deliverable = scope change |
| Bug fixes during development | IN | Standard QA |
| Bug fixes after acceptance signoff | OUT* | Warranty covers defects, not requests |
| Performance optimization | IN (basic) | Meets stated metrics; beyond = OUT |
| Accessibility (WCAG AA) | Decide at start | Document here |
| Data seeding / sample content | IN (minimal) | Enough to demo functionality |
| Documentation | IN (user) | Technical docs = OUT unless listed |
| Training | IN (N sessions) | Additional sessions billed separately |

*Warranty-period defects (bugs in accepted work) are covered. New features submitted as "bugs" are change requests.

**Gate:** Client confirms in-scope and out-of-scope lists before Step 3.

### Step 3: Effort Estimation and WBS

Decompose into phases > milestones > tasks. Each task: 0.5-5 days effort. Anything larger = subtasks.

**Estimation heuristics:**

1. Distinguish effort (person-days) from duration (calendar days). A 2-day task may span 5 calendar days with client review.
2. Client-dependent tasks (reviews, approvals, content) get own line items with explicit durations. Not buffered.
3. Integration and testing: double your gut estimate. Commonly underestimated by 50-100%.
4. Include overhead: PM, status reporting, environment setup, code reviews, meeting prep.

**Buffer allocation** (phase level, never task level):

| Risk Profile | Buffer % |
|-------------|----------|
| Known tech, experienced team | 15% |
| Some unknowns or new tech | 20% |
| Significant unknowns or first time | 25-30% |

Buffer consumption rules: consumed automatically (no CR needed). >50% consumed = notify client. 100% consumed = escalate to project-level buffer. Project buffer exhausted = formal re-estimation via Step 5. Buffer is never available for scope additions.

**Gate:** Delivery team reviews estimates (not just PM).

### Step 4: Timeline, Milestones, and Approval Gates

Each milestone has entry criteria, exit criteria, and an artifact.

**Approval gate SLAs:**

| Gate | Transition | Default SLA | If Missed |
|------|-----------|-------------|-----------|
| G1 | Phase 1 -> 2 | 5 biz days | Timeline shifts by delay |
| G2 | Phase 2 -> 3 | 5 biz days | Timeline shifts by delay |
| G3 | Phase 3 -> 4 | 3 biz days | Demo rescheduled |
| G4 | Phase 4 -> Close | 10 biz days | Auto-accepted per terms |

Approval process: submit with review request -> client responds APPROVED / APPROVED WITH COMMENTS / REVISION REQUESTED -> max 2 revision rounds per deliverable (additional = change requests) -> silent approval if no response within SLA + 5 grace days.

**Definition of Done pattern:** Every acceptance criterion is binary (pass/fail). Use measurable language ("loads in < 2s" not "loads fast"). Specify environment. Include negative criteria ("does NOT expose user data"). Define edge cases (0 items, 1 item, 10K+ items).

**Gate:** Client decision maker confirms SLAs and silent-approval clause.

### Step 5: Change Management

**Change Request Process (5 steps):**

1. **IDENTIFY** -- Either party identifies a potential change
2. **DOCUMENT** -- Requestor submits CR: description, reason, priority, affected deliverables
3. **ASSESS** -- Provider evaluates within 3 biz days: effort/timeline/budget/risk impact + recommendation
4. **DECIDE** -- Client approves or rejects based on assessment
5. **EXECUTE** -- If approved: SOW addendum, change logged, work proceeds

**Scope creep prevention rules:**

- No verbal scope changes. "Can you just quickly add..." -> "Let me document that as a CR."
- Weekly scope check: new requests, SOW alignment, assumption changes, buffer status.
- Goodwill threshold: changes < 4 hours may be absorbed. Cumulative cap at 2 days, then formal CRs.
- Parking lot: discussed-but-not-committed items tracked separately. Not in scope, not promised.
- Bug vs. feature: fails acceptance criteria = bug (fix included). Not in scope or changes to accepted work = feature (CR required).

**Re-estimation triggers** (any one fires formal re-estimation): assumption proves invalid, dependency delayed > 5 biz days, cumulative CRs exceed 15% of original effort, phase buffer 100% consumed, critical tech fails requiring rearchitecture, key team member unavailable > 10 biz days, client changes decision maker mid-project, regulatory requirements change after M1.

Re-estimation process: notice explaining trigger -> meeting within 3 biz days -> revised plan -> options: accept revision, reduce scope, or pause/cancel -> agreed path as SOW addendum.

**Gate:** Client acknowledges change management process before SOW is signed.

### Step 6: Assemble and Deliver

Output a single markdown document with sections: Document Details, Project Overview, Scope Definition, WBS, Timeline/Milestones, Acceptance Criteria, Change Management.

**SOW length guidelines:**

| Project Size | SOW Length | Focus |
|-------------|-----------|-------|
| Under $10K | 3-5 pages | Deliverables, acceptance, timeline, exclusions |
| $10K-$50K | 5-10 pages | Full SOW with WBS, milestones, change management |
| $50K-$200K | 10-20 pages | Comprehensive with detailed WBS, risk, approval gates |
| $200K+ | 20-40 pages | Full SOW + appendices, RACI, detailed task decomposition |

No pricing in the SOW (belongs in proposal/contract). SOW is a referenced attachment to the contract, not embedded.

After delivery, offer: "Adjust deliverables, modify timeline, add/remove phases, refine acceptance criteria, or generate a matching contract?"

## Examples

**Small project ($8K website redesign):**
4-page SOW. 3 phases (Design, Build, Launch). 6 deliverables with acceptance criteria. Out-of-scope: content writing, SEO, ongoing maintenance. 6-week timeline. 15% buffer. 2 approval gates.

**Mid-size project ($75K SaaS platform):**
15-page SOW. 5 phases with milestone gates. 22 deliverables across frontend, backend, integrations. Detailed WBS with dependency map. 20% buffer on dev phase, 15% elsewhere. Full change management with CR form template. WCAG AA in scope. 16-week timeline.

## Common Issues

| Issue | Fix |
|-------|-----|
| Client refuses to define out-of-scope | Add clause: "Items not explicitly listed as in-scope are out of scope by default." Draft exclusions for their review. |
| Scope too uncertain for deliverables | Recommend paid Discovery phase (1-2 weeks) whose deliverable is the full SOW. |
| Change requests outpacing delivery | Pause new CRs. Scope reset meeting. Re-baseline SOW with all approved changes. Resume clean. |

## Anti-Patterns

| Do NOT | Do Instead |
|--------|------------|
| Deliverables without acceptance criteria | Every deliverable has binary pass/fail criteria |
| Vague language ("as needed", "various") | Specify quantities, formats, boundaries |
| Skip out-of-scope section | Exclusions prevent more disputes than inclusions |
| Buffer at task level (padding every estimate) | Buffer at phase level with explicit allocation |
| Allow verbal scope changes | All changes in writing, no exceptions |
| Conflate effort with duration | Always distinguish person-days from calendar days |
| "ASAP" or "TBD" for milestone dates | Every milestone has a target date |
| Include pricing in SOW | Pricing in proposal/contract; SOW defines scope only |
| Combine SOW with contract | SOW is a referenced attachment, not embedded |

## Escalation

| Situation | Action |
|-----------|--------|
| Stakeholders disagree on deliverables | Scope alignment meeting. Document each view. Project sponsor prioritizes. SOW reflects sponsor's decisions. |
| Client wants to start before SOW signed | Issue Letter of Intent for Phase 1 only. Full SOW required before Phase 2. |
| Client expectations exceed budget/timeline | Present WBS transparently. Options: reduce scope, extend timeline, or increase budget. Never silently absorb the gap. |
| Client treats every issue as "bug" to dodge CRs | Reference bug vs. feature distinction. Escalate cumulative impact to sponsor if pattern develops. |
| Provider realizes deliverable was underscoped | Re-Estimation Notice. Absorb cost if provider error, but adjust timeline. If assumptions changed, use formal process. |
| Multiple SOW versions circulating | Version control: every revision gets a version number. Only latest signed version is authoritative. |

## Inputs

Project name, client, type, description, stakeholders, constraints (budget/timeline/regulatory/tech), existing docs (proposals, prior SOWs), known risks/dependencies/assumptions, success criteria.

## Outputs

Complete SOW in markdown: in-scope deliverables with acceptance criteria, out-of-scope exclusions, scope boundary decision tree, WBS with effort estimates, timeline with milestone definitions and approval gate SLAs, buffer allocation by phase, change request process, scope creep prevention rules, re-estimation triggers.

## Level History

- **Lv.1** -- Base: 8-step SOW protocol with templates, appendices, full WBS examples, Gantt charts, CR form template, acceptance sign-off form. (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** -- Compressed: Decision-rules-only rewrite. Removed templates, full WBS examples, Gantt charts, form templates. Preserved scope boundary decision tree, effort estimation heuristics, buffer allocation rules, acceptance criteria DoD pattern, 5-step CR process, scope creep prevention rules, re-estimation triggers, SOW length guidelines, approval gate SLAs. Added validation gates between steps. (Origin: MemStack v3.2, Mar 2026)
