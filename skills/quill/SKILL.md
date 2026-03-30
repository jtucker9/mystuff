---
name: quill
description: "Use when the user says 'create quotation', 'generate quote', 'proposal', or needs a client-facing price document. Do NOT use for invoices (use invoice-generator), contracts (use contract-template), or internal cost estimates."
---

# Quill -- Drafting Quotation

*Generate professional client quotations and proposals.*

## Activation

When this skill activates, output:

`Quill -- Drafting quotation...`

Then execute the instructions below.

## Instructions

1. **Gather requirements** -- ask the user for:
   - Client name and company
   - Project description (or "use Scan results" if just scanned)
   - Timeline expectations
   - Any specific requirements or constraints

2. **If project was already scanned** -- use the Scan results for scope and pricing.
3. **If not scanned** -- run a quick Scan first to get baseline metrics.

4. **Generate the quotation** using `templates/client-quote.md`:
   - Professional header with company info
   - Project scope breakdown with line items
   - Three pricing tiers (if applicable)
   - Timeline with milestones
   - Terms and conditions
   - Valid-until date (30 days from now)

5. **Save to SQLite** (primary):
   ```bash
   python C:/Projects/memstack/db/memstack-db.py set-context '{"project":"<client>","last_quote_date":"<date>","quote_summary":"<scope>"}'
   ```
6. **Save markdown copy** to `memory/projects/{client}-quote-{date}.md` (human-readable backup).
7. **Present formatted** for copy-paste into email or PDF export.

## Inputs

- Client name and company
- Project requirements or Scan results

## Outputs

- Professional quotation document
- Quote context saved to SQLite database
- Markdown backup in memory/projects/

## Examples

**Quote from scratch:**
User: "generate a quote for John at GreenTech for an admin dashboard"
Quill gathers scope, generates a three-tier quotation, saves to SQLite and markdown, presents formatted output.

**Quote from Scan results:**
User: "I just scanned the repo, now quote it for the client"
Quill pulls Scan metrics, builds line items from the scan, generates the quotation with scope already populated.

## Common Issues

**Pricing feels off:** Scan results were stale or from a different project. Re-run Scan on the correct repo before generating.

**Quote missing line items:** User gave a vague project description. Ask for specific deliverables before generating.

## Anti-Patterns

- Generating a quote without confirming the client name -- leads to unprofessional output with placeholder text.
- Skipping the Scan step for a technical project -- produces inaccurate scope and pricing.
- Using Quill for internal estimates or invoices -- use the dedicated invoice-generator or manual estimates instead.

## Level History

- **Lv.1** -- Base: Template-based quotation generation. (Origin: MemStack v1.0, Feb 2026)
- **Lv.2** -- Enhanced: Added YAML frontmatter, activation message, Scan integration. (Origin: MemStack v2.0 MemoryCore merge, Feb 2026)
- **Lv.3** -- Guide-aligned: Added negative triggers, examples, common issues, anti-patterns. Renamed Protocol to Instructions. Removed emoji from titles. (Origin: Anthropic skill guide alignment, Mar 2026)
