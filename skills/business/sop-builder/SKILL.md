---
name: sop-builder
description: "Use when the user says 'create SOP', 'write SOP', 'standard operating procedure', 'document process', 'process documentation', 'runbook', 'playbook', or is creating step-by-step documentation for a repeatable process. Do NOT use for project proposals (see proposal-writer) or scope documents (see scope-of-work)."
---

# 📖 SOP Builder — Standard Operating Procedure Generator
*Create clear, repeatable, production-grade standard operating procedures — from process discovery through validation to version-controlled documentation that anyone on the team can follow without tribal knowledge.*

## Activation

When this skill activates, output:

`📖 SOP Builder — Documenting your process...`

| Context | Status |
|---------|--------|
| **User says "create SOP", "write SOP", "standard operating procedure"** | ACTIVE |
| **User says "document process", "process documentation", "runbook"** | ACTIVE |
| **User says "playbook", "work instruction", "how-to guide"** | ACTIVE |
| **User wants step-by-step documentation for a repeatable task** | ACTIVE |
| **User needs to standardize a process across team members** | ACTIVE |
| **User wants to reduce onboarding time for a specific workflow** | ACTIVE |
| **User wants a project proposal or pitch** | DORMANT — see proposal-writer |
| **User wants a formal scope document** | DORMANT — see scope-of-work |
| **User wants a contract or legal agreement** | DORMANT — see contract-template |
| **User is discussing process improvement conceptually, not documenting** | DORMANT — do not activate |

## Protocol

### Step 1: Gather Inputs

Ask the user for the following. Accept partial inputs and fill gaps with sensible defaults or mark as TBD. A documented process with some TBDs is infinitely better than an undocumented one.

**Required:**
- **Process name**: Clear, specific name (e.g., "Production Release Deployment" not "Deploying stuff")
- **Process owner**: Person or role ultimately responsible for this process
- **Trigger event**: What initiates this process? (e.g., "Sprint ends", "New hire starts Day 1", "Customer submits refund request")
- **End state**: What does "done" look like? The measurable condition that proves the process completed successfully

**Strongly recommended:**
- **Department / team**: Which group owns and executes this process
- **Audience skill level**: Novice (step-by-step with screenshots), Intermediate (concise steps with references), Expert (checklist format with decision points only)
- **Tools involved**: Software, platforms, hardware, accounts, or services required (e.g., "GitHub, AWS Console, Slack, Jira")
- **Frequency**: How often is this process executed? (Daily, weekly, monthly, per-event, quarterly, annually)
- **Current pain points**: What goes wrong today? Where do people get stuck or improvise?

**Optional (enhances quality):**
- **Compliance requirements**: Regulatory standards (SOX, HIPAA, PCI-DSS, ISO 27001, GDPR), audit trail needs, retention policies
- **Related SOPs**: Other procedures that feed into or depend on this one
- **Approvals required**: Who must sign off at what stages?
- **SLA / time constraints**: Maximum allowable duration for the process or individual steps
- **Known exceptions**: Edge cases or alternate paths that occur regularly
- **Metrics / KPIs**: How is the success of this process measured? (e.g., "Deployment completes in < 30 min", "Zero P1 incidents within 24 hours post-deploy")

If the user provides only a brief description (e.g., "SOP for our deploy process"), extract what you can, infer reasonable defaults, and proceed. Flag all assumptions explicitly in the output so the process owner can validate them.

### Step 2: Process Discovery

Before writing a single step, map the process end-to-end. This prevents the #1 SOP failure: documenting what people *think* happens instead of what *actually* happens.

#### 2.1 — Interview Questions for Subject Matter Experts

If the user is the SME, ask these questions directly. If they're documenting someone else's process, provide these as an interview template.

```
PROCESS DISCOVERY INTERVIEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━

Process: [Process Name]
SME:     [Name / Role]
Date:    [Date]

TRIGGER & SCOPE
1. What event or condition kicks off this process?
2. How do you know the process is complete?
3. What is the very first thing you do when this process starts?
4. What is the very last thing you do before considering it done?

HAPPY PATH
5. Walk me through a normal, smooth execution from start to finish.
6. How long does each major step take?
7. What tools or systems do you use at each step?
8. Where do you hand off to someone else? Who, and what do they need?

DECISION POINTS
9. Where do you have to make a judgment call or check a condition?
10. What information do you use to decide which path to take?
11. Are there steps where you need approval before continuing?

EXCEPTIONS & FAILURES
12. What goes wrong most often?
13. When something fails, how do you recover?
14. Are there situations where you abandon the process entirely?
15. What's the worst-case scenario, and what do you do if it happens?

TRIBAL KNOWLEDGE
16. What do experienced people know that new people always miss?
17. Are there unofficial workarounds that aren't documented anywhere?
18. What would you tell your replacement on their first day?

DEPENDENCIES
19. What must be true before you can start? (Access, approvals, data)
20. Who else is affected if this process is delayed or fails?
21. Does this process depend on another process completing first?
```

#### 2.2 — Process Mapping

Build a linear process map before writing steps. Use this format to identify the structure:

```
PROCESS MAP: [Process Name]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[Trigger] ──▶ Step 1 ──▶ Step 2 ──▶ ◆ Decision ──▶ Step 3A (if yes)
                                          │
                                          └──▶ Step 3B (if no)
                                                   │
                                          ──▶ Step 4 ──▶ [End State]

Swim Lanes:
┌─────────────┬──────────┬───────────┬────────────┐
│ Role A       │ Role B   │ Role C    │ System     │
├─────────────┼──────────┼───────────┼────────────┤
│ Steps 1-2   │ Step 3   │ Step 5    │ Steps 4, 6 │
│ Approves 4  │          │ Reviews 6 │ Auto-email  │
└─────────────┴──────────┴───────────┴────────────┘
```

#### 2.3 — Swim Lane Identification

Identify every distinct role or system that participates in the process. For each:

| Role / Actor | Responsibilities in This Process | Required Access / Permissions |
|-------------|----------------------------------|-------------------------------|
| [Role name] | [What they do, which steps] | [Systems, accounts, permissions needed] |
| [System] | [Automated actions] | [API keys, service accounts, integrations] |

#### 2.4 — Decision Point Inventory

Catalog every branching decision in the process before writing steps. This prevents missed paths.

| Decision Point | Condition | Path A (Yes/True) | Path B (No/False) | Who Decides |
|---------------|-----------|--------------------|--------------------|-------------|
| D1: [Name] | [Condition to evaluate] | [Next step if true] | [Next step if false] | [Role] |
| D2: [Name] | [Condition to evaluate] | [Next step if true] | [Next step if false] | [Role] |

### Step 3: SOP Structure

Generate the SOP document with these sections in order. Every section serves a purpose — do not skip sections, but scale depth to the process complexity.

#### 3.1 — Document Header & Metadata

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
         STANDARD OPERATING PROCEDURE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Title:          [Process Name]
SOP ID:         SOP-[DEPT]-[NNN]
Version:        1.0
Effective Date: [Date]
Review Date:    [Date + review cadence]

Process Owner:  [Name / Role]
Department:     [Department / Team]
Classification: [Public | Internal | Confidential | Restricted]

Approved By:    [Name / Role]           Date: [Date]
Reviewed By:    [Name / Role]           Date: [Date]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
REVISION HISTORY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
| Version | Date       | Author      | Changes               |
|---------|------------|-------------|-----------------------|
| 1.0     | [Date]     | [Author]    | Initial release       |
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

#### 3.2 — Purpose & Scope

```
1. PURPOSE
━━━━━━━━━━

This procedure defines the standardized process for [process name].
It ensures [primary benefit: consistency / compliance / quality / safety]
and provides [secondary benefit: auditability / repeatability / training
baseline] for [department/team].

2. SCOPE
━━━━━━━━

Applies to:     [Who must follow this SOP — roles, teams, departments]
Covers:         [What activities, systems, and scenarios this SOP addresses]
Does NOT cover: [Explicit exclusions — related processes handled elsewhere]
Frequency:      [How often this process is executed]
Trigger:        [What event initiates this process]
End State:      [What "done" looks like — the measurable completion criteria]
```

#### 3.3 — Roles & Responsibilities (RACI Matrix)

Define accountability for every major step using RACI:
- **R** = Responsible (does the work)
- **A** = Accountable (has final authority, one per task)
- **C** = Consulted (provides input before the task)
- **I** = Informed (notified after the task)

```
3. ROLES & RESPONSIBILITIES
━━━━━━━━━━━━━━━━━━━━━━━━━━━

| Activity              | [Role A] | [Role B] | [Role C] | [Role D] |
|-----------------------|----------|----------|----------|----------|
| [Major activity 1]   | R        | A        | C        |          |
| [Major activity 2]   |          | R        | A        | I        |
| [Major activity 3]   | R        |          |          | A        |
| [Decision point 1]   | C        | A        | R        | I        |
| [Final approval]     |          | A        |          | I        |

Key contacts:
- Process Owner:        [Name], [email/slack], [phone]
- Backup/Delegate:      [Name], [email/slack], [phone]
- Escalation Contact:   [Name], [email/slack], [phone]
```

#### 3.4 — Prerequisites, Tools & Access

```
4. PREREQUISITES
━━━━━━━━━━━━━━━━

Before starting this process, verify ALL of the following:

Access & Permissions:
□ [System/tool] — [permission level required] — Request via [method]
□ [System/tool] — [permission level required] — Request via [method]

Tools & Software:
□ [Tool name] [version] — [download/install link]
□ [Tool name] [version] — [download/install link]

Knowledge & Training:
□ Completed [training/certification name]
□ Familiar with [prerequisite process / SOP-XXX]

Environment / Resources:
□ [Environment/resource] is available and [condition]
□ [Data/input] has been received from [source]

If any prerequisite is not met, STOP and contact [escalation contact]
before proceeding.
```

### Step 4: Step Writing

This is the core of the SOP. Every step must be unambiguous enough that a person encountering this process for the first time — with the stated skill level — can execute it without asking someone for help.

#### 4.1 — Action Verb Conventions

Every step begins with a clear action verb. Use these consistently:

| Verb | Meaning | Example |
|------|---------|---------|
| **Navigate** | Open or go to a location (URL, menu, file path) | Navigate to Settings > Integrations |
| **Enter** | Type or input a value | Enter the customer ID in the search field |
| **Select** | Choose from options (dropdown, radio, checkbox) | Select "Production" from the environment dropdown |
| **Click** | Press a specific UI element | Click the "Deploy" button |
| **Run** | Execute a command or script | Run `npm run build` in the project root |
| **Verify** | Confirm a condition is true before continuing | Verify the status shows "Ready" |
| **Wait** | Pause for a condition or duration | Wait for the build to complete (typically 3-5 minutes) |
| **Copy** | Duplicate text, files, or data | Copy the API key from the confirmation screen |
| **Review** | Examine output for correctness | Review the diff for unintended changes |
| **Notify** | Communicate to a person or channel | Notify #releases in Slack with the deployment summary |
| **Approve** | Grant authorization to proceed | Approve the pull request after reviewing changes |
| **Record** | Log information for audit or reference | Record the deployment ID in the release tracker |
| **Escalate** | Hand off to a higher authority | Escalate to the on-call engineer via PagerDuty |

#### 4.2 — Step Format

Use this format for every step. Scale detail to the audience skill level.

**For Novice audiences:**

```
5. PROCEDURE
━━━━━━━━━━━━

Step 1: [Action Verb] [What to do]
        [Detailed explanation of how to do it]
        Location: [Exact URL, path, or navigation instruction]
        Expected result: [What you should see after completing this step]
        Time estimate: ~[X] minutes
        ⚠️ Warning: [Common mistake or important note]

        [📸 Screenshot: description of what to capture]

        ✓ CHECKPOINT: [Verification — what confirms this step succeeded]
```

**For Intermediate audiences:**

```
Step 1: [Action Verb] [What to do]
        [Brief how-to with key details]
        Expected result: [What you should see]
        Time estimate: ~[X] minutes

        ✓ CHECKPOINT: [Verification]
```

**For Expert audiences:**

```
Step 1: [Action Verb] [What to do] (~[X] min)
        ✓ [Verification]
```

#### 4.3 — Decision Tree Notation

When a step requires a decision, use this branching format:

```
Step 4: Verify the build status

        ◆ DECISION: Did the build pass?
        │
        ├─ YES → Continue to Step 5
        │
        └─ NO → Go to Step 4a

Step 4a: Diagnose the build failure
         Run `npm run build 2>&1 | tail -50` to view the error output
         Expected result: Error message identifying the failure cause

         ◆ DECISION: Is the failure a known flaky test?
         │
         ├─ YES → Re-run the build (return to Step 3). If it fails
         │        a second time, treat as a real failure (go to NO path)
         │
         └─ NO → Escalate to the on-call engineer. Provide:
                  - Build URL
                  - Error output (last 50 lines)
                  - List of commits since last successful build
                  STOP — Do not proceed until the failure is resolved.
                  Go to Step 5 only after receiving confirmation.
```

#### 4.4 — Time Estimates

Include time estimates at both the step and total process level:

```
ESTIMATED DURATION
━━━━━━━━━━━━━━━━━━

Total process time: [X] minutes (typical) / [Y] minutes (worst case)

Breakdown:
  Steps 1-3  (Preparation):    ~[X] min
  Steps 4-8  (Execution):      ~[X] min
  Steps 9-10 (Verification):   ~[X] min
  Steps 11-12 (Communication): ~[X] min

Wait times (not included in active time):
  Build/deploy pipeline:        ~[X] min
  Approval from [role]:         ~[X] min (SLA: [Y] hours)
```

#### 4.5 — Verification Checkpoints

Insert checkpoints at critical junctures — not after every step, but after steps where failure would be costly or where the next step depends on the previous one completing correctly.

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ CHECKPOINT [N]: [Checkpoint Name]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Verify the following before proceeding:

□ [Condition 1 — specific, binary, verifiable]
□ [Condition 2 — specific, binary, verifiable]
□ [Condition 3 — specific, binary, verifiable]

If ANY condition is not met:
→ [Specific recovery action or escalation path]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Step 5: Exception Handling

Document what happens when things go wrong. This section transforms an SOP from "instructions for sunny days" into a reliable operational guide.

#### 5.1 — Common Failure Scenarios

```
6. EXCEPTION HANDLING
━━━━━━━━━━━━━━━━━━━━━

KNOWN FAILURE SCENARIOS
━━━━━━━━━━━━━━━━━━━━━━

| # | Failure Scenario         | Symptoms                    | Impact   | Resolution                              | Prevention          |
|---|--------------------------|-----------------------------|---------|-----------------------------------------|---------------------|
| F1 | [Failure name]          | [What you observe]          | [H/M/L] | [Step-by-step fix]                      | [How to avoid it]   |
| F2 | [Failure name]          | [What you observe]          | [H/M/L] | [Step-by-step fix]                      | [How to avoid it]   |
| F3 | [Failure name]          | [What you observe]          | [H/M/L] | [Step-by-step fix]                      | [How to avoid it]   |
```

#### 5.2 — Troubleshooting Decision Tree

```
TROUBLESHOOTING
━━━━━━━━━━━━━━━

Process did not complete successfully?

◆ Did the process fail at a specific step?
├─ YES → Note the step number
│   ◆ Is there a known failure scenario (F1-F[N]) that matches?
│   ├─ YES → Follow the resolution in the table above
│   └─ NO → Collect error details and escalate (see Escalation Paths below)
│
└─ NO (process completed but result is wrong)
    ◆ Is the output partially correct?
    ├─ YES → Identify which verification checkpoint failed.
    │        Re-execute from the step before that checkpoint.
    └─ NO → The process may have used incorrect inputs.
            Verify all prerequisites and inputs, then re-execute
            from Step 1. If it fails again, escalate.
```

#### 5.3 — Escalation Paths

```
ESCALATION PATHS
━━━━━━━━━━━━━━━━

| Severity | Condition                                     | Contact          | Method             | SLA            |
|----------|-----------------------------------------------|------------------|--------------------|----------------|
| P1       | Process failure blocks production/customers   | [On-call / Lead] | [PagerDuty/Phone]  | 15 minutes     |
| P2       | Process failure blocks team but not customers | [Team Lead]      | [Slack DM / Email] | 2 hours        |
| P3       | Process completes but with incorrect output   | [Process Owner]  | [Slack channel]    | 1 business day |
| P4       | Process improvement suggestion                | [Process Owner]  | [Ticket / Email]   | Next review    |

When escalating, always include:
1. SOP ID and version
2. Step number where the failure occurred
3. What you expected vs. what happened
4. Screenshots or logs if applicable
5. Actions already attempted
```

#### 5.4 — Rollback Procedures

```
ROLLBACK PROCEDURES
━━━━━━━━━━━━━━━━━━━

If this process must be reversed (partially or fully), follow these steps:

Rollback is possible: [Yes / No / Partial]
Rollback window:      [Time limit after which rollback is not possible]
Rollback authority:   [Who can authorize a rollback]

ROLLBACK STEPS:
1. [Action to reverse the most recent step]
2. [Action to reverse the step before that]
...
N. [Action to restore the original state]

ROLLBACK VERIFICATION:
□ [Condition confirming the system is back to its pre-process state]
□ [Condition confirming no data was lost or corrupted]

POST-ROLLBACK:
- Notify [stakeholders] that the process was rolled back
- Record the rollback reason in [tracking system]
- Schedule a review to address the root cause
```

### Step 6: Quality Assurance

An SOP that hasn't been tested by someone other than the author is a draft, not a procedure.

#### 6.1 — Review Process

```
7. QUALITY ASSURANCE
━━━━━━━━━━━━━━━━━━━━

REVIEW & APPROVAL WORKFLOW
━━━━━━━━━━━━━━━━━━━━━━━━━━

1. AUTHOR REVIEW
   Author completes the SOP and self-reviews against the SOP
   Quality Checklist (see below)

2. PEER REVIEW
   A second person familiar with the process reviews for:
   - Technical accuracy
   - Missing steps or assumptions
   - Clarity of language
   - Completeness of exception handling

3. NAIVE USER TEST
   A person who has NEVER performed this process follows
   the SOP step-by-step without assistance. Author observes
   but does not intervene unless safety is at risk.
   Record every point where the tester:
   - Asks a question (step is unclear)
   - Makes a mistake (step is ambiguous)
   - Gets stuck (step is missing information)
   - Skips a step (step seems unnecessary)

4. REVISION
   Incorporate findings from steps 2-3. Update version number.

5. APPROVAL
   Process Owner signs off on the final version.
   SOP is published to [document repository].
```

#### 6.2 — SOP Quality Checklist

```
SOP QUALITY CHECKLIST
━━━━━━━━━━━━━━━━━━━━

Completeness:
□ Every step begins with a clear action verb
□ No step requires undocumented tribal knowledge
□ All decision points have defined paths for each outcome
□ Prerequisites list every tool, access, and knowledge requirement
□ Exception handling covers the top [3-5] known failure modes
□ Rollback procedures exist for reversible processes
□ Time estimates are included at step and total level
□ RACI matrix accounts for every role involved

Clarity:
□ A person at the stated skill level can follow without help
□ No ambiguous pronouns ("it", "they", "that") without clear antecedents
□ Technical terms are defined or linked on first use
□ Screenshots or visual references are included where the UI is complex
□ Each step produces exactly one observable action or outcome

Accuracy:
□ Steps have been validated against the actual process (not memory)
□ System names, URLs, and paths are current and correct
□ Role names and contact information are current
□ Time estimates reflect actual measured execution times

Maintainability:
□ Version number and effective date are in the header
□ Revision history tracks all changes
□ Review date is scheduled
□ Process owner is clearly identified
□ Related SOPs are cross-referenced
```

#### 6.3 — Version Control & Review Cadence

```
VERSION CONTROL
━━━━━━━━━━━━━━

Numbering: [Major].[Minor]
  Major increment: Process flow changes, steps added/removed,
                   role changes, tool changes
  Minor increment: Clarifications, typo fixes, contact updates

Storage: [Document repository, wiki, shared drive — specify location]

SCHEDULED REVIEW CADENCE
━━━━━━━━━━━━━━━━━━━━━━━━

| Process Criticality | Review Frequency | Trigger for Unscheduled Review |
|--------------------|------------------|-------------------------------|
| Critical (P1 impact if wrong) | Quarterly | Any P1/P2 incident involving this process |
| Standard (daily/weekly use)   | Semi-annually | Tool change, role change, 3+ exceptions in a quarter |
| Low frequency (monthly+)      | Annually | Process failure, compliance audit finding |

Review checklist:
□ Walk through the process — does it still match reality?
□ Are all tools, URLs, and contacts current?
□ Have any steps been informally modified? Incorporate them.
□ Has the team or role structure changed?
□ Are there new failure modes to document?
□ Update effective date, version, and revision history.
```

### Step 7: Output

Assemble the complete SOP document from all sections above. Present it in markdown format ready for publication.

```
DOCUMENT ASSEMBLY ORDER
━━━━━━━━━━━━━━━━━━━━━━━

1. Document Header & Metadata (Section 3.1)
2. Revision History
3. Purpose & Scope (Section 3.2)
4. Roles & Responsibilities / RACI (Section 3.3)
5. Prerequisites, Tools & Access (Section 3.4)
6. Procedure — Step-by-Step (Section 4)
7. Exception Handling & Troubleshooting (Section 5)
8. Escalation Paths (Section 5.3)
9. Rollback Procedures (Section 5.4)
10. Appendices (reference tables, glossary, related SOPs)

APPENDICES TO INCLUDE:
A. Glossary of Terms (if technical jargon is used)
B. Related SOPs Cross-Reference
C. Change Log Template (for proposing SOP updates)
D. Quick Reference Card (1-page checklist version for experienced users)
```

After presenting the SOP, offer:

> "Want me to adjust the detail level, add more exception scenarios, generate a quick-reference checklist, or create a training walkthrough based on this SOP?"

---

## Complete SOP Template

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
         STANDARD OPERATING PROCEDURE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Title:          [Process Name]
SOP ID:         SOP-[DEPT]-[NNN]
Version:        1.0
Effective Date: [YYYY-MM-DD]
Review Date:    [YYYY-MM-DD]

Process Owner:  [Name / Role]
Department:     [Department / Team]
Classification: [Public | Internal | Confidential | Restricted]

Approved By:    [Name / Role]           Date: [YYYY-MM-DD]
Reviewed By:    [Name / Role]           Date: [YYYY-MM-DD]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
REVISION HISTORY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
| Version | Date       | Author      | Changes               |
|---------|------------|-------------|-----------------------|
| 1.0     | [Date]     | [Author]    | Initial release       |
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. PURPOSE
━━━━━━━━━━

This procedure defines the standardized process for [process name].
It ensures [primary benefit] and provides [secondary benefit]
for [department/team].

2. SCOPE
━━━━━━━━

Applies to:     [Roles / teams / departments]
Covers:         [Activities and scenarios included]
Does NOT cover: [Explicit exclusions]
Frequency:      [Execution frequency]
Trigger:        [Initiating event]
End State:      [Measurable completion criteria]

3. ROLES & RESPONSIBILITIES
━━━━━━━━━━━━━━━━━━━━━━━━━━━

| Activity          | [Role A] | [Role B] | [Role C] |
|-------------------|----------|----------|----------|
| [Activity 1]      | R        | A        |          |
| [Activity 2]      |          | R        | A        |
| [Activity 3]      | R        |          | I        |

R = Responsible | A = Accountable | C = Consulted | I = Informed

Key Contacts:
- Process Owner:      [Name], [contact]
- Escalation Contact: [Name], [contact]

4. PREREQUISITES
━━━━━━━━━━━━━━━━

Before starting, verify ALL of the following:

Access & Permissions:
□ [Requirement 1]
□ [Requirement 2]

Tools & Software:
□ [Requirement 1]
□ [Requirement 2]

Knowledge:
□ [Requirement 1]

If any prerequisite is not met, STOP and contact [contact].

5. PROCEDURE
━━━━━━━━━━━━

Estimated total time: [X] minutes (typical) / [Y] minutes (worst case)

Step 1: [Action verb] [What to do]
        [How to do it]
        Expected result: [What you should see]
        Time estimate: ~[X] min

Step 2: [Action verb] [What to do]
        [How to do it]
        Expected result: [What you should see]
        Time estimate: ~[X] min

        ◆ DECISION: [Condition to evaluate]
        ├─ YES → Continue to Step 3
        └─ NO  → [Alternative action or escalation]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ CHECKPOINT 1: [Checkpoint Name]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
□ [Verification 1]
□ [Verification 2]
If not met → [Recovery action]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Step 3: [Action verb] [What to do]
        [How to do it]
        Expected result: [What you should see]
        Time estimate: ~[X] min

[Continue steps as needed...]

Step N: [Final action verb] [Final step]
        Expected result: [End state achieved]

6. EXCEPTION HANDLING
━━━━━━━━━━━━━━━━━━━━━

| # | Failure Scenario | Symptoms | Impact | Resolution |
|---|-----------------|----------|--------|------------|
| F1 | [Scenario] | [Symptoms] | [H/M/L] | [Fix] |
| F2 | [Scenario] | [Symptoms] | [H/M/L] | [Fix] |

7. ESCALATION PATHS
━━━━━━━━━━━━━━━━━━━

| Severity | Condition | Contact | Method | SLA |
|----------|-----------|---------|--------|-----|
| P1 | [Blocks production] | [Contact] | [Method] | 15 min |
| P2 | [Blocks team] | [Contact] | [Method] | 2 hours |
| P3 | [Incorrect output] | [Contact] | [Method] | 1 day |

8. ROLLBACK
━━━━━━━━━━━

Rollback possible: [Yes / No / Partial]
Rollback window:   [Time limit]
Rollback authority: [Who authorizes]

Steps:
1. [Reverse action]
2. [Reverse action]

Verification:
□ [System back to pre-process state]

APPENDIX A: GLOSSARY
━━━━━━━━━━━━━━━━━━━━

| Term | Definition |
|------|-----------|
| [Term] | [Definition] |

APPENDIX B: RELATED SOPs
━━━━━━━━━━━━━━━━━━━━━━━━

| SOP ID | Title | Relationship |
|--------|-------|-------------|
| SOP-XXX-NNN | [Title] | [Upstream / Downstream / Related] |

APPENDIX C: QUICK REFERENCE CARD
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1-page condensed checklist version for experienced users]

□ Step 1: [Brief action]
□ Step 2: [Brief action]
  ◆ [Decision]: YES → Step 3 / NO → [Alt]
□ Step 3: [Brief action]
...
□ Step N: [Brief action]
□ Verify: [End state]
□ Notify: [Stakeholders]
```

---

## Example SOP: Production Release Deployment

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
         STANDARD OPERATING PROCEDURE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Title:          Production Release Deployment
SOP ID:         SOP-ENG-001
Version:        1.0
Effective Date: 2026-03-29
Review Date:    2026-06-29

Process Owner:  Lead Engineer
Department:     Engineering
Classification: Internal

Approved By:    VP of Engineering        Date: 2026-03-29
Reviewed By:    Senior SRE               Date: 2026-03-28

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
REVISION HISTORY
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
| Version | Date       | Author        | Changes               |
|---------|------------|---------------|-----------------------|
| 1.0     | 2026-03-29 | Lead Engineer | Initial release       |
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. PURPOSE
━━━━━━━━━━

This procedure defines the standardized process for deploying
code releases to the production environment. It ensures consistent,
repeatable deployments with rollback capability and provides an
audit trail for compliance and incident investigation.

2. SCOPE
━━━━━━━━

Applies to:     Release Engineers, Senior Developers, SRE team
Covers:         Scheduled production deployments of the main application
Does NOT cover: Hotfixes (see SOP-ENG-002), infrastructure changes
                (see SOP-OPS-004), database migrations (see SOP-ENG-005)
Frequency:      Weekly (Tuesdays and Thursdays, 10:00-12:00 ET)
Trigger:        Release branch passes all CI checks and has PM sign-off
End State:      New version running in production, health checks passing,
                release notes published, stakeholders notified

3. ROLES & RESPONSIBILITIES
━━━━━━━━━━━━━━━━━━━━━━━━━━━

| Activity                | Release Eng | Tech Lead | SRE   | PM    |
|-------------------------|-------------|-----------|-------|-------|
| Verify CI pipeline      | R           | I         |       |       |
| Approve release         |             | A         |       | C     |
| Execute deployment      | R           |           | C     |       |
| Monitor post-deploy     | R           |           | R     |       |
| Authorize rollback      |             | A         | R     | I     |
| Publish release notes   | R           |           |       | A     |
| Notify stakeholders     | R           |           |       | I     |

R = Responsible | A = Accountable | C = Consulted | I = Informed

Key Contacts:
- Release Engineer (on rotation):  #releases in Slack
- SRE On-Call:                     PagerDuty "SRE Primary"
- Tech Lead:                       @tech-lead in Slack

4. PREREQUISITES
━━━━━━━━━━━━━━━━

Before starting, verify ALL of the following:

Access & Permissions:
□ SSH access to deployment bastion host
□ Write access to the production deployment pipeline (GitHub Actions)
□ Access to monitoring dashboards (Datadog / Grafana)
□ Member of #releases Slack channel

Tools & Software:
□ GitHub CLI (gh) installed and authenticated
□ kubectl configured with production cluster context
□ Datadog/Grafana dashboard bookmarked

Knowledge:
□ Completed "Production Access Onboarding" training
□ Read SOP-ENG-003 (Incident Response) — you may need it

Environment:
□ Current deployment window (Tue/Thu 10:00-12:00 ET)
□ No active P1/P2 incidents (check #incidents)
□ Release branch has green CI status on all required checks
□ PM has approved the release scope in the release ticket

If any prerequisite is not met, STOP and post in #releases.

5. PROCEDURE
━━━━━━━━━━━━

Estimated total time: 25 minutes (typical) / 60 minutes (worst case)

Step 1: Verify the release branch status (~2 min)
        Navigate to the repository on GitHub.
        Select the release branch (e.g., release/v2.4.1).
        Verify all CI checks show green (passed).
        Expected result: All required status checks show ✓

        ◆ DECISION: Are all CI checks green?
        ├─ YES → Continue to Step 2
        └─ NO  → STOP. Notify the team in #releases.
                 Do not proceed until all checks pass.

Step 2: Confirm the deployment window (~1 min)
        Check #incidents in Slack for any active P1/P2 incidents.
        Verify current time is within the deployment window.
        Expected result: No active incidents, within window

        ◆ DECISION: Is the deployment window clear?
        ├─ YES → Continue to Step 3
        └─ NO  → Postpone to the next deployment window.
                 Notify PM and Tech Lead of the delay.

Step 3: Create the production deployment tag (~2 min)
        Run: git tag -a v[X.Y.Z] -m "Release v[X.Y.Z]"
        Run: git push origin v[X.Y.Z]
        Expected result: Tag appears on GitHub, deployment
                         pipeline triggers automatically

Step 4: Monitor the deployment pipeline (~10 min)
        Navigate to GitHub Actions > "Production Deploy" workflow.
        Watch the pipeline progress through stages:
          Build → Test → Stage → Canary → Full rollout
        Expected result: All stages complete with green status.
        Time estimate: Pipeline runs 8-12 minutes.

        ◆ DECISION: Did the pipeline complete successfully?
        ├─ YES → Continue to Step 5
        └─ NO  → Go to Step 4a

Step 4a: Diagnose pipeline failure
         Click on the failed stage to view logs.
         Copy the last 50 lines of the error output.

         ◆ DECISION: Is this a known transient failure (flaky test,
                      timeout, rate limit)?
         ├─ YES → Re-run the failed job. If it fails again,
         │        treat as a real failure (go to NO path).
         └─ NO  → Initiate rollback (see Section 8).
                  Escalate to SRE On-Call.
                  STOP — do not continue.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ CHECKPOINT 1: Deployment Verification
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
□ New version tag visible in production cluster
□ Canary instance health checks passing
□ No increase in error rate on monitoring dashboard
□ No alerts triggered in PagerDuty

If any condition is not met → Initiate rollback (Section 8)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Step 5: Validate production health (~5 min)
        Navigate to the monitoring dashboard.
        Compare error rates, latency, and throughput to the
        pre-deployment baseline (last 1 hour).
        Check: Error rate has not increased by more than 0.1%.
        Check: P99 latency has not increased by more than 50ms.
        Check: No new error types appearing in logs.
        Expected result: All metrics within acceptable thresholds

        ◆ DECISION: Are all health metrics within thresholds?
        ├─ YES → Continue to Step 6
        └─ NO  → Monitor for 5 more minutes.
                 If metrics do not recover, initiate rollback
                 (Section 8).

Step 6: Publish release notes (~3 min)
        Navigate to GitHub Releases.
        Click "Draft a new release."
        Select tag v[X.Y.Z].
        Enter the changelog (auto-generated from PR titles).
        Review and clean up the changelog for readability.
        Click "Publish release."
        Expected result: Release is visible on the Releases page

Step 7: Notify stakeholders (~2 min)
        Post in #releases:
          "✅ v[X.Y.Z] deployed to production.
           Release notes: [link]
           No issues detected. Monitoring for 30 min."
        Post in #general (if user-facing changes):
          "New release v[X.Y.Z] is live — [1-sentence summary]"
        Expected result: Messages posted, no questions or concerns

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✓ CHECKPOINT 2: Post-Deploy Confirmation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
□ Release notes published on GitHub
□ #releases notification posted
□ No P1/P2 alerts in the 10 minutes since deploy
□ Deployment recorded in the release tracker

If any condition is not met → Address before closing
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Step 8: Record the deployment (~1 min)
        Update the release tracker spreadsheet/ticket:
          - Version deployed
          - Deployment time
          - Deployer name
          - Status: Success / Rolled Back
        Close the release ticket.
        Expected result: Audit trail complete

6. EXCEPTION HANDLING
━━━━━━━━━━━━━━━━━━━━━

| # | Failure Scenario | Symptoms | Impact | Resolution |
|---|-----------------|----------|--------|------------|
| F1 | Canary health check fails | Canary pod CrashLoopBackOff | H | Auto-rollback triggers. Verify rollback completed. Investigate logs. |
| F2 | Error rate spike post-deploy | Error rate > 0.5% above baseline | H | Initiate manual rollback. Page SRE On-Call. |
| F3 | Pipeline timeout | Deploy stage exceeds 15 min | M | Check cluster resources. Re-run once. If repeated, check node capacity. |
| F4 | Tag already exists | git push rejected | L | Verify correct version number. Delete erroneous tag if unreleased. |
| F5 | Monitoring dashboard unreachable | Datadog/Grafana returns 5xx | M | Use kubectl to check pod status directly. Proceed with caution. |

7. ESCALATION PATHS
━━━━━━━━━━━━━━━━━━━

| Severity | Condition | Contact | Method | SLA |
|----------|-----------|---------|--------|-----|
| P1 | Production down or data loss | SRE On-Call | PagerDuty | 15 min |
| P2 | Degraded service, errors > 1% | SRE On-Call | Slack DM | 30 min |
| P3 | Minor issues, no user impact | Tech Lead | #releases | 2 hours |
| P4 | Process improvement | Lead Engineer | Release retro | Next sprint |

8. ROLLBACK
━━━━━━━━━━━

Rollback possible: Yes
Rollback window:   24 hours (after which data migrations may be irreversible)
Rollback authority: Tech Lead or SRE On-Call

Steps:
1. Run: kubectl rollout undo deployment/app -n production
2. Verify: kubectl rollout status deployment/app -n production
3. Wait for health checks to pass (~2 minutes)
4. Verify error rate returns to baseline on monitoring dashboard
5. Post in #releases: "⚠️ v[X.Y.Z] rolled back. Investigating."
6. Page SRE On-Call if not already engaged

Verification:
□ Previous version running (check /health endpoint version field)
□ Error rate returned to pre-deploy baseline
□ No data inconsistencies reported

Post-Rollback:
- Record rollback in release tracker with reason
- Schedule post-mortem within 24 hours
- Do not re-attempt deployment until root cause is identified

APPENDIX A: GLOSSARY
━━━━━━━━━━━━━━━━━━━━

| Term | Definition |
|------|-----------|
| Canary | A single instance running new code, receiving a fraction of traffic |
| Bastion host | A secured jump server used to access production infrastructure |
| P99 latency | The latency at the 99th percentile — 99% of requests are faster |
| CrashLoopBackOff | Kubernetes status indicating a pod is repeatedly crashing |

APPENDIX B: RELATED SOPs
━━━━━━━━━━━━━━━━━━━━━━━━

| SOP ID | Title | Relationship |
|--------|-------|-------------|
| SOP-ENG-002 | Hotfix Deployment | Emergency variant of this process |
| SOP-ENG-003 | Incident Response | Activated if deploy causes an incident |
| SOP-ENG-005 | Database Migration | Must complete before deploy if migrations exist |
| SOP-OPS-004 | Infrastructure Changes | Separate process for infra-level changes |

APPENDIX C: QUICK REFERENCE CARD
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

□ Verify: CI green, no incidents, in deploy window
□ Tag: git tag -a v[X.Y.Z] && git push origin v[X.Y.Z]
□ Monitor: Watch pipeline through Build → Test → Stage → Canary → Full
□ Validate: Error rate, latency, logs on dashboard
□ Publish: GitHub release notes
□ Notify: #releases and #general (if user-facing)
□ Record: Update release tracker, close ticket
□ Rollback: kubectl rollout undo deployment/app -n production
```

---

## Anti-Patterns

| Do NOT | Do Instead |
|--------|------------|
| Write steps from memory without validating against the actual process | Observe or walk through the process in real-time, then document |
| Use vague verbs like "handle", "process", "manage", "deal with" | Use specific action verbs: Navigate, Enter, Run, Verify, Click |
| Write "contact the team" without specifying who, how, and when | Name the role, the contact method, and the expected response time |
| Skip the exception handling section for "simple" processes | Every process fails eventually — document the top 3-5 failure modes |
| Assume the reader has tribal knowledge | Write for the person's first day — if they need context, provide it |
| Document only the happy path | Every decision point needs both YES and NO paths documented |
| Write a 30-page SOP for a 5-step process | Scale depth to complexity — a quick-reference card may be enough |
| Use screenshots without text descriptions | Screenshots become outdated; text descriptions survive UI changes |
| Create an SOP and never review it again | Set a review cadence and stick to it — stale SOPs are worse than none |
| Let the author be the only reviewer | The naive user test catches 80% of clarity issues the author cannot see |
| Write steps that combine multiple actions | One step = one action. "Log in and navigate to settings and update the config" is three steps. |
| Use conditional language without decision tree notation | "If applicable, you may want to..." → use ◆ DECISION with explicit paths |
| Skip the rollback section because "we'll figure it out" | The middle of a production outage is not the time to figure out rollback |
| Store the SOP only in someone's personal drive | SOPs belong in a shared, version-controlled, searchable repository |

**SOP Length Guidelines:**

| Process Complexity | SOP Length | Focus Areas |
|-------------------|-----------|-------------|
| Simple (< 10 steps, no decisions) | 1-3 pages | Procedure, prerequisites, quick reference card |
| Moderate (10-25 steps, 2-3 decisions) | 3-8 pages | Full SOP with RACI, exceptions, checkpoints |
| Complex (25+ steps, multiple roles, branching) | 8-15 pages | Full SOP with swim lanes, decision trees, detailed rollback |
| Critical (compliance, safety, financial) | 15-30 pages | Full SOP with audit trail, compliance mapping, training requirements |

## Escalation

| Situation | Action |
|-----------|--------|
| SME is unavailable for process discovery | Document what you know, mark gaps with `[NEEDS SME INPUT: specific question]`, and proceed. A partial SOP is better than waiting indefinitely. Schedule a follow-up. |
| Multiple people do the process differently | Document all variants. Have the process owner choose the canonical version. Note alternatives in an appendix if they serve different valid use cases. |
| Process has no single owner | Escalate to the department manager. Every SOP must have exactly one process owner. Shared ownership means no ownership. |
| Process is too complex to document in one SOP | Break it into sub-processes. Each sub-process gets its own SOP. The parent SOP references them (e.g., "For database migration steps, see SOP-ENG-005"). |
| Stakeholders disagree on the correct process | Facilitate a process alignment session. Document the agreed version. If no agreement is reached, the process owner makes the final call. |
| The SOP keeps getting out of date | Shorten the review cadence. Assign a specific person (not "the team") to review. Tie SOP review to an existing ceremony (sprint retro, quarterly planning). |
| Compliance requires specific SOP formatting | Adapt the template to meet regulatory requirements first — content structure is secondary to compliance acceptance. Add required fields (e.g., training acknowledgment signatures, regulatory references). |
| Process involves sensitive data or credentials | Never document actual credentials in the SOP. Reference the secret manager or vault. Write: "Retrieve the API key from [vault name] > [path]" not "The API key is abc123." |
| Nobody follows the SOP | Investigate why: too long, outdated, hard to find, or missing from the workflow. Fix the root cause. Consider embedding the SOP as a checklist in the tool itself (e.g., a GitHub issue template, a Jira workflow). |

## Inputs

- Process name and description
- Process owner (name and role)
- Department or team
- Trigger event (what initiates the process)
- End state (measurable completion criteria)
- Audience skill level (novice, intermediate, expert)
- Tools, systems, and platforms involved
- Compliance or regulatory requirements
- Frequency of process execution
- Known failure modes and pain points
- Related SOPs or documentation
- Stakeholder and role information
- SLA or time constraints
- SME interview notes or process observation data

## Outputs

- Complete SOP document in markdown with all sections
- Document header with metadata, version, and approval fields
- Revision history table
- Purpose and scope statement with explicit exclusions
- RACI matrix for all roles involved
- Prerequisites checklist (access, tools, knowledge, environment)
- Step-by-step procedure with action verbs and time estimates
- Decision tree notation for all branching logic
- Verification checkpoints at critical junctures
- Exception handling table with known failure scenarios
- Troubleshooting decision tree
- Escalation paths with severity levels, contacts, and SLAs
- Rollback procedures with verification steps
- SOP quality checklist for review
- Version control and review cadence guidelines
- Appendices: glossary, related SOPs, quick reference card
- Process discovery interview template (when building from scratch)
- Process map with swim lane identification

## Level History

- **Lv.1** — Base: 7-step SOP protocol covering input gathering (process name, owner, trigger, end state, department, audience skill level, tools, compliance, frequency, pain points), process discovery (SME interview template with 21 questions across 5 categories, process mapping with swim lanes, decision point inventory, role identification), SOP structure (document header with metadata and revision history, purpose and scope with explicit exclusions, RACI matrix, prerequisites checklist across 4 categories), step writing (action verb conventions table with 13 standardized verbs, three detail levels for novice/intermediate/expert audiences, decision tree notation with branching format, time estimates at step and total level, verification checkpoints with recovery actions), exception handling (failure scenario table with symptoms/impact/resolution/prevention, troubleshooting decision tree, escalation paths with severity-based SLAs, rollback procedures with verification and post-rollback actions), quality assurance (4-step review workflow including naive user test, SOP quality checklist with 16 items across completeness/clarity/accuracy/maintainability, version control numbering scheme, review cadence by process criticality), output assembly (10-section document assembly order, appendices for glossary/related SOPs/quick reference card). Complete SOP template ready for population, full example SOP for production release deployment (8 procedure steps, 5 failure scenarios, rollback procedure, 4 appendices). Anti-patterns table with 14 entries, SOP length guidelines by complexity, escalation guide for 9 scenarios. (Origin: MemStack v3.2, Mar 2026)
