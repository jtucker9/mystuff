---
name: state
description: "Use when the user says 'update state', 'project state', 'where was I', or at session start to load current context. Do NOT use for session logging (Diary), project handoffs (Project), or task planning (Work)."
---

# State -- Updating Project State

*Maintain a living document of where you are right now in a project.*

## Activation

When this skill activates, output:

`State -- Updating project state...`

Then execute the instructions below.

## Context Guard

| Context | Status |
|---------|--------|
| **User says "update state", "save state", "project state"** | ACTIVE -- update STATE.md |
| **User says "where was I", "where did I leave off"** | ACTIVE -- read and present STATE.md |
| **User starts a session and STATE.md exists** | ACTIVE -- read silently, use as context |
| **User says "save diary" or "log session"** | DORMANT -- Diary handles session logs |
| **User says "save project" or "handoff"** | DORMANT -- Project handles lifecycle |
| **User asks to recall past sessions** | DORMANT -- Echo handles historical recall |

## Instructions

### Reading State (session start or "where was I")

1. Check for `{project_dir}/.claude/STATE.md`
2. If found, present brief summary: what was being worked on, blockers, immediate next step
3. If not found: "No STATE.md exists yet. I can create one after we start working."

### Writing/Updating State

1. **Gather current state:**
   - Active task/phase being worked on
   - Decisions made this session (with rationale)
   - Open blockers or unanswered questions
   - Explicit next steps (specific enough to resume cold)
   - Key files modified recently
2. **Check git status:** `git status --short`
3. **Write STATE.md** to `{project_dir}/.claude/STATE.md`:
   ```markdown
   # Project State
   *Last updated: {YYYY-MM-DD HH:MM}*

   ## Currently Working On
   {Active task -- be specific}

   ## Decisions Made
   - {Decision}: {Rationale}

   ## Blockers
   - [ ] {Blocker description}

   ## Next Steps
   1. {Immediate next action}
   2. {Following action}

   ## Recently Modified Files
   - {file path} -- {what changed}

   ## Uncommitted Changes
   {List or "None -- clean working tree"}
   ```
4. **Confirm** with brief summary of what was saved.

## Deconfliction

| Skill | Tracks | When |
|-------|--------|------|
| **State** | Current snapshot -- where you are *right now* | During session, living document |
| **Diary** | Historical log -- what you *did* | End of session, append-only |
| **Project** | Project lifecycle -- handoff between sessions | Session boundaries |
| **Work** | Task list -- what *needs to be done* | Planning/tracking todos |

## Examples

**Example 1 -- Mid-session state save:**
User: "update state"
Output: Writes STATE.md with current task, recent decisions, and next steps. Confirms: "State saved. Currently: building notification system. Next: wire up WebSocket events."

**Example 2 -- Session start resume:**
User: "where was I"
Output: Reads STATE.md, presents: "Last working on CC Monitor. Blocker: API rate limit TBD. Next step: add retry logic to polling endpoint."

## Common Issues

| Issue | Fix |
|-------|-----|
| STATE.md gets stale because it was not updated before session end | Remind user to "update state" before wrapping up; Diary hook does not update STATE.md |
| Next steps are too vague to resume from | Write the exact file path and function name, not "continue working on the feature" |

## Anti-Patterns

- Do not auto-update STATE.md without the user requesting it
- Do not duplicate Diary content -- State is present tense, Diary is past tense
- Do not include full code snippets in STATE.md -- reference file paths instead
- Do not use State for task tracking -- that is Work's job

## Level History

- **Lv.1** -- Base: Living STATE.md creation and update protocol. Deconfliction with Diary/Project/Work. (Origin: MemStack v3.1, Feb 2026)
- **Lv.2** -- Guide compliance: Added negative triggers, Examples, Common Issues, Anti-Patterns. Renamed Protocol to Instructions. (Origin: MemStack v3.3, Mar 2026)
