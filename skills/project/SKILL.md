---
name: project
description: "Use when the user says 'save project', 'handoff', or when context is running low and state must be preserved. Do NOT use for session logging (Diary), task planning (Work), or recalling past sessions (Echo)."
---

# Project -- Saving Project State

*Save and restore project state between CC sessions for seamless handoffs.*

## Activation

When this skill activates, output:

`Project -- Saving project state...`

Then execute the instructions below.

## Instructions

### Saving (handoff):

1. **Capture current state:**
   - Accomplishments this session
   - In-progress work (uncommitted changes, partial work)
   - Open questions or pending decisions
   - Next steps in priority order
   - Key file paths modified
2. **Run git status** to capture uncommitted state
3. **Save project context to SQLite:**
   ```bash
   python C:/Projects/memstack/db/memstack-db.py set-context '{"project":"<name>","status":"active","current_branch":"<branch>","last_session_date":"<YYYY-MM-DD>","known_issues":"<issues>","backlog":"<next tasks>"}'
   ```
4. **Save markdown handoff** to `memory/projects/{project}-{date}.md`
5. **Present ready-to-paste prompt** for the next CC session

### Loading (restore):

1. **Load project context:** `memstack-db.py get-context <project>`
2. **Load recent sessions:** `memstack-db.py get-sessions <project> --limit 3`
3. **Load plan if exists:** `memstack-db.py get-plan <project>`
4. **Fallback:** Check `memory/projects/` for markdown handoffs
5. **Present combined state** so CC can continue immediately

## Examples

**Example 1 -- Context running low, save handoff:**
User: "context is running low -- save project"
Output: Saves `memory/projects/adminstack-2026-02-18.md`, prints paste-ready prompt with accomplishments + next steps.

**Example 2 -- Restoring at session start:**
User: "restore AdminStack"
Output: Loads DB context + last 3 sessions + active plan. Prints summary: "Last session built CC Monitor. Next: wire up WebSocket events."

## Common Issues

| Issue | Fix |
|-------|-----|
| SQLite DB not found or memstack-db.py errors | Fall back to reading/writing markdown files in `memory/projects/` |
| Handoff prompt is too vague to resume from | Include specific file paths, branch name, and the exact next action |

## Anti-Patterns

- Do not duplicate Diary's job -- Project saves state, Diary logs history
- Do not include full file contents in handoffs -- list paths and what changed
- Do not save project state automatically without the user asking
- Do not use this skill for task tracking -- that is Work's responsibility

## Level History

- **Lv.1** -- Base: Session state capture and handoff generation. (Origin: MemStack v1.0, Feb 2026)
- **Lv.2** -- Enhanced: Added YAML frontmatter, activation message, template integration. (Origin: MemStack v2.0, Feb 2026)
- **Lv.3** -- Advanced: SQLite-backed project context, combined restore from DB + sessions + plan. (Origin: MemStack v2.1, Feb 2026)
- **Lv.4** -- Guide compliance: Added negative triggers, Examples, Common Issues, Anti-Patterns. Renamed Protocol to Instructions. (Origin: MemStack v3.3, Mar 2026)
