---
name: webinar-script
description: "Generate a timestamped teach-to-sell webinar script with slide notes, presenter cues, and replay email sequence. Use when the user says 'webinar script', 'webinar', 'live presentation', 'webinar outline', 'pitch presentation', or wants a structured presentation that teaches then sells. Do NOT use for launch plans where webinar is one channel (see launch-plan), static sales page copy (see landing-page-copy), or YouTube video scripts without a live pitch (see youtube-script)."
---


# Webinar Script -- Teach-to-Sell Presentation

*Generate a timestamped webinar script with slide notes, presenter cues, and replay email sequence.*

## Activation

When this skill activates, output:

`Webinar Script -- Writing your teach-to-sell presentation...`

| Context | Status |
|---------|--------|
| **User says "webinar script", "webinar", "live presentation"** | ACTIVE |
| **User wants a presentation that teaches and then pitches** | ACTIVE |
| **User mentions webinar funnels or replay sequences** | ACTIVE |
| **User wants a launch plan with webinar as one channel** | DORMANT -- see launch-plan |
| **User wants static sales page copy (not live presentation)** | DORMANT -- see landing-page-copy |
| **User wants a YouTube video without a live pitch** | DORMANT -- see youtube-script |

## Instructions

### Step 1: Gather Inputs

Ask the user for:
- **Topic**: What will you teach?
- **Product to pitch**: Name, price, what's included
- **Target audience**: Who is attending? Expertise level?
- **Duration**: 45 or 60 minutes (default: 60)
- **Platform**: Zoom, WebinarJam, Demio, YouTube Live, etc. (optional)

**Gate**: Do not proceed without topic, product (name + price), and target audience.

### Step 2: Opening -- Hook and Frame (0:00-5:00)

**Hook (0:00-1:00):** Open with a bold statement, surprising stat, or provocative question. Never open with "Hi, I'm [name] and today we'll talk about..."

**Credibility (1:00-2:00):** 2-3 sentences, results-focused not resume-focused.

**Promise (2:00-3:00):** State exactly what they'll walk away with. Set the expectation: teaching first, then an offer.

**Agenda (3:00-5:00):** Preview 3 teaching points. First engagement prompt: "Type in the chat -- what's your biggest challenge with [topic]?"

Slides 1-3: Title, outcomes, agenda. Cue: acknowledge 2-3 chat responses.

### Step 3: Content -- Three Teaching Points (5:00-30:00)

Each point follows the same structure: **What** (name the concept) > **Why** (connect to pain) > **How** (high-level steps -- enough to understand, not enough to implement alone) > **Proof** (example or case study) > **Mini-CTA** ("I'll show you how to go deeper later").

- **Point 1 (5:00-13:00):** Core concept. Slides 4-6.
- **Point 2 (13:00-21:00):** Address the biggest objection or misconception. Use contrast: "Most people think X, but actually Y." Slides 7-9.
- **Point 3 (21:00-30:00):** Naturally bridge to the paid offer. Show the gap: "You now know WHAT to do, but implementing it requires [thing your product provides]." Slides 10-12.

Each point gets a chat engagement cue after the proof element.

**Gate**: Each teaching point must deliver standalone value. If a point only makes sense with the paid product, rewrite it.

### Step 4: Transition -- Bridge to Offer (30:00-35:00)

**Bridge (30:00-32:00):** Recap 3 points. Acknowledge they could do it alone. Identify the gap: time, complexity, accountability, missing pieces.

**Permission (32:00-33:00):** "I've built something that solves exactly this. Can I share it with you?" Wait for chat affirmation.

**Qualify (33:00-35:00):** "This is for you if [3 qualifiers]" and "This is NOT for you if [2 disqualifiers]." Filters the audience so those who stay are pre-qualified.

Slides 13-14. Cue: pause, read chat, transition deliberately.

### Step 5: Offer -- Present the Product (35:00-45:00)

**Product reveal (35:00-37:00):** Name, visual, one-sentence description. Do NOT start with price.

**Inclusions (37:00-40:00):** Walk through each component. For each: name, explain, state value. Stack visually with running total.

**Bonuses (40:00-42:00):** 2-3 bonuses with stated value. "Only available when you sign up during this webinar."

**Price reveal (42:00-43:00):** Value stack total first, then actual price. Show payment plan if available.

**Guarantee (43:00-44:00):** Specific, generous risk reversal.

**CTA (44:00-45:00):** Single clear action. Repeat link 3 times. "I'll keep this open while we do Q&A."

Slides 15-20. Cue: drop link in chat, "Who's in? Type 'I'm in!'"

**Gate**: Offer must include guarantee and at least one urgency element. If user has no guarantee, recommend one before finalizing.

### Step 6: Q&A -- Pre-Planted + Live (45:00-55:00)

Prepare 5-7 pre-planted questions covering: beginner suitability, time commitment, guarantee restatement, access timing, support availability, differentiation from alternatives, payment options.

Start with 2-3 pre-planted, then open to live. Redirect complex questions to DMs or post-purchase. Show CTA link on Q&A slide throughout.

### Step 7: Close -- Urgency and Final CTA (55:00-60:00)

Pick 1-2 honest urgency elements: bonus expiration, limited spots (if true), price increase after live, fast-action bonus.

Final recap: what they get, price, guarantee, link. Thank audience genuinely. "Whether you join today or not, go implement what you learned."

Slides 22-23. Cue: stay live 2-3 extra minutes for stragglers.

### Step 8: Replay Email Sequence

Generate 5 emails:
1. **Replay available (+1hr):** Replay link, 3 key takeaways, CTA
2. **Key insight (+1 day):** Expand most impactful teaching point, bridge to offer
3. **Social proof (+2 days):** Testimonial or early win, CTA
4. **Objection handling (+3 days):** Top 3 objections in FAQ format
5. **Last chance (+4 days):** Recap offer, deadline, final CTA

Each email: subject line + body summary only. Do not write full email copy unless asked.

**Gate**: Replay sequence must reference actual content from the webinar script, not generic templates.

### Step 9: Compile Output

Present as a single structured document: timestamped script with presenter dialogue, 23-slide deck outline, pre-planted Q&A bank, and replay email sequence with subject lines.

## Examples

**Example 1 -- Course creator selling a coaching program**
User: "Write a webinar script. I teach freelancers how to land $5K clients. Pitching my 8-week coaching program at $997. Audience: freelance designers and developers, intermediate level. 60 min on Zoom."
Output: Hook stat about average freelancer income, 3 teaching points (positioning, outreach scripts, pricing psychology), bridge identifying accountability gap, offer with value stack, 7 Q&A questions, 5-email replay sequence.

**Example 2 -- SaaS founder doing a product demo webinar**
User: "Webinar script for our project management tool launch. Free trial pitch, not a paid product. Target: small agency owners. 45 minutes."
Output: Adjusted structure -- teaching points focus on workflow problems agencies face, offer section presents free trial with onboarding bonus instead of price reveal, urgency tied to limited onboarding slots, replay sequence drives trial signups.

## Common Issues

- **User has no testimonials or social proof yet**: Use framework results, personal case study, or logical proof instead. Flag that social proof should be added after first cohort.
- **Webinar is under 45 minutes**: Cut to 2 teaching points instead of 3. Compress Q&A to pre-planted only. Do not cut the transition or offer sections.
- **Product has no guarantee**: Recommend a conditional guarantee ("If you do X and don't see Y, I'll refund you") and explain why risk reversal increases conversion.

## Anti-Patterns

- Writing the full webinar as a monologue instead of timestamped segments with cues
- Teaching so thoroughly that the audience feels no need for the paid product
- Skipping the permission bridge and jumping straight from teaching to pitching
- Using fake urgency (limited spots when there are none, fake countdown timers)
- Making the teaching section a thinly disguised sales pitch instead of delivering real value
- Writing full email copy for all 5 replay emails instead of subject lines and summaries
- Ignoring the audience expertise level and defaulting to beginner content

## Level History

- **Lv.1** -- Base: 7-segment timestamped script (hook > 3 teaching points > transition > offer > Q&A > close), 23-slide deck outline, pre-planted Q&A bank, value-stack offer presentation, 5-email replay sequence for no-show conversion. (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** -- Guide alignment: Added negative triggers, validation gates between steps, examples, common issues, anti-patterns. Renamed Protocol to Instructions. Removed emoji from titles. Compressed verbose script templates. (Origin: MemStack v3.3, Mar 2026)
