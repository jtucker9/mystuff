---
name: client-onboarding
description: "Generate a structured client onboarding system — welcome sequence, intake questionnaire, access provisioning, kickoff agenda, and communication protocol. WHEN: 'client onboarding', 'new client', 'onboard client', 'welcome client', 'kickoff'. NOT: contract drafting (contract-template), invoicing (invoice-generator), internal team onboarding."
---

# Client Onboarding — New Client Setup System

## Activation

| Context | Status |
|---------|--------|
| User says "client onboarding", "new client", "onboard client" | ACTIVE |
| User wants to set up a new client engagement or kickoff | ACTIVE |
| User mentions intake form, welcome email, or onboarding process | ACTIVE |
| User wants to draft a contract | DORMANT — see contract-template |
| User wants to send an invoice | DORMANT — see invoice-generator |
| User wants internal/employee onboarding | DORMANT — not this skill |

## Instructions

### Step 1: Gather Inputs

Collect before proceeding:
- **Service type**: web dev, consulting, design, marketing, SaaS, other
- **Client tier**: standard or premium (affects cadence, touch points)
- **Duration**: one-time project or ongoing retainer
- **Tools**: platforms client needs access to (GitHub, Figma, Slack, etc.)
- **Team**: solo or team — who is client-facing?
- **Existing process**: any current steps to preserve

**Gate**: All six inputs confirmed. If client tier is unknown, default to standard.

### Step 2: Design Welcome Email Sequence

Generate 4-email sequence — subject lines, key content points, and timing. Do NOT output full email bodies; output structured outlines the user fills in.

| Email | Timing | Purpose | Must Include |
|-------|--------|---------|--------------|
| Welcome | Day 0 (post-sign) | Set expectations | Point of contact, response time SLA, next 3 steps |
| Intake | Day 0 (with welcome) | Gather info | Link to questionnaire, 48hr deadline, section preview |
| Access & Setup | Day 1-2 | Tool access | Credentials/invites, kickoff date/link, agenda preview |
| Post-Kickoff | Day 3-5 | Confirm alignment | Key decisions, action items with owners+dates, milestone timeline |

**Gate**: Sequence covers all 4 phases. Each email has a clear CTA.

### Step 3: Create Intake Questionnaire

Structure into 4 sections — output category headings with 3-5 key questions each:

1. **Project Overview**: goals, success metrics, audience, hard deadlines, competitor examples
2. **Brand & Assets**: brand guidelines, logo files, colors/fonts, tone of voice, existing content
3. **Technical Access**: domain/hosting credentials, CMS access, analytics accounts, API keys, repo access
4. **Communication Preferences**: preferred channel, meeting availability + timezone, decision-maker, approval chain, update frequency

**Gate**: All 4 sections present. Technical section includes secure credential sharing instruction (never plain email).

### Step 4: Build Access Provisioning Checklist

Generate a tool access table from the tools listed in Step 1. Each row: tool name, purpose, access type (invite/credentials/API key), status placeholder.

Decision rules:
- If tool involves credentials: add "share via password manager or encrypted channel" note
- If tool has role-based access: specify minimum required role (prefer viewer/editor over admin)
- If client needs to grant access TO you: include brief "how to grant" instruction per tool

**Gate**: Every tool from Step 1 appears in the checklist. Secure sharing method specified.

### Step 5: Structure Kickoff Meeting

60-minute agenda with time blocks:

| Block | Duration | Content |
|-------|----------|---------|
| Introductions | 5 min | Roles, decision authority |
| Project Overview | 10 min | Goals, scope confirmation, open questions |
| Timeline & Milestones | 10 min | Phases, key dates, client dependencies |
| Communication & Process | 10 min | Channels, cadence, feedback/approval process, change orders |
| Technical Discussion | 15 min | Requirements, tool access status, integrations, risks |
| Q&A | 5 min | Open floor |
| Next Steps | 5 min | Action items with owners + dates, next meeting |

**Gate**: Agenda totals 60 min. Every block has an owner (you or client).

### Step 6: Define Communication Protocol

Output a protocol covering:

- **Channels**: primary (Slack/email), urgent (phone — emergencies only), meetings, documents, files
- **Response times**: email (4-8 biz hrs), chat (2-4 biz hrs), urgent (1 hr during biz hours)
- **Meeting cadence**: weekly standup (15 min, async option), bi-weekly review (30 min), monthly retro (retainer only)
- **Feedback process**: deliverable shared, 48hr review window, one revision round included, additional rounds at stated rate
- **Escalation ladder**: project lead, account manager, owner — with contact method for each
- **Status updates**: frequency, format (email/Slack/dashboard), content (done, next, blockers)

Decision rules:
- Retainer clients: monthly retro + dashboard access
- One-time projects: skip monthly retro, weekly updates only
- Premium tier: halve all response times

**Gate**: Cadence rules match project duration. Escalation has 2+ levels.

### Step 7: Compile and Output

Present the complete onboarding package as a structured summary referencing all prior steps. Include an onboarding timeline:

- Day 0: Contract signed, welcome + intake emails sent
- Day 0-2: Questionnaire completed, access granted
- Day 3-5: Kickoff meeting
- Day 5-7: Project environment fully set up
- Week 2: First deliverable/milestone

### Red Flag Detection

Flag and surface to user if any of these appear during onboarding:
- Client cannot identify a single decision-maker
- Questionnaire not returned within 72 hours (escalate)
- Client insists on insecure credential sharing
- Scope discussed at kickoff contradicts signed contract
- Client requests work begin before access is provisioned
- Multiple stakeholders with conflicting authority

## Examples

**Example 1 — Solo web dev, one-time project**
Inputs: web dev, standard tier, 6-week project, GitHub + Figma + Vercel, solo.
Output: 4-email sequence (standard timing), intake with all 4 sections, 3-tool access checklist, 60-min kickoff, weekly email updates, no monthly retro.

**Example 2 — Agency, premium retainer**
Inputs: marketing, premium tier, ongoing retainer, Slack + GA4 + Meta Ads + Notion, 3-person team.
Output: 4-email sequence (halved response SLAs), intake emphasizing brand/content sections, 4-tool checklist with role assignments, 60-min kickoff, bi-weekly review + monthly retro + shared dashboard, full escalation ladder.

## Common Issues

1. **Client never completes questionnaire**: Send reminder at 48hr. At 72hr, schedule a call to fill it out together. If still blocked, flag as red flag — project timeline slips.
2. **Credential sharing over plain email**: Redirect immediately to password manager or encrypted channel. Never proceed with plaintext credentials.
3. **Scope creep at kickoff**: If kickoff discussion reveals scope beyond the signed agreement, pause and document. Do not absorb — route to change order process.

## Anti-Patterns

- Sending all 4 emails at once (overwhelms client — respect the timing cadence)
- Granting admin access when viewer/editor suffices
- Starting work before intake questionnaire is returned
- Skipping kickoff for "simple" projects (alignment issues surface later)
- Using the same onboarding flow for one-time projects and retainers

## Escalation

- Questionnaire blocked >72hr with no response: escalate to account manager, consider project start delay
- Client refuses secure credential sharing: escalate to project lead, document risk in writing
- Conflicting stakeholder authority: pause onboarding, require client to designate single decision-maker before kickoff

## Inputs

- Service type and client tier
- Project duration and scope
- Tools and platforms used
- Team structure and roles
- Existing onboarding process (optional)

## Outputs

- 4-email welcome sequence (structured outlines, not full templates)
- 4-section intake questionnaire
- Tool/platform access checklist with secure sharing method
- 60-minute kickoff meeting agenda
- Communication protocol (channels, response times, escalation)
- Onboarding timeline (Day 0 through Week 2)

## Level History

- **Lv.1** — Base: 4-email welcome sequence, 4-section intake questionnaire, tool access checklist with secure credential sharing, 60-min kickoff agenda, communication protocol with escalation ladder, project setup checklist, onboarding timeline. (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** — Compressed: Creator-level density rewrite — decision rules only, no full templates, added red flag detection, anti-patterns, escalation paths, validation gates between steps, tier-aware cadence rules. (Origin: MemStack v3.2, Mar 2026)
