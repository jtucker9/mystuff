---
name: familiar
description: "Use when the user says 'dispatch', 'send familiar', 'split task', or needs work split across parallel CC sessions. Do NOT use for single-step tasks, sequential work that cannot parallelize, or simple questions."
---

# Familiar -- Dispatching Sub-Agents

Break large tasks into coordinated CC session prompts for parallel execution.

## Activation

When this skill activates, output:

`Familiar -- Dispatching sub-agents...`

Then execute the instructions below.

## Instructions

1. **Analyze the task** -- identify independent sub-tasks that can run in parallel
2. **Determine session count** -- split into 2-6 sessions based on complexity
3. **For each sub-task, generate a complete CC prompt** that includes:
   - Working directory path
   - Full task description with acceptance criteria
   - Any shared context (database schema, API contracts, types)
   - MemStack activation line: `Read C:\Projects\memstack\MEMSTACK.md`
   - CC Monitor reporting snippet (if configured in config.json)
4. **Add coordination notes** -- specify what each session should NOT touch to avoid conflicts
5. **Define merge order** -- which session's work should be committed first

## Inputs

- The large task description
- Project directory from config.json
- Number of available CC sessions (default: 3)

## Outputs

- Numbered list of sub-task prompts, each ready to paste into a new CC session
- Coordination notes explaining dependencies and merge order

## Examples

**Dispatch for full-stack feature:**
User: "dispatch -- build analytics dashboard, API routes, and migration" -> 3 sessions: DB/types, API routes, frontend page. Merge order: 1 -> 2 -> 3.

**Dispatch for content batch:**
User: "send familiar -- write 5 blog posts from these outlines" -> 5 sessions, one per post. No merge conflicts, parallel merge.

## Common Issues

- **Sessions edit the same file** -- Add explicit "do not touch" lists per session to prevent merge conflicts.
- **Missing shared types between sessions** -- Include the full type definitions in every session prompt, not just the first.

## Anti-Patterns

- Do not dispatch tasks that must run sequentially (e.g., migration then seed then test) -- run those in one session.
- Do not create more sessions than there are independent sub-tasks -- overhead outweighs benefit.
- Do not omit merge order -- uncoordinated commits cause rebase pain.

## Level History

- **Lv.1** -- Base: Multi-agent dispatch with coordinated prompts. (Origin: MemStack v1.0, Feb 2026)
- **Lv.2** -- Enhanced: Added YAML frontmatter, activation message, merge ordering. (Origin: MemStack v2.0 MemoryCore merge, Feb 2026)
- **Lv.3** -- Guide-aligned: Added negative triggers, examples, common issues, anti-patterns. Removed emoji from title. (Origin: Anthropic skill guide alignment, Mar 2026)
