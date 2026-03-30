---
name: humanize
description: "Use when the user says 'humanize', 'clean up writing', 'make it sound natural', or wants text to not sound AI-generated. Do NOT use for code formatting, commit messages, changelogs, or technical reference docs."
---

# Humanize -- Rewriting for Natural Voice

*Remove AI tells and rewrite content to sound like a human wrote it.*

## Activation

When this skill activates, output:

`Humanize -- Rewriting for natural voice...`

Then execute the instructions below.

## Context Guard

| Context | Status |
|---------|--------|
| **User says "humanize", "make it sound human/natural"** | ACTIVE |
| **User says "clean up this writing", "remove AI tone"** | ACTIVE |
| **User says "rewrite for blog/social/client"** | ACTIVE -- rewrite with audience in mind |
| **User is writing code or technical docs** | DORMANT |
| **User is writing commit messages or changelogs** | DORMANT |

## Instructions

### Step 1: Identify AI Patterns

Scan for these tells:

| AI Pattern | Replace With |
|------------|-------------|
| "delve", "delve into" | "explore", "look at", "dig into" |
| "leverage", "utilize" | "use" |
| "facilitate" | "help", "make easier" |
| "comprehensive", "robust" | "thorough", "solid" (or cut) |
| "streamline" | "simplify", "speed up" |
| "moreover", "furthermore" | cut, or "also" |
| "it's important to note" | cut -- just state the thing |
| "in today's [X] landscape" | cut entirely |
| "navigate" (non-literal) | "deal with", "handle" |

**Structural fixes:**
- Excessive hedging -> Just say the thing
- Hollow transitions -> Cut, or use a heading
- Overlong intros ("In the ever-evolving world of...") -> Start with the point
- Triple emphasis ("truly remarkable and incredibly powerful") -> Pick one
- Unnecessary qualifiers ("very", "really", "quite") -> Cut

### Step 2: Rewrite

1. Lead with the point
2. Shorter sentences -- split at commas when possible
3. Active voice over passive
4. Concrete over abstract
5. Vary rhythm -- mix short and long sentences
6. Cut filler -- if removing a word doesn't change meaning, remove it

### Step 3: Preserve

Do NOT change: technical accuracy, code examples, proper nouns, intentional formatting, or the author's actual arguments.

### Step 4: Present

Show the rewritten version. Note what changed: "Cut 40% -- mostly filler transitions" or "Replaced passive voice throughout."

## Examples

**Example 1 -- Marketing copy cleanup:**
Input: "In today's rapidly evolving landscape, leveraging comprehensive AI solutions facilitates robust optimization."
Output: "AI tools speed up your workflow. They handle the repetitive stuff so your team focuses on real work."
Changes: Cut filler intro, replaced jargon, 20 words -> 18.

**Example 2 -- Blog intro tightening:**
Input: "It's important to note that, moreover, navigating these complex challenges requires a game-changing approach."
Output: "These problems need a different approach."
Changes: Removed hedging, hollow transitions, and buzzwords. 17 words -> 6.

## Common Issues

| Issue | Fix |
|-------|-----|
| Rewrite changes the author's meaning or opinion | Re-read the original argument; preserve the claim, cut only the fluff |
| Output still sounds robotic after one pass | Run a second pass focusing on sentence rhythm and varied length |

## Anti-Patterns

- Do not add your own opinions or claims that were not in the original
- Do not convert all paragraphs to bullet lists -- vary the structure
- Do not over-shorten to the point of losing necessary context
- Do not rewrite code comments, JSDoc, or API documentation with this skill

## Level History

- **Lv.1** -- Base: AI pattern detection and rewrite protocol. Curated replacement table, structural fixes, voice guidelines. (Origin: MemStack v3.1, Feb 2026)
- **Lv.2** -- Guide compliance: Added negative triggers, Examples, Common Issues, Anti-Patterns. Renamed Protocol to Instructions. (Origin: MemStack v3.3, Mar 2026)
