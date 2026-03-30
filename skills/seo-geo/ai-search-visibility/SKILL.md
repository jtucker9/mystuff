---
name: ai-search-visibility
description: "Optimize content for citation by AI search engines (ChatGPT, Perplexity, Google AI Overviews, Bing Copilot). WHEN: 'AI search', 'GEO', 'generative engine optimization', 'ChatGPT ranking', 'Perplexity optimization', 'AI Overviews', 'LLM visibility', 'llms.txt'. NOT: traditional SEO audits (site-audit), Google Ads (google-ad), meta tags only (meta-tag-optimizer), JSON-LD only (schema-markup)."
---

# AI Search Visibility — Generative Engine Optimization

## Activation

| Context | Status |
|---------|--------|
| "AI search", "GEO", "generative engine optimization" | ACTIVE |
| "ChatGPT ranking", "Perplexity optimization", "AI Overviews" | ACTIVE |
| AI crawler access, llms.txt questions | ACTIVE |
| Traditional Google SEO audit | DORMANT — site-audit |
| Google Ads / PPC | DORMANT — google-ad |
| Meta tags or JSON-LD only | DORMANT — meta-tag-optimizer / schema-markup |

## Instructions

### Step 1: Gather Inputs

Collect before analysis: website URL, content type, 5-15 target queries, current AI visibility (tested or not), industry/niche, existing SEO status (DA, organic rankings), business goal, current robots.txt state.

If untested: instruct user to run each target query in ChatGPT Browse, Perplexity, Google (AI Overview), and Bing Copilot. Record per query: cited (yes/no/mentioned), who was cited instead, what format the cited content used.

**Gate:** Do not proceed without target queries and content type.

### Step 2: Assess Engine Landscape

Each engine discovers content differently — tailor recommendations accordingly.

| Engine | Source channel | Citation pattern | Primary ranking signal |
|--------|---------------|-----------------|----------------------|
| ChatGPT (Browse) | Bing index, live search | 2-5 inline sources | Content relevance > DA > recency |
| Perplexity | Own index (PerplexityBot) + search APIs | 5-15 numbered inline refs (highest opportunity) | Factual density > structure > freshness |
| Google AI Overviews | Google organic index | 3-8 expandable cards from top 10 results | Organic rank > E-E-A-T > structure |
| Bing Copilot | Bing index | 3-6 footnote-style refs | Bing organic rank > structure > freshness |

Key insight: Google AI Overviews require page-1 organic ranking as a prerequisite — GEO cannot bypass missing traditional SEO. For Perplexity, factual density and sourced claims dominate. Citation is never guaranteed; your content may inform an answer without attribution.

**Gate:** User understands that GEO is additive to SEO, not a replacement.

### Step 3: Audit Content Structure

Evaluate pages against these citability patterns — recommend structural changes, do not produce full HTML rewrites.

**Direct answer pattern:** Question heading, then 1-2 sentence authoritative answer, then supporting detail with evidence. The direct answer sentence is what gets extracted as a citation.

**Definition pattern:** "What Is [Term]?" heading, bolded term with 1-sentence definition, key characteristics as bolded-label bullet list.

**Comparison pattern:** "[A] vs [B]" heading, quick-answer verdict, then feature comparison table with specific values per column.

**Statistics pattern:** Sourced data points with specific numbers, grouped by category in tables. Source attribution inline ("Source: [Name], [Year]"). Unique/original data is the strongest citation magnet across all engines.

**FAQ pattern:** Question-answer pairs visible on page, paired with FAQPage schema markup. Schema alone does not earn citations.

Additional schema types that improve extraction: HowTo, Article+author, Product+Review, SpeakableSpecification (marks sections explicitly as citable).

Consider llms.txt at site root — a structured index of site content for AI crawlers. Low effort, positions for future adoption, but not universally respected yet.

**Gate:** Score content structure and identify specific pages needing structural fixes before proceeding.

### Step 4: Evaluate Authority Signals

E-E-A-T factors weigh differently for AI citation than traditional SEO:

| Signal | AI impact | Implementation |
|--------|----------|----------------|
| Author byline + credentials | High — LLMs evaluate author expertise | Named author with specific credentials on every article |
| Original research / proprietary data | Very high — unique data is highly citable | Surveys, dataset analysis, benchmark reports |
| Expert quotes with attribution | High — treated as evidence by LLMs | Named quotes with title/credentials |
| Publication reputation / cross-citation | Very high | Earned mentions from authoritative domains |
| Topical depth | Very high — comprehensive > surface-level | Full topic coverage, not thin answer pages |
| Recency signals | High for time-sensitive queries | Visible "Updated [date]", freshness sections |

Unattributed claims and anonymous authorship are low-trust signals for AI models.

**Gate:** Identify authority gaps before technical recommendations.

### Step 5: Technical Access Audit

**AI bot user agents and robots.txt decisions:**

| Bot | Company | Purpose | User agent |
|-----|---------|---------|------------|
| GPTBot | OpenAI | Training data collection | `GPTBot` |
| ChatGPT-User | OpenAI | Real-time browsing | `ChatGPT-User` |
| ClaudeBot | Anthropic | Training data | `ClaudeBot` |
| PerplexityBot | Perplexity | Search index | `PerplexityBot` |
| Google-Extended | Google | AI training (not regular Googlebot) | `Google-Extended` |
| Bytespider | ByteDance | Training data | `Bytespider` |
| CCBot | Common Crawl | Open training data | `CCBot` |

**robots.txt decision framework (choose one):**

- **Option A — Allow all:** Maximum AI visibility. For content businesses, publishers, anyone who benefits from maximum distribution. Allow all bots listed above.
- **Option B — Selective:** Allow browse/search bots (ChatGPT-User, PerplexityBot) for citation visibility, block training bots (GPTBot, Google-Extended) to prevent training use. Balanced approach.
- **Option C — Block all:** Content protection / paywall strategy. Eliminates all AI search visibility.

Critical distinction: blocking GPTBot blocks training, NOT ChatGPT Browse (that is ChatGPT-User). Blocking Googlebot blocks both traditional search AND AI Overviews.

Additional checks: SSR/pre-rendered HTML (JS-dependent content invisible to bots), page speed < 2s TTFB, semantic HTML (article/section/header elements, not div soup), no unintended noindex on target pages.

**Gate:** robots.txt decision made and aligned with business goals.

### Step 6: Build Content Strategy and Report

Content strategy types ranked by AI citation potential:

1. **Question-first content** — H1 as question, direct answer first, sub-questions as H2s, key takeaways list
2. **Comparison content** — "[A] vs [B]" with quick verdict, then detailed comparison table
3. **Statistics/data pages** — Sourced numbers by category, proprietary data preferred, table format
4. **Glossary/definition pages** — Term-by-term, bold definitions, map directly to "what is" queries
5. **Tool/calculator pages** — LLMs cite the page as a resource even though they cannot interact with it

Freshness strategy: update cornerstone content quarterly with new data, include visible "Updated" dates, mix timely and evergreen content.

Deliver prioritized report: current citation rate, AI bot access status, content structure score with specific fixes, authority gaps, competitive citation analysis (who gets cited for target queries), prioritized recommendations (high/medium/ongoing), content plan with target queries and formats, measurement baseline.

### Step 7: Establish Monitoring

No unified API exists for AI citation tracking. Practical approach:

- **Monthly manual audit:** Test target queries across all 4 engines, record cited/mentioned/absent per query per engine
- **Competitive tracking:** For each target query, record who IS cited — pattern-match their format advantages
- **Referrer analysis:** Server logs for traffic from chat.openai.com, perplexity.ai, bing.com/chat
- **Perplexity API:** Supports programmatic queries for automated weekly checks
- **Emerging tools:** Otterly.ai, Profound, GeoMonitor — evaluate as space matures
- **llms.txt request monitoring:** Server logs for /llms.txt hits

Key metrics: citation count per engine, citation position, competitor citation share, AI referrer traffic, content structure score.

## Examples

**Example 1 — SaaS documentation site, zero AI visibility:**
Inputs: 10 target queries, DA 45, no AI bot rules in robots.txt, content is JS-rendered SPA. Findings: content invisible to AI bots (CSR), no direct-answer formatting, anonymous authorship. Recommendations: SSR, add author bios with credentials, restructure top 10 pages with direct-answer pattern, robots.txt Option A, add llms.txt.

**Example 2 — E-commerce blog, partial Perplexity citations:**
Inputs: 15 comparison queries, DA 62, GPTBot blocked, strong organic rankings. Findings: cited in Perplexity for 3/15 queries, comparison pages lack tables. Recommendations: add comparison tables to all "[A] vs [B]" posts, add proprietary customer data to statistics pages, switch robots.txt from Option C to Option B (allow ChatGPT-User), quarterly content freshness updates.

## Common Issues

- **Cited in Perplexity but not Google AI Overviews:** Likely missing organic page-1 ranking — fix traditional SEO first via site-audit skill.
- **Content is comprehensive but never cited:** Missing direct-answer pattern — add 1-2 sentence authoritative answer immediately after each question heading.
- **AI bots blocked unintentionally:** Blanket robots.txt rules (e.g., disallowing all non-Googlebot agents) — audit and apply the 3-option framework explicitly.

## Anti-Patterns

- Keyword stuffing for AI — LLMs are not density matchers; topical depth and natural writing outperform repetition.
- Blocking all AI bots then expecting AI visibility — contradictory; make a deliberate robots.txt decision.
- Thin "answer-only" pages with no supporting depth — AI models prefer comprehensive sources over isolated answers.
- Optimizing for one engine only — well-structured content performs across all engines.
- Chasing AI search at the expense of human readers — poor engagement destroys the authority signals LLMs rely on.
- Presenting speculative techniques as proven — GEO is evolving; always disclose certainty level.

## Escalation

- Site has fundamental SEO problems (no organic rankings, major technical issues) — fix via site-audit first.
- YMYL content without genuine E-E-A-T — formatting cannot overcome missing real expertise.
- Legal/copyright concerns about AI training on content — requires legal counsel.
- Paywall business model with uncertainty about AI bot access — business strategy decision, not technical.
- Competitive landscape dominated by Wikipedia, government, or institutional authorities that cannot be realistically out-cited.

## Inputs

- Website URL and target pages
- 5-15 target queries
- Content type and industry
- Current AI visibility (tested or untested)
- Existing SEO status (DA, organic rankings)
- Current robots.txt state
- Business goals

## Outputs

- AI Search Visibility Report: current citation state, bot access audit, content structure score, authority assessment, competitive citation analysis, prioritized recommendations, content plan, measurement baseline

## Known vs Speculative

| Guidance | Confidence |
|----------|------------|
| Content structure improves AI citation | High — published research, empirical |
| robots.txt controls bot access | High — documented by OpenAI, Google, Perplexity |
| E-E-A-T signals influence citation | High — Google guidelines + observed behavior |
| Original data/statistics are highly citable | High — consistent across engines |
| llms.txt as future standard | Speculative — early adoption, no universal commitment |
| SpeakableSpecification improves AI extraction | Moderate — limited empirical data for AI |
| Specific ranking algorithms of AI engines | Unknown — none published |

Rule: disclose when a recommendation is based on emerging patterns vs established practice.

## Level History

- **Lv.1** — Base: Full 8-step protocol covering AI search landscape, content structure for citability, authority signals, technical optimization, content strategy, monitoring and measurement, known vs speculative transparency. (Origin: MemStack v3.3, Mar 2026)
- **Lv.2** — Compressed: Rewritten for creator-level density. Removed complete HTML/bash/JSON-LD examples, retained all decision frameworks, engine differences, bot user agents, content strategy types, citability patterns, robots.txt 3-option framework, E-E-A-T mapping, and monitoring approach. Added validation gates between steps. (Origin: MemStack v3.4, Mar 2026)
