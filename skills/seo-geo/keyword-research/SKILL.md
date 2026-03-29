---
name: keyword-research
description: "Use when the user says 'keyword research', 'find keywords', 'keyword strategy', 'search terms', 'keyword opportunities', or needs to identify target keywords with search volume, difficulty, and content mapping. Do NOT use for full site audits (see site-audit) or ad keyword groups (see google-ad)."
---

# 🔑 Keyword Research — Search Opportunity Discovery
*Identify target keywords with search volume, difficulty, and content mapping — producing a prioritized keyword strategy with topic clusters and an editorial plan.*

## Activation

When this skill activates, output:

`🔑 Keyword Research — Discovering search opportunities...`

| Context | Status |
|---------|--------|
| **User says "keyword research", "find keywords", "keyword strategy"** | ACTIVE |
| **User says "search terms", "keyword opportunities", "what should I rank for"** | ACTIVE |
| **User wants to identify high-value keywords for a niche** | ACTIVE |
| **User wants keyword mapping to content pages** | ACTIVE |
| **User wants topic cluster planning based on keywords** | ACTIVE |
| **User wants a full site SEO audit** | DORMANT — see site-audit |
| **User wants meta tag optimization** | DORMANT — see meta-tag-optimizer |
| **User wants schema markup / structured data** | DORMANT — see schema-markup |
| **User wants Google Ads keyword groups / PPC campaigns** | DORMANT — see google-ad |
| **User wants local SEO / Google Business optimization** | DORMANT — see local-seo |
| **User wants AI search / GEO optimization** | DORMANT — see ai-search-visibility |

---

## Protocol

### Step 1: Gather Inputs

Ask the user for the following. Items marked **(required)** must be answered before proceeding; others improve depth and precision.

- **Seed keywords** (required): 3-10 starting keywords or phrases the user associates with their business (e.g., "project management software", "task tracker", "team collaboration tool")
- **Niche / industry** (required): The market vertical (e.g., "B2B SaaS", "personal finance", "home renovation")
- **Target audience**: Who are they trying to reach? (e.g., "small business owners", "first-time homebuyers", "DevOps engineers")
- **Geographic target**: Local (city/metro), national, or international? Which country/language?
- **Business model**: How do they make money? (SaaS, e-commerce, affiliate, ad-supported, services, lead gen)
- **Existing content inventory**: URL of their site or blog, or a list of existing pages/posts — this prevents recommending keywords they already target
- **Competitor URLs**: 2-5 competitor sites to analyze for keyword gaps
- **Goals**: What outcome matters most — traffic, leads, sales, brand awareness, topical authority?
- **Budget / timeline**: Are they creating content themselves or outsourcing? How many pieces per month can they produce?
- **Domain authority context**: Is this a new site (DA < 20), established (DA 20-50), or authoritative (DA 50+)? This affects difficulty targeting.

**If the user provides only seed keywords**, proceed with reasonable assumptions and note them in the deliverable. Infer niche, audience, and business model from the keywords where possible.

---

### Step 2: Seed Keyword Expansion

Starting from the seed keywords, systematically expand the list using multiple techniques. The goal is to generate 100-300 raw keyword candidates before filtering.

#### 2a: Modifier Pattern Expansion

Apply modifier patterns to each seed keyword to generate long-tail variations:

| Modifier Type | Pattern | Example (seed: "project management") |
|---------------|---------|--------------------------------------|
| **How-to** | how to [seed] | how to project management for remote teams |
| **What-is** | what is [seed] | what is project management methodology |
| **Best** | best [seed] [qualifier] | best project management software for startups |
| **Versus** | [seed] vs [competitor] | project management vs task management |
| **For** | [seed] for [audience] | project management for freelancers |
| **Near** | [seed] near me / in [city] | project management consultants near me |
| **Year** | [seed] [year] | project management trends 2026 |
| **Free/Paid** | free [seed] | free project management tools |
| **Review** | [seed] review | monday.com project management review |
| **Alternative** | [seed] alternatives | asana alternatives for small teams |
| **Template** | [seed] template | project management template excel |
| **Example** | [seed] examples | project management plan examples |
| **Beginner** | [seed] for beginners | project management for beginners |
| **Cost/Price** | [seed] cost / pricing | project management software pricing |
| **Certification** | [seed] certification | project management certification online |

#### 2b: Google Autocomplete Mining

Use Google autocomplete to discover what real users search for:

```
Technique: Alphabet soup method
Type seed keyword + each letter of the alphabet in Google search bar:

project management a... → project management app, agile, automation
project management b... → project management books, best practices, board
project management c... → project management courses, certifications, career
...continue through Z

Also try:
- Seed keyword + underscore (_) before and after for wildcard suggestions
- Question prefixes: "why project management", "when to use project management"
- Preposition prefixes: "project management for", "project management with", "project management without"
```

**Tools for scaled autocomplete extraction:**
- KeywordTool.io (free tier: limited results)
- Ubersuggest (free tier: 3 searches/day)
- AnswerThePublic (free tier: limited daily searches)
- AlsoAsked.com (People Also Ask tree visualization)

#### 2c: People Also Ask (PAA) Extraction

PAA boxes reveal the questions users ask at each stage of the buyer journey:

```
Method:
1. Search each seed keyword in Google
2. Expand all PAA questions (click to expand, new ones appear)
3. Record each question — these are validated search queries
4. Group by theme:

Awareness stage PAA:
  "What is project management?"
  "Why is project management important?"
  "What are the types of project management?"

Consideration stage PAA:
  "What is the best project management methodology?"
  "How do I choose project management software?"
  "Project management vs program management?"

Decision stage PAA:
  "How much does Asana cost?"
  "Is Monday.com good for small teams?"
  "Jira vs Trello for agile teams?"
```

#### 2d: Related Searches and Semantic Variations

```
From Google SERP:
- "Related searches" at the bottom of page 1
- "People also search for" (appears when you click a result and return)
- Google Trends "Related queries" and "Related topics"

From tools:
- Google Keyword Planner "Keyword ideas" tab (free with Google Ads account)
- SEMrush Keyword Magic Tool or Ahrefs Keywords Explorer (paid)
- Google Search Console "Queries" report (shows what you already rank for — existing foothold keywords)
```

#### 2e: Question-Based Keywords

Question keywords are high-intent and ideal for featured snippet targeting:

| Question Type | Value | Content Format |
|---------------|-------|----------------|
| What is X? | Informational — top of funnel | Definition article, glossary |
| How to X? | Informational — mid funnel | Tutorial, guide, how-to |
| Why does X? | Informational — problem aware | Explainer, thought leadership |
| Which X is best? | Commercial — comparison | Listicle, comparison table |
| X vs Y? | Commercial — evaluation | Comparison article |
| How much does X cost? | Transactional — bottom funnel | Pricing page, cost breakdown |
| Where to buy X? | Transactional — purchase ready | Product page, local listing |

**Record every expanded keyword.** Do not filter yet — Step 3 will classify and Step 4 will score them.

---

### Step 3: Keyword Classification

Classify every keyword candidate by search intent. Intent determines what content format to create, what conversion action to target, and what SERP features to aim for.

#### 3a: Search Intent Taxonomy

| Intent | Signal Words | User Goal | Content Type | Conversion Expectation |
|--------|-------------|-----------|--------------|----------------------|
| **Informational** | what, how, why, guide, tutorial, learn, tips, examples | Learn something | Blog post, guide, video, infographic | Low — nurture / email capture |
| **Navigational** | [brand name], login, app, website, download | Find a specific site/page | Homepage, login page, app store | N/A — already aware of brand |
| **Commercial Investigation** | best, top, review, comparison, vs, alternative, pros and cons | Evaluate options | Listicle, comparison, review | Medium — lead capture / trial signup |
| **Transactional** | buy, price, discount, coupon, order, subscribe, free trial, demo | Complete an action | Product page, pricing page, signup | High — direct purchase / signup |

#### 3b: Intent Signals in Keywords

Look for these linguistic patterns to classify intent:

```
Informational signals:
  - Question words: what, how, why, when, where, who
  - Learning words: guide, tutorial, learn, understand, explain, tips
  - Concept words: definition, meaning, overview, introduction
  - Example: "how to create a project plan" → Informational

Commercial Investigation signals:
  - Comparison words: best, top, vs, versus, compare, alternative, review
  - Evaluation words: pros and cons, features, differences, which
  - Qualifier words: for [audience], for [use case]
  - Example: "best project management software for startups" → Commercial

Transactional signals:
  - Action words: buy, order, subscribe, signup, download, get, try
  - Price words: price, pricing, cost, discount, coupon, deal, cheap, affordable
  - Product-specific: [brand] + [product], [product] + [plan tier]
  - Example: "asana premium pricing" → Transactional

Navigational signals:
  - Brand + generic: [brand] login, [brand] support, [brand] app
  - Direct destination: [exact site name], [product name] download
  - Example: "asana login" → Navigational
```

#### 3c: SERP Feature Mapping by Intent

Different intents trigger different SERP features — target the features your content can win:

| SERP Feature | Dominant Intent | How to Target |
|-------------|----------------|---------------|
| Featured Snippet | Informational | Concise answer in first 50 words, then elaborate |
| People Also Ask | Informational | Answer related questions in subheadings |
| Knowledge Panel | Navigational | Structured data, Wikipedia presence |
| Product Carousel | Transactional | Product schema markup, merchant feeds |
| Local Pack | Transactional + Local | Google Business Profile, local schema |
| Video Carousel | Informational / How-to | YouTube video with optimized title/description |
| Image Pack | Informational / Commercial | Optimized images with descriptive alt text and filenames |
| Top Stories | Informational (newsy) | Timely content, news schema, fast publication |
| Site Links | Navigational | Clear site structure, internal linking |
| Reviews / Stars | Commercial / Transactional | Review schema markup |

**Assign each keyword:** Intent label + dominant SERP features observed (search manually or via SERP analysis tools).

---

### Step 4: Keyword Metrics Analysis

For each keyword candidate, gather and interpret these metrics. Use available tools — free tiers where budget is limited, paid tools for precision.

#### 4a: Search Volume Interpretation

| Monthly Search Volume | Classification | Strategic Implication |
|----------------------|----------------|----------------------|
| 10,000+ | Head term | High competition, brand-building, usually short-tail |
| 1,000-10,000 | Mid-tail | Balanced opportunity, moderate competition |
| 100-1,000 | Long-tail | Lower competition, higher conversion rates, easier to rank |
| 10-100 | Micro long-tail | Very specific, often high intent, quick wins for new sites |
| 0-10 | Zero/near-zero | May still be valuable if highly transactional or emerging |

**Important caveats:**
- Search volume is an estimate — tools disagree by 30-50% on the same keyword
- Volume does not equal traffic — CTR, SERP features, and position all affect clicks
- Zero-volume keywords can drive revenue if they match buyer intent exactly
- Seasonal keywords may show low average volume but spike 10x during peak months
- Google Keyword Planner groups related keywords, inflating individual estimates

#### 4b: Keyword Difficulty Assessment

Keyword Difficulty (KD) estimates how hard it is to rank on page 1. Different tools calculate KD differently, but the core signal is the same: backlink strength and content quality of current page-1 results.

| KD Score (0-100) | Difficulty | Realistic For | Estimated Effort |
|-------------------|-----------|---------------|-----------------|
| 0-20 | Very Easy | Any site, including new | Quality content alone may rank |
| 21-40 | Easy | Sites with DA 15+ | Good content + basic on-page SEO |
| 41-55 | Medium | Sites with DA 30+ | Strong content + some backlinks needed |
| 56-70 | Hard | Sites with DA 45+ | Authoritative content + link building campaign |
| 71-85 | Very Hard | Sites with DA 60+ | Major content investment + sustained link building |
| 86-100 | Extreme | Top authority sites only | Enterprise-level SEO effort, likely years |

**Manual difficulty check (no paid tools needed):**
```
For each keyword, search Google and analyze page-1 results:

1. Who ranks? → Major brands (hard) vs niche blogs (easier)
2. Content depth → 5,000-word comprehensive guides (hard) vs thin content (easier)
3. Domain authority → All DA 70+ sites (hard) vs mixed DA results (easier)
4. Content age → Old content ranking without updates = opportunity
5. SERP features → Many features = less organic real estate
6. Direct answer in SERP → If Google answers directly, fewer clicks available
```

#### 4c: CPC as Commercial Value Signal

Cost-per-click from Google Ads is a proxy for commercial value — advertisers only pay for keywords that convert.

| CPC Range | Commercial Signal | Implication |
|-----------|------------------|-------------|
| $0-1 | Low commercial value | Informational content, traffic-building |
| $1-5 | Moderate value | Commercial investigation, lead gen potential |
| $5-15 | High value | Strong buyer intent, worth targeting organically |
| $15-50 | Very high value | Competitive verticals (finance, legal, SaaS, insurance) |
| $50+ | Extreme value | Each click represents real revenue potential |

**Use CPC to prioritize:** A keyword with 500 monthly searches and $25 CPC is often more valuable than one with 5,000 searches and $0.50 CPC.

#### 4d: Click-Through Rate Estimation

Not all searches result in clicks. Estimate organic CTR based on:

| Factor | Impact on Organic CTR |
|--------|-----------------------|
| No SERP features | High CTR (~40-60% for position 1) |
| Featured snippet present | Position 0 takes ~8-12% CTR; position 1 drops |
| Ads above organic results | Organic CTR drops 10-15% on commercial keywords |
| Local pack present | Organic CTR drops below map pack |
| Knowledge panel | Answers query directly — many zero-click searches |
| Video carousel | Diverts clicks to YouTube |
| People Also Ask | Can either increase or decrease clicks depending on positioning |

**Traffic potential formula:**
```
Estimated monthly organic traffic = Search Volume x CTR at Target Position x CTR Modifier

Where:
  CTR at Position 1 ≈ 28-35%
  CTR at Position 2 ≈ 15-18%
  CTR at Position 3 ≈ 10-12%
  CTR at Position 4-5 ≈ 5-8%
  CTR at Position 6-10 ≈ 2-4%

CTR Modifier (multiply):
  No SERP features: 1.0
  Featured snippet present: 0.7
  Ads present: 0.85
  Knowledge panel: 0.5
  Multiple features: 0.4-0.6
```

#### 4e: Trend Analysis — Seasonal vs Evergreen

```
Use Google Trends (trends.google.com) for each keyword:

Evergreen pattern:
  Consistent search interest year-round
  → Create once, update annually
  → Example: "how to write a business plan"

Seasonal pattern:
  Predictable spikes at certain times of year
  → Publish 2-3 months BEFORE the spike for indexing
  → Example: "tax filing software" (Jan-Apr spike)

Trending up:
  Rising search interest over time
  → Early-mover advantage, create content now
  → Example: "AI project management tools"

Trending down:
  Declining search interest
  → Avoid investing heavily unless you already rank
  → Example: "Gantt chart software" (declining as agile grows)

Breakout:
  Sudden massive increase (Google Trends marks as "Breakout")
  → Act immediately — time-sensitive opportunity
  → Example: New technology, regulatory change, viral topic
```

---

### Step 5: Keyword Clustering

Group individual keywords into topic clusters. This prevents keyword cannibalization (multiple pages targeting the same query) and builds topical authority.

#### 5a: Topic Cluster Model

The pillar-cluster model organizes content into interconnected hubs:

```
                    ┌─────────────────────┐
                    │    PILLAR PAGE       │
                    │ (Comprehensive,      │
                    │  2000-5000 words)    │
                    └──────────┬──────────┘
                               │
            ┌──────────────────┼──────────────────┐
            │                  │                  │
   ┌────────▼────────┐ ┌──────▼───────┐ ┌───────▼────────┐
   │  CLUSTER POST   │ │ CLUSTER POST │ │  CLUSTER POST  │
   │  (Specific      │ │ (Specific    │ │  (Specific     │
   │   subtopic)     │ │  subtopic)   │ │   subtopic)    │
   └────────┬────────┘ └──────┬───────┘ └───────┬────────┘
            │                  │                  │
     ┌──────▼──────┐   ┌──────▼──────┐   ┌──────▼──────┐
     │ SUB-CLUSTER │   │ SUB-CLUSTER │   │ SUB-CLUSTER │
     │ (Very niche)│   │ (Very niche)│   │ (Very niche)│
     └─────────────┘   └─────────────┘   └─────────────┘

Arrows = internal links (bidirectional between pillar and clusters)
```

#### 5b: Pillar vs Cluster Content

| Attribute | Pillar Page | Cluster Post |
|-----------|------------|--------------|
| **Scope** | Broad topic overview | Narrow subtopic deep-dive |
| **Word count** | 2,000-5,000+ words | 800-2,000 words |
| **Target keyword** | Head term or mid-tail (higher volume, higher KD) | Long-tail (lower volume, lower KD) |
| **Search intent** | Mixed (informational + commercial) | Specific (usually single intent) |
| **Internal links** | Links to ALL its cluster posts | Links back to pillar + 1-2 sibling clusters |
| **Update frequency** | Quarterly — keep comprehensive and current | As needed — less maintenance |
| **Conversion goal** | Email signup, resource download | Direct answer, build trust, link to pillar |
| **Example** | "Project Management: The Complete Guide" | "How to Create a Gantt Chart in Excel" |

#### 5c: Semantic Grouping Method

Group keywords that should be served by a single page:

```
Method: SERP Overlap Test
1. Search keyword A in Google — note the top 5 URLs
2. Search keyword B in Google — note the top 5 URLs
3. If 3+ URLs overlap → same page should target both keywords
4. If 0-2 URLs overlap → separate pages needed

Example:
  "project management tools" → top 5 results
  "project management software" → top 5 results
  Overlap: 4/5 results are the same → these are the SAME keyword, one page targets both

  "project management tools" → top 5 results
  "agile project management" → top 5 results
  Overlap: 1/5 results → these need SEPARATE pages
```

Build clusters by grouping keywords with high SERP overlap:

```
CLUSTER: "Project Management Software"
├── project management software (primary — highest volume)
├── project management tools (secondary — SERP overlap confirms same page)
├── project management platforms
├── best pm software
└── online project management

CLUSTER: "Agile Project Management"
├── agile project management (primary)
├── agile methodology
├── scrum project management
├── agile vs waterfall
└── agile for beginners
```

#### 5d: Content Hub Architecture

Map each cluster to a URL structure:

```
Pillar: /project-management/
  ├── /project-management/software/           (Cluster: PM Software)
  ├── /project-management/agile/              (Cluster: Agile PM)
  ├── /project-management/methodologies/      (Cluster: PM Methodologies)
  ├── /project-management/templates/          (Cluster: PM Templates)
  └── /project-management/certifications/     (Cluster: PM Certifications)

Each cluster page links to:
  1. The pillar page (upward link)
  2. 2-3 related cluster siblings (lateral links)
  3. Its own sub-cluster posts (downward links)
```

#### 5e: Internal Linking Strategy per Cluster

| Link Type | Direction | Purpose | Anchor Text Rule |
|-----------|-----------|---------|-----------------|
| Pillar → Cluster | Downward | Distributes authority, signals subtopic relationship | Use cluster's primary keyword as anchor |
| Cluster → Pillar | Upward | Reinforces pillar's topical authority | Use pillar's primary keyword or branded term |
| Cluster → Cluster | Lateral | Connects related subtopics, increases crawl depth | Use natural phrase or secondary keyword |
| Cluster → Sub-cluster | Downward | Covers niche subtopics without bloating cluster page | Use specific long-tail keyword |
| Blog post → Cluster | Contextual | Drives link equity to money pages | Contextual anchor within body content |

**Internal linking rules:**
- Every cluster page MUST link to its pillar — no orphan clusters
- Every pillar MUST link to all its clusters — no hidden clusters
- Avoid over-optimization: vary anchor text, use natural phrasing
- Maximum 3-5 internal links per 1,000 words (more feels spammy)
- Prioritize above-the-fold links — they carry more weight

---

### Step 6: Competitive Gap Analysis

Identify keywords your competitors rank for that you do not — these are proven opportunities because someone in your niche already validates the traffic.

#### 6a: Competitor Keyword Overlap Analysis

```
Using SEMrush, Ahrefs, or free alternatives:

1. Enter your domain + 2-3 competitor domains
2. Generate a keyword gap report showing:
   - Keywords ALL competitors rank for but you don't (shared opportunities)
   - Keywords ONLY ONE competitor ranks for (unique angles)
   - Keywords where you rank but competitors rank higher (improvement opportunities)

Manual method (no paid tools):
1. List competitor URLs
2. Use Google: site:competitor.com [seed keyword] to find their content
3. Analyze their blog/resource center — what topics do they cover that you don't?
4. Check their sitemap.xml for content you may have missed
```

Organize findings into a gap matrix:

| Keyword | Your Rank | Comp A Rank | Comp B Rank | Comp C Rank | Gap Type |
|---------|-----------|-------------|-------------|-------------|----------|
| agile retrospective template | - | #3 | #7 | #12 | Missing — all competitors rank |
| project management for nonprofits | #18 | #4 | #6 | - | Improvement — you rank low |
| kanban board examples | - | - | #2 | - | Unique — only one competitor |
| remote project management tips | #5 | #8 | #11 | #3 | Defend — you rank but they're close |

#### 6b: Unique Keyword Opportunities

Focus on keywords where competitors are weak or absent:

```
High-value gaps:
1. Keywords competitors rank for on weak pages (thin content, old articles)
   → You can create a definitive resource and outrank quickly

2. Keywords where no competitor ranks in top 10 but search volume exists
   → Untapped opportunity — often emerging topics or long-tail niches

3. Keywords where competitors rank with non-optimized pages (forums, PDFs, old posts)
   → Low competition despite search demand

4. User-generated content opportunities (competitor ranks with a forum thread)
   → Create purpose-built content targeting the same query
```

#### 6c: Difficulty-Adjusted Opportunity Score

Combine metrics into a single prioritization score:

```
Opportunity Score = (Search Volume x Intent Weight x CPC Weight) / Keyword Difficulty

Where:
  Intent Weight:
    Transactional = 3.0
    Commercial Investigation = 2.0
    Informational = 1.0
    Navigational = 0.5 (usually not worth targeting unless it's your brand)

  CPC Weight:
    CPC > $10: 2.0
    CPC $3-10: 1.5
    CPC $1-3: 1.0
    CPC < $1: 0.7

  Keyword Difficulty: Use raw 0-100 score; if 0, use 1 to avoid division by zero

Example:
  "best project management software for startups"
  Volume: 2,400 | Intent: Commercial (2.0) | CPC: $12 (2.0) | KD: 45

  Score = (2400 x 2.0 x 2.0) / 45 = 213.3 → HIGH priority
```

#### 6d: Content Format Preferences by Keyword Type

| Keyword Pattern | Winning Content Format | Why |
|----------------|----------------------|-----|
| "best [X]" / "top [X]" | Listicle with comparison table | Users want scannable options |
| "how to [X]" | Step-by-step tutorial | Users want actionable instructions |
| "[X] vs [Y]" | Head-to-head comparison | Users want a clear verdict |
| "what is [X]" | Definition + comprehensive guide | Users want explanation then depth |
| "[X] template" | Downloadable template + instructions | Users want a ready-made asset |
| "[X] examples" | Gallery/showcase with analysis | Users want inspiration |
| "[X] cost" / "[X] pricing" | Pricing breakdown table | Users want specific numbers |
| "[X] review" | Detailed review with pros/cons | Users want honest evaluation |
| "[X] certification" | Guide with requirements + study plan | Users want a roadmap |
| "[X] for [audience]" | Tailored guide for that audience | Users want relevance to their situation |

---

### Step 7: Content Mapping

Map keywords to specific content pieces with priorities and timelines.

#### 7a: Matching Keywords to Content Types

| Content Type | Target Keywords | Goal | Typical Length |
|-------------|----------------|------|----------------|
| Pillar page | Head terms (KD 40-70, volume 5K+) | Topical authority, hub for cluster | 3,000-5,000 words |
| Cluster post | Mid-tail (KD 20-45, volume 500-5K) | Rank for specific subtopic, link to pillar | 1,200-2,500 words |
| FAQ / Glossary | Question keywords (KD 0-20, volume 50-500) | Featured snippets, PAA, low effort | 500-1,000 words per entry |
| Comparison page | "X vs Y" keywords (KD 20-50, CPC $3+) | Capture commercial intent, drive conversions | 1,500-3,000 words |
| Product / Landing page | Transactional keywords (CPC $5+) | Direct conversion | 800-2,000 words |
| Tool / Calculator | "calculator", "generator", "checker" keywords | Link bait, utility value, backlinks | N/A — interactive content |
| Case study | "[industry] + results/success/case study" | E-E-A-T, trust, bottom-funnel | 1,500-2,500 words |

#### 7b: Editorial Calendar Recommendations

```
Month 1-2 (Foundation):
  - Publish pillar page for your highest-priority cluster
  - Publish 4-6 cluster posts supporting that pillar
  - Optimize any existing pages for newly discovered keywords
  - Set up internal linking structure

Month 3-4 (Expansion):
  - Publish pillar page for second cluster
  - Publish 4-6 cluster posts for cluster 2
  - Publish 2-3 quick-win posts (KD < 20, volume 100+)
  - Update month 1-2 content with performance data

Month 5-6 (Depth + Gaps):
  - Publish pillar page for third cluster
  - Create comparison and review content (commercial intent)
  - Target competitor gap keywords identified in Step 6
  - Build internal links between all clusters

Ongoing:
  - 2-4 new posts per month per cluster
  - Quarterly content audits — update, consolidate, or prune
  - Monitor rankings and adjust strategy based on what's working
```

#### 7c: Priority Scoring Formula

Assign each keyword-content pair a priority score for sequencing:

```
Priority Score = Opportunity Score x Feasibility Modifier x Strategic Alignment

Opportunity Score: From Step 6c

Feasibility Modifier:
  Content already exists and needs updating: 2.0 (fastest win)
  Content can be created from existing expertise: 1.5
  Content requires research / interviews: 1.0
  Content requires tools, data, or design assets: 0.7
  Content requires external partnerships or link building: 0.5

Strategic Alignment:
  Directly supports primary business goal: 2.0
  Supports secondary goal or brand awareness: 1.0
  Nice-to-have, no direct business impact: 0.5

Priority tiers:
  Score > 500: P0 — Create immediately (this month)
  Score 200-500: P1 — Create soon (next 1-2 months)
  Score 50-200: P2 — Queue for quarter (next 3 months)
  Score < 50: P3 — Backlog (revisit next quarter or drop)
```

#### 7d: Existing Content Optimization Opportunities

Before creating new content, check if existing pages can capture keywords with optimization:

```
Quick wins — existing pages that rank positions 5-20:
  These pages are already indexed and have some authority.
  Optimization tactics:
  1. Add the target keyword to the title tag, H1, and first paragraph
  2. Expand thin content — add 500-1,000 words covering subtopics
  3. Add internal links FROM high-authority pages TO this page
  4. Update the publish date and add fresh information
  5. Improve meta description for better CTR
  6. Add FAQ schema for PAA-eligible queries

Consolidation — multiple pages targeting the same keyword:
  Merge them into one comprehensive page and 301 redirect the others.
  This consolidates link equity and eliminates cannibalization.

Content refresh — high-ranking pages with declining traffic:
  Update outdated statistics, tools, and recommendations.
  Add new sections covering recently emerged subtopics.
  Re-promote refreshed content for new backlinks.
```

---

### Step 8: Output

Deliver the keyword research as a structured deliverable.

#### 8a: Master Keyword List

Present as a table with all metrics. Group by cluster. Sort by priority within each cluster.

```
━━━ KEYWORD RESEARCH DELIVERABLE ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

── PROJECT SUMMARY ────────────────────────────────────────────────────────────
Niche:            [industry/niche]
Seed Keywords:    [original seeds]
Competitors:      [competitor URLs analyzed]
Total Keywords:   [N] keywords across [N] clusters
Analysis Date:    [date]

── CLUSTER MAP ────────────────────────────────────────────────────────────────

Cluster 1: [Cluster Name] — Pillar: [Primary Keyword]
│
├── [Keyword 1] | Vol: [N] | KD: [N] | CPC: $[N] | Intent: [I/C/T] | Priority: P[0-3]
├── [Keyword 2] | Vol: [N] | KD: [N] | CPC: $[N] | Intent: [I/C/T] | Priority: P[0-3]
├── [Keyword 3] | Vol: [N] | KD: [N] | CPC: $[N] | Intent: [I/C/T] | Priority: P[0-3]
└── ...

Cluster 2: [Cluster Name] — Pillar: [Primary Keyword]
│
├── ...
└── ...

── MASTER KEYWORD TABLE ───────────────────────────────────────────────────────

| # | Keyword | Cluster | Volume | KD | CPC | Intent | SERP Features | Opp. Score | Priority | Content Type | Target URL |
|---|---------|---------|--------|----|-----|--------|---------------|------------|----------|-------------|------------|
| 1 | [kw]    | [cl]    | [vol]  |[kd]|[$]  | [int]  | [features]    | [score]    | P[0-3]   | [type]      | [url/new]  |
| 2 | ...     | ...     | ...    |... | ... | ...    | ...           | ...        | ...      | ...         | ...        |

── COMPETITIVE GAP SUMMARY ────────────────────────────────────────────────────
Missing keywords (competitors rank, you don't):    [N]
Improvement keywords (you rank low):               [N]
Defend keywords (you rank, competitors closing):    [N]
Unique opportunities (weak competition):            [N]

── CONTENT PLAN ───────────────────────────────────────────────────────────────

P0 — Create This Month:
  1. [Content piece] targeting [keyword cluster] | Est. traffic: [N]/mo
  2. ...

P1 — Create Next 1-2 Months:
  1. [Content piece] targeting [keyword cluster] | Est. traffic: [N]/mo
  2. ...

P2 — Queue for Quarter:
  1. ...

── QUICK WINS (Existing Content Optimization) ─────────────────────────────────
  1. [Existing URL] — currently ranks #[N] for [keyword] — optimize: [specific actions]
  2. ...

── INTERNAL LINKING PLAN ──────────────────────────────────────────────────────
  [Pillar URL] ← links from → [Cluster URLs]
  [Cross-cluster links recommended]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

#### 8b: Export Formats

Offer the deliverable in the format the user prefers:
- **Markdown table** (default — paste into any doc)
- **CSV export** (for spreadsheet analysis and filtering)
- **JSON** (for programmatic use or CMS import)

---

## Anti-Patterns

- **Targeting only head terms**: Head terms (1-2 words, high volume) are extremely competitive. New and mid-authority sites should focus 70-80% of effort on long-tail keywords (3+ words, KD < 40) and build toward head terms as authority grows.
- **Ignoring search intent**: Creating a blog post for a transactional keyword (or a product page for an informational keyword) will not rank. Google matches content type to intent — get this wrong and no amount of optimization helps.
- **Keyword stuffing / over-optimization**: Repeating the target keyword unnaturally hurts rankings. Use the primary keyword in the title, H1, and first paragraph, then use synonyms and related terms naturally throughout the content.
- **Treating keyword difficulty as absolute**: KD scores are tool-specific estimates, not facts. A keyword with KD 60 in Ahrefs might be achievable if the top results have thin content, outdated information, or poor UX. Always manually review the SERP.
- **Creating separate pages for synonyms**: "Project management tools" and "project management software" have 80%+ SERP overlap. Creating separate pages causes cannibalization. Use the SERP overlap test (Step 5c) to confirm whether keywords need separate pages.
- **Ignoring zero-volume keywords**: Many transactional and niche keywords show zero volume in tools but receive real searches. If the keyword matches strong buyer intent and your niche, target it — the traffic may be small but high-converting.
- **Publishing without internal linking**: Orphan pages (no internal links pointing to them) are invisible to search engines and users. Every page needs at least 2-3 internal links from relevant existing content.
- **Chasing trending keywords without evergreen foundation**: Trending topics drive spikes but not sustained traffic. Build evergreen pillar content first, then supplement with trending topics that link back to the pillars.
- **Copying competitor keyword strategy wholesale**: Competitors may have different authority, audience, and business model. Use their keywords as inspiration for gaps, but prioritize based on YOUR site's realistic ranking ability.
- **Skipping content refresh**: Keywords and SERPs change constantly. Content published 12+ months ago should be audited for accuracy, freshness, and ranking performance. Updating existing content often produces faster results than creating new content.

## Escalation

Hand off to an SEO specialist or agency when:
- The site operates in a YMYL (Your Money, Your Life) niche where E-E-A-T requirements are extremely high (medical, financial, legal)
- The competitive landscape is dominated by high-authority sites (DA 70+) and paid tools show no viable low-competition opportunities
- The keyword strategy requires multi-language or multi-region international SEO (hreflang, ccTLD vs subdomain decisions)
- Link building is the primary bottleneck — keyword research is complete but the site cannot rank without a backlink acquisition strategy
- The business needs enterprise-level keyword tracking with automated rank monitoring, reporting dashboards, and API integrations
- Programmatic SEO (auto-generating thousands of pages from data) is the right strategy but requires engineering resources

## Inputs
- Seed keywords (3-10 starting terms)
- Niche / industry vertical
- Target audience demographics and needs
- Geographic and language targets
- Business model and revenue goals
- Existing site URL and content inventory
- Competitor URLs (2-5 recommended)
- Domain authority and site maturity context
- Content production capacity (posts per month)
- Available SEO tools (free tier only, paid subscriptions)

## Outputs
- Expanded keyword list (100-300 candidates, deduplicated)
- Intent classification for every keyword (informational / commercial / transactional / navigational)
- Metrics per keyword (search volume, KD, CPC, trend, SERP features)
- Topic cluster map with pillar-cluster hierarchy
- Competitive gap analysis (missing, improvement, defend, unique opportunities)
- Difficulty-adjusted opportunity scores and priority tiers (P0-P3)
- Content plan with editorial calendar and content type assignments
- Existing content optimization recommendations
- Internal linking plan per cluster
- Master keyword table in markdown, CSV, or JSON format

## Level History

- **Lv.1** — Base: Full 8-step protocol — input gathering, seed expansion (modifier patterns, autocomplete, PAA, related searches, question keywords), intent classification (4-type taxonomy with signal words and SERP feature mapping), metrics analysis (volume, KD, CPC, CTR estimation, trend analysis), topic clustering (pillar-cluster model, SERP overlap test, hub architecture, internal linking strategy), competitive gap analysis (overlap matrix, unique opportunities, difficulty-adjusted opportunity score), content mapping (type matching, editorial calendar, priority scoring, existing content optimization), structured deliverable output with cluster map and master table. Anti-patterns cover 10 common mistakes. (Origin: MemStack v3.3, Mar 2026)
