---
name: landing-page-copy
description: "Use when the user says 'landing page', 'sales page copy', 'hero section', 'conversion copy', or is creating persuasive copy for a product or service landing page. Do NOT use for blog posts (see blog-post), email sequences (see email-sequence), or ad copy (see facebook-ad/google-ad)."
---

# Landing Page Copy -- High-Converting Sales Copy
*Produce a complete, wireframe-ready landing page copy document with hero section, problem/agitation, solution, social proof, objection handling, and CTA blocks -- optimized for conversion.*

## Activation

When this skill activates, output:

`Landing Page Copy -- Crafting your conversion copy...`

| Context | Status |
|---------|--------|
| **User says "landing page", "sales page", "landing page copy"** | ACTIVE |
| **User says "hero section", "conversion copy", "sales copy"** | ACTIVE |
| **User says "write a page for my product/service"** | ACTIVE |
| **User wants persuasive copy for a product or service web page** | ACTIVE |
| **User wants a waitlist page, signup page, or lead gen page** | ACTIVE |
| **User wants blog content (not a conversion page)** | DORMANT -- see blog-post |
| **User wants email campaigns or drip sequences** | DORMANT -- see email-sequence |
| **User wants Facebook or Google ad copy** | DORMANT -- see facebook-ad or google-ad |
| **User wants product descriptions for e-commerce** | DORMANT -- see product-description |
| **User wants a newsletter edition** | DORMANT -- see newsletter |

---

## Protocol

### Step 1: Gather Inputs

Collect the following from the user. Ask for anything not provided -- do not assume defaults silently.

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| **Product/service** | Yes | -- | What is being sold, offered, or promoted |
| **Target audience** | Yes | -- | Who is this page for? Role, demographics, psychographics, experience level |
| **Primary CTA** | Yes | -- | The single most important action (buy, sign up, book a call, join waitlist) |
| **Unique value proposition** | Yes | -- | The one thing that makes this different from every alternative |
| **Page type** | No | Sales page | Sales page, Lead gen, Waitlist, Signup, Free trial, Webinar registration |
| **Competitor URLs** | No | None | Links to competing products/services for positioning analysis |
| **Tone** | No | Confident, conversational | Options: authoritative, casual, premium, urgent, empathetic, technical, playful |
| **Price point** | No | Not disclosed | Affects objection handling intensity and value justification depth |
| **Existing assets** | No | None | Testimonials, case studies, logos, data, awards already available |
| **Traffic source** | No | Mixed | Paid ads, organic search, email, social, referral -- affects awareness level and messaging |
| **Brand guidelines** | No | None | Colors, voice rules, words to avoid, required disclaimers |

**Example input prompt:**

> Write landing page copy for our AI-powered code review tool ($49/mo). Target audience: engineering managers at Series A-B startups. CTA: Start free trial. UVP: Catches bugs that human reviewers miss, trained on your team's codebase. Tone: confident, slightly technical. Competitors: CodeRabbit, Sourcery.

### Step 2: Customer Research Synthesis

Before writing a single word of copy, build a research document that maps the customer's psychology. Every section of the landing page will draw from this foundation.

#### 2a: Voice of Customer Mining

Extract the language your target audience actually uses to describe their problem. Sources to mine (ask the user if they have any of these):

| Source | What to Extract | Example |
|--------|----------------|---------|
| **Support tickets** | Exact complaints, recurring frustrations | "I keep having to manually check every PR" |
| **G2/Capterra reviews** (of competitors) | What people praise and criticize | "Great concept but misses too many edge cases" |
| **Reddit/HN threads** | Unfiltered frustrations, desired features | "I wish there was a tool that just..." |
| **Sales call transcripts** | Objections, decision criteria, comparison language | "We almost went with X but..." |
| **Survey responses** | Self-reported pain points and priorities | "My biggest challenge is..." |
| **Social media comments** | Emotional language, unguarded reactions | "This is exactly what I've been dealing with" |

**Output:** A voice-of-customer swipe file with 10-20 phrases in the customer's own words, organized by theme.

#### 2b: Pain Points Hierarchy

Rank the audience's pain points from surface-level to deep:

```
PAIN HIERARCHY:

Level 1 -- Surface Pain (symptoms they notice daily):
  - [e.g., "Code reviews take forever"]
  - [e.g., "PRs sit in review queue for 2+ days"]

Level 2 -- Operational Pain (business impact):
  - [e.g., "Shipping velocity is 40% slower than it should be"]
  - [e.g., "Senior engineers spend 30% of their time reviewing junior code"]

Level 3 -- Strategic Pain (what keeps them up at night):
  - [e.g., "We're falling behind competitors who ship faster"]
  - [e.g., "Our best engineers are burning out on review duty"]

Level 4 -- Identity Pain (how it makes them feel):
  - [e.g., "I'm failing my team by not solving this bottleneck"]
  - [e.g., "We hired smart people and then buried them in process"]
```

The landing page should address all four levels -- surface pain in the hero, operational pain in the problem section, strategic pain in the solution section, and identity pain in the closing CTA.

#### 2c: Desire Mapping

Mirror the pain hierarchy with what the audience wants:

| Functional Desire | Emotional Desire | Identity Desire |
|-------------------|-----------------|-----------------|
| Faster code reviews | Relief from review fatigue | "We run a high-velocity engineering org" |
| Fewer bugs in production | Confidence in code quality | "Our team ships code we're proud of" |
| More time for deep work | Freedom from tedious tasks | "I'm the manager who removed the bottleneck" |

**Copy principle:** Features satisfy functional desires. Benefits satisfy emotional desires. Transformation satisfies identity desires. The strongest landing pages hit all three.

#### 2d: Objection Inventory

List every reason the prospect might NOT convert, ranked by frequency:

```
OBJECTION INVENTORY:

1. [Most common] "Is this accurate enough to trust?" -> Counter: accuracy metrics, human-in-the-loop design
2. [Second most common] "My team will resist another tool" -> Counter: adoption story, gradual rollout path
3. "We've tried AI code review before and it was noisy" -> Counter: signal-to-noise ratio comparison
4. "This seems expensive for what it does" -> Counter: ROI calculation, time-saved math
5. "What about security? Our code is proprietary" -> Counter: SOC 2, on-prem option, data handling policy
6. [Latent] "What if I champion this and it fails?" -> Counter: risk reversal, free trial, easy cancellation
```

Each objection will be addressed in a specific section of the page -- some in the FAQ, some woven into social proof, some defused in the feature descriptions.

#### 2e: Awareness Level Assessment

Use Eugene Schwartz's 5 levels of awareness to calibrate the entire page's messaging approach:

| Level | Description | Messaging Strategy | Typical Traffic Source |
|-------|-------------|-------------------|----------------------|
| **Unaware** | Don't know they have a problem | Lead with the problem, educate first | Content marketing, social |
| **Problem-Aware** | Know the problem, don't know solutions exist | Agitate the pain, introduce the category | SEO, educational ads |
| **Solution-Aware** | Know solutions exist, don't know your product | Position against alternatives, differentiate | Comparison searches, review sites |
| **Product-Aware** | Know your product, haven't decided | Overcome objections, prove value, reduce risk | Retargeting, email, direct |
| **Most Aware** | Ready to buy, need a push | Lead with the offer, remove friction | Brand searches, referrals |

**Page calibration:**

- **Unaware/Problem-Aware:** Longer page. Heavy problem section. Educate before selling. Hero focuses on the pain, not the product.
- **Solution-Aware:** Medium page. Brief problem validation, then differentiation. Hero names the category and your advantage.
- **Product-Aware/Most Aware:** Shorter page. Skip education. Lead with offer, proof, and CTA. Hero leads with the deal or the transformation.

---

### Step 3: Hero Section

The hero section is the most important 5 seconds of the page. It must pass the "grunt test" -- a caveman glancing at it should understand: (1) what is this, (2) why should I care, (3) what do I do next.

#### 3a: Headline Formulas

Select from these 10 proven headline patterns. Choose based on awareness level and page type.

| # | Formula | Best For | Example |
|---|---------|----------|---------|
| 1 | **[Verb] [Desired Outcome] Without [Pain Point]** | Product-aware, SaaS | "Ship Faster Without Sacrificing Code Quality" |
| 2 | **The [Category] That [Key Differentiator]** | Solution-aware, unique positioning | "The Code Review Tool That Learns Your Codebase" |
| 3 | **[Outcome] in [Timeframe]** | Results-driven, urgency | "Production-Ready Code Reviews in Under 5 Minutes" |
| 4 | **Stop [Pain]. Start [Desire].** | Problem-aware, emotional | "Stop Drowning in PR Queues. Start Shipping." |
| 5 | **[Number]+ [Social Proof Group] [Verb] [Product] to [Outcome]** | Social proof lead, established product | "2,400+ Engineering Teams Use CodeBot to Ship 3x Faster" |
| 6 | **What If [Desired Scenario]?** | Unaware, aspirational | "What If Every Pull Request Got a Senior-Level Review Instantly?" |
| 7 | **[Audience]: [Direct Benefit Statement]** | Niche targeting, high specificity | "Engineering Managers: Cut Review Cycles by 60% This Quarter" |
| 8 | **The Fastest Way to [Outcome]** | Competitive, speed-focused | "The Fastest Way to Find Bugs Before Your Users Do" |
| 9 | **[Bold Claim]. [Proof Fragment].** | Confident, data-driven | "AI That Catches What Humans Miss. 94% Accuracy Across 10M Reviews." |
| 10 | **[Do X]. [Without Y]. [In Z].** | Triple-beat rhythm, scannable | "Review Code. Catch Bugs. Ship Confidently." |

**Headline selection criteria:**

- **Unaware audience:** Formula 4, 6 (problem-first)
- **Problem-aware:** Formula 1, 7, 8 (bridge pain to solution)
- **Solution-aware:** Formula 2, 9 (differentiate)
- **Product-aware:** Formula 3, 5, 10 (proof and action)

#### 3b: Subheadline Strategies

The subheadline completes the headline. It answers what the headline deliberately left unsaid.

| Strategy | Pattern | Example |
|----------|---------|---------|
| **Expand the mechanism** | "[Product] uses [mechanism] to [specific outcome]" | "Our AI trains on your team's code patterns to deliver reviews that match your standards" |
| **Add specificity** | "[Quantified benefit] for [specific audience]" | "Save 12+ hours per week per senior engineer on code review" |
| **Handle the 'how'** | "By [method], so you can [desire]" | "By automating first-pass review, so your team can focus on architecture and design" |
| **Social proof bridge** | "Join [number] [peers] who already [outcome]" | "Join 2,400 engineering teams who cut review time in half" |
| **Risk reversal** | "[Promise]. [Safety net]." | "See results in your first sprint. No credit card required." |

#### 3c: Hero CTA

The hero CTA should be the lowest-friction entry point to the conversion path.

| Page Type | Hero CTA | Button Text | Below-Button Text |
|-----------|----------|-------------|-------------------|
| **Free trial** | Start trial | "Start Free Trial" or "Try Free for 14 Days" | "No credit card required. Set up in 2 minutes." |
| **Sales page** | Begin purchase | "Get Started" or "Buy Now" | "30-day money-back guarantee" |
| **Lead gen** | Capture info | "Get the [Resource]" or "Download Free" | "Join 5,000+ who already have it" |
| **Waitlist** | Join list | "Join the Waitlist" or "Get Early Access" | "1,200 people ahead of you" |
| **Signup** | Create account | "Create Free Account" | "Free forever for teams under 5" |
| **Webinar** | Register | "Save My Spot" or "Register Free" | "Live on [date]. Replay available." |
| **Demo/call** | Schedule | "Book a Demo" or "Talk to Sales" | "30-minute call. No pressure." |

**CTA copy rules:**
- Button text uses first person when possible: "Start My Free Trial" outperforms "Start Your Free Trial"
- Button text starts with a verb
- Below-button text reduces anxiety (risk reversal, social proof, or friction removal)
- Never use "Submit" -- it implies giving something up

#### 3d: Social Proof Badges

Place above or directly below the hero CTA. These are trust signals, not full testimonials.

**Badge types (use 2-3 maximum in the hero):**

- Logo bar: "Trusted by teams at [Logo] [Logo] [Logo] [Logo] [Logo]"
- Aggregate rating: "Rated 4.8/5 on G2 from 340+ reviews"
- User count: "Used by 2,400+ engineering teams"
- Media mentions: "As seen in TechCrunch, The Verge, Hacker News"
- Security badge: "SOC 2 Type II Certified"
- Award badge: "G2 Leader, Fall 2026"

#### 3e: Above-the-Fold Checklist

Before moving to the next section, verify the hero passes these criteria:

| Check | Pass Criteria |
|-------|---------------|
| **Grunt test** | A stranger can identify what you sell, who it's for, and what to do in 5 seconds |
| **One CTA** | Exactly one primary call-to-action. No competing links or buttons |
| **Specificity** | At least one concrete number, timeframe, or measurable claim |
| **No jargon** | A smart 14-year-old could understand the headline |
| **Emotional hook** | The copy triggers a feeling (relief, curiosity, aspiration, urgency) |
| **Visual hierarchy** | Headline > Subheadline > CTA > Social proof (descending visual weight) |
| **Mobile-first** | Headline is under 10 words. Readable without horizontal scroll at 375px |

---

### Step 4: Problem / Agitation Section

This section validates the reader's pain and makes the status quo feel unacceptable. It earns the right to present a solution by proving you understand the problem deeply.

#### 4a: Pain Amplification Framework

Structure the problem section in three escalating layers. Draw directly from the Pain Hierarchy built in Step 2b.

**Layer 1 -- The Symptom (what they see):**
Name the daily frustrations they experience. Use their own language from the VoC research.

```
Example:
"Your PR queue is backed up. Again. Three senior engineers are spending their mornings
reading through code they didn't write, leaving comments they've left a hundred times
before, while their own work sits untouched."
```

**Layer 2 -- The Cost (what it's costing them):**
Translate symptoms into measurable business impact. Use specific numbers wherever possible.

```
Example:
"Every day a PR sits in review is a day your feature doesn't ship. At the average
engineering salary, manual code review costs a 10-person team $127,000 per year.
That's a full engineer's salary spent on a process that could be automated."
```

**Layer 3 -- The Trajectory (what happens if they don't act):**
Project the pain forward. What does the next 6-12 months look like if nothing changes?

```
Example:
"As your team grows, the problem compounds. More code means more reviews. More reviews
means more bottlenecks. The engineers you hired to build are spending their time
gatekeeping instead. Your best people start looking for teams that don't waste their time."
```

#### 4b: Agitation Without Manipulation

The problem section should create urgency through honesty, not manufactured fear. Follow these guardrails:

| Do | Don't |
|----|-------|
| Use real statistics and documented consequences | Fabricate or exaggerate data |
| Describe pain the audience genuinely experiences | Invent problems they don't have |
| Project realistic trajectories | Use doomsday scenarios |
| Acknowledge that alternatives exist | Pretend your product is the only option |
| Respect the reader's intelligence | Use condescending or patronizing language |
| Name the cost of inaction with math | Use vague fear-based language ("you'll fall behind") |

**Anti-pattern:** "If you don't buy our product, your company will fail." This is manipulation. Instead: "The average cost of manual code review at your team size is $127,000/year. Here's what that number looks like in 12 months if you add 5 more engineers."

#### 4c: Status Quo Positioning

Frame the current state as the true competitor -- not rival products. The biggest conversion barrier is usually inaction, not a competitor.

**Status quo framing pattern:**
```
"Right now, you're solving this with [current approach: manual process / spreadsheets /
an intern / willpower]. It works -- until it doesn't. Here's when it breaks: [specific
trigger event that makes the status quo untenable]."
```

---

### Step 5: Solution and Features

Transition from the problem to your product. The bridge sentence should connect the pain directly to the solution: "That's why we built [Product] -- [one-sentence value prop]."

#### 5a: Feature-to-Benefit Translation

Every feature must be translated into a benefit the audience cares about. Use the "So What?" test: state the feature, then ask "So what?" until you reach an outcome the buyer values.

| Feature | So What? (Level 1) | So What? (Level 2) | Final Benefit |
|---------|--------------------|--------------------|---------------|
| AI-powered code analysis | Finds bugs automatically | No more manual line-by-line review | "Your senior engineers get 10 hours back per week" |
| Learns your codebase patterns | Reviews match your team's standards | No generic, noisy suggestions | "Reviews that feel like they came from your best engineer" |
| Integrates with GitHub/GitLab | Works where your team already lives | Zero workflow disruption | "Set up in 5 minutes. No one has to change how they work" |
| SOC 2 Type II certified | Your code stays private | Meets enterprise security requirements | "Your security team will approve this on the first review" |

**Copy principle:** Lead with the benefit. Mention the feature as the mechanism. "Get 10 hours back per week [benefit] with AI-powered first-pass review [feature] that learns your team's standards [mechanism]."

#### 5b: Benefit Stacking

Present benefits in descending order of importance to the target audience. Group into 3-4 clusters:

**Pattern: Feature block layout**

```
FEATURE BLOCK 1: [Primary benefit category]
  Headline: [Benefit-driven, 5-8 words]
  Body: [2-3 sentences explaining the mechanism]
  Proof point: [Stat, testimonial snippet, or comparison]

FEATURE BLOCK 2: [Secondary benefit category]
  Headline: [Benefit-driven, 5-8 words]
  Body: [2-3 sentences]
  Proof point: [Evidence]

FEATURE BLOCK 3: [Tertiary benefit category]
  Headline: [Benefit-driven, 5-8 words]
  Body: [2-3 sentences]
  Proof point: [Evidence]
```

**Copy guideline for feature blocks:**
- Each block should be independently scannable (readers will not read all three linearly)
- Use parallel structure across blocks (all start with verbs, all use the same sentence count)
- Include a visual suggestion for each block (icon, screenshot, illustration)

#### 5c: Feature Grid Layout Recommendations

For pages with 6+ features, use a grid rather than stacked blocks:

| Grid Size | Layout | Best For |
|-----------|--------|----------|
| 3 features | Single row of 3 | Simple products, above-the-fold placement |
| 6 features | 2 rows of 3 | SaaS products, feature comparison pages |
| 9+ features | 3x3 grid or tabbed sections | Enterprise products, platform plays |

Each grid cell contains: **Icon + Headline (3-5 words) + One-sentence description.**

Full feature descriptions go in an expandable section or a dedicated features page -- not on the landing page. The landing page sells the outcome; the features page sells the mechanism.

#### 5d: "How It Works" Section

For products with a non-obvious workflow, add a 3-step "How It Works" section between features and social proof:

```
HOW IT WORKS:

Step 1: [Simple action verb] — [What the user does]
  "Connect your GitHub repo in one click"

Step 2: [What happens automatically] — [Behind the scenes]
  "Our AI analyzes your codebase patterns and review history"

Step 3: [The outcome] — [What the user gets]
  "Get detailed reviews on every PR, automatically"
```

**Rules:**
- Always exactly 3 steps (cognitive load research shows 3 is optimal for recall)
- Each step starts with a verb
- Each step has a one-line explanation
- Suggest a visual for each step (screenshot, icon, or mini-illustration)

---

### Step 6: Social Proof Blocks

Social proof is the most persuasive section of any landing page. It should be distributed throughout the page, not isolated in one section.

#### 6a: Testimonial Frameworks

Not all testimonials are equal. Curate and structure them using these frameworks:

**The Before-After-Bridge (BAB) Testimonial:**
```
"Before [Product], we were [specific pain]. After switching, [measurable outcome].
The difference was [emotional benefit]."

Example: "Before CodeBot, our PRs sat in queue for 3 days on average. After switching,
reviews come back in under 10 minutes. Our engineers are happier and we ship twice
as fast." — Sarah Chen, VP Engineering at Acme Corp
```

**The Specific Outcome Testimonial:**
```
"[Product] [specific measurable result] in [timeframe]."

Example: "CodeBot reduced our review cycle from 72 hours to 45 minutes. We shipped
23 more features last quarter." — Marcus Rivera, CTO at StartupX
```

**The Objection-Killer Testimonial:**
```
"I was skeptical about [common objection], but [proof it's unfounded]."

Example: "I was skeptical that AI could match our code standards, but CodeBot's
suggestions are better than 80% of the human reviews we were getting."
— Dev lead at a Fortune 500 company
```

**The Identity Testimonial:**
```
"[Product] made me/us [identity statement]."

Example: "CodeBot made us the engineering team that ships daily instead of weekly.
That changes how the whole company sees us." — Jamie Park, Engineering Manager
```

**Testimonial selection rules:**
- Use real names, titles, and companies (or industry + size if anonymized)
- Include a headshot or company logo if available
- Place the most relevant testimonial near the section it supports (objection-killer near FAQ, outcome near features)
- Minimum 3 testimonials, maximum 6 on a single landing page
- Each testimonial should address a different benefit or objection

#### 6b: Case Study Snippets

Full case studies live on their own pages. The landing page gets a compressed version:

**Case study snippet template:**
```
[COMPANY LOGO]

CHALLENGE: [One sentence describing their situation before]
SOLUTION: [One sentence describing what they did with your product]
RESULT: [2-3 specific, quantified outcomes]

"[One-sentence pull quote from the customer]"
— [Name, Title, Company]

[Link: Read the full story →]
```

**Example:**
```
[Acme Corp Logo]

CHALLENGE: 10-engineer team spending 40% of senior time on code review
SOLUTION: Deployed CodeBot with custom ruleset trained on their codebase
RESULT:
  • Review cycle time: 72 hours → 45 minutes
  • Features shipped per quarter: +23 (41% increase)
  • Senior engineer time recaptured: 400+ hours/quarter

"The ROI was obvious in the first week."
— Sarah Chen, VP Engineering, Acme Corp

Read the full story →
```

#### 6c: Numbers, Logos, and Awards

**Logo bar:**
- Show 5-8 recognizable logos
- If you lack big-name logos, use industry descriptions: "Trusted by teams in fintech, healthtech, and e-commerce"
- Place the logo bar immediately after the hero section or after the first testimonial

**Numbers bar:**
Use 3-4 key metrics in a horizontal layout:

```
[2,400+]          [10M+]              [94%]           [4.8/5]
Engineering       Code reviews        Accuracy         G2 rating
teams             completed           rate             (340 reviews)
```

**Awards and certifications:**
- G2 badges, Capterra ratings, industry awards
- Security certifications (SOC 2, GDPR, HIPAA)
- Place near the final CTA to reinforce trust at the decision point

#### 6d: Before/After Transformations

Show the transformation visually or narratively. This is especially powerful for products where the change is dramatic.

**Before/After table pattern:**

| Without [Product] | With [Product] |
|-------------------|---------------|
| PRs sit in review for 3 days | Reviews complete in under 10 minutes |
| Senior engineers spend 30% of time reviewing | Senior engineers focus on architecture |
| Bugs caught after deployment | Bugs caught before merge |
| Inconsistent code standards across team | Consistent standards, enforced automatically |

**Before/After narrative pattern:**
```
BEFORE: "Monday morning. You open Slack to 14 review requests. You spend until
lunch reading through diffs, leaving the same comments you left last week.
Your own feature work doesn't start until 2 PM."

AFTER: "Monday morning. You open Slack. CodeBot has already reviewed all 14 PRs.
Three need your attention for architecture decisions. The rest are approved
with detailed feedback. Your feature work starts at 9:05."
```

#### 6e: Trust Signal Placement Map

Distribute trust signals across the page, not in one cluster:

| Page Section | Trust Signal Type | Example |
|-------------|------------------|---------|
| **Hero** | Logo bar, user count, aggregate rating | "Trusted by 2,400+ teams" |
| **After Problem** | Testimonial (pain validation) | "We had exactly this problem..." |
| **After Features** | Case study snippet, outcome testimonial | "We shipped 23 more features..." |
| **Before Pricing** | Objection-killer testimonial, security badges | "I was skeptical but..." |
| **Final CTA** | Guarantee, award badges, aggregate review score | "30-day guarantee. 4.8/5 on G2." |

---

### Step 7: Objection Handling

Every prospect has reasons not to convert. Address them proactively so they don't become silent deal-breakers.

#### 7a: FAQ Section

The FAQ is objection handling disguised as helpfulness. Structure it to address the objections identified in Step 2d.

**FAQ writing rules:**
- Frame questions in the prospect's voice, not your marketing voice
- Bad: "What makes [Product] different?" Good: "I've tried AI code review tools before and they were noisy. How is this different?"
- Answer in 2-4 sentences. If the answer requires more, link to a detailed page.
- Lead each answer with the direct response, then elaborate
- Include 6-10 FAQs, ordered from most common objection to least

**FAQ template:**

```
Q: [Objection phrased as a question the prospect would actually ask]
A: [Direct answer in one sentence]. [Elaboration or evidence in 1-2 sentences].
   [Link to detailed page if applicable].

Q: "Is this accurate enough to replace human review?"
A: CodeBot maintains a 94% accuracy rate across 10M+ reviews, and you can tune
   the sensitivity for your team's standards. It's designed to handle first-pass
   review so your senior engineers can focus on the decisions that actually need
   human judgment. See our accuracy methodology →

Q: "What about the security of our code?"
A: Your code never leaves your infrastructure. We're SOC 2 Type II certified,
   offer on-prem deployment, and delete all analysis data within 24 hours.
   Read our security whitepaper →
```

#### 7b: Guarantee Framing

A strong guarantee reduces perceived risk and increases conversion. Match the guarantee to the price point and commitment level:

| Price Point | Guarantee Type | Copy Pattern |
|-------------|---------------|-------------|
| **Free trial** | No guarantee needed | "Try free for 14 days. No credit card required." |
| **Under $100/mo** | Money-back guarantee | "30-day money-back guarantee. If you don't see results, we'll refund every penny." |
| **$100-500/mo** | Results guarantee | "If you don't see a measurable reduction in review time in 30 days, we'll refund your first month AND help you find a tool that works." |
| **$500+/mo** | ROI guarantee | "If [Product] doesn't save you at least 2x its cost in engineering time within 90 days, you pay nothing." |
| **Enterprise** | Pilot program | "Start with a 30-day pilot on one team. Expand only if the results speak for themselves." |

**Guarantee placement:** Place near the pricing section and repeat near the final CTA. The guarantee should appear at the exact moment the prospect is calculating risk.

#### 7c: Risk Reversal

Beyond guarantees, layer additional risk-reversal elements:

- **No lock-in:** "Cancel anytime. No contracts. No penalties."
- **Easy exit:** "Export all your data in one click if you leave."
- **Low commitment entry:** "Start with our free tier. Upgrade when you're ready."
- **Proof before payment:** "See a demo review on your actual codebase before you sign up."
- **Social proof of safety:** "2,400 teams trust us. Here's why they stay: [retention metric]."

#### 7d: Comparison Tables

If the prospect is solution-aware and comparing alternatives, include a comparison table. This is especially effective for Product-Aware traffic.

**Comparison table rules:**
- Be honest about competitor strengths -- credibility matters more than winning every row
- Choose comparison criteria that highlight your genuine advantages
- Include the status quo ("doing nothing" or "manual process") as a column
- Use checkmarks, X marks, and specific values rather than vague descriptions

**Template:**

| Feature | [Your Product] | Competitor A | Competitor B | Manual Process |
|---------|---------------|-------------|-------------|----------------|
| Review speed | < 5 min | 15-30 min | 10-20 min | 24-72 hours |
| Learns your codebase | Yes | No | Limited | N/A (humans know it) |
| Accuracy | 94% | 78% | 85% | Varies by reviewer |
| Setup time | 5 min | 2 hours | 30 min | N/A |
| Price | $49/mo | $79/mo | $59/mo | $127K/yr (eng time) |

**Comparison table placement:** After the features section or in the FAQ. Never in the hero.

---

### Step 8: CTA and Closing

The final section must convert deliberation into action. The reader has been educated, persuaded, and reassured -- now close.

#### 8a: CTA Copy Formulas

The final CTA should be more assertive than the hero CTA. The reader has more context now.

| Formula | Example | Best For |
|---------|---------|----------|
| **Action + Outcome** | "Start Your Free Trial and Ship Faster This Week" | Free trial, strong outcome |
| **Imperative + Timeframe** | "Get CodeBot Running in 5 Minutes" | Low-friction signup |
| **Value Stack Recap** | "Get AI reviews, codebase learning, and 94% accuracy -- free for 14 days" | Complex products |
| **Social Proof + Action** | "Join 2,400 Teams. Start Your Free Trial." | Established products |
| **Question + Answer** | "Ready to stop wasting senior engineer time? Start here." | Problem-aware, decisive |
| **Identity + Action** | "Build the engineering team that ships daily. Get started free." | Aspirational, identity-driven |

#### 8b: Urgency Without Manipulation

Create urgency only when it's real. Manufactured urgency destroys trust.

| Legitimate Urgency | Copy Example |
|-------------------|-------------|
| **Limited-time pricing** | "Launch price: $29/mo (increases to $49/mo on April 15)" |
| **Capacity constraint** | "We onboard 20 new teams per month to ensure quality support" |
| **Time-sensitive results** | "Start this week and see results before your next sprint review" |
| **Cohort-based** | "Next cohort starts March 15. 8 spots remaining." |

| Fake Urgency (Never Use) | Why It Fails |
|--------------------------|-------------|
| "Only 3 left!" (for a SaaS product) | Obviously false for a digital product |
| Countdown timers that reset | Destroys trust when the reader returns |
| "This offer won't last" (for an evergreen page) | Vague and unbelievable |

#### 8c: Pricing Presentation

If price is shown on the landing page, present it in a way that anchors value before revealing cost.

**Pricing presentation order:**
1. Recap the value (what they get)
2. Anchor against the cost of the alternative (the status quo price)
3. Present the price
4. Restate in accessible terms (per day, per user, per review)
5. Add the guarantee

**Example:**
```
"Manual code review costs your team an estimated $127,000 per year in senior
engineering time. CodeBot gives your entire team instant, expert-level reviews
for $49/month -- less than the cost of a single team lunch.

Start free. Pay only when you're convinced."
```

**Price anchoring formula:** "[Alternative cost] vs [your price] = [savings] saved per [time period]."

#### 8d: Final CTA with Value Stack Recap

The last section of the page should summarize everything the reader gets and present the final conversion action.

**Value stack pattern:**

```
EVERYTHING YOU GET:

- AI-powered code reviews on every PR (instant, 24/7)
- Custom learning from your team's codebase and standards
- GitHub and GitLab integration (5-minute setup)
- SOC 2 Type II security certification
- Priority support with <2 hour response time
- 30-day money-back guarantee

[PRIMARY CTA BUTTON]
[Below-button text: risk reversal + social proof]
```

**Closing copy below the final CTA:**
Add a short paragraph (2-3 sentences) that addresses the reader who scrolled the entire page but still hasn't clicked. This reader is interested but hesitant. Speak directly to their hesitation:

```
"Still not sure? That's okay. Start with a free trial -- no credit card, no
commitment. See a review on your actual code in the next 5 minutes. If it's
not for you, you'll know quickly. And if it is, your team will thank you."
```

---

### Step 9: Output

Deliver the complete landing page copy document in this structure:

```
=== LANDING PAGE COPY DOCUMENT ===
Product: [name]
Audience: [target]
Page type: [sales/lead gen/waitlist/signup]
Awareness level: [from Step 2e]

--- RESEARCH FOUNDATION ---
Pain hierarchy: [summary from Step 2b]
Top 3 objections: [from Step 2d]
Voice of customer phrases: [5-10 key phrases]

--- HERO SECTION ---
Headline: [final headline]
Subheadline: [final subheadline]
Hero CTA: [button text]
Below-button text: [risk reversal/social proof]
Social proof badges: [2-3 badges]
[Wireframe note: describe layout, image/video placement]

--- PROBLEM / AGITATION ---
[Full copy for this section, 150-300 words]
[Wireframe note: suggested visual treatment]

--- SOLUTION & FEATURES ---
Bridge sentence: [transition from problem to solution]
Feature Block 1: [headline + body + proof point]
Feature Block 2: [headline + body + proof point]
Feature Block 3: [headline + body + proof point]
How It Works: [3 steps if applicable]
[Wireframe note: grid layout, icons, screenshots]

--- SOCIAL PROOF ---
Testimonial 1: [BAB or outcome format, with attribution]
Testimonial 2: [objection-killer format, with attribution]
Testimonial 3: [identity format, with attribution]
Case study snippet: [if available]
Numbers bar: [3-4 metrics]
[Wireframe note: placement and visual treatment]

--- OBJECTION HANDLING ---
FAQ: [6-10 Q&A pairs]
Comparison table: [if applicable]
Guarantee: [copy]
[Wireframe note: accordion/expand style recommended]

--- PRICING (if applicable) ---
Price anchor: [alternative cost]
Price presentation: [your price with reframing]
Guarantee restatement: [one line]

--- FINAL CTA ---
CTA headline: [closing headline]
CTA body: [value stack recap, 3-6 bullets]
Button text: [final CTA]
Below-button text: [last risk reversal]
Hesitant reader paragraph: [2-3 sentences for the undecided]

--- WIREFRAME NOTES ---
[Section-by-section layout recommendations]
[Mobile considerations]
[Suggested imagery/video placements]
[Color/contrast recommendations for CTA buttons]

--- PAGE METADATA ---
Page title: [60 chars max, for browser tab and SEO]
Meta description: [155 chars max]
OG title: [for social sharing]
OG description: [for social sharing]
```

---

## Anti-Patterns

- **Writing copy before research.** Skipping Step 2 produces generic copy that sounds like every other landing page. The research phase is what makes copy specific and persuasive. Always complete customer research synthesis before writing.
- **Feature-first hero section.** Leading with features instead of outcomes. "AI-powered code analysis" means nothing to the reader. "Ship faster without sacrificing code quality" means everything. Features explain how; the hero must explain why.
- **Multiple CTAs competing in the hero.** "Start Free Trial" AND "Book a Demo" AND "Watch Video" in the same hero section creates decision paralysis. One primary CTA per section. Secondary CTAs go below the fold.
- **Problem section that's too short.** Jumping from "here's a problem" to "here's our product" in two sentences. The reader needs to feel the problem is worth solving before they'll evaluate your solution. Invest 150-300 words in the problem section.
- **Manufactured urgency.** Countdown timers on evergreen pages, fake scarcity on digital products, "only X left" claims that reset. These tactics destroy trust and train the reader to ignore your signals.
- **Testimonials without specifics.** "Great product! Highly recommend." provides zero persuasive value. Every testimonial should include a specific outcome, a before/after contrast, or an objection overcome.
- **Ignoring the awareness level.** Sending a Problem-Aware audience to a page that assumes they already know your product. Or sending a Most-Aware audience to a page that spends 500 words explaining a problem they solved three years ago. Match the page to the traffic.
- **Wall-of-text feature descriptions.** Dense paragraphs explaining every feature kill momentum. Use the feature block pattern from Step 5b: headline, 2-3 sentences, proof point. Make it scannable.
- **No risk reversal.** Asking for money (or even an email address) without reducing perceived risk. Every conversion action should be paired with a guarantee, a proof point, or a friction remover.
- **Identical hero and final CTA.** The final CTA should be more assertive and include a value stack recap. The reader at the bottom of the page has more context than the reader at the top. Reflect that in the copy.
- **Writing for yourself instead of the customer.** Using internal jargon, company-centric language ("We're excited to announce..."), or features the team is proud of but the customer doesn't care about. Every sentence must pass the "Does the reader care?" test.
- **Skipping mobile copy review.** Headlines that work at desktop width often break on mobile. Check that all headlines are under 10 words, CTAs are thumb-friendly, and no section requires horizontal scrolling.

## Escalation

Hand off to a specialist when:

- **The page requires custom design or interactive elements.** This skill produces copy and wireframe recommendations, not visual designs. If the page needs animations, video production, or interactive calculators, engage a designer/developer.
- **A/B testing strategy is needed.** This skill produces one optimized variant. For structured experimentation (multivariate testing, statistical significance planning, traffic allocation), engage a CRO specialist.
- **The product involves regulated claims.** Health outcomes, financial returns, legal guarantees, or other claims subject to regulatory scrutiny must be reviewed by a compliance professional before publication.
- **The page is part of a multi-page funnel.** If the landing page feeds into a multi-step checkout, upsell sequence, or post-purchase flow, the full funnel should be mapped with the sales-funnel skill before writing individual pages.
- **Conversion rate optimization on an existing page.** This skill writes new pages. If the task is analyzing and improving an existing page's conversion rate, a CRO audit is a different discipline that requires analytics data, heatmaps, and session recordings.
- **The copy needs translation or localization.** Persuasive copy does not survive direct translation. Hire a localization specialist who understands conversion copywriting in the target language.
- **Ad copy is needed to drive traffic to the page.** Landing page copy and ad copy are different disciplines. Use facebook-ad or google-ad skills for the ads that point to this page.

## Inputs

- Product or service name and description (required)
- Target audience with demographics and psychographics (required)
- Primary call-to-action and conversion goal (required)
- Unique value proposition (required)
- Page type: sales, lead gen, waitlist, signup, free trial, webinar registration (default: sales page)
- Competitor URLs for positioning analysis (optional)
- Tone and voice guidelines (default: confident, conversational)
- Price point and pricing model (optional -- affects objection handling and value justification)
- Existing assets: testimonials, case studies, logos, data, awards (optional)
- Traffic source and awareness level (optional -- affects messaging calibration)
- Brand guidelines, colors, words to avoid, required disclaimers (optional)

## Outputs

- Complete landing page copy document with all sections: hero, problem/agitation, solution/features, social proof, objection handling, pricing (if applicable), and final CTA
- Research foundation: pain hierarchy, objection inventory, voice-of-customer phrases, awareness level assessment
- Wireframe-ready section-by-section layout recommendations with mobile considerations
- 10 headline options with recommended selection based on awareness level
- Feature-to-benefit translation table
- 3+ structured testimonial frameworks with attribution format
- FAQ section (6-10 objection-handling Q&A pairs)
- Comparison table vs competitors and/or status quo (if applicable)
- Guarantee and risk reversal copy
- Value stack recap for the final CTA
- Page metadata: title tag, meta description, OG tags for social sharing
- Suggested imagery/video placements with descriptions

## Level History

- **Lv.1** -- Base: Full 9-step protocol (gather inputs, customer research synthesis, hero section, problem/agitation, solution and features, social proof, objection handling, CTA and closing, structured output). 10 headline formulas mapped to awareness levels. Schwartz's 5 awareness levels with page calibration guide. Pain hierarchy framework (4 levels: surface, operational, strategic, identity). Voice of customer mining sources and extraction patterns. Feature-to-benefit translation with "So What?" test. 4 testimonial frameworks (BAB, specific outcome, objection-killer, identity). Before/after transformation patterns. FAQ as disguised objection handling. Guarantee framing by price point. Risk reversal layering. Comparison table rules with honesty guidelines. CTA copy formulas (6 patterns). Urgency ethics (legitimate vs fake urgency). Pricing presentation with value anchoring. Value stack recap pattern. Trust signal placement map across page sections. Wireframe-ready output format. Anti-patterns (12 items). Escalation matrix. Mobile-first copy guidelines. (Origin: MemStack v3.3, Mar 2026)
