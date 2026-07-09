---
name: linkedin-self-improving-system
description: Use when building, operating, or iterating a self-improving LinkedIn content system. Covers voice skill construction, performance analytics loop, distribution rules, and applying confirmed patterns to future post drafts.
version: 1.0.0
author: niksmac
license: MIT
metadata:
  hermes:
    tags: [linkedin, social-media, content-system, voice, analytics]
    related_skills: [linkedin-automation]
---

# Self-Improving LinkedIn System

A repeatable system for producing LinkedIn posts that get smarter every cycle. Split into two persistent skill/data layers: one captures your voice and never drifts, the other learns from real post performance and feeds rules back into new drafts.

## When to Use

- User asks to build a LinkedIn posting system or "ghost-writer skill"
- User asks to codify their LinkedIn voice, anti-patterns, or reference examples
- User asks to track post performance and derive posting rules
- User wants to know why a post underperformed or which patterns are winning
- User asks about 48-hour cadence, first-2-hour engagement, or comment-vs-broadcast behavior

## Layer 1 — Build the Writing Skill First

This is a persistent markdown brief that gets loaded before every post. It does not replace editing; it prevents drift.

### Voice DNA

Capture actual patterns, not adjectives. Inspect 10-15 of the user's best posts or any natural writing (emails, Reddit comments) and extract:
- Sentence openers they naturally use
- Whether questions, statements, or stories open posts
- Transition words and rhythm
- Tone markers

Anti-pattern to avoid: writing "professional and engaging" as a descriptor.

### Anti-List

Explicitly list what the user never wants to sound like. Be specific.
- Corporate phrasing, fake humility, motivational-poster energy, single-word dramatic line breaks
- Add the user's custom cringe list

### Post Structure

A loose internal guide, not a rigid template.
- Opening approach and typical length of hook
- How backup evidence or examples are introduced
- How the post closes and what CTA shape is used

### Topic Angles

List the 5-8 themes the user actually posts about. Specific to their world.

### Reference Posts

Paste in 3-5 full post examples. Label each with: what made it work, what angle it took. These are calibration anchors.

### File Location

Save under one of:
- Project skill: `<workspace>/skills/linkedin-writing/SKILL.md`
- User-local skill mirror: `~/.hermes/skills/linkedin-writing/SKILL.md`
- Canonical dotfiles skill tree: `~/.dotfiles/skills/linkedin-self-improving-system/SKILL.md`

Preferred path is `~/.dotfiles/skills/linkedin-self-improving-system/WRITING.md` and `~/.dotfiles/skills/linkedin-self-improving-system/PERFORMANCE.md` so the two layers remain separate but co-located.

## Layer 2 — Build the Performance Skill

Only build after 8-10 posts have been logged. The writing skill alone gives consistency; the performance skill gives improvement signals.

### Data Store

A running log of every post with one row per post. Fields:
- Post ID, URL, date, posting time
- Impressions, members reached, engagement rate
- Hook type: question, statement, problem-consequence, story open
- Narrative structure: list, story, argument, case study
- Topic angle
- Post length bucket: short <150w, medium 150-250w, long 250w+
- First 2-hour engagement signal: yes/no

### Pattern Engine

Patterns move through confidence levels:
- Tentative: 2-3 posts showing the same signal
- Emerging: 4-6 confirming it
- Confirmed: 7+ posts, strong signal

Only Confirmed patterns become Active Rules.

### Active Rules

Short list of specific, measurable rules. Not "post more" but:
- "Problem-consequence hooks outperform question hooks by 2x"
- "Posts under 150 words get higher engagement rate on Thursdays"
- "Commenting on 3 others before posting increases first-wave signal"

### Evolution Log

Timestamped list of when rules were added, changed, or retired. This keeps the system honest and debuggable.

### File Location

Save as a sibling file to the writing skill:
- `~/.dotfiles/skills/linkedin-self-improving-system/PERFORMANCE.md`

Do not inline this into the writing skill; separate files make iteration safer.

## Feedback Loop

1. Publish a post
2. 24-48 hours later, log metrics into the Data Store
3. Pattern Engine checks for signals across logged posts
4. Signals reaching Confirmed status become Active Rules
5. Active Rules get applied automatically in the next post draft
6. Repeat

Each cycle takes roughly 10 minutes.

## Distribution Rules

These are not hacks; these match how LinkedIn's distribution works.

### Post Frequency

Post once every 48 hours, not 24.
- LinkedIn distributes in waves over roughly 24-48 hours
- Publishing a new post before the previous cycle finishes causes cancellation: the old post stops circulating
- This is post cannibalization, not reach multiplication

### First 2 Hours

The first wave goes to the most engaged connections; based on that signal, LinkedIn decides whether to widen distribution.
- If anyone comments, respond within 5 minutes
- Replies with substance extend the conversation; "thanks" does not
- Do not edit the post after publishing; it can reset or hurt distribution
- Keep notifications on for 2 hours after publishing

### Go to Others, Not Just Your Own Posts

LinkedIn rewards participation, not broadcast.
- Before publishing, spend 15-20 minutes commenting meaningfully on posts in the target niche or audience
- After publishing, do the same to extend the activity window around the profile
- Two-sentence minimum; short praise comments get ignored

## Ramp Sequence

- Week 1: Build the writing skill. Pull 10 best posts, extract voice DNA, write anti-list, add 5 reference posts. Start using it immediately.
- Weeks 2-3: Post every 48 hours and log metrics in a simple data store. Do not build the performance skill yet.
- Week 4: Once 8-10 posts are logged, build the performance skill. Seed it with real patterns.
- Ongoing: after every post, spend 10 minutes logging metrics, checking patterns, updating Active Rules.

## Using the Skill in Drafting

When drafting a post for the user:
1. Load the writing skill first
2. Check the performance skill for Active Rules
3. Apply the winning pattern in the user's voice
4. For distribution: check time of day, hook type, length bucket against Active Rules
5. Do not invent new voice patterns not supported by the writing skill

## Pitfalls

- Building performance skill too early with too little data. Tentative patterns are not rules.
- Posting too often and cannibalizing distribution
- Generic anti-list that does not constrain output. Specificity is the point.
- Edits after publishing
- Broadcasting without engaging in others' content
- Treating the writing skill as a prompt to obey instead of a voice calibration to embody

## Verification Checklist

- [ ] `WRITING.md` exists with Voice DNA, Anti-List, Post Structure, Topic Angles, and 3-5 Reference Posts
- [ ] `PERFORMANCE.md` exists with Data Store schema, Pattern Engine thresholds, Active Rules, and Evolution Log
- [ ] At least 8 posts logged in Data Store before building second layer
- [ ] Posting cadence enforces 48-hour minimum between posts
- [ ] Active Rules count is small and specific, not generic
