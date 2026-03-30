---
name: launch-plan
description: "Use when the user says 'launch plan', 'product launch', 'launch strategy', 'go-to-market', 'GTM plan', 'launch calendar', or is planning a product or feature release. Do NOT use for ongoing evergreen funnels (see sales-funnel), ad copy only (see facebook-ad or google-ad), or post-launch retention strategy."
---

# Launch Plan -- Go-to-Market Calendar

Build a day-by-day launch calendar from pre-launch through post-launch with task checklists and contingency plans.

## Activation

When this skill activates, output:

`Launch Plan -- Building your go-to-market calendar...`

| Context | Status |
|---------|--------|
| User says "launch plan", "product launch", "go-to-market" | ACTIVE |
| User wants a launch calendar or timeline | ACTIVE |
| User is planning a release and needs sequenced tasks | ACTIVE |
| User wants ongoing funnel design (not time-bound) | DORMANT -- see sales-funnel |
| User wants ad copy only | DORMANT -- see facebook-ad or google-ad |
| User wants a product roadmap (not a launch event) | DORMANT -- see roadmap-builder |

## Instructions

### Step 1: Gather Inputs

Ask the user for:
- **Product/service**: What are you launching?
- **Launch date**: When is the target launch?
- **Audience size**: Email list, social following, existing customers
- **Available channels**: Email, social platforms, paid ads, PR, partnerships, podcast, blog
- **Team size**: Solo or team? Who handles what?
- **Budget**: Marketing budget for the launch window

**Gate**: Do not proceed until product, launch date, and at least one channel are confirmed.

### Step 2: Pre-Launch Phase (Weeks -4 to -1)

**Week -4 -- Foundation**
- Define launch messaging: one-liner, elevator pitch, value proposition
- Create landing page / waitlist page
- Set up email sequences (warm-up, announcement, follow-up)
- Plan content calendar for teasers

**Week -3 -- Audience Building**
- Start teaser content on social channels
- Publish behind-the-scenes content
- Reach out to affiliates/partners for launch support
- Begin waitlist promotion

**Week -2 -- Content Creation**
- Write launch emails (minimum 3: announcement, reminder, last chance)
- Create ad creatives for paid campaigns
- Prepare social media posts for launch week (batch create)
- Record demo/walkthrough video

**Week -1 -- Final Prep**
- Test purchase/sign-up flow end to end
- Send "launching soon" email to waitlist
- Schedule all social posts
- Brief any partners/affiliates with assets
- Set up tracking: UTMs, conversion pixels, analytics dashboards

**Gate**: Confirm the purchase/sign-up flow has been tested before moving to launch week.

### Step 3: Launch Week (Days 1-7)

**Day 1 -- Launch Day**: Send launch email (most engaged segment first), publish social announcements, activate paid ads, post in relevant communities, monitor sales/traffic/email hourly.

**Day 2 -- Social Proof**: Share first customer reactions, respond to all comments, resend email to non-openers with different subject line.

**Day 3 -- Overcome Objections**: Publish FAQ content, send targeted email to clickers-not-buyers, pause underperforming ads.

**Day 4-5 -- Case Studies**: Share detailed use case or customer story, guest post or podcast (if arranged), adjust ad targeting from Day 1-3 data.

**Day 6-7 -- Urgency Close**: Send "closing soon" email, final social push with urgency, last-chance retargeting ads.

**Gate**: If sales are below 50% of target by Day 3, trigger Contingency Plan (Step 5) before continuing Day 4 tasks.

### Step 4: Post-Launch Phase (Weeks +1 to +2)

**Week +1 -- Capitalize**: Collect and publish testimonials, send buyer thank-you email, analyze launch metrics (revenue, conversion rate, CAC, top channels), begin retargeting non-converters.

**Week +2 -- Optimize**: Write internal launch retrospective, set up evergreen funnel from launch assets, plan follow-up offers or upsells, gather customer feedback.

### Step 5: Contingency Plan

If launch underperforms (below 50% of target by Day 3):
1. **Diagnose**: Check traffic (awareness problem) vs conversion rate (offer problem)
2. **Traffic low**: Increase ad spend, do a flash collaboration, email blast to cold list
3. **Conversion low**: Add urgency (limited bonus), add proof (live testimonial), simplify offer
4. **Both low**: Extend launch window, pivot messaging, consider soft re-launch
5. **Nuclear option**: Pause, gather feedback, reposition, re-launch in 30 days

### Step 6: Metrics Dashboard

Provide a daily tracking template:

| Metric | Day 1 | Day 2 | Day 3 | Day 4 | Day 5 | Day 6 | Day 7 |
|--------|-------|-------|-------|-------|-------|-------|-------|
| Site visits | | | | | | | |
| Email opens | | | | | | | |
| Sales/sign-ups | | | | | | | |
| Revenue | | | | | | | |
| Ad spend | | | | | | | |
| ROAS | | | | | | | |

### Step 7: Output

Present the complete launch plan:

```
LAUNCH PLAN: [Product Name]
Launch Date: [date]
Revenue Target: $[amount]
Channels: [list]

PRE-LAUNCH (Weeks -4 to -1)
[tasks by week with owners]

LAUNCH WEEK (Days 1-7)
[daily tasks with times]

POST-LAUNCH (Weeks +1 to +2)
[tasks by week]

CONTINGENCY
[if/then decision tree]

METRICS TRACKER
[dashboard template]
```

## Examples

**Example 1 -- Solo SaaS launch**
User: "Launch plan for my invoicing app, launching April 15, email list of 800, $500 budget"
Output: Compressed 4-week pre-launch (solo-adjusted: skip partner outreach, focus on email + Twitter), 7-day launch week with 3 emails, $500 split between retargeting ads and one promoted post, contingency triggers at Day 3 if under 10 sign-ups.

**Example 2 -- Team course launch**
User: "GTM plan for our $297 online course, team of 3, 5k email list, $3k budget"
Output: Full 4-week pre-launch with task owners (RACI table), webinar on Day -3 as lead warmer, 7-day open cart with daily email sequence, $3k split across Facebook retargeting + affiliate commissions, Day 6-7 urgency with bonus expiry, contingency plan with "extend cart 48 hours" option.

## Common Issues

| Issue | Fix |
|-------|-----|
| Launch date is less than 2 weeks away | Compress pre-launch into 1 week; cut partner outreach and video; focus on email + one social channel |
| No email list or audience | Add a 2-week waitlist-building sprint before the 4-week countdown begins |
| Solo founder trying to execute a team-sized plan | Cut tasks to one channel, batch-create all content in Week -2, automate email sequences |

## Anti-Patterns

- Launching without testing the purchase/sign-up flow end to end
- Sending one launch email instead of a multi-touch sequence
- No contingency plan -- hoping Day 1 momentum carries the whole week
- Spending the entire budget on Day 1 ads before validating messaging
- Skipping post-launch follow-up (testimonials, retargeting, retrospective)
- Building a 7-channel launch plan for a solo founder with no automation

## Inputs
- Product/service description
- Launch date
- Audience size and channels
- Team members and roles
- Budget

## Outputs
- 4-week pre-launch task calendar
- Day-by-day launch week schedule with checklists
- 2-week post-launch optimization plan
- Owner/deadline task table
- Contingency plan with decision triggers
- Daily metrics dashboard template

## Level History

- **Lv.1** -- Base: 7-week launch calendar (4 pre + 1 launch + 2 post), daily task checklists with owners, contingency decision tree, metrics dashboard template, multi-channel coordination (email, social, paid, partnerships). (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** -- Guide alignment: Added negative triggers to description, validation gates between steps, Examples, Common Issues, Anti-Patterns. Renamed Protocol to Instructions. Removed emoji from title. (Origin: MemStack v3.3, Mar 2026)
