---
name: grimoire
description: "Use when the user says 'update context', 'update claude', 'save library', or after significant project changes. Do NOT use for reading CLAUDE.md, querying project facts, or session logging (use Echo/Diary instead)."
---

# Grimoire -- Updating the Knowledge Library

Manage and update CLAUDE.md files across all projects.

## Activation

When this skill activates, output:

`Grimoire -- Updating the knowledge library.`

Then execute the instructions below.

## Instructions

1. **Identify the target project** -- use config.json to find the CLAUDE.md path
2. **Read the current CLAUDE.md** if it exists
3. **Determine what to update** based on the session's work:
   - New API endpoints built
   - New database tables/migrations
   - New pages or components added
   - Architecture decisions made
   - Environment variables added
   - Dependencies installed
4. **Update the CLAUDE.md:**
   - Keep existing content intact
   - Add new entries under the right headings
   - Don't duplicate existing entries
   - Use consistent formatting
5. **If no CLAUDE.md exists** -- create one with standard sections:
   - Project Overview, Tech Stack, Directory Structure, Key Files
   - API Endpoints, Database Schema, Environment Variables, Dev Commands

## Inputs

- Project name (maps to config.json entry)
- What was built/changed this session

## Outputs

- Updated CLAUDE.md file
- Summary of what was added

## Examples

**Adding new API routes after a feature session:**
User: "update claude.md with the payment endpoints" -> Reads existing CLAUDE.md, appends POST/GET /api/payments under API Endpoints, adds stripe webhook env var.

**Creating CLAUDE.md for a new project:**
User: "update context for the new dashboard project" -> No CLAUDE.md found, creates one with all standard sections populated from the codebase.

## Common Issues

- **Duplicate entries after repeated updates** -- Always read the current file and check for existing entries before appending.
- **Wrong project targeted** -- Confirm the project name maps to the correct path in config.json before writing.

## Anti-Patterns

- Do not rewrite the entire CLAUDE.md when only adding a few lines -- append surgically.
- Do not use Grimoire to log session activity -- that is Diary's job.
- Do not remove existing entries unless the user explicitly asks to clean up stale content.

## Level History

- **Lv.1** -- Base: CLAUDE.md read/write with section management. (Origin: MemStack v1.0, Feb 2026)
- **Lv.2** -- Enhanced: Added YAML frontmatter, activation message, auto-detect what changed. (Origin: MemStack v2.0 MemoryCore merge, Feb 2026)
- **Lv.3** -- Guide-aligned: Added negative triggers, examples, common issues, anti-patterns. Removed emoji from title. (Origin: Anthropic skill guide alignment, Mar 2026)
