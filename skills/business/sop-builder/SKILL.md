---
name: sop-builder
description: "Build production-grade SOPs from process discovery through validation. WHEN: 'create SOP', 'write SOP', 'standard operating procedure', 'document process', 'runbook', 'playbook', step-by-step documentation for repeatable processes. NOT: project proposals (proposal-writer), scope documents (scope-of-work), contracts (contract-template), conceptual process discussion without documentation intent."
---

# SOP Builder

## Activation

| Context | Status |
|---------|--------|
| "create SOP", "write SOP", "standard operating procedure" | ACTIVE |
| "document process", "runbook", "playbook", "work instruction" | ACTIVE |
| Standardize a process across team members | ACTIVE |
| Project proposal, scope document, contract | DORMANT -- wrong skill |
| Discussing process improvement conceptually | DORMANT |

## Instructions

### Step 1: Gather Inputs

Collect from the user. Accept partial inputs; flag assumptions in output.

**Required:** process name (specific, not vague), process owner (person/role), trigger event, end state (measurable "done" condition).

**Recommended:** department/team, audience skill level (novice/intermediate/expert), tools involved, frequency, current pain points.

**Optional:** compliance requirements, related SOPs, approvals required, SLA/time constraints, known exceptions, metrics/KPIs.

**Gate:** Must have all four required inputs (or reasonable inferences) before proceeding.

### Step 2: Process Discovery

Map the process end-to-end before writing steps. Prevents documenting what people *think* happens instead of what *actually* happens.

Run a discovery interview if the user is the SME, or provide as a template. Cover these six categories:

| Category | Focus |
|----------|-------|
| Trigger & Scope | Start event, end condition, first/last actions |
| Happy Path | Normal execution walkthrough, timing, tools per step |
| Decision Points | Judgment calls, conditions, approval gates |
| Exceptions & Failures | Common failures, recovery, abort conditions, worst case |
| Tribal Knowledge | What experienced people know, unofficial workarounds, day-one briefing |
| Dependencies | Preconditions, downstream impact, upstream process chains |

Build a linear process map with decision diamonds, then identify swim lanes (role-to-step mapping) and inventory all decision points with conditions and both paths.

**Gate:** Process map with all decision points cataloged before writing steps.

### Step 3: Structure the Document

Assemble in this order: Header/Metadata, Revision History, Purpose & Scope, RACI Matrix, Prerequisites/Tools/Access, Procedure, Exception Handling, Escalation Paths, Rollback, Appendices.

**SOP ID format:** `SOP-[DEPT]-[NNN]`. **Version scheme:** Major = flow/step/role/tool changes; Minor = clarifications, typo fixes, contact updates. Scale depth to complexity -- not every process needs rollback or a glossary.

### Step 4: Write Steps

**Action verb conventions** -- every step begins with one:

| Verb | Meaning |
|------|---------|
| Navigate | Open/go to a location (URL, menu, path) |
| Enter | Type or input a value |
| Select | Choose from options |
| Click | Press a UI element |
| Run | Execute a command or script |
| Verify | Confirm a condition before continuing |
| Wait | Pause for a condition or duration |
| Copy | Duplicate text, files, or data |
| Review | Examine output for correctness |
| Notify | Communicate to a person or channel |
| Approve | Grant authorization to proceed |
| Record | Log information for audit/reference |
| Escalate | Hand off to a higher authority |

**Step detail level by audience:**

| Audience | Step includes |
|----------|--------------|
| Novice | Action, detailed how-to, location, expected result, time, warnings, screenshot placeholders, checkpoint |
| Intermediate | Action, brief how-to, expected result, time, checkpoint |
| Expert | Action with time estimate, verification only |

**Decision tree notation** for branching steps:

```
Step N: Verify [condition]
        DECISION: [condition]?
        |-- YES -> Continue to Step N+1
        |-- NO  -> Go to Step Na (sub-step with recovery/escalation)
```

Nest decisions when sub-steps require further branching. Terminal branches must either rejoin the main flow or explicitly STOP with escalation.

Include time estimates at step and total-process level (typical + worst case).

Insert checkpoints only at critical junctures -- after steps where failure is costly or the next step depends on success. Each checkpoint: binary verifiable conditions + recovery action if not met.

**Gate:** Every step has an action verb, every decision has both paths defined, checkpoints exist at critical junctures.

### Step 5: Exception Handling

Document failure scenarios in a table: scenario, symptoms, impact (H/M/L), resolution, prevention.

Add a troubleshooting decision tree: failed at specific step? -> known scenario match? -> follow resolution or escalate. Completed but wrong output? -> identify failed checkpoint -> re-execute from prior step or escalate.

Define escalation paths by severity (P1-P4) with contact, method, and SLA.

Include rollback procedures when the process is reversible: rollback window, authority, reversal steps, verification conditions.

**Gate:** Top 3-5 failure modes documented, escalation paths defined.

### Step 6: Quality Assurance

Four-step QA workflow:

1. **Author review** -- self-check against quality criteria (action verbs, no tribal knowledge gaps, all decision paths, prerequisites complete, exception handling)
2. **Peer review** -- technical accuracy, missing steps, clarity, exception completeness
3. **Naive user test** -- someone who has never done the process follows it without help; author observes and records every question, mistake, or stall
4. **Revision + approval** -- incorporate findings, bump version, process owner signs off

**Review cadence by criticality:**

| Criticality | Frequency | Unscheduled trigger |
|-------------|-----------|---------------------|
| Critical (P1 impact if wrong) | Quarterly | Any P1/P2 incident involving this process |
| Standard (daily/weekly use) | Semi-annually | Tool change, role change, 3+ exceptions/quarter |
| Low frequency (monthly+) | Annually | Process failure, compliance audit finding |

### Step 7: Output

Present the assembled SOP in markdown. Offer to adjust detail level, add exception scenarios, or create a training walkthrough.

**SOP length guidelines:**

| Complexity | Steps | Target length |
|------------|-------|---------------|
| Simple (linear, single role) | 5-10 | 1-2 pages |
| Moderate (decisions, 2-3 roles) | 10-20 | 3-5 pages |
| Complex (multi-role, branching, compliance) | 20+ | 5-10 pages |

**Gate:** Passes the quality checklist from Step 6 before delivery.

## Examples

**Simple linear:** "SOP for weekly database backup." Single-role, no decisions, novice detail. Linear 6 steps, one checkpoint after backup verification, exception table for disk space and connection failures.

**Complex branching:** "SOP for customer refund requests." Multi-role (support, finance, manager), 3 decision points (amount thresholds, exception approval, payment method). RACI matrix, decision trees for approval routing, exception handling for processor failures and chargebacks.

## Common Issues

| Issue | Fix |
|-------|-----|
| Steps require undocumented tribal knowledge | Run discovery interview with SME; every implicit assumption becomes an explicit prerequisite or sub-step |
| Decision points have only the happy path | Inventory all decisions in Step 2; force both YES and NO paths before writing steps |
| SOP becomes stale within months | Set review cadence by criticality; assign a process owner who is accountable for updates |

## Anti-Patterns

- **Template-stuffing:** Filling every section regardless of process complexity. A 5-step backup script does not need a RACI matrix or rollback procedures.
- **Memory-based documentation:** Writing steps from what people remember instead of observing/walking through the actual process. Always validate against reality.
- **Audience mismatch:** Expert-level SOPs for novice users (they get stuck) or novice-level SOPs for experts (they ignore them). Match detail to the stated audience.
- **Orphan SOPs:** No owner, no review date, no version history. These decay into misleading artifacts within one quarter.

## Escalation

- Process spans multiple departments with conflicting procedures -> facilitate cross-team alignment before documenting; do not paper over disagreements
- Compliance/regulatory requirements are unclear -> flag for legal/compliance review; do not guess at regulatory obligations
- User wants to document a process that does not yet exist -> redirect to process design first; SOPs document reality, not aspirations

## Inputs

| Input | Required | Source |
|-------|----------|--------|
| Process name | Yes | User |
| Process owner | Yes | User |
| Trigger event | Yes | User |
| End state | Yes | User |
| Audience skill level | No (default: intermediate) | User |
| Tools involved | No | User/discovery |
| Frequency | No | User |
| Compliance requirements | No | User |

## Outputs

| Output | Format |
|--------|--------|
| Complete SOP document | Markdown |
| Process map | ASCII diagram (inline) |
| RACI matrix | Markdown table |
| Exception handling table | Markdown table |

## Level History

- **Lv.1** -- Base: SOP structure, step writing conventions, action verb table, audience skill levels, decision tree notation, exception handling, QA workflow, version control scheme, review cadence, length guidelines. (Origin: MemStack v2.0, Feb 2026)
- **Lv.2** -- Compression: Removed full SOP template, exhaustive interview questions (retained 6 categories), quick reference card, verbose examples. Added validation gates, anti-patterns, escalation criteria, input/output tables. (Origin: MemStack v3.3, Mar 2026)
