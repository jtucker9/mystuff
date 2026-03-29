---
name: ai-search-visibility
description: "Use when the user says 'AI search', 'AI visibility', 'ChatGPT ranking', 'Perplexity optimization', 'GEO', 'generative engine optimization', or needs to optimize content for AI-powered search engines and LLM citations. Do NOT use for traditional SEO audits (see site-audit) or Google Ads (see google-ad)."
---

# 🤖 AI Search Visibility — Generative Engine Optimization
*Optimize content for citation by AI-powered search engines — ChatGPT, Perplexity, Google AI Overviews, and Bing Copilot — by improving structure, authority signals, technical access, and content strategy.*

## Activation

When this skill activates, output:

`🤖 AI Search Visibility — Optimizing for AI search engines...`

| Context | Status |
|---------|--------|
| **User says "AI search", "GEO", "generative engine optimization"** | ACTIVE |
| **User says "ChatGPT ranking", "Perplexity optimization"** | ACTIVE |
| **User wants content cited by AI-powered search engines** | ACTIVE |
| **User mentions "AI Overviews", "Bing Copilot", "LLM visibility"** | ACTIVE |
| **User asks about llms.txt or AI crawler access** | ACTIVE |
| **User wants traditional Google SEO audit** | DORMANT — see site-audit |
| **User wants Google Ads or PPC** | DORMANT — see google-ad |
| **User wants meta tags only** | DORMANT — see meta-tag-optimizer |
| **User wants structured data / JSON-LD only** | DORMANT — see schema-markup |

## Protocol

### Step 1: Gather Inputs

Collect the following before analysis:

- **Website URL**: The site or page(s) to optimize
- **Content type**: Blog, SaaS landing page, documentation, e-commerce, news, educational, directory, tool
- **Target queries**: The questions or topics the user wants to appear in AI answers for (5-15 queries)
- **Current AI visibility**: Has the user tested their content in ChatGPT, Perplexity, etc.? What appeared?
- **Industry/niche**: Competitive landscape and topical area
- **Existing SEO status**: Domain authority, organic traffic level, current search rankings
- **Business goal**: Brand awareness, traffic, leads, sales, thought leadership

If the user has not tested their current visibility, recommend immediate testing:

```
Before we begin, test these queries in each AI search engine:
1. Open ChatGPT (with Browse), Perplexity, Google (AI Overview), Bing Copilot
2. Ask each of your 5-10 target queries
3. Note:
   - Were you cited? (link, brand mention, or content paraphrase)
   - Who WAS cited instead?
   - What format did the cited content use?
   - How was the answer structured?
```

---

### Step 2: AI Search Landscape Analysis

Explain how each AI search engine discovers, selects, and cites content. This context is essential for the user to understand *why* the recommendations work.

#### How LLMs Find and Cite Sources

AI search engines use three source channels — each requires different optimization:

| Channel | How It Works | Who Uses It | Optimization Focus |
|---------|-------------|-------------|-------------------|
| **Training data** | Content absorbed during model pre-training (months-old cutoff) | All LLMs for background knowledge | Establish topical authority over time; be the canonical source on your topic |
| **RAG / Index retrieval** | Content indexed and retrieved from a curated web index at query time | Perplexity, Google AI Overviews, Bing Copilot | Structured content, clear answers, schema markup, freshness signals |
| **Live web search** | Real-time web search triggered by the query | ChatGPT Browse, Perplexity (some queries), Bing Copilot | Page speed, crawlability, traditional SEO ranking (you must rank to be retrieved) |

#### Engine-by-Engine Differences

**ChatGPT (Browse mode):**
- Uses Bing search index when browsing is triggered
- Cites sources with inline links and a "Sources" section
- Prefers pages that directly answer the question in the first 1-2 paragraphs
- GPTBot crawls for training data (separate from Browse)
- Citation pattern: tends to cite 2-5 sources per answer, blending information across them
- Ranking signal emphasis: content relevance > domain authority > recency

**Perplexity:**
- Maintains its own web index (PerplexityBot) plus uses search APIs
- Most citation-heavy of all AI search engines — every claim gets an inline citation number
- Cites 5-15 sources per answer, making it the highest-opportunity platform
- Strongly prefers pages with clear factual claims, statistics, and structured data
- Citation pattern: numbered inline references, each linking to the source page
- Ranking signal emphasis: factual density > structured content > freshness > authority

**Google AI Overviews (formerly SGE):**
- Pulls from Google's existing search index — traditional SEO is a prerequisite
- Appears at the top of search results for informational queries
- Cites sources as expandable cards beneath the AI-generated summary
- If you don't rank on page 1 organically, you almost certainly won't appear in AI Overviews
- Citation pattern: 3-8 source cards, usually from top 10 organic results
- Ranking signal emphasis: Google organic ranking > E-E-A-T > content match > structured data

**Bing Copilot:**
- Uses Bing's search index with Microsoft's LLM layer
- Inline citations with footnote numbers linking to sources
- More conversational than Google AI Overviews
- Citation pattern: 3-6 sources, footnote style
- Ranking signal emphasis: Bing organic ranking > content structure > freshness

#### Key Insight: Citation Is Not Guaranteed

Unlike traditional SEO where ranking = visibility, AI search engines *synthesize* answers. Your content may inform an answer without being cited. The goal is twofold:

1. **Be selected as a source** (your page is retrieved/crawled)
2. **Be cited in the answer** (the LLM attributes information to you)

Both require distinct optimization — retrieval depends on technical factors and traditional SEO; citation depends on content structure, authority, and "citability."

---

### Step 3: Content Structure for AI Consumption

AI models extract information more reliably from well-structured content. Every recommendation in this section increases the probability that an LLM will both find and cite your content.

#### 3.1 Clear Heading Hierarchy

```html
<!-- ✅ AI-FRIENDLY: Clear, descriptive, question-based headings -->
<h1>What Is Generative Engine Optimization (GEO)?</h1>
  <h2>How GEO Differs from Traditional SEO</h2>
  <h2>Key GEO Strategies for 2026</h2>
    <h3>Optimizing Content Structure for LLMs</h3>
    <h3>Building Authority Signals AI Models Trust</h3>
  <h2>How to Measure AI Search Visibility</h2>

<!-- ❌ AI-HOSTILE: Vague, keyword-stuffed, non-descriptive headings -->
<h1>GEO Guide</h1>
  <h2>Our Services</h2>
  <h2>Learn More</h2>
    <h3>Click Here</h3>
```

LLMs use headings as a **structural map** to locate relevant content. If a user asks "how does GEO differ from SEO," the model scans headings for the closest match and extracts the content beneath it.

#### 3.2 Direct Answer Formatting (The "Citability" Pattern)

The single most important structural pattern for AI citation. Place a concise, authoritative answer immediately after the question heading:

```markdown
## What is the average cost of a kitchen renovation in 2026?

The average cost of a kitchen renovation in 2026 is $15,000-$45,000 for a mid-range
remodel and $45,000-$120,000+ for a high-end remodel, according to HomeAdvisor and
Remodeling Magazine data.

Several factors affect the final cost:
- **Cabinet replacement**: $5,000-$25,000 (largest single expense)
- **Countertops**: $2,000-$8,000 depending on material
- **Appliances**: $3,000-$15,000 for a full suite
- **Labor**: typically 20-35% of total project cost
```

**Why this works:**
- First sentence directly answers the question (LLMs extract this for citation)
- Specific numbers and data sources increase "citability" — LLMs prefer citable claims over vague statements
- Bullet points with bolded categories help LLMs parse structured comparisons
- Sources mentioned inline signal trustworthiness to the model

**Pattern: Question → Direct Answer → Supporting Detail → Evidence**

This is the format that AI search engines cite most frequently. The direct answer sentence becomes the extracted quote.

#### 3.3 Definition Patterns

LLMs heavily cite definition-style content. Use this format for key terms:

```markdown
## What Is [Term]?

**[Term]** is [clear 1-sentence definition]. [1-2 sentences of context explaining
why it matters or how it's used.]

### Key characteristics of [Term]:
- **[Attribute 1]**: [explanation]
- **[Attribute 2]**: [explanation]
- **[Attribute 3]**: [explanation]
```

#### 3.4 Comparison Tables

AI models frequently extract tabular comparisons. When your content compares options, use tables:

```markdown
## [Option A] vs [Option B]: Which Is Better for [Use Case]?

| Feature | Option A | Option B |
|---------|----------|----------|
| Price | $X/mo | $Y/mo |
| Best for | [use case] | [use case] |
| Key advantage | [specific] | [specific] |
| Key limitation | [specific] | [specific] |
| Our recommendation | [verdict] | [verdict] |
```

Tables are disproportionately cited because they contain dense, structured, comparable information.

#### 3.5 FAQ Schema + Content

FAQ sections serve dual purposes — they're structured data for traditional search AND pattern-matched by LLMs:

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "How long does a kitchen renovation take?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "A mid-range kitchen renovation typically takes 6-10 weeks..."
      }
    }
  ]
}
</script>
```

Pair the schema with visible FAQ content on the page — schema alone won't get you cited, but schema + visible content signals to both traditional and AI search engines.

#### 3.6 Structured Data Types That Improve AI Extraction

| Schema Type | When to Use | AI Benefit |
|-------------|-------------|------------|
| `FAQPage` | Any page with Q&A content | Questions mapped directly to answers |
| `HowTo` | Tutorial/instructional content | Step-by-step extraction |
| `Article` + `author` | Blog posts, news, analysis | Author authority signals |
| `Product` + `Review` | Product pages, comparisons | Structured product data |
| `Organization` | About pages, homepages | Entity recognition and trust |
| `LocalBusiness` | Local service providers | Local query matching |
| `Dataset` | Research, statistics pages | Data citation |
| `SpeakableSpecification` | Key content for voice/AI answers | Explicitly marks citable sections |

`SpeakableSpecification` is particularly underused — it explicitly tells search engines which content sections are suitable for spoken or AI-generated answers:

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Article",
  "speakable": {
    "@type": "SpeakableSpecification",
    "cssSelector": [".article-summary", ".key-takeaway"]
  }
}
</script>
```

#### 3.7 The llms.txt Standard

`llms.txt` is an emerging convention (similar to `robots.txt`) that provides LLMs with a structured overview of your site's content:

```
# Site Name

> Brief description of what this site covers.

## Topics
- [Topic 1 Overview](/topic-1): Brief description
- [Topic 2 Overview](/topic-2): Brief description

## Key Resources
- [Getting Started Guide](/getting-started): Description
- [API Reference](/api/docs): Description
- [Pricing](/pricing): Description

## Optional
- [About Us](/about): Description
- [Contact](/contact): Description
```

Place at `https://yourdomain.com/llms.txt`. While not universally adopted yet, it's a low-effort signal that costs nothing to implement and positions the site for future AI crawlers that respect it.

---

### Step 4: Authority Signals for AI Citation

AI models don't just extract content — they evaluate trustworthiness. Authority signals influence whether a model cites your page or a competitor's.

#### 4.1 E-E-A-T for AI (Experience, Expertise, Authoritativeness, Trustworthiness)

Google's E-E-A-T framework applies to AI search with additional nuances:

| Signal | Traditional SEO Impact | AI Search Impact | How to Implement |
|--------|----------------------|-----------------|-----------------|
| **Author byline + bio** | Moderate | High — LLMs evaluate author credentials | Named author with expertise description on every article |
| **Author credentials** | Moderate | High — "Dr.", certifications, years of experience | Include in author bio and article intro |
| **Publication reputation** | High | Very high — LLMs weight authoritative domains | Earn mentions/citations from authoritative sources |
| **Original research/data** | High | Very high — unique data is highly citable | Conduct surveys, analyze datasets, publish findings |
| **Expert quotes** | Moderate | High — attributed quotes signal depth | Include named expert quotes with credentials |
| **Topical depth** | High | Very high — comprehensive coverage signals authority | Cover the full topic, not just surface-level |
| **Recency signals** | Moderate | High for time-sensitive topics | Publication date, "Updated [date]", freshness in content |
| **Citation by other sources** | Very high | Very high — cross-citation is a strong trust signal | Earn backlinks and mentions from industry sources |

#### 4.2 Author Bios That AI Models Trust

```html
<!-- ✅ AI-FRIENDLY: Specific credentials, experience, verifiable -->
<div class="author-bio" itemscope itemtype="https://schema.org/Person">
  <strong itemprop="name">Sarah Chen</strong>,
  <span itemprop="jobTitle">Senior Kitchen Designer</span> at
  <span itemprop="worksFor">HomeStyle Studios</span>.
  <span itemprop="description">15 years of residential renovation experience.
  NKBA-certified. Has designed 200+ kitchen remodels in the $30K-$150K range.</span>
</div>

<!-- ❌ AI-HOSTILE: No credentials, no specificity -->
<p>Written by our team.</p>
```

#### 4.3 Original Research and Data

Original data is the strongest AI citation magnet. LLMs heavily cite statistics, survey results, and proprietary data because they are unique and attributable.

**High-citation content patterns:**
- "We surveyed 500 [professionals/consumers] and found..."
- "Our analysis of 10,000 [data points] shows..."
- "Based on our internal data from [timeframe]..."
- Industry benchmarks with your company's dataset
- Annual/quarterly reports with trend data

**Example:**
```markdown
## Average SaaS Churn Rate by Company Stage (2026 Data)

Based on our analysis of 847 SaaS companies using [YourProduct], the median
monthly churn rate varies significantly by company stage:

| Company Stage | Median Monthly Churn | 25th Percentile | 75th Percentile |
|--------------|---------------------|-----------------|-----------------|
| Pre-seed / MVP | 8.2% | 5.1% | 12.4% |
| Seed ($1-3M ARR) | 5.7% | 3.2% | 8.1% |
| Series A ($3-10M ARR) | 3.4% | 2.1% | 5.2% |
| Series B+ ($10M+ ARR) | 2.1% | 1.3% | 3.0% |

*Source: [YourCompany] Customer Benchmark Report, Q1 2026. N=847 companies.*
```

This kind of content gets cited because it is specific, sourced, formatted for extraction, and cannot be found elsewhere.

#### 4.4 Expert Quotes

Named expert quotes with credentials increase citation probability:

```markdown
"The biggest mistake homeowners make is underestimating plumbing costs during
renovation," says **Michael Torres, Master Plumber (25 years) and owner of
Torres Plumbing in Austin, TX**. "Moving a sink or dishwasher even a few feet
can add $2,000-$5,000 to your project."
```

AI models treat attributed quotes as evidence. Unattributed claims are lower-trust.

---

### Step 5: Technical Optimization

#### 5.1 AI Bot Crawlability

AI companies crawl the web using identifiable user agents. Your `robots.txt` decisions directly control which AI models can index your content:

| Bot | Company | Purpose | User Agent String |
|-----|---------|---------|-------------------|
| GPTBot | OpenAI | Training + Browse retrieval | `GPTBot` |
| ChatGPT-User | OpenAI | Real-time browsing in ChatGPT | `ChatGPT-User` |
| ClaudeBot | Anthropic | Training data | `ClaudeBot` |
| PerplexityBot | Perplexity | Index for search answers | `PerplexityBot` |
| Google-Extended | Google | AI model training (separate from Googlebot) | `Google-Extended` |
| Bytespider | ByteDance | Training data | `Bytespider` |
| CCBot | Common Crawl | Open training data | `CCBot` |

**robots.txt Decision Framework:**

```
# OPTION A: Allow all AI bots (maximum visibility)
# Recommended for: content businesses, publishers seeking AI citations,
# anyone whose business benefits from maximum distribution

User-agent: GPTBot
Allow: /

User-agent: ChatGPT-User
Allow: /

User-agent: PerplexityBot
Allow: /

User-agent: ClaudeBot
Allow: /

User-agent: Google-Extended
Allow: /

# OPTION B: Selective access (balanced approach)
# Recommended for: businesses that want AI search visibility but want
# to control which models train on their content

User-agent: ChatGPT-User
Allow: /
# (Allow browsing so ChatGPT can cite you in real-time)

User-agent: PerplexityBot
Allow: /
# (Allow indexing for Perplexity citations)

User-agent: GPTBot
Disallow: /
# (Block training data collection)

User-agent: Google-Extended
Disallow: /
# (Block AI training, still indexed by regular Googlebot)

# OPTION C: Block all AI bots (content protection)
# Recommended for: premium content behind paywalls, content where
# unauthorized use is a business risk
# WARNING: This eliminates all AI search visibility

User-agent: GPTBot
Disallow: /

User-agent: ChatGPT-User
Disallow: /

User-agent: PerplexityBot
Disallow: /
```

**Critical distinction:** Blocking `GPTBot` blocks training data collection but does NOT block ChatGPT Browse (that's `ChatGPT-User`). Blocking `Googlebot` blocks both traditional AND AI Overviews. Be precise about what you're blocking and why.

#### 5.2 Page Speed and Crawl Budget

AI bots operate under crawl budgets just like traditional search bots. Slow pages get crawled less:

- **Target**: < 2 second load time for AI bot accessibility
- **Priority**: Server response time (TTFB) matters more than client-side rendering for bots
- **Static HTML preference**: AI bots handle server-rendered HTML better than client-side JavaScript rendering
- **SSR or pre-rendering**: If your site is a SPA (React, Vue, etc.), server-side render or pre-render pages for bots

```bash
# Check if your page renders content without JavaScript
curl -s https://yoursite.com/target-page | grep -c "<article\|<main\|<h1"
# If 0, your content requires JS — AI bots may not see it
```

#### 5.3 Clean HTML Semantics

AI models extract content more reliably from semantic HTML:

```html
<!-- ✅ SEMANTIC: Clear content boundaries -->
<article>
  <header>
    <h1>Article Title</h1>
    <p class="byline">By <span rel="author">Jane Smith</span></p>
    <time datetime="2026-03-15">March 15, 2026</time>
  </header>
  <section>
    <h2>Key Finding</h2>
    <p>The direct answer to the topic question...</p>
  </section>
</article>

<!-- ❌ NON-SEMANTIC: Content buried in divs -->
<div class="wrapper">
  <div class="header-block">
    <div class="title-text">Article Title</div>
    <div class="meta-info">By Jane Smith | March 15, 2026</div>
  </div>
  <div class="body-content">
    <div class="section-title">Key Finding</div>
    <div class="section-body">The answer...</div>
  </div>
</div>
```

#### 5.4 Content Accessibility Checklist

```bash
# Verify your page is accessible to AI bots

# 1. Check robots.txt for AI bot rules
curl -s https://yoursite.com/robots.txt | grep -iE "gptbot|chatgpt|perplexity|claudebot|google-extended"

# 2. Check if llms.txt exists
curl -s -o /dev/null -w "%{http_code}" https://yoursite.com/llms.txt

# 3. Check page renders without JavaScript
curl -s https://yoursite.com/target-page | wc -c
# Compare to browser-rendered size — large discrepancy = JS-dependent content

# 4. Check for meta robots noindex
curl -s https://yoursite.com/target-page | grep -i "noindex"

# 5. Check structured data
curl -s https://yoursite.com/target-page | grep -c "application/ld+json"

# 6. Check page speed (using Google PageSpeed API)
curl -s "https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url=https://yoursite.com/target-page&strategy=mobile" | python3 -c "import sys,json;d=json.load(sys.stdin);print('Performance:',d['lighthouseResult']['categories']['performance']['score']*100)"
```

---

### Step 6: Content Strategy for AI Visibility

Certain content formats are disproportionately cited by AI search engines. Build a content strategy around these high-citation formats:

#### 6.1 Question-First Content

AI search queries are overwhelmingly questions. Structure content to match:

**High-citation patterns:**
- "What is [term]?" -- definition pages
- "How to [task]?" -- tutorial/guide pages
- "Why does [phenomenon] happen?" -- explainer pages
- "When should you [action]?" -- decision-guide pages
- "[X] vs [Y]: which is better?" -- comparison pages

**Content template:**
```markdown
# [Question as H1]

[Direct 1-2 sentence answer — this is what gets cited]

[Expanded context — 2-3 paragraphs with supporting detail]

## [Sub-question 1]
[Direct answer + detail]

## [Sub-question 2]
[Direct answer + detail]

## Key Takeaways
- [Takeaway 1 — concise, factual]
- [Takeaway 2 — concise, factual]
- [Takeaway 3 — concise, factual]
```

#### 6.2 Comparison Content

"Best X for Y" and "[A] vs [B]" queries are among the most common AI search patterns:

```markdown
# Best Project Management Tools for Remote Teams (2026)

## Quick Answer
The best project management tool for remote teams depends on team size and workflow:
- **Small teams (< 10)**: Linear — fast, keyboard-driven, minimal overhead
- **Mid-size teams (10-50)**: Notion — flexible, combines docs + tasks
- **Enterprise (50+)**: Jira — mature, integrations, compliance features

## Detailed Comparison

| Tool | Best For | Price | Key Strength | Key Weakness |
|------|----------|-------|-------------|-------------|
| Linear | Engineering teams | $8/user/mo | Speed, UX | Limited non-dev features |
| Notion | Cross-functional teams | $10/user/mo | Flexibility | Performance at scale |
| Jira | Enterprise/regulated | $8.15/user/mo | Customization | Complexity |
```

#### 6.3 Statistics and Data Pages

AI models cite statistics constantly. A well-structured statistics page can generate citations across hundreds of AI search queries:

```markdown
# Email Marketing Statistics (2026)

## Key Email Marketing Stats
- Average email open rate across all industries: **21.3%** (Source: Mailchimp, 2026)
- Average click-through rate: **2.6%** (Source: Mailchimp, 2026)
- Email marketing ROI: **$36 for every $1 spent** (Source: Litmus, 2025)
- 89% of marketers use email as the primary channel for lead generation (Source: HubSpot, 2026)

## Open Rates by Industry
| Industry | Open Rate | Click Rate | Unsubscribe Rate |
|----------|-----------|------------|-------------------|
| Education | 28.5% | 4.3% | 0.2% |
| E-commerce | 15.7% | 2.0% | 0.3% |
| SaaS/Technology | 22.1% | 2.8% | 0.2% |
```

**Why this works:** LLMs answering "what is the average email open rate" will scan for pages with exactly this data point, clearly formatted and sourced.

#### 6.4 Glossary and Definition Pages

Glossary pages are high-value AI citation targets because they map directly to "what is" queries:

```markdown
# [Industry] Glossary: Key Terms Explained

## A

### A/B Testing
**A/B testing** (also called split testing) is a method of comparing two versions of a
webpage, email, or other content to determine which performs better. Traffic is randomly
split between version A (control) and version B (variant), and conversion rates are
compared for statistical significance.

### ARR (Annual Recurring Revenue)
**ARR** is the annualized value of recurring subscription revenue...
```

#### 6.5 Tool and Calculator Pages

Interactive tools generate AI citations because models reference them as resources:

- ROI calculators ("Use [YourBrand]'s ROI calculator to estimate...")
- Cost estimators
- Comparison tools
- Assessment/quiz tools
- Free checklist generators

Even though LLMs can't interact with the tool, they cite the page *as a resource* users should visit.

#### 6.6 Content Freshness Strategy

AI search engines weight freshness for time-sensitive queries:

- **Update cornerstone content quarterly** with new data, examples, and dates
- **Include visible "Last Updated" dates** — `<time datetime="2026-03-15">Updated March 2026</time>`
- **Avoid evergreen-only strategy** — mix timely content (annual reports, trend analysis) with evergreen
- **Republish with new data** — don't just update silently; include a "What's New in [Year]" section

---

### Step 7: Monitoring and Measurement

AI search visibility is harder to measure than traditional SEO because AI engines don't provide analytics dashboards. Use these methods:

#### 7.1 Manual Testing Protocol

Run this monthly for your target queries:

```
AI SEARCH VISIBILITY AUDIT

Date: [YYYY-MM-DD]
Queries tested: [N]

For each target query, test in all 4 engines:

| Query | ChatGPT | Perplexity | Google AI Overview | Bing Copilot |
|-------|---------|------------|-------------------|--------------|
| "[query 1]" | ❌ Not cited | ✅ Cited (#3) | ✅ In overview | ❌ Not cited |
| "[query 2]" | ✅ Cited (#1) | ✅ Cited (#1) | ❌ No overview | ✅ Cited (#2) |

Legend:
✅ Cited (#N) = your content cited, with position if applicable
🟡 Mentioned = brand/content referenced but no link
❌ Not cited = not present in answer
⬜ No AI answer = engine showed traditional results only
```

#### 7.2 Competitive Monitoring

Track who IS getting cited for your target queries:

```
COMPETITIVE AI CITATION ANALYSIS

Query: "best CRM for small business"

| Engine | Cited Sources | Our Position |
|--------|--------------|-------------|
| ChatGPT | Forbes, HubSpot, Salesforce blog, PCMag | Not cited |
| Perplexity | G2, HubSpot, Forbes, TechRadar, Capterra | Not cited |
| Google AI | HubSpot, Forbes, PCMag, NerdWallet | Not cited |

Pattern: Forbes and HubSpot appear in 3/3 engines.
Action: Analyze their content structure, authority signals, and format.
```

#### 7.3 Automated Monitoring Approaches

Currently no API-based monitoring exists for most AI search engines. Practical options:

- **Perplexity**: Their API allows programmatic queries — build a monitoring script that checks your target queries weekly
- **Google AI Overviews**: No direct API, but Google Search Console may show impressions from AI Overview clicks (limited data)
- **ChatGPT/Bing Copilot**: Manual testing only as of early 2026
- **Third-party tools**: Emerging tools like Otterly.ai, Profound, and GeoMonitor track AI search citations — evaluate these as the space matures
- **Referrer log analysis**: Check server logs for traffic from AI platforms (`chat.openai.com`, `perplexity.ai`, `bing.com/chat`)

```bash
# Check server logs for AI referrer traffic
grep -iE "perplexity|openai|chat\.bing|copilot" /var/log/nginx/access.log | awk '{print $11}' | sort | uniq -c | sort -rn
```

#### 7.4 Key Metrics to Track

| Metric | How to Measure | Cadence |
|--------|---------------|---------|
| Citation count (per engine) | Manual audit of target queries | Monthly |
| Citation position | Note if cited #1, #2, etc. | Monthly |
| Competitor citation share | Who gets cited instead of you | Monthly |
| AI referrer traffic | Server logs / analytics referrer data | Weekly |
| llms.txt requests | Server logs for `/llms.txt` requests | Monthly |
| Content structure score | Internal audit of citability patterns | Quarterly |

---

### Step 8: Output

Deliver the AI Search Optimization Report:

```
━━━ AI SEARCH VISIBILITY REPORT ━━━━━━━━━━

── CURRENT STATE ─────────────────────────
Website: [url]
Industry: [industry]
Queries tested: [N]
Current citation rate: [X]% across [N] target queries
Best-performing engine: [engine] ([X]% citation rate)
Worst-performing engine: [engine] ([X]% citation rate)

── AI BOT ACCESS ─────────────────────────
GPTBot:        [✅ Allowed / ❌ Blocked / ⚠️ No robots.txt rule]
ChatGPT-User:  [✅ Allowed / ❌ Blocked / ⚠️ No robots.txt rule]
PerplexityBot: [✅ Allowed / ❌ Blocked / ⚠️ No robots.txt rule]
ClaudeBot:     [✅ Allowed / ❌ Blocked / ⚠️ No robots.txt rule]
Google-Extended:[✅ Allowed / ❌ Blocked / ⚠️ No robots.txt rule]
llms.txt:      [✅ Present / ❌ Missing]

── CONTENT STRUCTURE SCORE ───────────────
Question-based headings:     [✅ / ❌] [X]% of pages
Direct answer formatting:    [✅ / ❌] [X]% of pages
FAQ schema:                  [✅ / ❌] [X] pages
Comparison tables:           [✅ / ❌] [X] pages
Statistics with sources:     [✅ / ❌] [X] pages
Author bios with credentials:[✅ / ❌] [X]% of articles

── AUTHORITY ASSESSMENT ──────────────────
Domain authority: [score]
Author credentials visible: [yes/no]
Original research/data: [yes/no — describe]
Expert quotes: [frequency]
External citations of your content: [estimate]

── COMPETITIVE LANDSCAPE ─────────────────
Top cited competitors: [list with citation frequency]
Competitor advantages: [what they do that you don't]
Your advantages: [unique data, expertise, format]

── RECOMMENDATIONS ───────────────────────

🔴 HIGH PRIORITY (implement within 2 weeks):
1. [Recommendation — specific, actionable, with expected impact]
2. [Recommendation]
3. [Recommendation]

🟡 MEDIUM PRIORITY (implement within 1 month):
4. [Recommendation]
5. [Recommendation]

🟢 ONGOING (build into content workflow):
6. [Recommendation]
7. [Recommendation]

── CONTENT PLAN ──────────────────────────

| Priority | Content Piece | Target Queries | Format | Est. Impact |
|----------|--------------|----------------|--------|-------------|
| P1 | [title] | [queries it targets] | [format] | [High/Med/Low] |
| P1 | [title] | [queries it targets] | [format] | [High/Med/Low] |
| P2 | [title] | [queries it targets] | [format] | [High/Med/Low] |
| P2 | [title] | [queries it targets] | [format] | [High/Med/Low] |
| P3 | [title] | [queries it targets] | [format] | [High/Med/Low] |

── MEASUREMENT PLAN ──────────────────────
Baseline date: [today]
Next audit: [date — 30 days]
Queries to monitor: [list]
Engines to check: ChatGPT, Perplexity, Google AI Overviews, Bing Copilot
Success metric: [X]% citation rate increase within [timeframe]
```

---

## Known vs Speculative Guidance

This is a rapidly evolving field. Be transparent with users about certainty levels:

| Category | Confidence | Basis |
|----------|------------|-------|
| Content structure improves AI citation | **High** | Published research (GEO papers, industry data), consistent empirical observation |
| robots.txt controls bot access | **High** | Documented by OpenAI, Google, Perplexity |
| E-E-A-T signals influence AI citation | **High** | Google's published guidelines + observed AI Overview behavior |
| Original data/statistics are highly citable | **High** | Consistent across all AI search engines empirically |
| llms.txt will become a standard | **Speculative** | Early adoption, no universal commitment from AI companies |
| Perplexity citation volume advantage | **Moderate** | Observed but may change as product evolves |
| SpeakableSpecification improves AI extraction | **Moderate** | Schema.org standard, limited empirical data for AI specifically |
| AI search will replace significant traditional search volume | **Speculative** | Trend is clear, magnitude is uncertain |
| Specific ranking algorithms of AI search engines | **Unknown** | No AI search engine has published ranking criteria |

**Rule:** Always disclose when a recommendation is based on emerging patterns rather than established best practices. Never present speculation as fact.

---

## Anti-Patterns

- **Keyword stuffing for AI**: LLMs are not keyword-density matchers. Unnaturally repeating terms hurts readability without improving AI citation. Write naturally with topical depth.
- **Blocking all AI bots then expecting AI visibility**: You cannot be cited if you block the crawlers. Make a deliberate, informed robots.txt decision.
- **Ignoring traditional SEO**: Google AI Overviews pull from the organic index. If you don't rank organically, AI Overviews won't cite you. GEO is additive to SEO, not a replacement.
- **Creating thin "answer" pages**: A page with only a 2-sentence answer and no depth will not build authority. AI models prefer comprehensive sources where the direct answer is supported by extensive context.
- **Optimizing for one engine only**: AI search is multi-engine. Content structured well for one engine generally performs across all of them.
- **Chasing AI search at the expense of users**: If your content reads like it was written for a bot, humans won't engage, share, or link to it — destroying the authority signals that AI models rely on.
- **Assuming AI search behavior is static**: These engines update constantly. Strategies that work today may need adjustment. Build a monitoring cadence, not a one-time optimization.
- **Treating GEO as a black box hack**: There is no trick to "gaming" AI search. The fundamentals are: be the best, clearest, most authoritative source on your topic. The structural optimizations in this skill help AI models *find* and *extract* your content — they don't substitute for quality.

## Escalation

Hand off to a specialist or pause the engagement when:

- The site has fundamental SEO problems (no organic rankings, major technical issues) — fix traditional SEO first via the **site-audit** skill
- The content is in a YMYL (Your Money Your Life) category and the user lacks genuine E-E-A-T — no amount of formatting will overcome missing real expertise
- Legal/copyright concerns about AI training on their content require legal counsel, not technical optimization
- The user's business model depends on paywall content and they're unsure about allowing AI bot access — this is a business strategy decision, not a technical one
- Competitive landscape is dominated by Wikipedia, government sites, or medical/legal authorities that cannot be realistically outranked in AI citations

## Inputs

- Website URL and pages to optimize
- Target queries (5-15 questions users ask that the site should answer)
- Content type and industry
- Current AI search visibility (tested or untested)
- Existing SEO status (domain authority, organic rankings)
- robots.txt current state
- Business goals for AI search visibility

## Outputs

- AI Search Visibility Report (current state assessment)
- AI bot access audit (robots.txt + llms.txt)
- Content structure score with specific fixes
- Authority signal assessment
- Competitive citation analysis
- Prioritized recommendations (high/medium/ongoing)
- Content plan with target queries, formats, and expected impact
- Measurement plan with baseline and monitoring cadence

## Level History

- **Lv.1** — Base: Full 8-step protocol covering AI search landscape (ChatGPT, Perplexity, Google AI Overviews, Bing Copilot), content structure for citability (heading hierarchy, direct answer formatting, FAQ schema, definition patterns, comparison tables, SpeakableSpecification), authority signals (E-E-A-T for AI, author bios, original research, expert quotes), technical optimization (AI bot crawlability, robots.txt decision framework, llms.txt, page speed, semantic HTML), content strategy (question-first, comparison, statistics, glossary, tools, freshness), monitoring and measurement (manual testing protocol, competitive analysis, referrer tracking, key metrics), known vs speculative transparency matrix. (Origin: MemStack v3.3, Mar 2026)
