---
name: shard
description: "Use when the user says 'shard this', 'split file', or when working with files over 1000 lines. Do NOT use for logic refactors, renaming, or files under 500 lines."
---

# Shard -- Refactoring Large File

*Split monolithic files into focused, maintainable modules.*

## Activation

When this skill activates, output:

`Shard -- Refactoring large file...`

Then execute the instructions below.

## Context Guard

| Context | Status |
|---------|--------|
| **User says "shard", "split file"** | ACTIVE -- full protocol |
| **Editing a file over 1000 lines** | ACTIVE -- suggest refactor |
| **User says "refactor" for logic changes (not splitting)** | DORMANT |
| **File is under 500 lines** | DORMANT |

## Instructions

1. **Identify the target file** and count lines: `wc -l <file>`
2. **Analyze structure:**
   - List all exports (functions, components, types, constants)
   - Identify logical groupings
   - Map internal dependencies (what calls what)
3. **Propose the split** -- present to user BEFORE executing:
   - Target: 100-300 lines per new file
   - Group related functionality
   - Keep types near consumers
   - Shared utilities in separate file
4. **Execute the refactor:**
   - Create new files with proper names
   - Move code to appropriate files
   - Add import/export statements
   - Create index.ts barrel if needed for backwards compatibility
   - Update all imports throughout the project
5. **Verify build:** `npm run build 2>&1 | tail -20`
6. **Present result** -- new file structure with line counts

## Examples

**Example 1 -- React page component:**
User: "shard infrastructure/page.tsx -- it's 1100 lines"
Output: Splits into page.tsx (120), RailwayTab.tsx (200), HetznerTab.tsx (180), types.ts (80), constants.ts (60). Build passes.

**Example 2 -- Utility barrel file:**
User: "split utils.ts"
Output: Splits into string-utils.ts, date-utils.ts, api-helpers.ts, index.ts (barrel re-export). All 47 import sites updated.

## Common Issues

| Issue | Fix |
|-------|-----|
| Build breaks after split due to circular imports | Identify the cycle, extract shared types/constants into a dedicated file both modules import |
| Existing tests import from the old file path | Update test imports or add barrel re-exports from the original path |

## Anti-Patterns

- Do not execute the split without proposing the plan first
- Do not create files with fewer than 50 lines -- merge small fragments together
- Do not split files that are under 500 lines unless explicitly asked
- Do not skip the build verification step

## Level History

- **Lv.1** -- Base: File analysis and splitting with import updates. (Origin: MemStack v1.0, Feb 2026)
- **Lv.2** -- Enhanced: Added YAML frontmatter, context guard, propose-before-execute, activation message. (Origin: MemStack v2.0, Feb 2026)
- **Lv.3** -- Guide compliance: Added negative triggers, Examples, Common Issues, Anti-Patterns. Renamed Protocol to Instructions. (Origin: MemStack v3.3, Mar 2026)
