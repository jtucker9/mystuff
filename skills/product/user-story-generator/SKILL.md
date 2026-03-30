---
name: user-story-generator
description: "Use when the user says 'user stories', 'write stories', 'backlog', 'story generator', 'acceptance criteria', 'sprint planning', or needs structured user stories for project management tools. Do NOT use for full PRDs (see prd-writer), detailed single-feature specs (see feature-spec), or product roadmaps (see roadmap-builder)."
---

# User Story Generator -- Backlog-Ready Story Builder

*Generate prioritized user stories with acceptance criteria, story points, and epic groupings ready for Jira, Linear, or GitHub Projects.*

## Activation

When this skill activates, output:

`User Story Generator -- Building your story backlog...`

| Context | Status |
|---------|--------|
| **User says "user stories", "write stories", "backlog"** | ACTIVE |
| **User needs stories for sprint planning** | ACTIVE |
| **User wants acceptance criteria in Given/When/Then** | ACTIVE |
| **User wants a full PRD (stories are one section)** | DORMANT -- see prd-writer |
| **User wants a detailed spec for ONE feature** | DORMANT -- see feature-spec |

## Instructions

### Step 1: Gather Inputs

Ask the user for:
- **Product/feature context**: What are we writing stories for?
- **User types**: Who are the different users? (admin, end user, viewer, etc.)
- **Scope**: Full product backlog or specific feature area?
- **Sprint duration**: 1 week or 2 weeks? (for story point calibration)
- **Existing context** (optional): PRD, wireframes, feature list

**Gate**: Must have product context and at least one user type before proceeding.

### Step 2: Define Personas

Brief card per user type: name, role, primary goal, usage context, tech level (low/med/high).

### Step 3: Generate Stories

For each persona, generate stories grouped by functional area. Rules:
- Action must be specific and observable ("filter results by date" not "have better search")
- Benefit must explain WHY, not restate the action
- One story = one testable behavior
- If a story needs "and" in the action, split it

**Gate**: Every story must reference a defined persona. No "As a user" -- use the specific persona name/role.

### Step 4: Acceptance Criteria

2-4 criteria per story in Given/When/Then format. Must cover: happy path, at least one edge case, at least one error condition.

### Step 5: MoSCoW Priority

Assign each story: Must (product does not work without it), Should (important but has workaround), Could (enhances experience), Won't (deferred).

**Gate**: If > 50% of stories are "Must", re-evaluate. A backlog where everything is critical means nothing is prioritized.

### Step 6: Story Point Estimates

Fibonacci scale (1, 2, 3, 5, 8, 13). Flag any story at 13+ for breakdown into smaller stories.

### Step 7: Group into Epics

Organize into epics (13-40 points each, roughly 1-2 sprints). Each epic: description, total points, story count, ordered story list with priority and points.

### Step 8: Dependencies and Sprint Loading

Map blocking relationships between stories. Flag circular dependencies as risks. Suggest sprint loading: Sprint 1 = foundation stories, Sprint 2 = core features, Sprint 3 = enhancements.

### Step 9: Assemble Output

Sections: Personas, Epics with stories/AC/priority/points, Dependencies, Sprint Suggestion, CSV Export (Epic, Story ID, Title, Description, Priority, Points, AC -- for Jira/Linear/GitHub import).

## Examples

**Example 1 -- E-commerce feature**:
User: "User stories for a product review system." Output: 2 personas (buyer, store admin), 3 epics (Submit Review, Moderate Reviews, Display Reviews), 14 stories, 42 total points. Sprint 1: data model + submit flow (13 pts). Sprint 2: moderation queue + display (16 pts). Sprint 3: sorting, filtering, helpful votes (13 pts).

**Example 2 -- Internal tool**:
User: "Stories for an employee time-off request system." Output: 3 personas (employee, manager, HR admin), 2 epics (Request Flow, Admin Management), 9 stories, 28 points. Key dependency: manager approval flow blocks HR reporting.

## Common Issues

- **Stories that are tasks, not user value**: "Set up database" is a task. "As a user, I want my data saved so I can return to my work" is a story. Every story must deliver user-visible value.
- **Missing error-path acceptance criteria**: If AC only covers the happy path, the developer does not know how to handle failures. Every story needs at least one error AC.
- **Epic bloat**: Epics over 40 points should be split. An epic that spans 3+ sprints loses its value as a planning unit.

## Anti-Patterns

- Writing "As a user" instead of a specific persona
- Combining multiple behaviors in one story ("and" in the action)
- Acceptance criteria that are not testable ("should work well")
- Estimating all stories as 3 or 5 points without differentiation
- Skipping the dependency map and discovering blockers mid-sprint
- Building a backlog without export format for the team's project management tool

## Level History

- **Lv.1** -- Base: Persona-grouped story generation, Given/When/Then acceptance criteria, MoSCoW prioritization, Fibonacci story point estimation, epic groupings, dependency mapping with sprint loading, CSV export format for tool import. (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** -- Guide compliance: Added negative triggers, validation gates, Examples, Common Issues, Anti-Patterns. Compressed from 213 to <200 lines. (Origin: MemStack v3.3, Mar 2026)
