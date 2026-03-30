---
name: sight
description: "Use when the user says 'draw', 'diagram', 'visualize', 'architecture', or needs a visual overview of code structure. Do NOT use for writing code, generating documentation, or describing architecture in prose."
---

# Sight -- The Hidden Becomes Clear

*Generate Mermaid diagrams showing project architecture, schema, and data flow.*

## Activation

When this skill activates, output:

`Sight -- The hidden becomes clear.`

Then execute the instructions below.

## Context Guard

| Context | Status |
|---------|--------|
| **User asks for a diagram or visualization** | ACTIVE |
| **User says "draw", "diagram", "architecture"** | ACTIVE |
| **User asks to "show" or "map" the structure** | ACTIVE |
| **Discussing diagrams conceptually** | DORMANT |
| **User is looking at existing diagrams** | DORMANT |

## Instructions

1. **Determine diagram type** from context:
   - "database" / "schema" -> `erDiagram`
   - "api" / "endpoints" -> `flowchart TD`
   - "components" / "pages" -> `graph TD`
   - "architecture" / "structure" -> `flowchart TD` (system overview)
   - "flow" / "process" -> `sequenceDiagram`
2. **Scan the relevant code:**
   - DB: read migration files in `database/`
   - API: list files in `src/app/api/`
   - Pages: list files in `src/app/`
   - Architecture: read package.json, directory structure, configs
3. **Generate Mermaid diagram** as a fenced code block
4. **Optionally save** to `docs/diagrams/{name}.mermaid`

## Examples

**Example 1 -- Database schema:**
User: "draw the database schema"
Output: Scans migration files, produces `erDiagram` with all tables, columns, and relationships as a Mermaid code block.

**Example 2 -- API route map:**
User: "diagram the API endpoints"
Output: Scans `src/app/api/`, produces `flowchart TD` grouping routes by resource with HTTP methods labeled on edges.

## Common Issues

| Issue | Fix |
|-------|-----|
| Mermaid syntax errors when entity names contain special characters | Wrap node labels in quotes: `A["my-service (v2)"]` |
| Diagram is too large to read | Split into sub-diagrams by domain or layer instead of one monolith |

## Anti-Patterns

- Do not generate diagrams without scanning the actual codebase first
- Do not describe architecture in prose when the user asked for a diagram
- Do not create PNG/SVG exports -- output Mermaid source; the user renders it
- Do not invent tables, routes, or components not found in the code

## Level History

- **Lv.1** -- Base: Mermaid diagram generation from codebase analysis. (Origin: MemStack v1.0, Feb 2026)
- **Lv.2** -- Enhanced: Added YAML frontmatter, context guard, activation message, diagram type detection. (Origin: MemStack v2.0, Feb 2026)
- **Lv.3** -- Guide compliance: Added negative triggers, Examples, Common Issues, Anti-Patterns. Renamed Protocol to Instructions. (Origin: MemStack v3.3, Mar 2026)
