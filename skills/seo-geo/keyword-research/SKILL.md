---
name: keyword-research
description: "Use when the user says 'keyword research', 'find keywords', 'keyword strategy', 'search terms', 'keyword opportunities', or needs to identify target keywords with search volume, difficulty, and content mapping. Do NOT use for full site audits (see site-audit), ad keyword groups (see google-ad), or meta tag optimization (see meta-tag-optimizer)."
---

# Keyword Research

Discover, classify, cluster, and prioritize keyword opportunities into an actionable content plan with topic clusters and editorial sequencing.

## Activation

| Context | Status |
|---------|--------|
| "keyword research", "find keywords", "keyword strategy", "search terms" | ACTIVE |
| Identify high-value keywords for a niche or map keywords to content | ACTIVE |
| Topic cluster planning based on keywords | ACTIVE |
| Full site SEO audit | DORMANT — see site-audit |
| Google Ads / PPC keyword groups | DORMANT — see google-ad |
| Meta tags, schema markup, local SEO, AI search optimization | DORMANT — see respective skills |

## Instructions

### Step 1: Gather Inputs

Collect before proceeding. Required: **seed keywords** (3-10) and **niche/industry**. Optional but improves precision: target audience, geographic target, business model, existing site URL, competitor URLs (2-5), domain authority tier (new < DA 20, established 20-50, authoritative 50+), content production capacity.

If only seeds provided, infer niche/audience/model from keywords and note assumptions.

**Gate:** Do not proceed without at least seed keywords and niche.

### Step 2: Seed Expansion

Generate 100-300 raw candidates using all five techniques:

1. **Modifier patterns** — Apply how-to, what-is, best, versus, for-[audience], near, [year], free/paid, review, alternative, template, example, cost/pricing prefixes/suffixes to each seed.
2. **Autocomplete mining** — Alphabet soup method: seed + each letter A-Z. Also try underscore wildcards, question prefixes (why/when/how), preposition prefixes (for/with/without). Scale with KeywordTool.io, Ubersuggest, AnswerThePublic.
3. **PAA extraction** — Expand People Also Ask boxes for each seed in Google. Group questions by funnel stage (awareness / consideration / decision).
4. **Related searches** — Bottom-of-SERP related searches, Google Trends related queries/topics, Search Console existing foothold queries.
5. **Question-based keywords** — What/how/why/which/where questions mapped to content formats (definition, tutorial, explainer, comparison, pricing page).

Do not filter yet — Step 3 classifies, Step 4 scores.

**Gate:** Minimum 50 candidates before proceeding.

### Step 3: Intent Classification

Classify every keyword by search intent using signal words:

| Intent | Signal Words | Content Type |
|--------|-------------|--------------|
| **Informational** | what, how, why, guide, tutorial, learn, tips | Blog, guide, video |
| **Commercial Investigation** | best, top, review, vs, alternative, pros and cons | Listicle, comparison, review |
| **Transactional** | buy, price, discount, subscribe, free trial, demo | Product page, pricing page |
| **Navigational** | [brand] login, [brand] app, [brand] support | Homepage, app page |

Assign each keyword: intent label + dominant SERP features observed.

**Gate:** Every keyword must have an intent label.

### Step 4: Metrics and Scoring

For each keyword, gather: search volume, keyword difficulty (KD), CPC, trend direction.

**KD manual assessment** (when no paid tools available) — search Google and check:
1. Who ranks? Major brands (hard) vs niche blogs (easier)
2. Content depth of top results (comprehensive guides vs thin pages)
3. Domain authority spread of page-1 results
4. Content freshness — old content ranking without updates = opportunity
5. SERP feature density — many features = less organic real estate
6. Direct answer in SERP — zero-click risk

**Traffic potential formula:**
`Estimated traffic = Volume x CTR-at-position x SERP-modifier`
Position 1 CTR ~30%, position 2 ~16%, position 3 ~11%. SERP modifiers: no features 1.0, featured snippet 0.7, ads present 0.85, knowledge panel 0.5, multiple features 0.4-0.6.

**Gate:** Metrics populated for all P0/P1 candidates minimum.

### Step 5: Topic Clustering

Group keywords using the **SERP overlap test**: search keyword A and B, note top 5 URLs. 3+ overlapping URLs = same page targets both. 0-2 overlap = separate pages.

**Topic cluster model:**
- **Pillar page** — broad topic, 2000-5000 words, targets head/mid-tail term (higher volume/KD), links to ALL its cluster posts.
- **Cluster post** — narrow subtopic, 800-2000 words, targets long-tail (lower volume/KD), links back to pillar + 1-2 sibling clusters.

**Internal linking rules:**
- Every cluster MUST link to its pillar — no orphans
- Every pillar MUST link to all its clusters — no hidden content
- Vary anchor text, use natural phrasing
- Max 3-5 internal links per 1,000 words
- Prioritize above-the-fold link placement

Map clusters to URL hierarchy: `/pillar/` with `/pillar/cluster-slug/` children.

**Gate:** All keywords assigned to a cluster with pillar identified.

### Step 6: Competitive Gap Analysis

Compare your domain against 2-3 competitors. Categorize gaps: missing (they rank, you don't), improvement (you rank low), defend (you rank, they're closing), unique (weak competition everywhere).

Manual method: `site:competitor.com [seed]`, review their sitemap.xml, analyze their content coverage.

### Step 7: Prioritization and Content Mapping

**Opportunity score:**
`Score = (Volume x Intent_Weight x CPC_Weight) / KD`
Intent weights: Transactional 3.0, Commercial 2.0, Informational 1.0, Navigational 0.5.
CPC weights: >$10 = 2.0, $3-10 = 1.5, $1-3 = 1.0, <$1 = 0.7.

**Priority score:**
`Priority = Opportunity x Feasibility x Strategic_Alignment`
Feasibility: existing content to update 2.0, in-house expertise 1.5, requires research 1.0, requires assets 0.7, requires partnerships 0.5.
Strategic alignment: primary goal 2.0, secondary goal 1.0, nice-to-have 0.5.

Priority tiers: P0 (>500, this month), P1 (200-500, next 1-2 months), P2 (50-200, this quarter), P3 (<50, backlog).

**Content-to-keyword type mapping:**

| Keyword Pattern | Content Format |
|----------------|---------------|
| "best [X]" / "top [X]" | Listicle with comparison table |
| "how to [X]" | Step-by-step tutorial |
| "[X] vs [Y]" | Head-to-head comparison |
| "what is [X]" | Definition + comprehensive guide |
| "[X] template/examples" | Downloadable asset or gallery |
| "[X] cost/pricing" | Pricing breakdown table |
| "[X] for [audience]" | Tailored guide for segment |

### Step 8: Deliver

Output structured deliverable: project summary, cluster map, master keyword table (keyword, cluster, volume, KD, CPC, intent, opportunity score, priority, content type, target URL), competitive gap summary, content plan by priority tier, quick wins (existing pages ranking 5-20), internal linking plan. Offer markdown (default), CSV, or JSON format.

## Examples

**Example 1 — SaaS niche, new site:**
Seeds: "time tracking app", "employee hours tracker". Niche: B2B SaaS. DA < 20. Focus expansion on long-tail modifiers ("free time tracking app for freelancers") and question keywords. Cluster around pillar "Time Tracking" with clusters for features, comparisons, templates. Target KD < 30 keywords first. P0: 4-6 cluster posts, defer pillar until clusters establish authority.

**Example 2 — Established blog, content refresh:**
Seeds: "home renovation budget", "kitchen remodel cost". DA 35, existing 50 posts. Run gap analysis against 3 competitor blogs. Prioritize quick wins: existing posts ranking 8-15 that need content expansion and internal link injection. New content targets gaps where competitors rank on thin/old pages. Cluster pillars around room types, budget tiers, DIY vs contractor.

## Common Issues

- **Tool KD scores disagree wildly** — Always verify with manual SERP review (Step 4 manual checks). Tools are directional, not absolute.
- **Zero-volume keywords dismissed** — Many high-converting transactional queries show 0 in tools. Target if intent is strong and niche is validated.
- **Keyword cannibalization detected** — Run SERP overlap test. If overlap > 60%, consolidate to one page and 301 redirect the other.

## Anti-Patterns

- Targeting only head terms on a low-DA site — focus 70-80% on long-tail (KD < 40)
- Mismatching content format to intent — blog post for transactional keyword will not rank
- Creating separate pages for synonyms with high SERP overlap — causes cannibalization
- Publishing without internal links — orphan pages are invisible to crawlers
- Copying competitor strategy wholesale without adjusting for your DA and resources
- Chasing trends without an evergreen foundation

## Escalation

Hand off to SEO specialist when: YMYL niche with strict E-E-A-T requirements, competitive landscape is all DA 70+ with no viable gaps, multi-language/multi-region international SEO needed, link building is the primary bottleneck, or programmatic SEO at scale is required.

## Inputs

- Seed keywords (3-10), niche/industry (required)
- Target audience, geographic target, business model
- Existing site URL and content inventory
- Competitor URLs (2-5), domain authority tier
- Content production capacity, available SEO tools

## Outputs

- Expanded keyword list (100-300, deduplicated) with intent classification
- Metrics per keyword (volume, KD, CPC, trend, SERP features)
- Topic cluster map with pillar-cluster hierarchy and URL structure
- Competitive gap analysis (missing, improvement, defend, unique)
- Priority-scored content plan with editorial sequencing (P0-P3)
- Existing content optimization recommendations
- Internal linking plan per cluster
- Master keyword table (markdown, CSV, or JSON)

## Level History

- **Lv.1** — Base: Full 8-step protocol with seed expansion techniques, intent taxonomy, KD assessment, traffic potential formula, topic cluster model, competitive gap analysis, priority scoring, content mapping. Anti-patterns and escalation criteria. (Origin: MemStack v3.3, Mar 2026)
- **Lv.2** — Compressed: Decision-rule density rewrite. Removed exhaustive modifier tables, PAA walkthrough examples, full cluster diagrams, detailed gap matrices, editorial calendar templates, output formatting boilerplate. Preserved all technique names, formulas, classification systems, and linking rules. 793 lines to ~170 lines. (Origin: MemStack v3.4, Mar 2026)
