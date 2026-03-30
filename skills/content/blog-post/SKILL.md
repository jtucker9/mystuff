---
name: blog-post
description: "Long-form blog/article creation with SEO, structure, and CTA. WHEN: 'write blog post', 'blog post about', 'write article', 'create blog', 'content for blog', guest posts, thought leadership, tutorials. NOT: landing pages (landing-page-copy), emails (email-sequence), social (twitter-thread), newsletters (newsletter), product copy (product-description)."
---

# Blog Post

## Activation

| Context | Status |
|---------|--------|
| "write blog post", "write article", "blog post about", "create blog" | ACTIVE |
| Long-form editorial, guest post, thought leadership, tutorial | ACTIVE |
| Landing page copy, email sequence, social thread, newsletter, product description | DORMANT -- route to respective skill |

Output on activation: `Blog Post -- Crafting your article...`

## Instructions

### Step 1: Gather Inputs

Collect topic and target audience (both required). Ask for anything missing -- never assume silently.

Optional with defaults: tone (professional/conversational), word count (1500-2000), primary SEO keyword (derived from topic), secondary keywords (derived from primary), CTA goal (newsletter signup), publication platform (generic blog), competitor/internal links, brand voice notes.

Word count tiers: Short 800-1200, Standard 1500-2000, Long-form 2500-4000, Pillar 4000+.

**Gate:** Do not proceed until topic + audience are confirmed.

### Step 2: Research and Angle

Classify search intent (informational/navigational/commercial/transactional). Identify content gaps in top results. Go deeper than the best existing piece or take a radically different format.

Angle frameworks:

| Framework | When to use |
|-----------|-------------|
| **Contrarian** | Conventional wisdom is wrong or incomplete |
| **Experience report** | First-hand data backs the argument |
| **Synthesis** | Connecting ideas others haven't |
| **Update** | Best practices have changed, content is outdated |
| **Framework** | Giving readers a reusable mental model |
| **Deep dive** | Topic deserves more rigor than it usually gets |

Output:
```
ANGLE: [1-sentence thesis]
FORMAT: [Problem/Solution | How-To | Listicle | Comparison | Case Study | Opinion]
DIFFERENTIATOR: [What this does that competitors don't]
```

Draft 3 candidate hooks for refinement in Step 4.

**Gate:** Angle must be stated and format chosen before outlining.

### Step 3: Outline Architecture

Structure types -- choose by format:

- **Problem/Solution:** Problem (evidence) > Why it happens > Solution (steps) > Results > CTA
- **How-To:** Outcome preview > Prerequisites > Steps (action verb H2s) > Common mistakes > CTA
- **Listicle:** Numbered items with benefit hooks > How to choose > CTA
- **Comparison:** Quick verdict > Criteria with winners > When to use each > CTA
- **Case Study:** Situation > Challenge > Approach (decisions) > Results (quantified) > Lessons > CTA
- **Opinion:** Conventional wisdom (why wrong) > Evidence > Better model > Implications > CTA

For each H2, define: purpose, target word count, key evidence, transition to next section. Aim 4-7 H2s standard, 7-12 pillar.

**Gate:** Full outline with section purposes approved before writing prose.

### Step 4: Hook and Introduction

Hook patterns: **Stat-Lead** (surprising number), **Question** (reader answers mentally), **Story** (2-4 sentence micro-narrative), **Contrarian** (contradicts held belief), **Pain-Point** (describes reader's frustration with specificity).

Introduction structure: Hook (1-3 sentences) > Context (why now, 1-2 sentences) > Thesis (1 sentence) > Roadmap (1 sentence). Complete within 150 words.

### Step 5: Body Writing

Paragraph patterns: **CEI** (Claim-Evidence-Implication) for workhorse paragraphs, **PCS** (Problem-Cause-Solution) for actionable content, **OIA** (Observation-Insight-Application) for thought leadership. Keep 3-5 sentences per paragraph; single-sentence paragraphs max twice per 1000 words.

Transition types between H2s: bridge, contrast, escalation, callback, question, summary-advance.

Technical posts: context sentence before every code block, show wrong-then-right, realistic variable names, self-contained examples.

Bold key phrases for F-pattern scanners. One visual break (heading/image/quote/list/table/code) every 250-350 words.

### Step 6: SEO Optimization

**Title tag** (50-60 chars, primary keyword in first 40 chars). Title formulas:
- How to [Task] Without [Pain Point]
- [Number] [Topic] Mistakes That [Consequence]
- [Topic]: A [Qualifier] Guide for [Audience]
- Why [Conventional Wisdom] Is Wrong (And What to Do Instead)
- [Option A] vs [Option B]: [Decision Frame]
- The [Adjective] Guide to [Topic] in [Year]
- What [Entity] Teaches Us About [Topic]
- [Task]: [Number] Lessons from [Experience]

**Meta description:** 150-160 chars, primary keyword, value prop, don't duplicate title.

**Keyword placement:** Primary keyword required in: title tag (first 40 chars), meta description, first 100 words, at least 1 H2, URL slug. Density target 1-2%; above 2% triggers rewrite.

**Internal links:** 3-5 recommendations with anchor text and placement. Max 1 per 300 words. Descriptive anchors only.

Suggest image placements with alt text containing keywords.

**Gate:** Title tag under 60 chars and meta description under 160 chars before finalizing.

### Step 7: CTA and Conclusion

CTA types: newsletter signup (1-3% CVR), free resource download (3-8%), product trial (0.5-2%), consultation (0.2-1%), related content (5-15% CTR), community join (2-5%), social share (1-3%).

**Progressive CTA placement:** Soft at ~40% (contextual mention), Medium at ~70% (after compelling section), Hard at conclusion (full ask with value prop).

Conclusion patterns: **Callback** (resolve opening story/stat), **Key Takeaways** (3-5 numbered distillations), **Forward-Looking** (connect to trend), **Challenge** (direct reader to act now).

### Step 8: Editorial Check and Delivery

Readability targets:

| Metric | Target |
|--------|--------|
| Flesch Reading Ease | 60-70 standard, 45-55 technical |
| Average sentence length | 15-20 words |
| Passive voice | Under 10% |
| Adverb density | Under 3% |
| Heading frequency | One H2/H3 per 250-350 words |

Deliver as: SEO metadata block (title tag, meta description, slug, keywords, schema type) > Full article with formatting > CTA block > Internal link recommendations > Editorial metrics (word count, read time at 250 wpm, readability score, keyword density).

**Gate:** All readability targets met before delivery.

## Examples

**Example 1 -- Technical B2B:**
Topic: "Why most startups fail at database design." Audience: technical founders. Angle: Contrarian. Format: Problem/Solution. Hook: Pain-Point (2AM page story). CTA: database architecture review consultation. Word count: 2000.

**Example 2 -- Content Marketing:**
Topic: "Content repurposing strategies for solo creators." Audience: solopreneurs, beginner. Angle: Framework (3-layer repurposing model). Format: How-To. Hook: Stat-Lead (creator burnout stat). CTA: free repurposing checklist download. Word count: 1500.

## Common Issues

| Issue | Fix |
|-------|-----|
| Post reads as keyword-stuffed | Rewrite all forced keyword insertions for natural phrasing; verify density under 2% |
| Introduction exceeds 250 words | Cut context/roadmap; hook must land within 3 sentences |
| Sections feel disconnected | Add explicit transition sentence (bridge/callback/question) between every H2 |

## Anti-Patterns

- Writing prose before completing the outline -- unstructured drafts produce unstructured posts
- Keyword density above 2% -- reads as SEO-first, triggers penalties
- Burying the lead past sentence 3 -- multi-paragraph throat-clearing kills engagement
- CTA only at the bottom -- use progressive placement (40%/70%/end)
- Making claims without evidence -- assertions need data, examples, or citations in non-opinion formats
- Ignoring existing content landscape -- writing without checking what ranks is entering a conversation without listening
- Wall of text without visual breaks every 250-350 words

## Escalation

- **Original research required** -- skill synthesizes existing knowledge, does not conduct primary research
- **Regulated content** (legal, medical, financial) -- flag for professional review before publication
- **Multi-channel campaign** -- route to twitter-thread, email-sequence, landing-page-copy separately
- **Custom graphics/infographics needed** -- skill suggests placements only, engage a designer
- **Translation/localization** -- engage specialist, do not machine-translate output

## Inputs

- Topic or working title (required)
- Target audience (required)
- Tone (default: professional/conversational)
- Word count target (default: 1500-2000)
- Primary + secondary SEO keywords (optional, derived from topic)
- CTA goal (default: newsletter signup)
- Publication platform (default: generic blog)
- Competitor/internal links (optional)
- Brand voice notes (optional)

## Outputs

- Complete blog post with H1/H2/H3 hierarchy and formatting
- SEO metadata: title tag, meta description, URL slug, keyword map
- Progressive CTA copy integrated at 40%/70%/end
- 3-5 internal link recommendations with anchors and placement
- Image placement suggestions with alt text
- Editorial metrics: word count, read time, readability score, keyword density

## Level History

- **Lv.1** -- Base: 8-step protocol, 6 structure templates, 6 angle frameworks, 5 hook patterns, 3 paragraph structures, SEO keyword placement map, title formulas, progressive CTA strategy, 4 conclusion patterns, readability targets, anti-patterns, escalation matrix. (Origin: MemStack v3.3, Mar 2026)
- **Lv.2** -- Compressed: Removed full outline templates, example paragraphs, JSON-LD blocks, platform-specific adjustment table, evidence type catalog, transition examples, code examples, formatting verification checklist. Preserved all framework names, structure types, hook patterns, title formulas, readability targets, CTA types with benchmarks. Added validation gates between steps. (Origin: MemStack v3.4, Mar 2026)
