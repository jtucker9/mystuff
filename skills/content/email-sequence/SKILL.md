---
name: email-sequence
description: "Design multi-email automated campaigns with timing, segmentation, and automation logic. WHEN: 'email sequence', 'drip campaign', 'email series', 'nurture sequence', 'onboarding emails', 'abandoned cart emails', 're-engagement campaign'. NOT: single newsletters (newsletter), one-off promotional emails, landing page copy (landing-page-copy), social content."
---

# Email Sequence

## Activation

| Context | Status |
|---------|--------|
| Multi-email automated campaign request | ACTIVE |
| "drip campaign", "welcome series", "cart recovery" | ACTIVE |
| Single newsletter edition | DORMANT -- see newsletter |
| Single promotional email | DORMANT -- write directly |
| Landing page or social content | DORMANT -- see respective skill |

Output on activation: `Email Sequence -- Building your campaign...`

## Instructions

### Step 1: Gather Inputs

Collect all required inputs before proceeding. Do not assume defaults for required fields.

| Input | Required | Notes |
|-------|----------|-------|
| Sequence type | Yes | Welcome, Nurture, Launch, Cart, Re-engage, Post-Purchase |
| Audience segment | Yes | Who receives this and their awareness level |
| Product/service | Yes | What you are selling |
| Desired action | Yes | Ultimate conversion goal |
| Platform | No | Affects automation capabilities |
| Brand voice | No | Defaults to professional, friendly |
| Existing assets | No | Landing pages, testimonials, case studies |
| Price point | No | Affects urgency tactics |

**Gate:** All 4 required inputs confirmed before proceeding.

### Step 2: Sequence Architecture

Select type, map the arc, then set cadence. Do not write copy until the blueprint is locked.

#### Sequence Type Decision Tree

| Type | Trigger | Emails | Cadence |
|------|---------|--------|---------|
| **Welcome / Onboarding** | Signup or trial start | 5-7 | Day 0, 1, 3, 5, 7, 10, 13 |
| **Nurture** | Lead magnet download | 5-8 | Every 2-3 days, 2-3 weeks |
| **Launch / Promo** | Campaign start | 4-6 | Day 1, 3, 5, 6, 7 (compress last 48h) |
| **Abandoned Cart** | Cart abandonment | 3-4 | 1h, 24h, 48h, 72h |
| **Re-engagement** | 30-90 day inactivity | 3-5 | Day 0, 3, 7, 14, then remove |
| **Post-Purchase** | Purchase confirmed | 4-6 | Immediate, Day 2, 7, 14, 30 |

#### Arc Roles per Type

Each email gets one role. Map roles before writing.

- **Welcome:** Deliver > Activate > Educate > Prove > Overcome > Urge > Final
- **Nurture:** Value > Story > Framework > Mistake > Proof > Bridge > Offer > FAQ
- **Launch:** Announce > Educate > Prove > Overcome > Urge > Last Call
- **Cart:** Remind > Overcome > Incentivize > Final
- **Re-engage:** Miss You > Value > Feedback > Incentive > Sunset (list clean)
- **Post-Purchase:** Confirm > Onboard > Check-in > Review Ask > Upsell > Referral

#### Cadence Rules

- Never 2 emails same day (exceptions: cart recovery, launch final 48h)
- B2B: Tue-Thu, 9-11 AM recipient time. B2C: Tue/Thu/Sun
- Cart: first email within 1 hour -- recovery drops 50% after 24h
- Every sequence must have exit conditions (conversion, unsub, spam)

**Gate:** Arc blueprint with email count, roles, and timing confirmed before writing.

### Step 3: Subject Lines

Write 2-3 options per email. Vary formula across the sequence.

#### Subject Line Rules

- 40-50 characters max (truncation kills mobile open rates)
- Front-load value in first 25 characters
- Sentence case only -- ALL CAPS triggers spam filters
- Personalize with first name max 1-2x per sequence
- No misleading RE:/FWD: -- violates CAN-SPAM
- Preview text: complement the subject, never repeat it (40-130 chars)

#### Spam Triggers to Avoid in Subjects

FREE, Act now, Limited time, Congratulations, Click here, Buy now, Urgent, Winner, No obligation, Risk-free, Guaranteed, Double your, $$, Make money. Context matters: "free trial" to opted-in users is fine.

#### A/B Test Priority Order

1. Subject line (open rate gate)
2. CTA copy and placement (click rate)
3. From name (trust + open rate)
4. Send time (smaller open rate effect)
5. Email length (click rate)

Minimum 1,000 per variant, 95% confidence before declaring winner.

**Gate:** Subject line options drafted for all emails before writing body copy.

### Step 4: Email Copy

Choose framework per email based on its arc role. Do not write full templates -- write the actual emails for the user's product and audience.

#### CTA Rules

- One primary CTA per email -- multiple CTAs dilute clicks
- Button + inline text link (both pointing to same action)
- First person on buttons ("Start my trial" > "Start your trial")
- Place CTA after value is established, repeat at bottom for long emails
- Action verbs: "Create my first project" not "Click here"

#### Format Decision

- Plain text: 1:1 feel, B2B sales, re-engagement
- Simple HTML: branded comms, feature emails with screenshots
- Rich HTML: launch campaigns, cart recovery with product images

**Gate:** Each email has exactly one CTA, one arc role, and one framework before finalizing.

### Step 5: Segmentation

Define behavioral triggers that move subscribers between sequences.

#### Trigger Types

| Event | Action |
|-------|--------|
| Clicked activation link | Skip reminder, advance to next role |
| Visited pricing page | Tag high-intent, send pricing variant |
| Completed key action | Move to retention/upsell sequence |
| No opens 3+ emails | Move to re-engagement |
| Purchased | Exit sales sequence, enter post-purchase |
| Replied | Tag engaged, notify sales if applicable |

### Step 6: Output

Present: timing diagram, automation flow with branching, exit conditions, all emails with subjects/preview/body/CTA, segmentation rules, A/B test plan, target metrics.

**Gate:** Output includes exit conditions for every conversion path.

## Examples

**Welcome sequence for SaaS trial:**
5 emails over 13 days. Arc: Welcome > Activate > Social Proof > Objection > Urgency. Exit on conversion to paid. Branch at Day 7: pricing page visitors get high-intent variant.

**Abandoned cart for e-commerce:**
3 emails: 1h reminder with cart contents, 24h objection handler with social proof, 48h incentive with discount code. Exit on purchase. Suppress if item goes out of stock.

## Common Issues

- **Open rates below 20%:** Subject lines are the problem -- A/B test first, then check list hygiene and from name.
- **High opens, low clicks:** CTA is buried, unclear, or competing with secondary links -- reduce to single CTA with action verb.
- **Subscribers getting emails after converting:** Missing exit conditions in automation -- add conversion check before every send after Email 1.

## Anti-Patterns

- Writing emails in isolation without mapping the arc first -- produces disjointed sequences
- Same subject line formula every email -- subscribers tune out by Email 3
- No exit conditions -- converted users receiving trial-ending urgency emails
- Hard sell in Email 1 -- welcome emails earn the right to pitch; value first
- Sending identical sequence to all segments -- trial users and lead magnet downloaders need different arcs
- Treating email like blog posts -- 2-3 sentence paragraphs, conversational tone, "you" not "we"

## Escalation

- Complex CRM lead scoring integration -- marketing automation specialist
- Custom HTML/CSS responsive templates -- email designer/developer
- GDPR/CASL/CAN-SPAM compliance review -- legal specialist
- Multi-channel campaign coordination -- run landing-page-copy, facebook-ad, google-ad skills separately
- Emails landing in spam due to DNS/IP reputation -- deliverability specialist

## Inputs

- Sequence type (required)
- Audience segment (required)
- Product/service (required)
- Conversion goal (required)
- Email platform (optional)
- Brand voice (optional)
- Existing assets (optional)
- Price point (optional)

## Outputs

- Complete email sequence: subjects, preview text, body copy per email
- Sequence arc diagram with email roles
- Timing diagram with cadence
- Automation flow with conditional branching and exit conditions
- Behavioral trigger map for segmentation
- A/B test plan prioritized by impact
- Target benchmarks: open rate, click rate, conversion rate by sequence type

## Metrics Benchmarks

| Metric | Welcome | Nurture | Launch | Cart | Re-engage |
|--------|---------|---------|--------|------|-----------|
| Open rate | 50-60% | 25-35% | 20-30% | 40-50% | 15-25% |
| Click rate | 15-25% | 3-7% | 3-8% | 10-15% | 3-5% |
| Conversion | 5-10% | 1-3% | 2-5% | 5-15% | 2-5% |
| Unsub ceiling | 0.5% | 0.3% | 0.5% | 0.2% | 3% |

## Level History

- **Lv.1** -- Base: 8-step protocol, 6 sequence types with arcs, subject/CTA/segmentation rules, 5-email welcome templates, merge tag references, framework breakdowns (AIDA/PAS/BAB/Story), industry benchmark tables, deliverability checklist. (Origin: MemStack v3.3, Mar 2026)
- **Lv.2** -- Compressed: Decision-rule density rewrite. Removed full email templates, framework breakdowns, merge tag tables, industry benchmarks. Preserved sequence decision tree, arc roles, subject line rules, spam triggers, A/B priority order, CTA rules, segmentation triggers, metrics benchmarks by type. Added validation gates between steps. (Origin: MemStack v3.4, Mar 2026)
