---
name: email-sequence
description: "Use when the user says 'email sequence', 'drip campaign', 'email series', 'nurture sequence', 'onboarding emails', or is creating a multi-email automated campaign. Do NOT use for newsletters (see newsletter), single marketing emails, or landing page copy (see landing-page-copy)."
---

# Email Sequence -- Automated Campaign Builder
*Design and write complete multi-email automated campaigns with subject lines, body copy, timing logic, segmentation rules, and platform-ready automation flows.*

## Activation

When this skill activates, output:

`Email Sequence -- Building your campaign...`

| Context | Status |
|---------|--------|
| **User says "email sequence", "drip campaign", "email series"** | ACTIVE |
| **User says "nurture sequence", "onboarding emails", "welcome series"** | ACTIVE |
| **User says "abandoned cart emails", "re-engagement campaign"** | ACTIVE |
| **User wants to create a multi-email automated campaign** | ACTIVE |
| **User wants a single newsletter edition** | DORMANT -- see newsletter |
| **User wants a single promotional email** | DORMANT -- provide a one-off email, do not build a sequence |
| **User wants landing page copy** | DORMANT -- see landing-page-copy |
| **User wants social media content** | DORMANT -- see twitter-thread or tiktok-script |

---

## Protocol

### Step 1: Gather Inputs

Collect the following from the user. Ask for anything not provided -- do not assume defaults silently.

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| **Sequence type** | Yes | -- | Welcome, Nurture, Launch/Promo, Abandoned Cart, Re-engagement, Post-Purchase |
| **Audience segment** | Yes | -- | Who receives this? (new signups, trial users, past customers, cold leads, churned users) |
| **Product/service** | Yes | -- | What you are selling or promoting |
| **Desired action** | Yes | -- | The ultimate conversion goal (purchase, book demo, upgrade, reactivate) |
| **Email platform** | No | Generic | ConvertKit, Mailchimp, ActiveCampaign, Klaviyo, HubSpot, Drip, SendGrid, Brevo |
| **Brand voice** | No | Professional, friendly | Casual, corporate, witty, authoritative, empathetic, bold |
| **Existing assets** | No | None | Landing pages, lead magnets, testimonials, case studies, product pages |
| **Price point** | No | Not specified | Affects urgency tactics and objection handling |
| **Audience awareness level** | No | Problem-aware | Unaware, Problem-aware, Solution-aware, Product-aware, Most-aware |

**Example input prompt:**

> Build a 5-email welcome sequence for new trial users of our project management SaaS ($29/mo). Goal: convert to paid plan. Voice: friendly, slightly informal. Platform: ConvertKit. Audience is small business owners who just signed up for a 14-day trial.

### Step 2: Sequence Architecture

Select the sequence type and build the structural blueprint before writing any copy.

#### 2a: Sequence Type Decision Tree

| Sequence Type | Trigger Event | Goal | Recommended Emails | Cadence |
|---------------|---------------|------|-------------------|---------|
| **Welcome / Onboarding** | New signup or trial start | Activate user, build habit, convert to paid | 5-7 emails | Day 0, 1, 3, 5, 7, 10, 13 |
| **Nurture** | Lead magnet download, blog subscriber | Build trust, educate, move to sales-ready | 5-8 emails | Every 2-3 days for 2-3 weeks |
| **Launch / Promo** | Campaign start date | Drive purchases during a limited window | 4-6 emails | Compressed: Day 1, 3, 5, 6, 7 (last 48h = 2 emails) |
| **Abandoned Cart** | Cart abandonment event | Recover lost sale | 3-4 emails | 1 hour, 24 hours, 48 hours, 72 hours |
| **Re-engagement** | Inactivity threshold (30-90 days) | Win back or clean list | 3-5 emails | Day 0, 3, 7, 14, then remove |
| **Post-Purchase** | Purchase confirmation | Reduce refunds, encourage reviews, upsell | 4-6 emails | Immediate, Day 2, 7, 14, 30 |

#### 2b: Sequence Arc Design

Every sequence follows a narrative arc. Map each email to its role in the arc before writing.

**Welcome / Onboarding arc:**
```
Email 1 (Day 0): WELCOME — Deliver promise, set expectations, quick win
Email 2 (Day 1): ACTIVATE — Get them to complete one key action
Email 3 (Day 3): EDUCATE — Show a feature/benefit they haven't discovered
Email 4 (Day 5): SOCIAL PROOF — Customer stories, results, testimonials
Email 5 (Day 7): OVERCOME — Address the #1 objection head-on
Email 6 (Day 10): URGENCY — Trial ending, what they'll lose
Email 7 (Day 13): FINAL — Last chance, direct CTA, personal note
```

**Nurture arc:**
```
Email 1: VALUE — Deliver the lead magnet + one bonus insight
Email 2: STORY — Share a relevant case study or personal story
Email 3: FRAMEWORK — Teach a mental model they can apply immediately
Email 4: MISTAKE — Warn about a common mistake (positions you as expert)
Email 5: PROOF — Social proof, testimonials, results data
Email 6: BRIDGE — Connect their problem to your solution
Email 7: OFFER — Present the product/service with clear CTA
Email 8: FAQ — Handle remaining objections, final push
```

**Launch / Promo arc:**
```
Email 1: ANNOUNCE — What's coming, why it matters, early access or bonus
Email 2: EDUCATE — Deep dive on the problem this solves
Email 3: PROOF — Case studies, beta results, testimonials
Email 4: OBJECTION — Address the top 3 reasons people don't buy
Email 5: URGENCY — 24 hours left, bonus expiring, limited spots
Email 6: LAST CALL — Final email, closes tonight, recap all value
```

**Abandoned Cart arc:**
```
Email 1 (1 hour): REMINDER — "You left something behind" + cart contents
Email 2 (24 hours): OBJECTION — Address why they hesitated + social proof
Email 3 (48 hours): INCENTIVE — Discount, free shipping, or bonus
Email 4 (72 hours): FINAL — Last reminder, item going fast / price rising
```

**Re-engagement arc:**
```
Email 1: MISS YOU — Acknowledge absence, show what's new
Email 2: VALUE — Free resource or exclusive content to re-engage
Email 3: FEEDBACK — "Was it something we said?" survey link
Email 4: INCENTIVE — Win-back discount or special offer
Email 5: SUNSET — "We're removing you unless you click" (clean list)
```

**Post-Purchase arc:**
```
Email 1: CONFIRM — Order confirmation + set delivery expectations
Email 2 (Day 2): ONBOARD — Getting started guide, setup help
Email 3 (Day 7): CHECK-IN — "How's it going?" + support resources
Email 4 (Day 14): REVIEW — Ask for review/testimonial
Email 5 (Day 30): UPSELL — Complementary product or upgrade
Email 6 (Day 45): REFERRAL — Referral program invite
```

#### 2c: Timing and Cadence Rules

| Rule | Rationale |
|------|-----------|
| **Never send 2 emails in the same day** (except abandoned cart or last-day launch) | Inbox fatigue causes unsubscribes |
| **B2B: send Tuesday-Thursday, 9-11 AM recipient local time** | Highest open rates for business audiences |
| **B2C: send Tuesday, Thursday, or Sunday** | Consumer engagement peaks mid-week and weekends |
| **Space nurture emails 2-3 days apart** | Close enough to maintain momentum, far enough to avoid fatigue |
| **Launch sequences compress at the end** | Urgency requires tighter cadence in the final 48 hours |
| **Abandoned cart: first email within 1 hour** | Recovery rate drops 50% after 24 hours |
| **Include an exit condition for every sequence** | If the user converts, stop sending. If they unsubscribe, respect it immediately. |

### Step 3: Subject Line Engineering

Every email lives or dies by its subject line. Write 2-3 options per email, ranked by expected performance.

#### 3a: Subject Line Formulas

| Formula | Pattern | Example | Best For |
|---------|---------|---------|----------|
| **Curiosity gap** | Incomplete loop | "The one feature 80% of users miss" | Onboarding, nurture |
| **Benefit-first** | Clear value | "Save 3 hours this week with one setting" | Welcome, education |
| **Question** | Direct address | "Still setting up your workspace?" | Re-engagement, nudge |
| **Social proof** | Name-drop or stat | "How Acme Co. cut onboarding time by 60%" | Proof, nurture |
| **Urgency** | Time pressure | "Your trial ends in 48 hours" | Trial expiry, launch close |
| **Personal** | Casual, 1:1 tone | "Quick question about your account" | Re-engagement, check-in |
| **How-to** | Promise instruction | "How to build your first project in 5 min" | Onboarding, activation |
| **Negative** | Loss aversion | "Don't lose your saved work" | Abandoned cart, expiry |
| **List** | Numbered promise | "3 things to set up before Friday" | Education, onboarding |

#### 3b: Subject Line Rules

| Rule | Why |
|------|-----|
| **40-50 characters max** | Truncation on mobile kills open rates |
| **Front-load the value** | First 25 characters must convey the core message |
| **Lowercase or sentence case** | ALL CAPS triggers spam filters and looks aggressive |
| **Personalize with first name sparingly** | "{{first_name}}, your trial is ending" -- use max 1-2x in a sequence |
| **No misleading RE: or FWD:** | Violates CAN-SPAM and destroys trust |
| **Avoid spam trigger words** | See list below |
| **Test emoji use for your audience** | Can boost open rates 5-10% or feel unprofessional -- A/B test it |

#### 3c: Spam Trigger Words to Avoid

Do not use these in subject lines. Email filters penalize them:

```
FREE, Act now, Limited time, Congratulations, You've been selected,
Click here, Buy now, Urgent, Winner, No obligation, Risk-free,
Guaranteed, Double your, $$, Make money, Cash, Credit, Discount,
Lowest price, Order now, Special promotion, While supplies last,
100% free, No cost, No fees, Apply now, Get started now
```

Note: context matters. "Free trial" in a SaaS onboarding email to opted-in users is fine. "FREE CASH GUARANTEED" is not.

#### 3d: Preview Text Optimization

Preview text appears after the subject line in most email clients (40-130 characters depending on device).

| Strategy | Example |
|----------|---------|
| **Complement, don't repeat** | Subject: "Your trial starts now" / Preview: "Here's the one thing to set up first" |
| **Tease the content** | Subject: "3 mistakes killing your conversions" / Preview: "#2 is the one nobody talks about" |
| **Create a sentence with the subject** | Subject: "We need to talk" / Preview: "...about the new dashboard features you haven't tried yet" |
| **Add social proof** | Subject: "How to close more deals" / Preview: "1,200+ sales teams already use this method" |

#### 3e: A/B Testing Framework

| Element | Test Method | Sample Size | Significance |
|---------|-------------|-------------|-------------|
| **Subject line** | A/B split 50/50 | Minimum 1,000 per variant | Wait for 95% confidence |
| **Send time** | A/B split across 2 times | Minimum 500 per variant | Test for 2 weeks |
| **From name** | Brand name vs. personal name | Full list split | Test over 4 sends |
| **Preview text** | A/B paired with winning subject | Minimum 1,000 per variant | 48-hour observation window |

**A/B test priority order** (highest impact first):
1. Subject line (affects open rate -- the gate to everything else)
2. CTA copy and placement (affects click rate)
3. From name (affects open rate and trust)
4. Send time (affects open rate, smaller effect)
5. Email length (affects click rate)

### Step 4: Email Body Framework

#### 4a: Structural Frameworks

Choose one framework per email based on its role in the arc.

**AIDA (Attention-Interest-Desire-Action)** -- best for sales-oriented emails:
```
ATTENTION: Opening line that stops the scroll (1 sentence)
INTEREST: Expand on the problem or opportunity (2-3 sentences)
DESIRE: Show the transformation or result (2-3 sentences + proof)
ACTION: Single clear CTA (1 sentence + button)
```

**PAS (Problem-Agitate-Solution)** -- best for objection-handling and pain-point emails:
```
PROBLEM: Name the specific pain they're experiencing (1-2 sentences)
AGITATE: Make the problem feel urgent or costly (2-3 sentences)
SOLUTION: Present your product/service as the answer (2-3 sentences + CTA)
```

**BAB (Before-After-Bridge)** -- best for transformation and social proof emails:
```
BEFORE: Describe their current frustrating state (2-3 sentences)
AFTER: Paint the picture of life after using your solution (2-3 sentences)
BRIDGE: Explain how to get from before to after -- your product (2 sentences + CTA)
```

**Story Framework** -- best for nurture and relationship-building emails:
```
HOOK: Start mid-action or with a surprising statement (1 sentence)
CONTEXT: Set the scene briefly (1-2 sentences)
CONFLICT: What went wrong or what was at stake (2-3 sentences)
RESOLUTION: What happened and what was learned (2-3 sentences)
LESSON: Connect the story to the reader's situation (1-2 sentences)
CTA: Bridge from lesson to action (1 sentence + button)
```

#### 4b: CTA Best Practices

| Rule | Implementation |
|------|---------------|
| **One primary CTA per email** | Multiple CTAs dilute clicks. Pick one action. |
| **Button + text link** | Include the CTA as both a styled button AND an inline text link below it |
| **Action-oriented verb** | "Start your project" not "Click here" or "Submit" |
| **First person on button** | "Start my free trial" outperforms "Start your free trial" by 25-30% |
| **Place CTA after value** | Earn the click before asking for it |
| **Repeat CTA at bottom** | Long emails: CTA after the main pitch AND at the email footer |
| **Contrast color for button** | Button should visually pop against the email background |

**CTA examples by email role:**

| Email Role | Weak CTA | Strong CTA |
|------------|----------|------------|
| Activation | "Click here" | "Create my first project" |
| Social proof | "Learn more" | "See how Acme saved 40%" |
| Trial expiry | "Upgrade" | "Keep my account active" |
| Abandoned cart | "Complete purchase" | "Finish checking out ($12.99)" |
| Re-engagement | "Come back" | "See what's new since February" |

#### 4c: Mobile-First Formatting Rules

Over 60% of emails are opened on mobile. Format accordingly:

| Rule | Why |
|------|-----|
| **Single column layout** | Multi-column breaks on small screens |
| **44px minimum CTA button height** | Apple's tap target minimum for usability |
| **14-16px body font size** | Smaller text requires zooming on mobile |
| **Max 600px email width** | Standard rendering width across clients |
| **Paragraphs of 2-3 sentences** | Long blocks of text are unreadable on mobile |
| **No image-only emails** | Images blocked by default in many clients; alt text is essential |
| **Preheader text in HTML** | Hidden text that populates the preview pane on mobile |
| **Test in dark mode** | Light text on dark background can make logos and buttons invisible |

#### 4d: Plain Text vs HTML

| Format | When to Use |
|--------|-------------|
| **Plain text** | Personal 1:1 feel, deliverability-focused sequences, B2B sales outreach, re-engagement campaigns |
| **HTML (simple)** | Branded communications, product-feature emails with screenshots, post-purchase with order details |
| **HTML (rich)** | Launch campaigns with design elements, abandoned cart with product images, e-commerce with multiple products |

Best practice: always include a plain-text version alongside HTML. Most platforms generate this automatically. If not, write it manually -- some enterprise clients block HTML entirely.

#### 4e: Storytelling Arc Across the Sequence

A great sequence is not 5 disconnected emails -- it is a single story told in chapters. Use narrative continuity:

| Technique | Example |
|-----------|---------|
| **Recurring character** | Introduce "Sarah" in Email 1 who had the same problem; reference her progress in Emails 3 and 5 |
| **Running thread** | "In the last email, I mentioned X. Here's what I didn't tell you..." |
| **Progressive disclosure** | Each email reveals one piece of the full solution |
| **Callback** | Final email references the opening line of Email 1 |
| **Escalating stakes** | Each email raises the cost of inaction slightly |

### Step 5: Individual Email Templates

Provide complete email copy for the selected sequence type. Below is a full 5-email Welcome/Onboarding sequence for a SaaS product as the reference template.

---

**EMAIL 1 of 5 -- WELCOME (Day 0, immediately after signup)**

```
SUBJECT OPTIONS:
  A: Welcome to [Product] — here's your quick-start guide
  B: You're in — let's get you set up in 5 minutes
  C: Your [Product] account is ready (do this first)

PREVIEW TEXT: The one setup step that saves you hours later.

FROM: [Founder first name] at [Product]

---

Hi {{first_name}},

Welcome to [Product] — I'm glad you're here.

You just joined [X,000+] teams who use [Product] to [core benefit
statement — e.g., "manage projects without the chaos"]. Your 14-day
trial starts today.

Here's the fastest way to get value from your account:

**Step 1: [Most important activation action]**
[1-sentence instruction + link to the feature]

That single step is what separates teams who love [Product] from
teams who forget they signed up. It takes about 3 minutes.

If you have questions at any point, just reply to this email.
I read every one.

Talk soon,
[Founder name]
[Title], [Product]

P.S. Tomorrow I'll send you [teaser for Email 2 — e.g., "a 2-minute
video walkthrough of the dashboard"].

[BUTTON: "Set up my account →"]
```

---

**EMAIL 2 of 5 -- ACTIVATE (Day 1)**

```
SUBJECT OPTIONS:
  A: Day 2: the feature most people discover too late
  B: A 2-minute walkthrough of your [Product] dashboard
  C: {{first_name}}, have you tried [key feature] yet?

PREVIEW TEXT: This is the feature our power users set up on day one.

---

Hi {{first_name}},

Quick question — did you get a chance to [activation action from
Email 1]?

If yes — great, you're ahead of most new users.

If not — no worries. Here's a 2-minute walkthrough that makes it
simple:

[LINK or embedded video thumbnail: "Watch the 2-min setup guide"]

While you're in there, check out [Feature B]. It's the feature that
users tell us they wish they'd found sooner. Here's why:

**[Feature B] lets you [specific benefit].**

For example, [concrete example — e.g., "instead of switching between
three tabs to check project status, you see everything in one view"].

Here's how to turn it on:
1. Go to Settings → [Feature B]
2. Toggle "Enable [Feature B]"
3. Done — it takes 30 seconds

Tomorrow I'll share how [Customer Name] uses [Product] to
[impressive result].

[BUTTON: "Turn on [Feature B] →"]
```

---

**EMAIL 3 of 5 -- SOCIAL PROOF (Day 3)**

```
SUBJECT OPTIONS:
  A: How [Customer] cut [pain point] by [X]%
  B: "We tried 4 tools before finding [Product]"
  C: The results after 30 days with [Product]

PREVIEW TEXT: A real story from a team like yours.

---

Hi {{first_name}},

I wanted to share something from [Customer Name], who runs
[brief company description — similar to reader's profile].

Before [Product], their team was [specific pain point — e.g.,
"tracking projects across 3 different spreadsheets and losing
tasks in Slack threads"].

After switching to [Product]:

  - [Result 1 — e.g., "Project delivery time dropped 34%"]
  - [Result 2 — e.g., "Team standup meetings went from 30 min
    to 10 min"]
  - [Result 3 — e.g., "Zero missed deadlines in 3 months"]

Here's what [Customer contact name] said:

> "[Direct quote from customer — keep it specific and
> result-oriented, not generic praise]"

The setup that got them these results took about 20 minutes.
You're already partway there.

**Want the same setup?** I put together a template based on
their workflow:

[BUTTON: "Use the [Customer] template →"]

If you have questions, just hit reply.

[Founder name]
```

---

**EMAIL 4 of 5 -- OBJECTION HANDLING (Day 7)**

```
SUBJECT OPTIONS:
  A: "What if my team won't actually use it?"
  B: The #1 concern about [Product] (and the honest answer)
  C: Is [Product] worth it? Here's how to decide.

PREVIEW TEXT: The most common question from trial users — answered.

---

Hi {{first_name}},

About a week into a trial, most people start thinking the same
thing:

"This seems good, but will my team actually adopt it?"

Fair question. Here's the honest answer:

**Adoption depends on one thing: whether the tool fits into how
your team already works — not whether your team changes to fit
the tool.**

That's why we built [Feature C] — it [specific capability that
reduces adoption friction, e.g., "integrates with Slack, so your
team gets updates where they already are, without learning a new
interface"].

Here's what adoption actually looks like:

  **Week 1:** You set up the workspace (done — you're here)
  **Week 2:** You invite 2-3 team members to try one project
  **Week 3:** Those team members invite others because it's
  easier than the old way

You don't need to migrate everything at once. Start with one
project. If it works, expand.

**You have 7 days left on your trial.** That's enough time to
run a real test with your team.

[BUTTON: "Invite my team →"]

P.S. If price is the concern — reply and tell me about your team
size. I'll make sure you're on the right plan.
```

---

**EMAIL 5 of 5 -- CONVERSION / URGENCY (Day 12)**

```
SUBJECT OPTIONS:
  A: Your trial ends in 48 hours
  B: {{first_name}}, keep your [Product] workspace?
  C: Last call — your projects will be archived Friday

PREVIEW TEXT: Everything you've built is saved — if you upgrade
before [day].

---

Hi {{first_name}},

Your [Product] trial ends on [date — e.g., "this Friday at
midnight"].

Here's what you've built so far:

  - [X] projects created
  - [X] tasks completed
  - [X] team members invited

(If those numbers are low, that's okay — but it means the
best way to evaluate [Product] is in the next 48 hours.)

**What happens when the trial ends:**
- Your workspace is archived (not deleted) for 30 days
- You lose access to [key feature] and [key feature]
- Your team members are logged out

**What happens when you upgrade:**
- Everything stays exactly as it is
- Plans start at $[price]/month ([price per user] per user)
- Cancel anytime — no contracts, no hassle

Most teams who upgrade tell us they decided within the first
week. You've had almost two.

[BUTTON: "Keep my workspace — Upgrade now →"]

If [Product] isn't right for you, no hard feelings. Your data
stays archived for 30 days in case you change your mind.

But if it IS right and you just haven't gotten around to it —
this is the nudge.

[Founder name]

P.S. Hit reply if you need more time. I can extend your trial
if you're still evaluating.
```

---

### Step 6: Segmentation and Personalization

#### 6a: Behavioral Triggers

Move subscribers between sequences based on actions, not just time.

| Trigger Event | Action |
|---------------|--------|
| **Opened Email 1 but not Email 2** | Send a re-send of Email 2 with a different subject line |
| **Clicked activation link** | Skip the activation reminder email; advance to social proof |
| **Visited pricing page** | Tag as "high intent"; send pricing-specific email |
| **Completed key action** | Move from onboarding to retention/upsell sequence |
| **No opens for 3+ emails** | Move to re-engagement sequence |
| **Purchased** | Exit the sales sequence immediately; move to post-purchase |
| **Replied to any email** | Tag as "engaged"; notify sales team if applicable |
| **Unsubscribed** | Exit all sequences; do not re-add without explicit opt-in |

#### 6b: Dynamic Content Blocks

Use conditional logic to personalize email body based on subscriber data:

```
{% if plan == "free" %}
  You're currently on the Free plan. Upgrade to Pro to unlock
  [feature list].
{% elif plan == "trial" %}
  Your trial ends in {{days_remaining}} days. Here's what
  you'll keep when you upgrade.
{% elif plan == "pro" %}
  As a Pro member, you have early access to our new [feature].
{% endif %}
```

**Common dynamic blocks:**

| Block | Personalizes By | Example |
|-------|----------------|---------|
| **Industry** | Subscriber's industry tag | Different case studies for SaaS vs. e-commerce |
| **Role** | Job title or role tag | CEO sees ROI metrics; developer sees API docs |
| **Usage level** | Product activity data | Power user gets advanced tips; inactive gets re-activation |
| **Plan tier** | Current subscription level | Free user gets upgrade pitch; paid user gets upsell |
| **Location** | Geographic data | Timezone-appropriate send times; region-specific offers |
| **Funnel stage** | Lead score or activity | High-intent leads skip educational content |

#### 6c: Merge Tags Reference

| Platform | First Name | Email | Custom Field | Date | Fallback |
|----------|-----------|-------|--------------|------|----------|
| **Mailchimp** | `*|FNAME|*` | `*|EMAIL|*` | `*|FIELDNAME|*` | `*|DATE:d/m/Y|*` | `*|FNAME|default:friend*` |
| **ConvertKit** | `{{ subscriber.first_name }}` | `{{ subscriber.email_address }}` | `{{ subscriber.field_name }}` | -- | `{{ subscriber.first_name \| default: "friend" }}` |
| **ActiveCampaign** | `%FIRSTNAME%` | `%EMAIL%` | `%FIELDNAME%` | `%CURRENTDATE%` | `%FIRSTNAME:friend%` |
| **Klaviyo** | `{{ first_name }}` | `{{ email }}` | `{{ person.field }}` | `{{ now }}` | `{{ first_name\|default:"friend" }}` |
| **HubSpot** | `{{ contact.firstname }}` | `{{ contact.email }}` | `{{ contact.field }}` | `{{ today }}` | `{{ contact.firstname \| default("friend") }}` |
| **Drip** | `{{ subscriber.first_name }}` | `{{ subscriber.email }}` | `{{ subscriber.tags }}` | -- | `{{ subscriber.first_name \| default: "there" }}` |

**Always include a fallback value.** If the first name field is empty, "Hi friend" is better than "Hi ".

#### 6d: Conditional Logic Patterns

Build branching automation logic using if/then rules:

```
AUTOMATION FLOW:

[Trigger: User signs up for trial]
  |
  ├── Send Email 1 (Welcome) — immediately
  |
  ├── Wait 1 day
  |
  ├── Check: Did user complete activation action?
  |     ├── YES → Tag "activated" → Send Email 3 (Social Proof) on Day 3
  |     └── NO  → Send Email 2 (Activation nudge) → Wait 2 days
  |                 ├── Check: Activated now?
  |                 │     ├── YES → Send Email 3 on schedule
  |                 │     └── NO  → Send Email 3 anyway (proof motivates action)
  |
  ├── Wait until Day 7
  |
  ├── Check: Has user visited pricing page?
  |     ├── YES → Send pricing-specific Email 4 (high-intent variant)
  |     └── NO  → Send standard Email 4 (Objection handling)
  |
  ├── Wait until Day 12
  |
  ├── Check: Has user converted to paid?
  |     ├── YES → EXIT sequence → Enter Post-Purchase sequence
  |     └── NO  → Send Email 5 (Urgency / trial ending)
  |
  └── Day 14: Trial expires
        ├── Converted → Post-Purchase sequence
        └── Not converted → Enter Re-engagement sequence (wait 7 days, then start)
```

### Step 7: Metrics and Optimization

#### 7a: Benchmark Metrics by Sequence Type

| Metric | Welcome | Nurture | Launch | Abandoned Cart | Re-engagement |
|--------|---------|---------|--------|----------------|---------------|
| **Open rate** | 50-60% | 25-35% | 20-30% | 40-50% | 15-25% |
| **Click rate** | 15-25% | 3-7% | 3-8% | 10-15% | 3-5% |
| **Conversion rate** | 5-10% | 1-3% | 2-5% | 5-15% | 2-5% |
| **Unsubscribe rate** | < 0.5% | < 0.3% | < 0.5% | < 0.2% | 1-3% (expected) |

#### 7b: Industry Benchmarks

| Industry | Avg Open Rate | Avg Click Rate | Avg Conversion Rate |
|----------|--------------|----------------|-------------------|
| **SaaS / Technology** | 25-30% | 3-5% | 1-3% |
| **E-commerce** | 20-25% | 2-4% | 2-5% |
| **Professional services** | 25-30% | 3-5% | 1-2% |
| **Health & wellness** | 25-30% | 2-4% | 1-3% |
| **Education / Courses** | 30-35% | 4-6% | 2-4% |
| **Finance** | 25-30% | 3-5% | 1-2% |
| **Non-profit** | 30-35% | 3-5% | 1-2% |
| **Media / Publishing** | 25-30% | 4-6% | 1-2% |

#### 7c: Optimization Priority Matrix

When a sequence underperforms, diagnose in this order:

| Problem | Diagnostic | Fix |
|---------|-----------|-----|
| **Low open rate (< 20%)** | Subject lines, from name, send time, list quality | A/B test subject lines; test personal from name; clean list of inactive subscribers |
| **High opens, low clicks (< 2%)** | Email content, CTA clarity, relevance | Rewrite CTA copy; reduce to single CTA; improve content-to-CTA bridge |
| **High clicks, low conversions** | Landing page, offer, price, friction | Audit landing page; simplify checkout; test pricing; add trust signals |
| **High unsubscribe rate (> 0.5%)** | Frequency, relevance, expectation mismatch | Reduce send frequency; improve segmentation; set expectations at signup |
| **High spam complaints (> 0.1%)** | Permission, content quality, unsubscribe visibility | Verify opt-in process; make unsubscribe link prominent; review content for clickbait |
| **Declining engagement over sequence** | Content fatigue, wrong cadence | Shorten sequence; add more value per email; increase spacing between sends |

#### 7d: Deliverability Best Practices

| Practice | Implementation |
|----------|---------------|
| **Authenticate your domain** | Set up SPF, DKIM, and DMARC records |
| **Warm up new domains** | Start with 50 sends/day, increase 20% daily over 2-3 weeks |
| **Maintain list hygiene** | Remove hard bounces immediately; soft bounces after 3 consecutive |
| **Use double opt-in** | Confirms intent and improves list quality |
| **Monitor sender reputation** | Check Google Postmaster Tools, Microsoft SNDS monthly |
| **Include physical address** | Required by CAN-SPAM; use your business address or a PO box |
| **Make unsubscribe easy** | One-click unsubscribe in header; visible link in footer |
| **Avoid image-heavy emails** | Aim for 60/40 text-to-image ratio minimum |
| **Test before sending** | Use Mail Tester, Litmus, or Email on Acid to preview across clients |
| **Consistent from address** | Don't rotate sender addresses -- it confuses spam filters |

### Step 8: Output

Present the complete sequence in this structured format:

```
============================================================
EMAIL SEQUENCE: [Sequence Name]
============================================================
Type: [Welcome / Nurture / Launch / Abandoned Cart / etc.]
Audience: [Segment description]
Product: [Product/service name]
Goal: [Primary conversion action]
Platform: [Email platform]
Total emails: [count]
Duration: [total days from first to last send]

── TIMING DIAGRAM ─────────────────────────────────────────

Day 0    Day 1    Day 3    Day 7    Day 12
  |        |        |        |        |
  E1       E2       E3       E4       E5
  Welcome  Activate Proof    Objection Urgency

── AUTOMATION LOGIC ───────────────────────────────────────

[Trigger] → E1 → [Wait] → [Condition check] → E2 or skip
→ [Wait] → E3 → [Wait] → [Condition] → E4 variant A/B
→ [Wait] → [Conversion check] → E5 or exit

── EXIT CONDITIONS ────────────────────────────────────────

• User converts (purchases/upgrades) → Exit → Post-Purchase
• User unsubscribes → Exit immediately
• User marks as spam → Exit immediately
• Sequence completes without conversion → [Next sequence]

── EMAIL 1 of [N] ─────────────────────────────────────────
Role: [Welcome / Activate / Proof / etc.]
Send: [Timing — Day X, or trigger-based]
Subject (A): [Subject line option A]
Subject (B): [Subject line option B]
Preview text: [Preview text]
From: [From name and address]
CTA: [Button text] → [URL]
Framework: [AIDA / PAS / BAB / Story]

[Full email body copy]

── EMAIL 2 of [N] ─────────────────────────────────────────
[Same structure]

[... repeat for all emails ...]

── SEGMENTATION RULES ─────────────────────────────────────

Tag: [tag name] — Applied when: [condition]
Tag: [tag name] — Applied when: [condition]
Dynamic block: [block name] — Shows for: [segment]

── A/B TEST PLAN ──────────────────────────────────────────

Test 1: Email 1 subject line A vs B — Metric: open rate
Test 2: Email 4 CTA copy — Metric: click rate
Test 3: Email 5 with/without P.S. — Metric: conversion

── SUCCESS METRICS ────────────────────────────────────────

Target open rate: [X]%
Target click rate: [X]%
Target sequence conversion rate: [X]%
Review date: [2 weeks after launch]
============================================================
```

---

## Anti-Patterns

- **Writing emails in isolation.** Each email must connect to the previous and set up the next. Writing them independently produces a disjointed experience. Always design the arc (Step 2b) before writing individual emails.
- **Multiple CTAs per email.** Every additional CTA reduces click-through on the primary action. One email, one CTA. If you need a secondary link, make it visually subordinate (text link, not button).
- **Same subject line formula every time.** If every email uses a question format, the subscriber tunes out by Email 3. Vary the formula across the sequence (curiosity, benefit, social proof, urgency).
- **Sending the same sequence to everyone.** A trial user and a lead magnet downloader have different awareness levels. Segment your sequences by audience and behavior. A one-size-fits-all sequence converts poorly.
- **No exit conditions.** If a user purchases on Day 3, do not send them the "your trial is ending" email on Day 12. Always build conversion-based exit logic into the automation.
- **Treating email like a blog post.** Email is a conversation, not a publication. Keep paragraphs to 2-3 sentences. Write like you are talking to one person. Use "you" more than "we."
- **Ignoring the plain text version.** Some email clients, corporate firewalls, and accessibility tools render plain text only. If your email is only designed in HTML, these subscribers see a broken mess.
- **Front-loading the pitch.** If Email 1 is a hard sell, there is no Email 2 -- the subscriber is gone. Welcome emails should deliver value first and sell later. The first 2-3 emails earn the right to pitch.
- **Not testing on mobile.** If the email looks good on desktop but the CTA button is cut off on an iPhone SE, you lose 60%+ of your potential clicks. Test every email on at least one mobile device.
- **Arbitrary send timing.** "Every 3 days" is not a strategy. Timing should be based on the sequence type (Step 2c), audience behavior (B2B vs B2C), and the natural decision timeline for your product.

## Escalation

Hand off to a specialist when:

- **The sequence requires deep CRM integration with lead scoring.** This skill builds email content and automation logic, but complex lead scoring models with multi-property rules are better handled by a marketing automation specialist using the platform's native tools.
- **The user needs custom HTML email templates.** This skill produces the copy, structure, and CTA logic. Visual design, custom HTML/CSS, responsive templates, and pixel-perfect rendering require a dedicated email designer or developer.
- **Legal compliance review is needed.** Sequences involving financial services, healthcare, or international audiences (GDPR, CASL, CAN-SPAM) should be reviewed by a compliance specialist before sending.
- **The sequence is part of a larger multi-channel campaign.** If the email sequence must coordinate with landing pages (landing-page-copy), ad campaigns (facebook-ad, google-ad), or webinars (webinar-script), recommend running those skills separately and aligning timing across channels.
- **Deliverability issues require infrastructure changes.** If emails are landing in spam, the problem may be DNS configuration (SPF/DKIM/DMARC), IP reputation, or sending infrastructure -- not content. Escalate to a deliverability specialist or the platform's support team.
- **The product requires a sales-assisted sequence.** If the conversion path involves a sales rep (demo booking, custom quotes), this skill designs the email content, but the handoff logic and CRM integration need sales ops involvement.

## Inputs

- Sequence type: Welcome, Nurture, Launch, Abandoned Cart, Re-engagement, Post-Purchase (required)
- Audience segment description (required)
- Product or service being promoted (required)
- Desired conversion action (required)
- Email platform (optional -- affects merge tag syntax and automation capabilities)
- Brand voice and tone guidelines (optional)
- Existing marketing assets: landing pages, testimonials, case studies (optional)
- Price point and billing model (optional)
- Audience awareness level (optional)

## Outputs

- Complete email sequence with subject lines, preview text, and full body copy for every email
- Sequence arc diagram mapping each email to its narrative role
- Timing diagram with send schedule and cadence rationale
- Automation flow with conditional branching logic and exit conditions
- Behavioral trigger map for segment-based routing
- Segmentation rules with dynamic content blocks and merge tags
- A/B test plan prioritized by expected impact
- Performance benchmarks with industry-specific targets
- Deliverability checklist
- Platform-ready structured output

## Level History

- **Lv.1** -- Base: Full 8-step protocol (gather inputs, sequence architecture, subject line engineering, email body framework, individual email templates, segmentation and personalization, metrics and optimization, structured output). 6 sequence types with timing and cadence (Welcome, Nurture, Launch, Abandoned Cart, Re-engagement, Post-Purchase). Narrative arc design for each type. 9 subject line formulas with spam trigger avoidance. Preview text and A/B testing framework. 4 email body frameworks (AIDA, PAS, BAB, Story). CTA best practices with weak vs strong examples. Mobile-first formatting rules. Plain text vs HTML guidance. Storytelling arc across sequence with continuity techniques. Complete 5-email welcome sequence templates with full copy. Behavioral trigger map with 8 event-action pairs. Dynamic content blocks with conditional logic patterns. Merge tag reference for 6 major platforms. Automation flow diagram with branching logic. Benchmark metrics by sequence type and industry. Optimization priority matrix for underperforming sequences. Deliverability best practices checklist. Anti-patterns, escalation matrix, structured output format. (Origin: MemStack v3.3, Mar 2026)
