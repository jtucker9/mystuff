---
name: kdp-format
description: "Use when the user says 'kdp', 'format for kdp', 'format book', or 'manuscript' and needs print-ready output. Do NOT use for writing book content, cover design, or general Word document formatting."
---


# KDP Format -- Converting manuscript to KDP-ready .docx
*Convert a markdown manuscript into a professionally formatted Word document for Amazon KDP.*

## Critical Warning -- Unit Systems in python-docx

- Property setters (`section.left_margin = Inches(0.75)`) handle unit conversion automatically
- Raw XML attributes use TWIPS (1 inch = 1440 twips), NOT EMU (1 inch = 914400 EMU)
- NEVER use `str(Inches(x))` in raw XML -- it produces EMU values, 635x too large
- Always prefer python-docx property setters over raw XML for margins -- KDP may reject raw XML margins

## Activation

When this skill activates, output:

`KDP Format -- Converting manuscript to KDP-ready .docx...`

Then execute the instructions below.

## Context Guard

| Context | Status |
|---------|--------|
| **User asks to format a manuscript for KDP** | ACTIVE -- full conversion |
| **User says "format for kdp" with a file path** | ACTIVE -- full conversion |
| **User mentions book formatting or manuscript** | ACTIVE -- ask for file path |
| **User is writing content, not formatting** | DORMANT -- do not activate |
| **Discussing KDP concepts generally** | DORMANT -- do not activate |

## Output Specifications

| Property | Value |
|----------|-------|
| Trim size | 6" x 9" (standard trade paperback) |
| Body font | Georgia 11pt |
| Heading font | Arial (24pt chapters, 14pt sub, 13pt sections) |
| Code font | Courier New 10pt, gray background |
| Margins | Top 0.75", Bottom 0.75", Inside 0.75" (gutter), Outside 0.5" |
| Line spacing | 1.3x body, 1.0x code/quotes |
| Paragraph indent | 0.3" first-line (except first after heading) |

## Markdown Conventions

```
---
title: "Book Title"
author: "Author Name"
year: 2025
isbn: "978-..."
---
# Part One: Part Title        -> Part header (own page, centered)
## Chapter 1: Chapter Title   -> Chapter (new page, drop spacing)
### Section Heading            -> Section heading (bold, left)
Regular paragraph text.        -> Body text (Georgia 11pt, indented)
> Blockquote text              -> Teal left border, indented
```code```                     -> Gray background, Courier New
---                            -> Scene break (* * * centered)
```

## Instructions

### Step 1: Get the manuscript path

If not provided, ask: "What is the path to your markdown manuscript file?"

### Step 2: Build the document with python-docx

Use Python with `python-docx`. The deprecated `format-kdp.js` (Node/docx npm) is retained as reference only -- do not use for new work.

### Step 3: Dual output (paperback vs ebook)

Accept a `--format` flag: `paperback` or `ebook`. Build one master document, then post-process:

| Feature | Paperback | Ebook |
|---------|-----------|-------|
| TOC style | Dot-leader with PAGEREF | Hyperlinks with w:anchor |
| Mirror margins | Yes | No |
| Headers/footers | Yes (author/title, page numbers) | No |
| Page numbers | Yes (suppressed in front matter) | No |
| Trim size | Fixed 6" x 9" | No fixed dimensions |

### Step 4: TOC construction

python-docx has no field code API -- TOC requires raw XML. Add bookmarks (`_ch1`, `_ch2`) to Heading 1 paragraphs. Paperback: use PAGEREF field codes with dot-leader tabs (resolves on Ctrl+A, F9 in Word). Ebook: use `w:hyperlink` with `w:anchor`. KDP ebook validation requires: `toc` bookmark, `{ TOC }` field code, and TOC paragraph styles.

Ebook fallback: import DOCX into Kindle Create, export as .kpf, upload .kpf instead of raw DOCX.

### Step 5: Report results

```
KDP Format -- Complete!
Generated: <output-path>
Trim size: 6" x 9" | Chapters: <count> | Parts: <count>
Next: Open in Word, Ctrl+A F9 to update fields, verify, upload to KDP
```

## Key Implementation Notes

- **Mirror margins** (paperback only): `sectPr.append(parse_xml('<w:mirrorMargins .../>'))` -- swaps inside/outside on even pages
- **Section breaks**: Each new section inherits page number format. Set `w:fmt` and `w:start` explicitly. Unlink footers before modifying content
- **Spine text**: Minimum 0.0625" padding per side. Spine width = pages x 0.002252" (white paper)
- **Tables**: Parse markdown pipe tables into `document.add_table()`, match Georgia 11pt, bold headers

## Examples

**Standard paperback conversion:**
User: "format my-book.md for kdp" -> Parse markdown, generate .docx with all specs, report chapter/part counts.

**Dual format request:**
User: "I need both paperback and ebook versions" -> Build master document, post-process into two variants with appropriate TOC style and margin settings.

## Common Issues

| Issue | Fix |
|-------|-----|
| Margins are insanely huge in output | You used EMU values in raw XML instead of TWIPS -- use property setters or `int(inches * 1440)` |
| KDP ebook rejects TOC as "not found" | Missing one of: `toc` bookmark, TOC field code, or TOC paragraph styles -- all three are required |

## Anti-Patterns

- Using `str(Inches(x))` in raw XML attributes -- produces EMU, not TWIPS
- Setting margins via raw `w:pgMar` XML instead of python-docx property setters
- Applying mirror margins to ebook output -- ebook has no physical pages
- Adding headers/footers or page numbers to ebook variant

## Level History

- **Lv.1** -- Base: Original spec-based formatting guidelines. (Origin: MemStack v2.0-v3.1, Feb 2026)
- **Lv.2** -- Implementation: TOC field codes, mirror margins, dual output, section break management, KDP validation, spine text rules. (Origin: MemStack v3.2, Feb 2026)
