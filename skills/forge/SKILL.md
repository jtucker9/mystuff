---
name: forge
description: "Use when the user says 'forge this', 'new skill', 'create enchantment', or wants to create a MemStack skill. Do NOT use for editing non-skill files, general code generation, or template creation outside the skill system."
---

# Forge -- Creating New Skill

*Create new MemStack skills or improve existing ones.*

## Activation

When this skill activates, output:

`Forge -- Creating new skill...`

Then execute the instructions below.

## Instructions

### Creating a new skill

1. **Gather info** -- ask the user what the skill does, its trigger keywords, required inputs, and expected outputs.
2. **Generate the skill file** in v2.1 format:
   - YAML frontmatter with name and description (include negative triggers)
   - Activation message
   - Context guard (if the skill could have false positives)
   - Instructions, Inputs/Outputs, Examples, Common Issues, Anti-Patterns
   - Level history starting at Lv.1
3. **Write the file** to `skills/{category}/{name}/SKILL.md`
4. **Update the skill index** -- add a new row to the catalog table in `pro-skills.md` or equivalent.
5. **Confirm creation** -- show the skill name, triggers, and file path.

### Improving an existing skill

1. Read the current skill file.
2. Apply improvements based on user feedback.
3. Increment the level in Level History.
4. Write the updated file.

## Inputs

- Skill concept description, trigger keywords, desired behavior

## Outputs

- New SKILL.md file in skills/{category}/{name}/
- Updated skill index

## Examples

**Create a new skill:**
User: "forge a skill called Beacon for health check pinging"
Forge gathers requirements, writes `skills/automation/beacon/SKILL.md`, updates index, confirms triggers.

**Improve an existing skill:**
User: "forge -- add error handling guidance to the deploy skill"
Forge reads the current file, adds the section, increments level history, writes the update.

## Common Issues

**Skill never activates:** Frontmatter description is missing trigger keywords or is too narrow. Add the exact phrases users will say.

**False positive activation:** No context guard defined. Add a context guard table with ACTIVE/DORMANT conditions.

## Anti-Patterns

- Creating a skill file without YAML frontmatter -- the skill catalog cannot index it.
- Writing triggers that overlap with existing skills -- check the catalog first to avoid conflicts.
- Skipping negative triggers in the description -- leads to false activations on unrelated tasks.

## Level History

- **Lv.1** -- Base: Skill file generation and index updates. (Origin: MemStack v1.0, Feb 2026)
- **Lv.2** -- Enhanced: Added YAML frontmatter, v2.1 format generation, level tracking. (Origin: MemStack v2.0 MemoryCore merge, Feb 2026)
- **Lv.3** -- Guide-aligned: Added negative triggers, examples, common issues, anti-patterns. Renamed Protocol to Instructions. Removed emoji from titles. (Origin: Anthropic skill guide alignment, Mar 2026)
