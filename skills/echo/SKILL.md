---
name: echo
description: "Use when the user references past sessions, asks 'what did we do', 'do you remember', 'last session', 'recall', or 'continue from'. Do NOT use for saving sessions (use Diary), planning work (use Work), or searching code (use grep/glob)."
---


# Echo -- Searching the Archives
*Recall information from past CC sessions using semantic vector search.*

## Activation

When this skill activates, output:

`Echo -- Searching the archives...`

Then execute the instructions below.

## Context Guard

| Context | Status |
|---------|--------|
| **User says "recall", "remember", "last session", "what did we"** | ACTIVE -- search memory |
| **User asks about past work ("did we build X?")** | ACTIVE -- search memory |
| **User says "continue from" or "resume" a past topic** | ACTIVE -- search memory |
| **User is describing NEW work ("build X", "add Y")** | DORMANT -- not recall |
| **User mentions "memory" in code context (RAM, variables)** | DORMANT -- technical term |
| **User says "save" or "log"** | DORMANT -- Diary handles writing |

## Instructions

### Step 1: Semantic Vector Search (primary)

```bash
python C:/Projects/memstack/skills/echo/search.py "<keywords>" --top-k 5
```

Present results with scores, dates, and source files.

### Step 2: SQLite Keyword Search (augment or fallback)

```bash
python C:/Projects/memstack/db/memstack-db.py search "<keywords>" --project <project>
```

### Step 3: Recent Sessions and Insights

```bash
python C:/Projects/memstack/db/memstack-db.py get-sessions <project> --limit 5
python C:/Projects/memstack/db/memstack-db.py get-insights <project>
```

### Step 4: Markdown Fallback

If both vector and SQLite return nothing, check `memory/sessions/` and `memory/projects/` for markdown files.

### Step 5: Present Findings

Combine and deduplicate results from all sources. Show similarity scores, dates, accomplishments, pending items, and source attribution (vector/SQLite/markdown).

### Step 6: No Results

If nothing found: "No session logs found for [topic]. Use Diary to save future sessions."

## Indexing

Re-index sessions after new diary entries:
```bash
python C:/Projects/memstack/skills/echo/index-sessions.py        # incremental
python C:/Projects/memstack/skills/echo/index-sessions.py --force # full re-embed
```

## Examples

**Recall past work:**
User: "what did we do on AdminStack last week?" -> Run vector search + SQLite search, present top results with dates and scores.

**Resume from past session:**
User: "continue from where we left off on the API" -> Search for recent sessions mentioning "API", find Session Handoff section, present pickup instructions.

## Common Issues

| Issue | Fix |
|-------|-----|
| Vector search returns no results but SQLite does | Re-index: `python skills/echo/index-sessions.py --force` |
| Results are stale / missing recent sessions | New diary entries need indexing before vector search finds them |

## Anti-Patterns

- Skipping vector search and going straight to SQLite -- vector search returns better-ranked results
- Returning only one source when multiple sources have results -- always run all steps and combine
- Activating when user says "save" or "log" -- that is Diary territory, not Echo
- Summarizing from conversation context instead of searching the database -- you do not persist between sessions

## Level History

- **Lv.1** -- Base: Session log search and recall. (Origin: MemStack v1.0, Feb 2026)
- **Lv.2** -- Enhanced: Context guard, activation message. (Origin: MemStack v2.0, Feb 2026)
- **Lv.3** -- Advanced: SQLite backend as primary source. (Origin: MemStack v2.1, Feb 2026)
- **Lv.4** -- Native: CC rules integration. (Origin: MemStack v3.0-beta, Feb 2026)
- **Lv.5** -- Semantic: LanceDB vector-powered recall with sentence-transformers. (Origin: MemStack v3.1, Feb 2026)
