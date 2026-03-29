---
name: blog-post
description: "Use when the user says 'write blog post', 'blog post about', 'write article', 'create blog', 'content for blog', or is creating long-form written content for a blog or publication. Do NOT use for landing page copy (see landing-page-copy), email sequences (see email-sequence), or social media posts (see twitter-thread)."
---

# Blog Post -- Long-Form Content Creation
*Produce a complete, publish-ready blog post with SEO metadata, structured sections, readability optimization, and internal linking suggestions.*

## Activation

When this skill activates, output:

`Blog Post -- Crafting your article...`

| Context | Status |
|---------|--------|
| **User says "write blog post", "blog post about", "write article"** | ACTIVE |
| **User says "create blog", "content for blog", "write a post about"** | ACTIVE |
| **User provides a topic and wants long-form written content** | ACTIVE |
| **User wants to create a guest post, thought leadership piece, or tutorial** | ACTIVE |
| **User wants landing page copy (not editorial content)** | DORMANT -- see landing-page-copy |
| **User wants email sequences or drip campaigns** | DORMANT -- see email-sequence |
| **User wants social media posts or threads** | DORMANT -- see twitter-thread |
| **User wants newsletter content** | DORMANT -- see newsletter |
| **User wants product descriptions** | DORMANT -- see product-description |

---

## Protocol

### Step 1: Gather Inputs

Collect the following from the user. Ask for anything not provided -- do not assume defaults silently.

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| **Topic** | Yes | -- | The subject of the blog post |
| **Target audience** | Yes | -- | Who is reading this? Role, experience level, industry |
| **Tone** | No | Professional, conversational | Options: formal, conversational, witty, authoritative, empathetic, edgy |
| **Word count target** | No | 1,500-2,000 | Short (800-1,200), Standard (1,500-2,000), Long-form (2,500-4,000), Pillar (4,000+) |
| **Primary SEO keyword** | No | Derived from topic | The main search term to target |
| **Secondary keywords** | No | Derived from primary | 3-5 supporting terms and long-tail variations |
| **CTA goal** | No | Newsletter signup | What action should the reader take after reading? |
| **Publication platform** | No | Generic blog | WordPress, Medium, Substack, Ghost, Dev.to, company blog, LinkedIn article |
| **Existing content** | No | None | Links to competitor articles or internal posts on the same topic |
| **Brand voice notes** | No | None | Any style guide references, words to avoid, required terminology |

**Example input prompt:**

> Write a blog post about "Why most startups fail at database design" for technical founders, conversational tone, 2,000 words, targeting "startup database design" keyword. CTA: sign up for our database architecture review service.

### Step 2: Research and Angle

Before writing, establish the article's strategic position. This step determines whether the post will stand out or blend into existing search results.

#### 2a: Competitive Content Analysis

Evaluate the existing content landscape for the target keyword:

- **Search intent classification**: Is the searcher looking for informational, navigational, commercial, or transactional content? Match the post format to the dominant intent.
- **Content gap identification**: What do the top 5-10 results cover? What do they all miss? The gap is your angle.
- **Depth assessment**: Are competing articles surface-level listicles or deep technical guides? Go deeper than the best existing piece OR take a radically different format.

#### 2b: Unique Angle Development

Every blog post needs a thesis -- a single, defensible claim that makes this article worth reading over every other article on the same topic.

**Angle frameworks:**

| Framework | When to use | Example |
|-----------|-------------|---------|
| **Contrarian** | When conventional wisdom is wrong or incomplete | "You don't need microservices -- here's why monoliths win at scale" |
| **Experience report** | When first-hand data backs the argument | "We migrated 4TB from MongoDB to PostgreSQL: here's what broke" |
| **Synthesis** | When you can connect ideas others haven't | "What cognitive load theory teaches us about API design" |
| **Update** | When best practices have changed and content is outdated | "Everything you learned about REST pagination in 2020 is wrong now" |
| **Framework** | When you can give readers a mental model | "The 3-layer test: how to evaluate any database for your startup" |
| **Deep dive** | When the topic deserves more rigor than it usually gets | "Connection pooling from first principles: what actually happens under the hood" |

Output the chosen angle as:

```
ANGLE: [1-sentence thesis]
FORMAT: [Problem/Solution | How-To | Listicle | Comparison | Case Study | Opinion]
DIFFERENTIATOR: [What this post does that competing content does not]
```

#### 2c: Hook Development

Draft 3 candidate hooks (Step 4 will refine the winner). Having options prevents settling for the first idea.

### Step 3: Outline Architecture

Build a full section-by-section outline before writing any prose. The outline is the structural contract -- no section should exist without a clear purpose.

#### 3a: Choose a Blog Structure

Select the structure that best fits the topic, audience, and angle:

**Problem/Solution**
```
H1: [Title]
  H2: The Problem (with evidence)
  H2: Why It Happens (root cause analysis)
  H2: The Solution (your approach)
    H3: Implementation Step 1
    H3: Implementation Step 2
    H3: Implementation Step 3
  H2: Results / What to Expect
  H2: Conclusion + CTA
```

**How-To / Tutorial**
```
H1: [Title]
  H2: What You'll Build / Learn (outcome preview)
  H2: Prerequisites
  H2: Step 1: [Action verb phrase]
    H3: Sub-step details
  H2: Step 2: [Action verb phrase]
  H2: Step 3: [Action verb phrase]
  H2: Common Mistakes to Avoid
  H2: Next Steps + CTA
```

**Listicle**
```
H1: [Number] [Topic] [Qualifier]
  H2: 1. [Item] -- [Benefit or hook]
  H2: 2. [Item] -- [Benefit or hook]
  H2: ...
  H2: How to Choose the Right One
  H2: Conclusion + CTA
```

**Comparison**
```
H1: [Option A] vs [Option B]: [Decision frame]
  H2: Quick Verdict (for skimmers)
  H2: [Criterion 1] -- [Winner]
  H2: [Criterion 2] -- [Winner]
  H2: [Criterion 3] -- [Winner]
  H2: When to Use [A] vs [B]
  H2: Conclusion + CTA
```

**Case Study**
```
H1: [Result] -- How [Company/Person] [Achieved outcome]
  H2: The Situation (before state)
  H2: The Challenge (what made it hard)
  H2: The Approach (what was done)
    H3: Decision 1
    H3: Decision 2
  H2: The Results (quantified outcomes)
  H2: Lessons Learned
  H2: Apply This to Your [Context] + CTA
```

**Opinion / Thought Leadership**
```
H1: [Provocative claim]
  H2: The Conventional Wisdom (and why it's wrong)
  H2: What I've Seen Instead (evidence)
  H2: A Better Mental Model
  H2: What This Means for You
  H2: Conclusion + CTA
```

#### 3b: Section Planning

For each H2 section, define:

| Section | Purpose | Length (words) | Key evidence | Transition to next |
|---------|---------|----------------|-------------|-------------------|
| Introduction | Hook + thesis + promise | 150-250 | Opening stat/story | "Let's start with..." |
| Section 2 | ... | ... | ... | ... |
| ... | ... | ... | ... | ... |
| Conclusion | Summarize + CTA | 150-200 | Callback to opening | -- |

Aim for 4-7 H2 sections for a standard post, 7-12 for pillar content.

#### 3c: Evidence Planning

For each major claim, identify the type of evidence needed:

| Evidence Type | Best For | Example |
|---------------|----------|---------|
| **Statistic** | Establishing scale, urgency | "73% of developers report..." |
| **Case study** | Proving something works | "When Stripe migrated to..." |
| **Expert quote** | Lending authority | "As Martin Fowler argues..." |
| **Code example** | Technical tutorials | Working code snippet |
| **Analogy** | Explaining complex concepts | "Database indexing is like a book's table of contents" |
| **Personal experience** | Building trust | "In my 8 years of consulting, I've seen..." |
| **Comparison** | Making abstract concrete | "That's the equivalent of loading the entire Wikipedia for each page view" |

### Step 4: Hook and Introduction

The introduction must accomplish three things in the first 150 words: grab attention, establish the problem, and promise value.

#### 4a: Hook Patterns

Select one of five proven hook patterns based on the topic and audience:

**1. Stat-Lead Hook**
Opens with a surprising or alarming number.
```
"78% of database performance issues trace back to decisions made in the first week
of a project. Not the last week. The first."
```
Best for: data-driven audiences, B2B, establishing urgency.

**2. Question Hook**
Opens with a question the reader can't help but answer mentally.
```
"When was the last time you looked at your database schema and thought,
'This was a great decision'?"
```
Best for: engaging skeptics, self-assessment topics, common pain points.

**3. Story Hook**
Opens with a micro-narrative (2-4 sentences) that illustrates the problem.
```
"At 2 AM on a Tuesday, our on-call engineer got paged. The dashboard was red.
Response times had spiked to 14 seconds. The root cause? A JOIN across three
unindexed tables that had been fine at 10,000 rows but catastrophic at 10 million."
```
Best for: technical audiences, case studies, emotionally resonant topics.

**4. Contrarian Hook**
Opens by contradicting a widely held belief.
```
"You've been told to normalize your database. Every tutorial, every textbook,
every senior engineer at your last job. They're not wrong exactly -- but they're
giving you advice for a world that no longer exists."
```
Best for: thought leadership, opinion pieces, experienced audiences who've heard the standard advice.

**5. Pain-Point Hook**
Opens by describing the reader's current frustrating situation with specificity.
```
"You're three months into your startup. The MVP works. Users are signing up.
And then someone runs a report and the whole app locks up for 45 seconds.
You stare at the query plan and realize you have to redesign the schema --
but the data is already live."
```
Best for: problem/solution posts, product-aware audiences, how-to content.

#### 4b: Introduction Template

After the hook, complete the introduction with this structure:

```
[HOOK: 1-3 sentences using one of the five patterns above]

[CONTEXT: 1-2 sentences establishing why this matters now]

[THESIS: 1 sentence stating the article's core argument or promise]

[ROADMAP: 1 sentence previewing what the reader will learn]
```

**Example complete introduction:**

> At 2 AM on a Tuesday, our on-call engineer got paged. Response times had spiked to 14 seconds. The root cause? A three-way JOIN across unindexed tables that worked fine at 10,000 rows but collapsed at 10 million.
>
> This isn't a rare story. Most startups treat database design as an afterthought -- something to fix "when we scale." But by the time you scale, the cost of fixing it has multiplied tenfold.
>
> In this guide, I'll walk through the five database design decisions that most commonly derail startups, and show you how to get them right from day one -- without over-engineering.

### Step 5: Body Writing

#### 5a: Paragraph Structure

Each paragraph in the body should follow one of these patterns:

**Claim-Evidence-Implication (CEI)** -- the workhorse paragraph:
```
[CLAIM: One clear assertion]
[EVIDENCE: Data, example, or quote supporting the claim]
[IMPLICATION: Why this matters to the reader]
```

**Problem-Cause-Solution (PCS)** -- for actionable content:
```
[PROBLEM: What goes wrong]
[CAUSE: Why it goes wrong (root cause, not symptom)]
[SOLUTION: What to do instead, with specifics]
```

**Observation-Insight-Application (OIA)** -- for thought leadership:
```
[OBSERVATION: Something the reader has noticed but not analyzed]
[INSIGHT: The non-obvious explanation or pattern]
[APPLICATION: How the reader can use this understanding]
```

Keep paragraphs to 3-5 sentences. Single-sentence paragraphs are permitted for emphasis but should appear no more than twice per 1,000 words.

#### 5b: Transition Patterns

Never let sections feel disconnected. Use explicit transitions between H2 sections:

| Transition Type | Example | Use When |
|----------------|---------|----------|
| **Bridge** | "That explains the what. Now let's look at the how." | Moving from concept to implementation |
| **Contrast** | "But there's a catch." | Introducing a complication or caveat |
| **Escalation** | "If that wasn't bad enough, there's a deeper problem." | Building tension before the solution |
| **Callback** | "Remember the 2 AM incident from the intro? Here's how it could have been prevented." | Tying back to the opening |
| **Question** | "So how do you actually implement this without grinding your project to a halt?" | Introducing a practical section |
| **Summary-advance** | "So far we've covered X. Next, we need to address Y." | Maintaining orientation in long posts |

#### 5c: Technical Content

For technical blog posts, code examples are essential evidence. Follow these rules:

- **Every code block must have context.** Precede it with a sentence explaining what it does and why.
- **Show the wrong way first, then the right way.** "Before/after" is more instructive than "here's the correct way."
- **Use realistic variable names.** Not `foo`/`bar` -- use domain-relevant names.
- **Keep examples self-contained.** The reader should be able to copy-paste and understand without scrolling.
- **Annotate with comments** only where the code isn't self-explanatory.

Example pattern for technical posts:

```
Here's what most teams do when they first encounter this problem:

```python
# The naive approach -- works, but doesn't scale
def get_user_orders(user_id):
    user = db.query("SELECT * FROM users WHERE id = %s", [user_id])
    orders = db.query("SELECT * FROM orders WHERE user_id = %s", [user_id])
    for order in orders:
        order['items'] = db.query("SELECT * FROM items WHERE order_id = %s", [order['id']])
    return user, orders
```

This generates N+1 queries -- one for orders, then one per order for items. At 10 orders, you get 12 queries. At 1,000, you get 1,002. Here's the fix:

```python
# Single query with JOIN -- constant time regardless of order count
def get_user_orders(user_id):
    return db.query("""
        SELECT u.*, o.*, i.*
        FROM users u
        JOIN orders o ON o.user_id = u.id
        JOIN items i ON i.order_id = o.id
        WHERE u.id = %s
    """, [user_id])
```
```

#### 5d: Visual Callouts

Use formatting elements to break up wall-of-text and highlight key information:

**Blockquotes** -- for key insights, expert quotes, or important warnings:
> The most expensive database migration is the one you do after launch.

**Bold key phrases** -- for scanners who read in F-pattern:
> The critical mistake is **treating schema design as a one-time decision** rather than an evolving contract.

**Bullet lists** -- for 3+ parallel items:
- Use when listing options, steps, or characteristics
- Keep each bullet to 1-2 lines maximum
- Start each with the same part of speech (parallel structure)

**Tables** -- for comparisons and structured data:

| Feature | PostgreSQL | MongoDB | When to Choose |
|---------|-----------|---------|---------------|
| Schema | Rigid | Flexible | Rigid when data shape is known |
| Joins | Native | Manual | PostgreSQL for relational data |
| Scale | Vertical first | Horizontal first | MongoDB for massive write volume |

**Callout boxes** (platform-dependent -- use blockquotes as fallback):
> **Key Takeaway:** Your database schema is a bet on your data's future shape. Make the bet explicit.

#### 5e: Data Presentation

When presenting statistics or data:

- **Cite the source** inline: "According to [Source, Year]..."
- **Contextualize numbers**: "That's equivalent to..." or "To put this in perspective..."
- **Use specific numbers over vague ones**: "73% of respondents" beats "most respondents"
- **Prefer recent data**: Anything older than 3 years should be flagged with a note
- **Round sensibly**: "roughly 3 out of 4" can be more memorable than "74.7%"

### Step 6: SEO Optimization

#### 6a: Title Tag

Construct the title tag (displayed in search results) separately from the H1. The H1 can be longer or more creative; the title tag must be concise and keyword-forward.

**Title tag formula:** `[Primary Keyword]: [Benefit or Qualifier] ([Year] if evergreen)`

**Constraints:**
- 50-60 characters (truncation threshold on Google)
- Primary keyword within the first 40 characters
- Include a power word: guide, proven, essential, complete, ultimate, mistakes, why, how

**Headline formulas:**

| Formula | Example |
|---------|---------|
| How to [Task] Without [Pain Point] | How to Scale PostgreSQL Without Downtime |
| [Number] [Topic] Mistakes That [Consequence] | 7 Database Design Mistakes That Kill Startups |
| [Topic]: A [Qualifier] Guide for [Audience] | Connection Pooling: A Practical Guide for Node.js Developers |
| Why [Conventional Wisdom] Is Wrong (And What to Do Instead) | Why "Normalize Everything" Is Wrong (And What to Do Instead) |
| [Topic] vs [Topic]: [Decision Frame] | SQL vs NoSQL: How to Choose for Your Next Project |
| The [Adjective] Guide to [Topic] in [Year] | The Complete Guide to Database Indexing in 2026 |
| What [Notable Entity] Teaches Us About [Topic] | What Netflix's Data Architecture Teaches Us About Schema Design |
| [Task]: [Number] Lessons from [Experience] | Migrating to PostgreSQL: 5 Lessons from a 4TB Migration |

#### 6b: Meta Description

**Constraints:**
- 150-160 characters
- Include the primary keyword naturally
- Include a CTA or value proposition
- Do NOT duplicate the title

**Template:**
```
Learn [what the reader will learn] with [unique value prop]. [Proof element or CTA].
```

**Example:**
```
Learn why most startup databases fail under scale and how to design yours to grow
from day one. Includes schema templates and migration strategies.
```

#### 6c: Keyword Placement Map

Ensure the primary keyword and secondary keywords appear in these locations:

| Location | Primary Keyword | Secondary Keywords |
|----------|----------------|-------------------|
| **Title tag (H1)** | Required -- within first 40 chars | Optional |
| **Meta description** | Required -- natural placement | 1 secondary if it fits |
| **First 100 words** | Required | Not required |
| **At least 1 H2** | Required | At least 1 per secondary |
| **Image alt text** | At least 1 instance | At least 1 instance |
| **Body text** | 3-5 natural occurrences per 1,000 words | 1-2 each per 1,000 words |
| **URL slug** | Required | Not required |
| **Last 100 words** | Recommended | Optional |

**Keyword density target:** 1-2% for primary keyword. If the keyword appears more than 2% of the time, rewrite -- it will read as spammy and may trigger search engine penalties.

#### 6d: Internal Linking Strategy

Recommend 3-5 internal link placements:

```
INTERNAL LINKS:
1. [anchor text] -> [target page URL or suggested page topic]
   Placement: [which section, which sentence]
   Rationale: [why this link helps the reader]

2. [anchor text] -> [target page URL or suggested page topic]
   Placement: [which section, which sentence]
   Rationale: [why this link helps the reader]
```

**Internal linking rules:**
- Link from body text, not headings
- Use descriptive anchor text (not "click here" or "read more")
- Link to pages that genuinely help the reader's next step
- Do not link the same anchor text to two different destinations
- Limit to 1 internal link per 300 words (more becomes distracting)

#### 6e: Image Alt Text

For each suggested image or visual:

```
IMAGE: [description of what the image should show]
ALT TEXT: [keyword-rich, descriptive alt text for accessibility and SEO]
PLACEMENT: [after which paragraph or section]
```

#### 6f: Schema Markup (Article)

Provide JSON-LD structured data for the Article schema:

```json
{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "[Title]",
  "description": "[Meta description]",
  "author": {
    "@type": "Person",
    "name": "[Author name]"
  },
  "publisher": {
    "@type": "Organization",
    "name": "[Publication name]"
  },
  "datePublished": "[ISO 8601 date]",
  "dateModified": "[ISO 8601 date]",
  "mainEntityOfPage": {
    "@type": "WebPage",
    "@id": "[URL]"
  },
  "keywords": "[primary keyword, secondary keywords]"
}
```

For how-to posts, also include `HowTo` schema with step-by-step markup. For FAQ sections, include `FAQPage` schema.

### Step 7: CTA and Conclusion

#### 7a: CTA Types

Match the CTA to the user's goal and the reader's awareness stage:

| CTA Type | Best For | Conversion Rate Benchmark | Example |
|----------|----------|--------------------------|---------|
| **Newsletter signup** | Top of funnel, thought leadership | 1-3% | "Get articles like this in your inbox every Thursday" |
| **Free resource download** | Lead magnet, list building | 3-8% | "Download our database design checklist (PDF)" |
| **Product trial/demo** | Product-aware readers | 0.5-2% | "Try our schema analyzer free for 14 days" |
| **Consultation/call** | High-ticket services | 0.2-1% | "Book a free 30-minute database architecture review" |
| **Related content** | Engagement, time-on-site | 5-15% CTR | "Read next: How to Monitor PostgreSQL in Production" |
| **Community join** | Community-led products | 2-5% | "Join 4,000+ developers in our Slack community" |
| **Social share** | Amplification, reach | 1-3% | "Found this useful? Share it with your team" |

#### 7b: CTA Placement Strategy

Do not save the CTA only for the end. Use a progressive CTA approach:

- **Soft CTA at ~40% mark**: A contextual mention, usually in a callout box. "If you're dealing with this right now, [our tool/service] can help -- [link]."
- **Medium CTA at ~70% mark**: After a particularly compelling section. "Want to go deeper? [Resource/action]."
- **Hard CTA at conclusion**: The primary conversion ask. Full sentence, clear value proposition, specific action.

#### 7c: Conclusion Patterns

The conclusion must accomplish three things: summarize without repeating, reinforce the thesis, and drive action.

**Pattern 1: Callback Close**
Return to the opening story/stat and resolve it.
```
"Remember that 2 AM page? With the design principles we've covered, that
JOIN would have been caught in week one -- not month twelve. [CTA]"
```

**Pattern 2: Key Takeaways Close**
Distill the article into 3-5 numbered takeaways, then CTA.
```
"Here's what to remember:
1. [Takeaway 1]
2. [Takeaway 2]
3. [Takeaway 3]

[CTA paragraph]"
```

**Pattern 3: Forward-Looking Close**
Connect the topic to a larger trend or future state.
```
"As data volumes continue to double every two years, the startups that treat
schema design as a first-class engineering discipline will outlast those that
don't. The best time to redesign your database was before launch.
The second-best time is today. [CTA]"
```

**Pattern 4: Challenge Close**
End with a direct challenge to the reader.
```
"Open your database schema right now. Run the five checks from this article.
If you find even two of these issues, you have work to do --
but at least now you know where to start. [CTA]"
```

### Step 8: Editorial Checklist and Output

#### 8a: Readability Targets

Before delivering the final draft, verify these metrics:

| Metric | Target | Tool |
|--------|--------|------|
| **Flesch Reading Ease** | 60-70 (standard), 45-55 (technical) | Hemingway, readable.com |
| **Average sentence length** | 15-20 words | Count manually or use Hemingway |
| **Paragraph length** | 3-5 sentences max | Visual scan |
| **Passive voice** | Under 10% of sentences | Hemingway app |
| **Adverb density** | Under 3% of word count | Manual scan |
| **Jargon density** | Define any term a first-year professional wouldn't know | Manual scan |
| **Heading frequency** | One H2/H3 every 250-350 words | Word count between headings |

#### 8b: Formatting Verification

| Check | Pass Criteria |
|-------|---------------|
| **H1** | Exactly one. Contains primary keyword. |
| **H2 sections** | 4-7 for standard, 7-12 for pillar. Each starts with a clear topic sentence. |
| **H3 sub-sections** | Used only under H2s. Never skip from H2 to H4. |
| **Lists** | No list exceeds 10 items (split into sub-lists or a table). |
| **Code blocks** | Language specified. Context sentence before each block. |
| **Links** | No broken anchors. External links open in new tab. |
| **Images** | Alt text on all. At least one image per 500 words (suggested). |
| **Bold text** | Used for key phrases, not entire sentences. |
| **Italic text** | Used for emphasis or titles, not decoration. |
| **First-person** | Consistent -- either "I" (personal) or "we" (company) throughout. |

#### 8c: Platform-Specific Adjustments

| Platform | Adjustments |
|----------|-------------|
| **WordPress** | Include Yoast/RankMath SEO fields. Suggest category and tags. |
| **Medium** | Remove H1 (Medium generates from title). Use quote blocks for callouts. No more than 5 tags. |
| **Substack** | Consider email preview (first 2 lines). No schema markup (not supported). |
| **Dev.to** | Use frontmatter (`---` block) with title, published, description, tags, canonical_url, cover_image. Add series name if applicable. |
| **Ghost** | Include excerpt field and feature image suggestion. Internal bookmarks for TOC. |
| **LinkedIn Article** | Shorter paragraphs. More personal tone. No code blocks (use images of code). |
| **Company blog** | Follow brand style guide. Include author bio and headshot placement. |

#### 8d: Final Output Format

Deliver the complete blog post in this structure:

```
--- SEO METADATA ---
Title tag: [50-60 chars]
Meta description: [150-160 chars]
URL slug: [keyword-rich, hyphenated]
Primary keyword: [target term]
Secondary keywords: [3-5 terms]
Schema type: Article | HowTo | FAQPage

--- ARTICLE ---

# [H1 Title]

[Full article text with all formatting, H2/H3 structure, code blocks,
blockquotes, bold/italic, lists, tables, and image placement markers]

--- CTA BLOCK ---
[Primary CTA with copy]

--- INTERNAL LINKS ---
[3-5 recommended internal links with anchor text and placement]

--- SCHEMA MARKUP ---
[JSON-LD block]

--- EDITORIAL NOTES ---
Word count: [actual]
Estimated read time: [minutes, at 250 wpm]
Flesch Reading Ease: [estimated score]
Primary keyword occurrences: [count]
Readability notes: [any flags from the checklist]
```

---

## Anti-Patterns

- **Starting to write without an outline.** An unstructured draft produces an unstructured post. Always complete Step 3 before Step 5.
- **Keyword stuffing.** If the primary keyword appears more than 2% of the time, the post reads as SEO-first, reader-second. Rewrite for natural placement.
- **Burying the lead.** If the reader doesn't know what the post is about by sentence 3, the introduction needs rewriting. Avoid multi-paragraph throat-clearing.
- **Wall of text.** Every 250-350 words should have a visual break: heading, image, blockquote, list, table, or code block. Readers scan before they read.
- **Generic conclusions.** "In conclusion, [topic] is important" teaches nothing. Use a conclusion pattern from Step 7 that adds value.
- **CTA as afterthought.** A single CTA jammed at the bottom converts poorly. Use the progressive CTA strategy from Step 7b.
- **Writing for search engines instead of readers.** SEO gets the reader to the page. The writing keeps them there. If you have to choose, choose the reader -- Google's algorithms increasingly reward engagement over keyword mechanics.
- **Ignoring the existing content landscape.** Writing a post without checking what already ranks is like entering a conversation without listening first. Step 2a exists for a reason.
- **One-size-fits-all tone.** A blog post for CTOs reads differently than one for junior developers. Adjust vocabulary, assumed knowledge, and examples to match the stated audience.
- **No evidence for claims.** Assertions without data, examples, or citations are opinions. Opinions are fine in opinion pieces -- but label them as such. In how-to and informational content, back every major claim.

## Escalation

Hand off to a specialist when:

- **The topic requires original research or data collection.** This skill synthesizes existing knowledge into well-structured content. It does not conduct surveys, interviews, or experiments. If the post requires primary data, engage a researcher first.
- **Legal, medical, or financial claims are central to the post.** Content in regulated domains (health advice, legal guidance, investment recommendations) must be reviewed by a qualified professional before publication. Flag this to the user.
- **The post is part of a multi-channel campaign.** If the blog post needs coordinated social media threads (twitter-thread), email sequences (email-sequence), or landing pages (landing-page-copy), recommend the user run those skills separately for each channel.
- **Visual design or custom graphics are required.** This skill suggests image placements and alt text but does not produce images. If the post requires infographics, diagrams, or custom illustrations, engage a designer.
- **Translation or localization is needed.** If the content must be published in multiple languages, engage a localization specialist rather than machine-translating the output.

## Inputs

- Topic or working title (required)
- Target audience description (required)
- Tone / voice (default: professional, conversational)
- Word count target (default: 1,500-2,000)
- Primary and secondary SEO keywords (optional -- derived from topic if not provided)
- CTA goal and target action (default: newsletter signup)
- Publication platform (default: generic blog)
- Existing competitor articles or internal content links (optional)
- Brand voice notes or style guide references (optional)

## Outputs

- Complete blog post with H1/H2/H3 hierarchy, body text, and all formatting
- SEO metadata: title tag, meta description, URL slug, keyword placement map
- Schema markup (JSON-LD) for Article, HowTo, or FAQPage as appropriate
- 3-5 internal link recommendations with anchor text and placement rationale
- Progressive CTA copy (soft, medium, hard) integrated into the article
- Image placement suggestions with alt text
- Editorial metrics: word count, read time, readability score, keyword density
- Platform-specific formatting notes if a publication platform was specified

## Level History

- **Lv.1** -- Base: Full 8-step protocol (gather inputs, research and angle, outline architecture, hook and introduction, body writing, SEO optimization, CTA and conclusion, editorial checklist and output). 6 blog structure templates (Problem/Solution, How-To, Listicle, Comparison, Case Study, Opinion). 5 hook patterns (stat-lead, question, story, contrarian, pain-point). 3 paragraph structures (CEI, PCS, OIA). 6 transition patterns. Technical content guidelines with before/after code examples. SEO keyword placement map with density targets. Title tag formulas and meta description templates. Article schema markup (JSON-LD). Progressive CTA strategy (soft/medium/hard). 4 conclusion patterns (callback, takeaways, forward-looking, challenge). Readability targets (Flesch 60-70, sentence length 15-20, passive voice under 10%). Platform-specific adjustments for 7 platforms. Anti-patterns, escalation matrix, structured output format. (Origin: MemStack v3.3, Mar 2026)
