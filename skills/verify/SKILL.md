---
name: verify
description: "Use when the user says 'verify', 'check this work', 'does it pass', or before committing completed work. Do NOT use for code review of others' code (use code-reviewer), running tests in isolation, or pre-push checks (hooks handle that)."
---


# Verify -- Checking Work
*Review completed work against requirements before committing.*

## Activation

When this skill activates, output:

`Verify -- Checking work against requirements...`

Then execute the instructions below.

## Context Guard

| Context | Status |
|---------|--------|
| **User says "verify", "check this work", "does it pass"** | ACTIVE -- run verification |
| **User says "is this done", "ready to commit"** | ACTIVE -- run verification |
| **User is mid-task, still actively coding** | DORMANT -- let them finish first |
| **User asks to commit or push** | DORMANT -- Seal hook handles pre-push checks |
| **User asks to review someone else's code** | DORMANT -- use code-reviewer skill |

## Instructions

### Step 1: Identify the Task

Determine what was being built from conversation context, git diff, or recent commits. Summarize: "**Task:** [what was being built/changed]"

### Step 2: Run Automated Checks

Run whatever applies to the current project:

```bash
npm run build    # or make build, python -m py_compile <file>
npm test         # or pytest, make test
npm run lint     # if available
```

If no build/test tooling exists, skip and note "No automated checks configured."

### Step 3: Manual Requirement Check

Compare completed work against original requirements. List each requirement, check whether it was implemented, flag gaps or missing edge cases.

### Step 4: Check for Common Issues

- Uncommitted debug code: `console.log`, `print()`, `debugger`, `TODO` left behind
- Hardcoded values: magic numbers, hardcoded URLs, temp credentials
- Missing error handling: unhandled promises, missing try/catch at boundaries
- Incomplete cleanup: unused imports, dead code from earlier attempts

### Step 5: Generate Report

```markdown
## Verification Report
*{YYYY-MM-DD}*

### Task: {what was being built}

### Automated Checks
- [x] Build: passes / [ ] fails -- {error}
- [x] Tests: passes / [ ] fails -- {error}
- [x] Lint: passes / [ ] N/A

### Requirements
- [x] {Requirement 1} -- implemented in {file}
- [ ] {Requirement 3} -- MISSING: {what's needed}

### Issues Found
1. {Issue} -> {Suggested fix}

### Verdict: PASS / NEEDS FIX
```

**PASS:** "Looks good. Ready to commit."
**NEEDS FIX:** List specific fixes, prioritized by severity.

## Examples

**Clean verification:**
User: "verify this work" -> Run build+tests (pass), check requirements (all met), scan for debug code (clean). Verdict: PASS.

**Failed verification:**
User: "is this done?" -> Run build (pass), tests (1 failure), find leftover `console.log` in production code. Verdict: NEEDS FIX with 2 items.

## Common Issues

| Issue | Fix |
|-------|-----|
| No test tooling in the project | Skip automated tests but always run the manual requirement check and debug code scan |
| Build passes but requirements are not met | Build passing does not equal requirements met -- always do Step 3 |

## Anti-Patterns

- Skipping verification because "the change is too small" -- small changes cause regressions
- Reporting PASS without running automated checks when they exist
- Running verification mid-task before the user has finished working
- Treating build success as proof that all requirements are met

## Level History

- **Lv.1** -- Base: Pre-commit verification with automated + manual checks, structured report output. (Origin: MemStack v3.1, Feb 2026)
