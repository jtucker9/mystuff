---
name: feedback-analyzer
description: "Use when the user says 'analyze feedback', 'feedback analysis', 'customer feedback', 'feature requests', 'support tickets', 'user reviews', or has raw user feedback that needs categorization and prioritization. Do NOT use for competitor/market analysis (see competitor-analysis), roadmap planning without feedback data (see roadmap-builder), or writing feature specs (see feature-spec)."
---

# Feedback Analyzer -- Customer Feedback Intelligence

*Categorize, score, and prioritize raw user feedback into an actionable report with executive summary.*

## Activation

When this skill activates, output:

`Feedback Analyzer -- Analyzing your customer feedback...`

| Context | Status |
|---------|--------|
| **User says "analyze feedback", "feedback analysis"** | ACTIVE |
| **User has support tickets, reviews, or survey data to process** | ACTIVE |
| **User asks "what are customers asking for?"** | ACTIVE |
| **User wants to build a roadmap from feedback** | Chain: feedback-analyzer then roadmap-builder |
| **User wants competitor analysis (not user feedback)** | DORMANT -- see competitor-analysis |

## Instructions

### Step 1: Gather Inputs

Ask the user for:
- **Feedback source**: support tickets, app reviews, NPS surveys, social media, sales call notes, forum posts
- **Raw data**: paste, file, or described themes
- **Product context**: which product
- **Time period**: when collected
- **User segments** (optional): plan type, tenure, geography

**Gate**: Must have raw data or described themes plus product context before proceeding.

### Step 2: Categorize by Theme

Classify each item into: Bug Report, Feature Request, UX Issue, Praise, Confusion, Churn Signal. For each: ID, category, one-line summary, source, segment, verbatim quote.

Group related requests into unified themes ("dark mode" + "night theme" + "less bright" = one theme).

### Step 3: Sentiment Analysis

Score sentiment per category (-1.0 to +1.0) and compute overall sentiment. Note trend vs. last period if available (improving / stable / declining).

### Step 4: Frequency and Impact Ranking

Rank themes by frequency (count, % of total). Then score each by impact:
- Users Affected: Many (3) / Some (2) / Few (1)
- Revenue Impact: High (3) / Medium (2) / Low (1) -- churn mentions and upgrade blockers = High
- Effort (inverted): Low (3) / Medium (2) / High (1)
- Priority Score = Users x Revenue x Effort, normalized to 10

**Gate**: Every theme must have all three impact dimensions scored. Do not leave any as "unknown".

### Step 5: Roadmap Alignment (if user has existing roadmap)

Map themes to existing roadmap items. Flag gaps (not planned), contradictions (deprioritized but users demand it), and alignments.

### Step 6: Quick Wins

Identify actions meeting all three criteria: < 1 week effort, affects > 10% of feedback volume, no dependencies. List each with action, impact, effort, and urgency reason.

### Step 7: Executive Summary

Top 5 action items ranked Critical / Important / Nice-to-have with owner suggestions and timelines. One-paragraph key insight on product direction.

### Step 8: Assemble Report

Output sections: Executive Summary, Category Breakdown, Frequency Ranking, Impact Assessment, Roadmap Alignment (if applicable), Quick Wins, Raw Feedback Log.

## Examples

**Example 1 -- App store reviews**:
User pastes 47 iOS reviews. Output: 6 themes identified, top theme "slow load times" (34% of feedback, sentiment -0.7), 2 quick wins (cache optimization, loading skeleton), executive summary recommending performance sprint.

**Example 2 -- Support tickets**:
User provides 3 months of Zendesk export. Output: 89 tickets categorized, churn signal cluster around billing UX (12 tickets), feature request cluster around API access (18 tickets), roadmap gap flagged for API -- not currently planned.

## Common Issues

- **Too few feedback items for statistical significance**: If < 15 items, note that results are directional, not statistically reliable. Still categorize but caveat the frequency percentages.
- **Mixed products in one dataset**: Ask the user to confirm product scope. If mixed, separate analysis per product or the themes become meaningless.
- **Sentiment without context**: Raw sentiment scores mislead without category context. A -0.5 in Bug Reports is expected; a -0.5 in Praise signals data quality issues.

## Anti-Patterns

- Treating all feedback items as equally weighted regardless of user segment or revenue
- Reporting frequency without impact scoring (popular requests are not always important)
- Skipping theme deduplication so related requests appear as separate low-priority items
- Presenting raw data without an executive summary
- Recommending actions without effort estimates

## Level History

- **Lv.1** -- Base: 6-category feedback taxonomy, sentiment scoring, frequency ranking with deduplication, impact assessment (users x revenue x effort), roadmap alignment mapping, quick wins identification, executive summary with prioritized action items. (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** -- Guide compliance: Added negative triggers, validation gates, Examples, Common Issues, Anti-Patterns. Compressed from 233 to <200 lines. (Origin: MemStack v3.3, Mar 2026)
