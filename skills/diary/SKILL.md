---
name: diary
description: "Use when the user says 'save diary', 'log session', 'wrapping up', or at end of a productive session. Do NOT use for recalling past sessions (use Echo), saving project state (use Project), or mid-task logging."
---


# Diary -- Logging Session
*Document what was accomplished in each CC session for future recall.*

## Activation

When this skill activates, output:

`Diary -- Logging session...`

Then execute the instructions below.

## Context Guard

| Context | Status |
|---------|--------|
| **User says "save diary", "log session", "write diary"** | ACTIVE -- write diary |
| **User says "that's it", "wrapping up"** | ACTIVE -- suggest diary if work was done |
| **Mid-session, user is actively coding** | DORMANT -- don't interrupt flow |
| **Casual conversation, no code changes made** | DORMANT -- nothing to log |
| **User asks to recall past sessions ("what did we do")** | DORMANT -- Echo handles recall |
| **Session just started, no work yet** | DORMANT -- nothing to log |

## Instructions

1. **Summarize the session:** project name, date, what was built/changed, key files modified, commits made (check `git log --oneline -10`), decisions and rationale, problems and solutions.

2. **Format the diary entry:**
   ```markdown
   # Session Diary -- {project} -- {date}

   ## Accomplished
   - Item 1...

   ## Files Changed
   - path/to/file.ts -- description

   ## Commits
   - abc1234 Message

   ## Decisions
   - Decision: reason

   ## Next Steps
   - What to do next

   ## Session Handoff
   **In Progress:** [what was actively being worked on]
   **Uncommitted Changes:** [list any unstaged work, or "None"]
   **Pick Up Here:** [exact instruction for next session]
   **Session Context:** [anything important not captured elsewhere]
   ```

3. **Save to SQLite** (primary storage):
   ```bash
   python C:/Projects/memstack/db/memstack-db.py add-session '{"project":"<name>","date":"<YYYY-MM-DD>","accomplished":"<bullets>","files_changed":"<bullets>","commits":"<bullets>","decisions":"<bullets>","next_steps":"<bullets>"}'
   ```

4. **Save decisions as insights** for cross-project search:
   ```bash
   python C:/Projects/memstack/db/memstack-db.py add-insight '{"project":"<name>","type":"decision","content":"<decision>","context":"Session <date>"}'
   ```

5. **Save markdown backup** to `memory/sessions/{date}-{project}.md`

## Examples

**Standard diary save:**
User: "save diary" -> Summarize accomplishments, check git log, save to SQLite + markdown, confirm with project/duration/commit count.

**End-of-session prompt:**
User: "that's it for today" -> Offer to save diary. If accepted, run full protocol including Session Handoff section.

## Common Issues

| Issue | Fix |
|-------|-----|
| memstack-db.py not found or errors | Verify Python path and that `memstack.db` exists at expected location |
| Session Handoff section missing | Always include it -- it is the most valuable part for cold-start resumption |

## Anti-Patterns

- Activating mid-task when user is still working -- wait until they signal completion
- Skipping the Session Handoff section because "nothing is in progress" -- always include it even if empty
- Logging a session where nothing happened -- no commits and no decisions means nothing to log
- Using Echo's recall protocol instead of writing -- Diary writes, Echo reads

## Level History

- **Lv.1** -- Base: Session logging with git integration. (Origin: MemStack v1.0, Feb 2026)
- **Lv.2** -- Enhanced: Context guard, 500-line limit with archive. (Origin: MemStack v2.0, Feb 2026)
- **Lv.3** -- Advanced: SQLite as primary storage, auto-extract insights. (Origin: MemStack v2.1, Feb 2026)
- **Lv.4** -- Native: CC rules integration (`.claude/rules/diary.md`). (Origin: MemStack v3.0-beta, Feb 2026)
- **Lv.5** -- Handoff: Structured Session Handoff section for cold-start resumption. (Origin: MemStack v3.1, Feb 2026)
