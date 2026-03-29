---
name: youtube-script
description: "Use when the user says 'YouTube script', 'video script', 'write script for YouTube', 'YouTube video outline', or is creating scripted content for a YouTube video with hooks, chapters, and CTAs. Do NOT use for TikTok/Reels short-form scripts (see tiktok-script) or webinar presentations (see webinar-script)."
---

# YouTube Script -- Video Content Creation
*Produce a complete, production-ready YouTube video script with hook engineering, chapter timestamps, A-roll/B-roll notation, retention techniques, CTA integration, and SEO metadata package.*

## Activation

When this skill activates, output:

`YouTube Script -- Writing your video script...`

| Context | Status |
|---------|--------|
| **User says "YouTube script", "video script", "write script for YouTube"** | ACTIVE |
| **User says "YouTube video outline", "script for my channel"** | ACTIVE |
| **User wants a long-form video script with hooks, chapters, and CTAs** | ACTIVE |
| **User provides a topic and wants scripted content for YouTube** | ACTIVE |
| **User wants a tutorial, commentary, or review video scripted** | ACTIVE |
| **User wants TikTok/Reels/Shorts scripts (short-form)** | DORMANT -- see tiktok-script |
| **User wants a webinar or live presentation script** | DORMANT -- see webinar-script |
| **User wants a blog post or written article** | DORMANT -- see blog-post |
| **User wants a podcast script (audio-only)** | DORMANT -- provide general guidance, no dedicated skill |

---

## Protocol

### Step 1: Gather Inputs

Collect the following from the user. Ask for anything not provided -- do not assume defaults silently.

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| **Topic** | Yes | -- | The subject or title concept for the video |
| **Target audience** | Yes | -- | Who is watching? Demographics, experience level, interests |
| **Video length target** | No | 10-12 minutes | Short (5-7 min), Standard (10-12 min), Long (15-20 min), Deep Dive (25-40 min) |
| **Channel niche** | No | Derived from topic | Tech, business, lifestyle, education, gaming, finance, health, entertainment |
| **Tone / energy level** | No | Conversational, medium energy | Options: high energy/hype, conversational/friendly, calm/authoritative, edgy/provocative, educational/measured |
| **CTA goal** | No | Subscribe | Subscribe, watch another video, buy product, join community, download resource, visit website |
| **Thumbnail concept** | No | Generated in Step 7 | Any visual ideas the creator already has for the thumbnail |
| **Existing content** | No | None | Links to competitor videos or own channel videos on similar topics |
| **A-roll format** | No | Talking head | Talking head, screen recording, voiceover + B-roll, mixed |
| **Brand constraints** | No | None | Sponsors to mention, words to avoid, required disclaimers |

**Example input prompt:**

> Write a YouTube script about "Why most developers quit their first job within 6 months" for junior developers and career changers, 12 minutes, tech/career niche, conversational tone, CTA is subscribe + watch next video on interview prep.

### Step 2: Hook Engineering (First 30 Seconds)

The first 30 seconds determine whether the viewer stays or clicks away. YouTube's retention graph shows the steepest drop-off in this window. Every second must earn the next second.

#### 2a: Hook Type Selection

Choose one primary hook and optionally layer a secondary hook on top:

| Hook Type | What It Does | Example | Best For |
|-----------|-------------|---------|----------|
| **Curiosity gap** | Opens a question the viewer MUST see answered | "There's a reason every top YouTuber's studio has this one thing -- and it's not a camera." | Explainers, mysteries, reveals |
| **Bold claim** | Makes a statement that demands proof | "I made $47,000 in 30 days with a skill I learned in a weekend." | Results-driven, business, finance |
| **Story cold open** | Drops the viewer into a scene mid-action | "So I'm sitting in the interview, and the CTO looks at me and says, 'We don't hire people like you.'" | Story-driven, personal, commentary |
| **Demonstration** | Shows the end result immediately | *[SHOW: finished app running on screen]* "This took me 4 hours to build. Let me show you how." | Tutorials, builds, before/after |
| **"Don't do X"** | Warns against a common mistake | "If you're learning Python right now, stop doing this immediately." | Educational, mistake-avoidance |
| **Pattern interrupt** | Breaks the expected format visually or tonally | *[CUT TO: creator standing in the rain]* "I coded an entire app outside today to prove a point." | Entertainment, viral, personality-driven |
| **Question** | Asks something the viewer answers internally | "How many mass-produced apps do you think it takes to replace one thoughtful product?" | Commentary, opinion, philosophical |

#### 2b: The 30-Second Structure

The first 30 seconds must accomplish three things: hook, context, and promise.

```
[0:00-0:05]  HOOK — Stop the scroll. One sentence or visual that arrests attention.
[0:05-0:15]  CONTEXT — Why this matters. Why now. Why the viewer should care.
[0:15-0:30]  PROMISE — What the viewer will learn, gain, or feel by the end.
             Optional: preview the payoff ("By the end of this video, you'll know exactly...")
             Optional: open loop ("...but there's one thing nobody talks about, and I'll get to that.")
```

#### 2c: Retention Graph Psychology

YouTube surfaces the audience retention graph for every video. Understanding it shapes hook design:

| Graph Pattern | What It Means | How to Fix |
|---------------|--------------|------------|
| **Cliff at 0:05** | Hook failed -- viewer never engaged | Stronger opening line, visual interrupt in frame 1 |
| **Slide from 0:05-0:30** | Context or promise was weak | Tighten the "why this matters" beat, add urgency |
| **Dip at intro/logo** | Branded intro is too long | Cut to 3 seconds max or remove entirely |
| **Gradual decline** | Content doesn't maintain hooks | More pattern interrupts, open loops (see Step 5) |
| **Spike then drop** | Clickbait -- thumbnail/title oversold | Align promise with actual content delivered |
| **Flat line (good)** | Strong retention -- content matches expectation | This is the goal |

**Rule:** Never put a branded intro or logo bumper before the hook. Hook first, intro after (if at all). Most successful creators skip intros entirely or place them after the 30-second hook.

### Step 3: Structure Selection

Choose a video structure based on the topic and format. Each structure has a different pacing profile and chapter layout.

#### 3a: Video Structures

**Tutorial**
```
[0:00]  Hook + "What we're building"
[0:30]  Prerequisites / setup
[2:00]  Step 1: [Action]
[4:00]  Step 2: [Action]
[6:00]  Step 3: [Action]
[8:00]  Common mistakes / troubleshooting
[9:30]  Final result + recap
[10:30] CTA + next video suggestion
```
Best for: how-to content, coding walkthroughs, DIY, recipes.
Pacing: steady, instructional. Energy: low-medium.

**Story-Driven**
```
[0:00]  Cold open (scene from the middle or end)
[0:30]  "Here's how we got here" — rewind
[2:00]  Act 1: Setup — the situation before
[4:00]  Act 2: Conflict — what went wrong / the challenge
[7:00]  Act 3: Resolution — what happened / lessons learned
[9:00]  Reflection — what it means for the viewer
[10:00] CTA
```
Best for: personal stories, vlogs, career content, documentaries.
Pacing: build tension, release. Energy: variable, follows emotional arc.

**Listicle**
```
[0:00]  Hook + "X things you need to know about..."
[0:30]  Item 1 (strongest or most surprising)
[2:00]  Item 2
[3:30]  Item 3
[5:00]  Item 4
[6:30]  Item 5
[8:00]  Item 6-7 (if applicable, faster pace)
[9:00]  Bonus item or "the one most people miss"
[10:00] Recap + CTA
```
Best for: tips, tools, mistakes, recommendations, ranked lists.
Pacing: reset energy with each item. Start strong, save a strong item for the end.

**Comparison**
```
[0:00]  Hook + "Which one should you actually use?"
[0:30]  Quick verdict (for the impatient)
[1:30]  Criterion 1: [Feature] — Winner: [X]
[3:00]  Criterion 2: [Feature] — Winner: [Y]
[4:30]  Criterion 3: [Feature] — Winner: [X]
[6:00]  Criterion 4: [Feature] — Winner: [Y]
[7:30]  Price / value comparison
[8:30]  "Which one should YOU pick?" (decision framework)
[9:30]  CTA
```
Best for: product reviews, tool comparisons, "vs" videos.
Pacing: rhythmic, back and forth. Energy: medium, analytical.

**Day-in-the-Life / Vlog**
```
[0:00]  Hook — highlight reel or teaser of best moment
[0:30]  Morning routine / setup
[2:00]  Main activity block 1
[4:00]  Transition / reflection
[5:00]  Main activity block 2
[7:00]  Challenge or unexpected event
[8:30]  Evening / wrap-up
[9:30]  Takeaway — "Here's what I learned today"
[10:00] CTA
```
Best for: lifestyle, productivity, "what I do" content.
Pacing: relaxed but varied. Energy: medium, personal.

**Deep Dive / Essay**
```
[0:00]  Hook — provocative claim or question
[0:30]  "To understand this, we need to go back to..."
[2:00]  Historical context / background
[5:00]  The core argument — Part 1
[8:00]  The core argument — Part 2
[11:00] Counter-arguments and nuance
[13:00] "So what does this mean?"
[15:00] Implications for the viewer
[17:00] Conclusion + CTA
```
Best for: video essays, industry analysis, "why" questions, long-form education.
Pacing: slow build, dense content. Energy: measured, authoritative.

**Opinion / Commentary**
```
[0:00]  Hook — state the opinion directly
[0:30]  "Here's why I think this"
[1:30]  Evidence 1 — strongest argument
[3:30]  Evidence 2
[5:30]  Evidence 3
[7:00]  "But here's where it gets interesting" — nuance/counterpoint
[8:30]  "What this means for you"
[9:30]  CTA + invite discussion in comments
```
Best for: reactions, hot takes, industry commentary, news analysis.
Pacing: assertive, momentum-driven. Energy: medium-high.

#### 3b: Chapter Planning

After selecting a structure, plan specific chapters with:

| Chapter | Timestamp | Duration | Key Points | Energy Level | Visual Mode |
|---------|-----------|----------|------------|-------------|-------------|
| Hook | 0:00 | 30s | [hook + promise] | High | A-roll close-up |
| [Chapter 1] | 0:30 | 2 min | [3 bullet points] | Medium | A-roll + B-roll |
| [Chapter 2] | 2:30 | 2 min | [3 bullet points] | Medium | Screen recording |
| ... | ... | ... | ... | ... | ... |
| CTA | 9:30 | 30s | [subscribe + next video] | High | A-roll direct |

Energy should NOT be monotone. Plan rises and drops -- a consistent energy level causes viewer fatigue regardless of whether it's high or low.

### Step 4: Script Writing

Write the complete script with production-ready notation for the creator and editor.

#### 4a: Notation System

Use these visual cues throughout the script to separate spoken content from production direction:

| Notation | Meaning | Example |
|----------|---------|---------|
| **Plain text** | Spoken words (A-roll dialogue) | "So here's what most people get wrong..." |
| `[SHOW: ...]` | On-screen visual — graphic, image, screenshot | `[SHOW: screenshot of error message]` |
| `[CUT TO: ...]` | Camera angle or scene change | `[CUT TO: screen recording of VS Code]` |
| `[B-ROLL: ...]` | Supplementary footage over narration | `[B-ROLL: hands typing on keyboard, coffee being poured]` |
| `[SCREEN RECORDING: ...]` | Screen capture with narration | `[SCREEN RECORDING: navigating to settings panel]` |
| `[TEXT ON SCREEN: ...]` | Lower third, title card, or text overlay | `[TEXT ON SCREEN: "Step 2: Configure the API"]` |
| `[SFX: ...]` | Sound effect | `[SFX: whoosh transition]` |
| `[MUSIC: ...]` | Background music direction | `[MUSIC: upbeat lo-fi fades in]` |
| `[PAUSE: Xs]` | Deliberate pause for emphasis | `[PAUSE: 2s]` |
| `[ENERGY: ...]` | Energy/delivery direction for the speaker | `[ENERGY: lean in, lower voice]` |
| `(...)` | Stage direction or action note | *(picks up product and holds to camera)* |

#### 4b: Pacing Guidelines

| Video Length | Target Word Count | Words Per Minute | Segments |
|-------------|-------------------|-----------------|----------|
| 5-7 min | 750-1,050 | ~150 wpm conversational | 4-5 chapters |
| 10-12 min | 1,500-1,800 | ~150 wpm conversational | 6-8 chapters |
| 15-20 min | 2,250-3,000 | ~150 wpm conversational | 8-12 chapters |
| 25-40 min | 3,750-6,000 | ~150 wpm conversational | 12-20 chapters |

**Note:** These word counts cover spoken words only. B-roll segments, pauses, and screen recordings add time without adding script words. A 10-minute video with heavy B-roll may only have 1,200 spoken words.

**Pacing rules:**
- Vary sentence length. Mix short punchy sentences (5-8 words) with medium explanatory ones (15-20 words). Never exceed 25 words in a single sentence -- it's too long to follow audibly.
- Front-load each section. The first sentence of each chapter should be the most interesting thing in that chapter.
- Use the "breath test." Read the script aloud. If you run out of breath mid-sentence, the sentence is too long for video.

#### 4c: Energy Management

Energy should rise and fall deliberately across the video. A flat energy line (whether high or low) causes viewer fatigue.

```
ENERGY MAP (10-minute video):

High   ████░░░░██░░░░░░████░░░░██░░░░░░████████
Med    ░░░░████░░████░░░░░░████░░████░░░░░░░░░░
Low    ░░░░░░░░░░░░░░██░░░░░░░░░░░░░░██░░░░░░░░
       |Hook |Ch1  |Ch2  |Ch3  |Ch4  |Ch5  |CTA|
       0:00  2:00  4:00  6:00  7:00  8:30  9:30
```

**Energy rules:**
- Hook: always high
- After hook: drop to medium (contrast makes the hook feel more impactful)
- Each new chapter: brief energy spike, then settle
- Before a key point: drop energy, then spike on the reveal (creates emphasis)
- CTA: return to high energy -- match or exceed the hook

#### 4d: Conversational vs. Scripted Balance

Most successful YouTube videos sound natural but are carefully scripted. The goal is "planned spontaneity."

**Techniques for natural delivery:**
- Write in spoken English, not written English. "Here's the thing" not "It is important to note that."
- Use contractions: "don't", "can't", "we're" -- never "do not", "cannot", "we are."
- Include verbal signposts: "Okay, so...", "Now here's where it gets interesting...", "Look..."
- Leave room for ad-lib. Mark sections where the creator should riff naturally: `[AD-LIB: share your personal take on this]`
- Write transitions as spoken bridges, not written headers: "Alright, so now that we've covered X, let's talk about why Y matters even more."

### Step 5: Retention Techniques

YouTube rewards watch time. Every technique in this section exists to keep viewers watching through the full video.

#### 5a: Pattern Interrupts

Insert a pattern interrupt every 30-60 seconds. A pattern interrupt is any change that re-engages a wandering viewer.

| Interrupt Type | What Changes | Example |
|----------------|-------------|---------|
| **Visual cut** | Camera angle, zoom, or scene | Cut from wide to close-up mid-sentence |
| **B-roll insert** | Overlay footage replaces talking head | `[B-ROLL: timelapse of city traffic]` while narrating |
| **Graphic pop** | On-screen text or image appears | `[TEXT ON SCREEN: "Important" with arrow]` |
| **Sound effect** | Audio punctuation | `[SFX: record scratch]` before a correction |
| **Energy shift** | Speaker changes pace or volume | `[ENERGY: suddenly quiet, leaning in]` "But here's the real secret..." |
| **Direct address** | Speaker breaks the fourth wall | "If you're still watching, you're already ahead of 90% of people." |
| **Physical movement** | Speaker moves or gestures | *(stands up from desk, walks to whiteboard)* |

**Rule:** Never go more than 60 seconds without at least one pattern interrupt. In the first 3 minutes, use one every 20-30 seconds. After the viewer is invested, you can stretch to 45-60 seconds between interrupts.

#### 5b: Open Loops

An open loop is a question or tease planted early that is resolved later. It gives the viewer a reason to keep watching.

**Placement strategy:**
- Plant 2-3 open loops in the first 2 minutes
- Resolve them at different points throughout the video (not all at the end)
- Always resolve every loop you open -- unresolved loops feel like broken promises

**Examples:**
```
PLANT (0:45): "Now, there's a third option that most people don't know about,
              and it's honestly the best one -- but we'll get to that in a minute."

RESOLVE (6:30): "Remember that third option I mentioned? Here it is..."
```

```
PLANT (1:20): "I actually made this exact mistake on my channel, and it cost me
              50,000 views. I'll show you the analytics later."

RESOLVE (8:00): [SCREEN RECORDING: YouTube analytics showing the drop]
               "Here's that analytics screenshot I mentioned..."
```

#### 5c: "But First" Transitions

When moving between sections, use "but first" or "before we get to that" to stack anticipation:

```
"Alright, I'm going to show you the exact setup I use -- but first, you need
to understand why the default settings are actually working against you."
```

This technique converts a section transition (a natural exit point) into a curiosity hook (a reason to stay).

#### 5d: Visual Variety Cues

Annotate the script with visual mode changes. No single visual mode should run for more than 90 seconds.

| Visual Mode | Use For | Max Duration |
|-------------|---------|-------------|
| **A-roll (talking head)** | Direct explanation, opinion, emphasis | 60-90 seconds |
| **Screen recording** | Tutorials, demos, walkthroughs | 90-120 seconds |
| **B-roll montage** | Context, atmosphere, transitions | 15-30 seconds |
| **Graphics/animations** | Data, processes, comparisons | 20-45 seconds |
| **Text on screen** | Key stats, quotes, lists | 5-15 seconds |
| **Split screen** | Before/after, comparisons | 15-30 seconds |

#### 5e: Audience Interaction Moments

Build in moments that prompt mental or physical engagement:

- **Poll/question:** "Let me know in the comments -- which one of these do you use?"
- **Prediction prompt:** "Before I reveal the answer, pause and guess."
- **Relatability check:** "If this has ever happened to you, smash that like button."
- **Challenge:** "Try this right now. Seriously, pause the video and do it."

Place one interaction moment every 3-4 minutes. More than that feels desperate; less feels like a lecture.

### Step 6: CTA Integration

CTAs must feel organic, not bolted on. The goal is to earn the action by delivering value first.

#### 6a: Subscribe Prompt

**When:** Between minutes 2-4 (after you've proved you're worth subscribing to, but before the viewer might leave).

**How:** Tie the subscribe CTA to a content promise, not a generic ask.

Bad: "Don't forget to subscribe and hit the bell!"
Good: "I make one of these every week -- if you want to get better at [topic], subscribe so you don't miss the next one."

Best: Deliver value, then subscribe ask as a natural extension:
```
"That technique alone saved me 3 hours a week. I share stuff like this every
Tuesday and Friday -- hit subscribe if you want more."
```

#### 6b: Mid-Roll CTA Placement

For videos over 8 minutes, place a soft CTA at the natural midpoint (usually between chapters 3 and 4). This is the "value valley" -- you've delivered enough to have credibility, and the viewer is invested.

**Mid-roll CTA formula:**
```
[Deliver a strong insight in the previous section]
"If that was helpful, drop a like -- it genuinely helps this video reach
more people who need it. Okay, moving on..."
```

**Rule:** The mid-roll CTA should take no more than 8 seconds. Anything longer breaks pacing.

#### 6c: End Screen Optimization

The last 20-30 seconds of the video are for the end screen. YouTube allows clickable elements (cards) during this window.

**End screen script pattern:**
```
[Summarize the video in 1 sentence]
"If you found this useful, you're going to love this video [GESTURE: point to
end screen card area] where I go deeper into [related topic]. I'll see you
in that one."
[Hold for 15-20 seconds while end screen elements display]
```

**Rules:**
- Always point or gesture toward the end screen card position
- Reference the next video by topic, not just "this video"
- Do NOT say goodbye or "thanks for watching" before the end screen -- it signals the viewer to leave
- Keep talking or maintain visual interest through the end screen duration

#### 6d: Comment Engagement Prompts

Seed the comments section with specific prompts that drive algorithmic engagement:

| Prompt Type | Example | Why It Works |
|-------------|---------|-------------|
| **Opinion poll** | "Team A or Team B? Tell me in the comments" | Low effort, high response rate |
| **Experience share** | "Have you ever dealt with this? What happened?" | Generates long comments (algorithm loves these) |
| **Debate starter** | "I know some of you disagree -- change my mind" | Drives replies and threads |
| **Specific question** | "What's YOUR biggest challenge with [topic]?" | Content research + engagement |
| **Easter egg** | "If you made it this far, comment [secret word]" | Rewards loyal viewers, tests retention |

Place 1-2 comment prompts per video. The strongest placement is immediately after your best insight, when engagement impulse is highest.

### Step 7: SEO and Metadata

#### 7a: Title Formulas for CTR

The title and thumbnail together determine click-through rate. The title should create curiosity; the thumbnail should create emotion.

**Title formulas:**

| Formula | Example | Best For |
|---------|---------|----------|
| **How I [Result] in [Timeframe]** | "How I Learned Rust in 30 Days" | Results, transformation |
| **[Number] [Topic] Mistakes [Consequence]** | "7 Python Mistakes That Cost You Hours" | Education, mistakes |
| **Why [Thing] Is [Unexpected Adjective]** | "Why GraphQL Is Overrated" | Opinion, commentary |
| **[Thing] vs [Thing]: Honest Review** | "M4 Mac vs PC: A Developer's Honest Take" | Comparison |
| **I Tried [Thing] for [Time] -- Here's What Happened** | "I Tried Wake Up at 5AM for 30 Days" | Experiment, story |
| **The [Adjective] Guide to [Topic]** | "The Complete Guide to Docker in 2026" | Comprehensive tutorials |
| **Stop [Doing Thing] (Do This Instead)** | "Stop Writing CSS Like This (Do This Instead)" | Corrective, educational |
| **[Topic] Explained in [Time]** | "Kubernetes Explained in 15 Minutes" | Concise education |
| **What Nobody Tells You About [Topic]** | "What Nobody Tells You About Remote Work" | Insider knowledge |
| **I [Did Thing] So You Don't Have To** | "I Read 50 Productivity Books So You Don't Have To" | Curation, sacrifice |

**Title rules:**
- 50-70 characters (longer titles get truncated on mobile)
- Front-load the most interesting word
- Use a number if applicable (odd numbers outperform even)
- Never use ALL CAPS for the entire title (one word in caps is acceptable for emphasis)
- Avoid clickbait that the video cannot deliver on -- YouTube penalizes high-CTR/low-retention

#### 7b: Description Template

```
[First 2 lines: compelling summary -- these show above the "Show more" fold]

Timestamps:
0:00 - [Chapter title]
0:30 - [Chapter title]
2:15 - [Chapter title]
...

Resources mentioned:
- [Resource 1]: [URL]
- [Resource 2]: [URL]

Connect with me:
- Twitter: [URL]
- Instagram: [URL]
- Newsletter: [URL]
- Discord: [URL]

Gear I use (affiliate links):
- Camera: [product + link]
- Mic: [product + link]
- Lighting: [product + link]

#keyword1 #keyword2 #keyword3

[Disclosure if applicable: "Some links above are affiliate links."]
```

**Description rules:**
- First 150 characters are critical -- they show in search results
- Always include timestamps (YouTube uses them for chapter markers AND search indexing)
- 3-5 hashtags maximum in the description (YouTube shows the first 3 above the title)
- Include relevant links but don't spam -- 5-10 links maximum
- YouTube indexes the description for search -- include target keywords naturally

#### 7c: Tag Strategy

YouTube tags have diminished in importance but still help with discovery for misspellings and related terms.

| Tag Category | Count | Examples |
|-------------|-------|---------|
| **Exact match** | 1-2 | "how to learn python", "python tutorial 2026" |
| **Broad match** | 3-5 | "python", "programming", "coding tutorial" |
| **Long-tail** | 3-5 | "python for beginners step by step", "learn python from scratch" |
| **Related topics** | 2-3 | "software development", "web development", "tech career" |
| **Channel name** | 1 | "[Your channel name]" |

**Total tags:** 10-15. YouTube allows 500 characters total. Do not use irrelevant tags -- YouTube penalizes tag stuffing.

#### 7d: Thumbnail Text Guidelines

The thumbnail and title work as a pair -- they should complement each other, not duplicate.

**Rules:**
- Maximum 4-5 words on the thumbnail
- Text must be readable at mobile size (thumbnail is ~120x68 pixels on mobile)
- Use contrasting colors -- white or yellow text on dark backgrounds
- Do not repeat the title verbatim on the thumbnail
- Include a face with an expressive emotion when possible (faces increase CTR by 30-40%)
- Use the rule of thirds -- face on one side, text on the other

**Thumbnail text formulas:**

| Formula | Example | When to Use |
|---------|---------|-------------|
| **Outcome word** | "FASTER" | Tutorial, optimization |
| **Number + result** | "$47K" | Income, results |
| **Question** | "WORTH IT?" | Review, comparison |
| **Versus** | "A vs B" | Comparison |
| **Emotion word** | "I QUIT" | Story, personal |
| **Warning** | "DON'T" | Mistake-avoidance |

#### 7e: Custom Thumbnail Concepts

For each script, provide 2-3 thumbnail concepts:

```
THUMBNAIL CONCEPT 1:
- Background: [color/scene]
- Face/expression: [emotion]
- Text: [3-5 words]
- Props/graphics: [any visual elements]
- Color palette: [2-3 dominant colors]

THUMBNAIL CONCEPT 2:
- Background: [color/scene]
- Face/expression: [emotion]
- Text: [3-5 words]
- Props/graphics: [any visual elements]
- Color palette: [2-3 dominant colors]
```

### Step 8: Output

Deliver the complete script package in this structure:

```
============================================================
 YOUTUBE SCRIPT: [Title]
============================================================
Duration: [target length]
Structure: [Tutorial / Story / Listicle / etc.]
Audience: [target viewer]
Tone: [energy/style]
Estimated word count: [spoken words]

------------------------------------------------------------
 CHAPTER PLAN
------------------------------------------------------------

| # | Timestamp | Chapter Title       | Duration | Energy |
|---|-----------|---------------------|----------|--------|
| 1 | 0:00      | Hook                | 0:30     | High   |
| 2 | 0:30      | [Chapter title]     | 2:00     | Medium |
| 3 | 2:30      | [Chapter title]     | 2:30     | Medium |
| ...                                                      |

------------------------------------------------------------
 SCRIPT
------------------------------------------------------------

## [0:00] HOOK

[ENERGY: high, direct to camera]
[MUSIC: subtle tension build underneath]

"[Hook line -- first sentence spoken within 1 second]"

[SHOW: relevant visual that reinforces the hook]
[TEXT ON SCREEN: key phrase from the hook]

"[Context -- why this matters]"

"[Promise -- what the viewer will learn/gain]"

[PAUSE: 1s]

---

## [0:30] CHAPTER 1: [Title]

[CUT TO: appropriate visual mode]
[ENERGY: settled, conversational]

"[Transition from hook into first topic]"

[B-ROLL: relevant supplementary footage]

"[Main content for this section...]"

[SHOW: supporting graphic or screenshot]

"[Key insight or takeaway for this chapter]"

[TEXT ON SCREEN: key stat or quote]

---

## [2:30] CHAPTER 2: [Title]

[CUT TO: different visual mode for variety]
[ENERGY: building]

"But before we get into that -- [open loop or 'but first' transition]"

"[Content...]"

[SCREEN RECORDING: if tutorial/demo content]

[AD-LIB: personal anecdote about this topic]

---

[... continue for all chapters ...]

---

## [~9:30] CLOSE + CTA

[ENERGY: high, matching the hook]

"[1-sentence summary of the video]"

"If you got value from this, you'll love [GESTURE: point to end screen area]
this video where I cover [related topic]. Hit subscribe so you don't miss
next week's video -- I'll see you in that one."

[Hold on camera for 20 seconds while end screen displays]
[MUSIC: outro, upbeat]

------------------------------------------------------------
 SEO METADATA
------------------------------------------------------------

Title: [50-70 characters]
Description: [Full description using template from Step 7b]

Tags:
- [tag1]
- [tag2]
- ...

Timestamps (for description):
0:00 - [Chapter title]
0:30 - [Chapter title]
...

------------------------------------------------------------
 THUMBNAIL CONCEPTS
------------------------------------------------------------

Concept 1: [description]
Concept 2: [description]

------------------------------------------------------------
 RETENTION NOTES
------------------------------------------------------------

Open loops planted:
1. [timestamp] — "[tease]" → resolved at [timestamp]
2. [timestamp] — "[tease]" → resolved at [timestamp]

Pattern interrupts: [count] total, avg every [X] seconds
Comment prompts: [list with timestamps]
CTA placements: Subscribe [timestamp], Like [timestamp], End screen [timestamp]

------------------------------------------------------------
 PRODUCTION NOTES
------------------------------------------------------------

A-roll segments: [count] ([total duration])
B-roll needed: [list of B-roll clips to shoot or source]
Screen recordings needed: [list]
Graphics/animations needed: [list]
Music cues: [list with timestamps]
Sound effects: [list with timestamps]
============================================================
```

---

## Complete Example Script

Below is an abbreviated example demonstrating the notation format for a 10-minute tech/career video.

```
============================================================
 YOUTUBE SCRIPT: Why Most Developers Quit in 6 Months
============================================================
Duration: 10-12 minutes
Structure: Story-Driven + Listicle Hybrid
Audience: Junior developers, bootcamp grads, career changers
Tone: Conversational, empathetic, medium energy
Estimated word count: 1,500

------------------------------------------------------------
 SCRIPT (Excerpt — First 3 Minutes)
------------------------------------------------------------

## [0:00] HOOK

[ENERGY: direct, serious, close-up camera angle]
[MUSIC: low ambient drone, barely audible]

"67% of junior developers think about quitting within their
first six months on the job."

[TEXT ON SCREEN: "67%" large, red, center frame]
[PAUSE: 1.5s]

"And it's not because the code is too hard."

[CUT TO: medium shot, creator leans back]
[ENERGY: shift to conversational]

"I've mentored over 200 junior devs, and the reason most
of them want to quit has nothing to do with technical skill.
By the end of this video, you'll know the five real reasons
-- and exactly how to survive each one."

[B-ROLL: stock footage of developer at desk looking frustrated,
then cut to same person looking confident — subtle before/after]

"Oh, and number four? That one almost made ME quit. I'll
get to that."

[MUSIC: transition sting, then upbeat lo-fi fades in]

---

## [0:35] CHAPTER 1: The Expectation Gap

[CUT TO: talking head, slightly wider frame]
[ENERGY: empathetic, measured]

"The first reason — and honestly the biggest one — is what
I call the expectation gap."

[SHOW: split screen graphic — left side "What you expected"
(clean code, pair programming, mentorship), right side
"What you got" (legacy codebase, Jira tickets, meetings)]

"In bootcamp or in your tutorials, you're building cool
projects from scratch. You pick the stack. You write clean
code. You feel like a wizard."

[ENERGY: slight drop, more serious]

"Then you start your first job, and your first task is to
fix a bug in a 200,000-line codebase written in 2017 by
someone who has already left the company."

[SFX: record scratch]

*(creator looks at camera deadpan)*

"Nobody prepared you for that."

[TEXT ON SCREEN: "Nobody prepares you for this."]

"The fix? Adjust your expectations BEFORE day one.
Your first job isn't about building. It's about learning
how real software works — and that means messy, legacy,
undocumented real software."

[AD-LIB: share a specific example from your first job]

---

## [2:20] CHAPTER 2: The Impostor Spiral

[CUT TO: screen recording of a Slack conversation (blurred
names) showing technical discussion]
[ENERGY: building, relatable]

"Reason number two: the impostor spiral. And I don't just
mean impostor syndrome — I mean the spiral."

"Here's how it works..."

[SHOW: animated diagram — circular flow:
"See senior dev's code" → "Feel dumb" → "Don't ask questions"
→ "Fall behind" → "Feel dumber" → repeat]

"You see a pull request from a senior developer and you
don't understand half of it. So you feel behind. Because
you feel behind, you don't ask questions — you don't want
to look stupid. Because you don't ask questions, you
actually fall behind. And now the feeling is real."

[PAUSE: 1.5s]
[ENERGY: lean in, direct]

"Break the spiral. Ask the question. I have never — not
once in 10 years — seen a junior developer get fired for
asking too many questions. I HAVE seen them get fired
for not asking enough."

[TEXT ON SCREEN: "Ask. The. Question."]
[SFX: subtle impact sound on each word]

"By the way, if you're dealing with this right now, hit
subscribe — I talk about this stuff every week and it
does get easier."

---

[... script continues for remaining chapters ...]
```

---

## Anti-Patterns

- **Writing a blog post and reading it aloud.** Written English and spoken English are different languages. Blog sentences are too long, too formal, and too dense for video. Write for the ear: short sentences, contractions, verbal signposts, rhythm variation.
- **Saving the best content for the end.** Most viewers leave before the halfway mark. Front-load your strongest material. Give away the best insight early -- it builds trust and earns the right to keep the viewer's attention for the rest.
- **Monotone energy throughout.** A constant energy level -- whether high or low -- puts viewers to sleep. Plan deliberate peaks and valleys. The contrast is what creates engagement, not the absolute energy level.
- **Generic CTAs.** "Like and subscribe" is invisible to viewers because every creator says it. Tie your CTA to specific value: "Subscribe if you want to get better at [specific skill] -- I post every Tuesday."
- **No pattern interrupts.** Talking head with no visual changes for 3+ minutes causes a retention cliff. Insert a visual, audio, or energy change at least every 60 seconds.
- **Opening with a branded intro.** A 10-second animated logo intro is a retention killer. The viewer clicked for content, not your brand. Hook first. If you must have an intro, place it after the hook and keep it under 3 seconds.
- **Ignoring the thumbnail-title relationship.** The thumbnail and title are a team. If the title says "7 Mistakes" and the thumbnail also says "7 MISTAKES" -- you've wasted the thumbnail. Use the thumbnail to add emotion, context, or a visual hook that the title cannot convey.
- **Unresolved open loops.** If you tease something ("I'll show you that later"), you must deliver. Unresolved loops erode trust and train viewers to ignore your teases in future videos.
- **Writing the script without speaking it.** Always read the script aloud during writing. Sentences that look fine on paper often feel unnatural when spoken. If you stumble over a line, rewrite it.
- **Cramming too much into short videos.** A 10-minute video should make 3-5 points, not 15. Depth beats breadth on YouTube. Viewers subscribe to channels that make them FEEL like they learned something, and depth creates that feeling.

## Escalation

Hand off to a specialist when:

- **The video requires professional motion graphics or animations.** This skill provides direction for visuals (`[SHOW: animated diagram]`) but does not produce them. If complex animations are central to the video, engage a motion designer.
- **The video involves on-location shooting or complex cinematography.** This skill produces the script and editorial direction. If the video requires multi-camera setups, location scouting, or professional lighting design, engage a videographer or DP.
- **Sponsored content requires legal review.** If the video includes paid sponsorships, affiliate disclosures, or product claims, ensure the script is reviewed for FTC compliance. Flag this to the user.
- **The topic involves medical, legal, or financial advice.** Content in regulated domains should be reviewed by a qualified professional. The script can present information, but claims must be verified.
- **The creator needs a full video production workflow.** This skill produces the script and metadata. If the creator needs editing, color grading, sound design, or distribution strategy, those are separate specializations.
- **Short-form repurposing is needed.** If the YouTube video needs to be cut into TikTok/Reels/Shorts clips, use the tiktok-script skill for the short-form adaptations.

## Inputs

- Topic or title concept (required)
- Target audience description (required)
- Video length target (default: 10-12 minutes)
- Channel niche (default: derived from topic)
- Tone and energy level (default: conversational, medium energy)
- CTA goal (default: subscribe)
- Thumbnail concept or visual ideas (optional)
- Existing competitor videos or own channel content (optional)
- A-roll format preference (default: talking head)
- Brand constraints -- sponsors, disclaimers, words to avoid (optional)

## Outputs

- Complete timestamped script with spoken dialogue and production notation
- Chapter plan with timestamps, durations, and energy levels
- Hook engineering (first 30 seconds) using proven hook type
- A-roll / B-roll / screen recording / graphic annotations throughout
- Retention map: open loops planted and resolved, pattern interrupt placements
- CTA integration: subscribe prompt, mid-roll CTA, end screen script, comment prompts
- SEO metadata: title, description with timestamps, tags, hashtags
- 2-3 thumbnail concepts with text, expression, color palette
- Production notes: B-roll shot list, screen recordings needed, graphics list, music/SFX cues
- Energy management map across the full video duration

## Level History

- **Lv.1** -- Base: Full 8-step protocol (gather inputs, hook engineering, structure selection, script writing, retention techniques, CTA integration, SEO and metadata, output). 7 hook types (curiosity gap, bold claim, story cold open, demonstration, "don't do X", pattern interrupt, question) with retention graph psychology. 7 video structures (Tutorial, Story-driven, Listicle, Comparison, Day-in-the-Life, Deep Dive, Opinion/Commentary) with chapter planning. Production notation system (SHOW, CUT TO, B-ROLL, SCREEN RECORDING, TEXT ON SCREEN, SFX, MUSIC, PAUSE, ENERGY, AD-LIB). Pacing guidelines by video length with words-per-minute targets. Energy management mapping with peak/valley planning. Pattern interrupts (7 types, every 30-60 seconds), open loops (plant/resolve tracking), "but first" transitions, visual variety cues, audience interaction moments. CTA integration (subscribe prompts, mid-roll placement, end screen optimization, comment engagement). SEO package (10 title formulas, description template, tag strategy, thumbnail text guidelines, custom thumbnail concepts). Complete example script demonstrating notation format. Anti-patterns, escalation matrix, structured output format. (Origin: MemStack v3.3, Mar 2026)
