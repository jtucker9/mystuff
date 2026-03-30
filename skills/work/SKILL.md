---
name: work
description: "Use when the user says 'plan', 'todo', 'copy plan', 'append plan', 'resume plan', 'priorities', or 'what's next'. Do NOT use for executing tasks (just do them), session logging (use Diary), or recalling past work (use Echo)."
---


# Work -- Plan Execution Engaged
*Track tasks, manage plans, and survive CC compacts with three operating modes.*

## Activation

When this skill activates, output:

`Work -- Plan execution engaged.`

Then determine which mode to use based on the trigger.

## Context Guard

| Context | Status |
|---------|--------|
| **User says "copy plan", "append plan", "resume plan"** | ACTIVE -- use matching mode |
| **User says "what's next", "todo", "priorities"** | ACTIVE -- quick query mode |
| **User provides a task list or plan** | ACTIVE -- copy mode |
| **General discussion about planning concepts** | DORMANT -- do not activate |
| **User is executing a task (not managing the list)** | DORMANT -- do not activate |

## Step 0: Silent Context Compilation (MANDATORY)

Before any mode, silently gather state. Do NOT present findings:

1. Read `STATE.md` and `CLAUDE.md` if they exist
2. Check recent diary: `python C:/Projects/memstack/db/memstack-db.py get-sessions <project> --limit 3`
3. Check git: `git log --oneline -5` and `git diff --stat`

## Instructions

### Mode 1: Copy Plan

**Trigger:** "copy plan" or new plan provided

1. Parse plan into individual numbered tasks
2. Save each: `python C:/Projects/memstack/db/memstack-db.py add-plan-task '{"project":"<name>","task_number":<n>,"description":"<task>","status":"pending"}'`
3. Confirm with task count
4. Write markdown copy to `memory/projects/{project}-plan.md`

**Status values:** `pending`, `in_progress`, `completed`, `blocked`

### Mode 2: Append Plan

**Trigger:** "append plan" or updating task statuses

1. Read current plan: `python C:/Projects/memstack/db/memstack-db.py get-plan <project>`
2. Update tasks: `python C:/Projects/memstack/db/memstack-db.py update-task '{"project":"<name>","task_number":<n>,"status":"completed"}'`
3. Add new tasks if needed via `add-plan-task`

### Mode 3: Resume Plan

**Trigger:** "resume plan" -- use after CC compact or new session

1. Load plan: `python C:/Projects/memstack/db/memstack-db.py get-plan <project>`
2. Output summary: `Plan: {project} ({done}/{total} complete)` with Completed/In Progress/Pending/Blocked lists
3. Continue from first incomplete task

### Quick Commands

- **"what's next"** -- returns the single next pending task
- **"priorities"** -- shows top 3 pending items
- **"todo"** -- shows all pending and in-progress items

## Examples

**Resume after compact:**
User: "resume plan" -> Load plan from SQLite, show 5/9 complete, recommend next pending task.

**Quick status check:**
User: "todo" -> Query plan, show all pending/in-progress tasks with status indicators.

## Common Issues

| Issue | Fix |
|-------|-----|
| Plan lost after CC compact | Use "resume plan" to reload from SQLite -- plans survive compacts |
| Tasks out of sync with actual progress | Run "append plan" to update statuses before resuming |

## Anti-Patterns

- Activating when the user is executing a task, not managing the list
- Presenting Step 0 findings to the user -- it is silent context gathering
- Creating a plan without saving to SQLite -- markdown alone does not survive compacts
- Using Echo to find a plan -- Work owns plans, Echo owns session recall

## Level History

- **Lv.1** -- Base: Single-mode TODO tracking. (Origin: MemStack v1.0, Feb 2026)
- **Lv.2** -- Enhanced: Three modes (copy/append/resume), context guard. (Origin: MemStack v2.0, Feb 2026)
- **Lv.3** -- Advanced: SQLite-backed plans with per-task status tracking. (Origin: MemStack v2.1, Feb 2026)
- **Lv.4** -- Native: CC rules integration. (Origin: MemStack v3.0-beta, Feb 2026)
- **Lv.5** -- Context-aware: Silent context compilation (Step 0). (Origin: MemStack v3.2, Feb 2026)
