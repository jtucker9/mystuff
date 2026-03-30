---
name: content-pipeline
description: "Design end-to-end content automation pipelines. WHEN: 'content pipeline', 'content automation', 'auto-publish', 'repurpose content', 'blog to social'. NOT WHEN: single social post, launch announcement (see launch-plan), or n8n workflow where content is incidental (chain to n8n-workflow-builder)."
---

# Content Pipeline

Design a multi-platform content pipeline with stage gates, AI integration, and analytics feedback.

## Activation

| Context | Status |
|---------|--------|
| "content pipeline", "content automation", "auto-publish" | ACTIVE |
| Repurpose content across platforms | ACTIVE |
| YouTube + blog + social automation | ACTIVE |
| n8n workflow (content is just the use case) | CHAIN to n8n-workflow-builder |
| Single social media post | DORMANT |
| Launch announcement sequence | DORMANT -- see launch-plan |

## Instructions

### Step 1: Gather Inputs

Collect before designing anything:

- **Content type**: Blog, video, podcast, newsletter, social, or multi-format
- **Source material**: Where raw content originates (scripts, recordings, notes)
- **Target platforms**: Blog, YouTube, Twitter/X, LinkedIn, Instagram, newsletter
- **Posting cadence**: Daily, 3x/week, weekly, biweekly
- **Team structure**: Solo or team? Who reviews?
- **Existing tools**: CMS, email platform, schedulers already in use

**Gate**: All six inputs answered before proceeding.

### Step 2: Define Pipeline Stages

Map the five-stage lifecycle. Every piece flows through all five:

| Stage | Status Flow | Advances When |
|-------|-------------|---------------|
| Create | draft_started > draft_complete | Author marks complete |
| Review | in_review > changes_requested > approved | Reviewer approves |
| Schedule | formatting > assets_ready | All platform variants generated |
| Publish | scheduled > published | Publish date reached |
| Distribute | published > distributed | All platform posts confirmed live |

**Content type routing** -- source format determines which derivative formats to generate:

- Blog post (source of truth) > thread, LinkedIn post, newsletter section, carousel, pin
- YouTube video > blog transcript, short clips, quote cards
- Podcast > show notes blog, audiogram clips, quote cards
- Newsletter > social teasers, blog archive post

**Decision**: If user has one dominant format, make it the source of truth. If multi-format, ask which is canonical.

**Gate**: Stage map and source-of-truth format confirmed.

### Step 3: Design Approval Workflow

Three quality gates. Skip none for published content:

**Gate A -- Content Approval** (after draft):
- Factually accurate, brand-voice consistent, no AI artifacts
- CTA present and relevant
- Approve > auto-format for all platforms. Reject > return to creation with notes.

**Gate B -- Visual/Format Review** (after platform formatting):
- Images licensed, thumbnail compelling, social posts standalone-readable, links working
- Approve > schedule for publish. Reject > return to formatting.

**Gate C -- Post-Publish Check** (1 hour after publish):
- Automated: links resolve, images load
- Manual: formatting spot-check, monitor initial responses
- Fix issues immediately if found

**Approval workflow rules**:
- Solo creator: self-review with 24-hour cooling period between draft and approval
- Team of 2-3: author drafts, one reviewer approves, no self-approval on Gate A
- Team of 4+: rotating reviewer assignment, SLA of 48 hours on Gate A
- Automation: status column in Notion/Airtable; n8n watches for status change; Slack notification with one-click approve

**Gate**: Approval workflow documented with who/when/how for each gate.

### Step 4: Build Scheduling Strategy

**Calendar pattern** -- assign platform days based on cadence:

- High volume (daily): Rotate platforms. Blog Mon, thread Tue, video Wed, LinkedIn Thu, newsletter Fri.
- Medium (3x/week): Blog + thread Mon, LinkedIn Wed, newsletter Fri.
- Low (weekly): Blog + all social derivatives same day, newsletter end of week.

**Scheduling rules**:
- Publish blog first (SEO indexing head start), derivatives 24-48h later
- Newsletter aggregates weekly, never publish same day as blog
- Social posts: schedule via Buffer/Typefully API or n8n
- Blog: CMS scheduled publish via API
- Email: platform scheduled send

**Gate**: Calendar template filled for at least 2 weeks.

### Step 5: Configure Cross-Platform Publishing

**Decision tree per platform**:

| Platform | Auto-publish? | Condition |
|----------|--------------|-----------|
| Blog | Yes | After Gate A approval |
| Twitter/X | Yes | After Gate B, via API |
| LinkedIn | Semi-auto | Draft via API, manual review of preview |
| Instagram | Manual | API limitations; send formatted content to Slack for manual post |
| YouTube | Manual | Upload requires metadata review |
| Newsletter | Yes | After Gate B, scheduled send |

**AI integration points** (where AI accelerates, not replaces):

| Stage | AI Task | Human Review Level |
|-------|---------|-------------------|
| Create | First draft from outline | Heavy edit required |
| Create | Video script from topic | Personalization required |
| Schedule | SEO meta generation | Light review |
| Schedule | Social post derivatives | Tone check |
| Schedule | Email subject lines (5 variants) | Pick one |
| Distribute | Alt text for images | Light review |

**Gate**: Publishing config documented per platform.

### Step 6: Analytics Feedback Loop

**Tracking windows** by platform:
- Blog: daily for 7 days (views, time on page, bounce)
- YouTube: daily for 14 days (views, watch time, CTR, retention)
- Social (Twitter/LinkedIn/Instagram): 48 hours (impressions, engagement)
- Newsletter: 72 hours (open rate, click rate, unsubscribes)

**Feedback-to-ideation rules**:
- Top 20% performers by engagement > create more in same category
- Bottom 20% > analyze cause (topic, timing, headline, format) before repeating
- Audience questions from comments > direct input to ideation stage
- Format with highest engagement rate > increase frequency

**Composite score**: Rate each piece 1-10 across platforms. Verdict: Scale (7+), Iterate (4-6), Retire (1-3).

**Gate**: Analytics sources identified, scorecard template created.

## Examples

**Solo blogger, weekly cadence**: Blog source of truth > auto-generate thread + LinkedIn post + newsletter section via n8n. Self-review with 24h cooling. Publish blog Monday, social Tuesday, newsletter Friday. Track via GA + native analytics. Monthly scorecard review.

**Team of 3, daily cadence**: Rotating content calendar across blog/video/social. Author drafts, editor reviews (48h SLA), designer handles formatting. n8n orchestrates: webhook on blog publish triggers derivative generation, Slack notification for Gate B, auto-schedule approved social posts. Weekly analytics digest to team channel.

## Common Issues

- **AI artifacts in published content**: Gate A must explicitly check for robotic phrasing, hallucinated statistics, and generic filler. Never auto-publish AI drafts without human Gate A.
- **Platform API rate limits**: Buffer/Twitter/LinkedIn APIs have daily post limits. Queue excess posts for next available slot rather than failing silently.
- **Newsletter-blog cannibalization**: If newsletter reproduces full blog post, readers skip the blog. Newsletter should summarize + link, not duplicate.

## Anti-Patterns

- Publishing AI-generated content without human review at Gate A
- Identical copy across all platforms (each platform needs native formatting and tone)
- Scheduling all derivatives simultaneously (stagger for algorithm favor)
- Skipping analytics review (pipeline becomes output-only with no learning)
- Over-automating Instagram/YouTube (these platforms penalize bot-like posting patterns)

## Escalation

- If user needs n8n workflow implementation details > chain to n8n-workflow-builder
- If user needs SEO optimization for blog content > chain to site-audit or meta-tag-optimizer
- If user needs email sequence design (not just newsletter) > chain to email-sequence
- If pipeline scope exceeds 5 platforms or 3 content types > recommend phased rollout starting with one source-of-truth format

## Inputs

- Content type and source format
- Target platforms
- Posting cadence
- Team size and review process
- Existing tools and integrations

## Outputs

- 5-stage pipeline design (create > review > schedule > publish > distribute)
- Content type routing map (source of truth > derivatives)
- Approval workflow with 3 quality gates
- Publishing calendar template
- Cross-platform publishing config (auto vs. manual per platform)
- AI integration points with review levels
- Analytics feedback loop with composite scorecard

## Level History

- **Lv.1** -- Base: 5-stage content pipeline, AI integration at 8 touch points with prompt templates, multi-platform format specs (blog, YouTube, Twitter, LinkedIn, Instagram, newsletter), content calendar with atomization strategy, 3-tier quality gates, analytics feedback loop with content scorecard, n8n workflow designs for daily publishing and weekly analytics. (Origin: MemStack v3.2, Mar 2026)
- **Lv.2** -- Compressed: Creator-level density rewrite. Replaced verbose workflow configs and prompt templates with decision rules. Added content type routing, approval workflow rules by team size, scheduling strategy by cadence, cross-platform auto/manual decision tree, analytics feedback-to-ideation rules. Preserved all 5 pipeline stages and 3 quality gates. (Origin: MemStack v3.2, Mar 2026)
