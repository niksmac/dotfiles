---
name: 'linkedin-automation'
description: "Automate LinkedIn outreach safely with compliance-first practices. Handles connection requests, personalized messaging, and follow-up sequences while respecting LinkedIn's rate limits and detection systems. Triggers: 'message LinkedIn people', 'LinkedIn automation', 'send connection requests on LinkedIn', 'LinkedIn outreach', 'LinkedIn bot', 'message people on LinkedIn'."
---

# LinkedIn Automation Skill

Safe, compliant LinkedIn outreach automation that respects LinkedIn's terms of service and minimizes account risk.

## Before Starting

**Check for context first:**
- Is the user logged into LinkedIn?
- Do they have the OpenCode Chrome extension connected?
- Get the list of profile URLs from the user
- Get the message template they want to send

Ask one clarifying question if needed: "Should I personalize each message with profile-specific details, or use the same template for all?"

### CSV Data Input (Optional)

If the user has a CSV file with prospect data:

1. **Ask for the CSV file path** — e.g., `leads.csv`
2. **Read the CSV** and extract column headers
3. **Map columns to variables** — Use `{column_name}` syntax in message template
4. **Validate** — Ensure all required columns exist

**Example CSV format:**

```csv
first_name,company,role,linkedin_url,recent_activity,job_change
John,Acme Corp,VP Sales,linkedin.com/in/johndoe,hiring 3 new AEs,joined 2 months ago
Sarah,Tech Inc,CTO,linkedin.com/in/sarahsmith,launched new API,promoted last month
```

**Message template:**
```
Hi {first_name}, saw you're now {role} at {company}. {recent_activity} — impressive timing. Would love to connect.
```

**Renders to:**
> "Hi John, saw you're now VP Sales at Acme Corp. hiring 3 new AEs — impressive timing. Would love to connect."

> "Hi Sarah, saw you're now CTO at Tech Inc. launched new API — impressive timing. Would love to connect."

**Requirements:**
- CSV must have `linkedin_url` column
- All `{variable}` in template must match a column header
- Empty cells: Use fallback or skip personalization for that row

## How This Skill Works

### Mode 1: Pre-Flight Check

Verify safe conditions before starting:
- Chrome with OpenCode extension is running
- User is logged into LinkedIn
- Confirm rate limits with user (default to conservative)

### Mode 2: Safe Execution

Execute outreach with anti-detection measures:
- Open each profile in LinkedIn
- Hover before clicking (mimic human behavior)
- Type message character-by-character with delays
- 2-5 second pauses between actions
- Spread activity throughout the day

### Mode 3: Post-Monitoring

After execution:
- Watch for LinkedIn warnings
- Advise user to monitor account health
- Track metrics manually

---

## Safe Rate Limits

These limits are based on industry best practices and community findings to avoid account restrictions:

| Action | Daily Limit | Weekly Limit | Notes |
|--------|-------------|--------------|-------|
| Connection Requests | 40-50 | 300-500 | Start lower for new accounts |
| New Messages | 20-50 | 100-250 | Spread throughout day |
| Profile Views | 50-100 | 300-500 | Reduced effectiveness in 2026 |
| Likes/Comments | 20-50 | — | Must be genuinely relevant |

### Account Age Adjustments

- **New accounts (< 3 months)**: Start at 50% of limits, ramp up over 4-6 weeks
- **Established accounts**: Can use full limits
- **High SSI scores (75+)**: Slightly more lenient

---

## Anti-Detection Measures

### Timing & Pacing

| Technique | Implementation |
|-----------|----------------|
| Action delays | 2-5 seconds between each action |
| Character typing | Type character-by-character, not instant fill |
| Randomized intervals | Vary delays so actions aren't rhythmic |
| Session length | Limit to 30-45 minutes per session |
| Weekend reduction | Reduce activity by 50% on weekends |

### Behavioral Patterns

- **Hover before click**: Briefly hover over elements before clicking
- **Natural scrolling**: Occasionally scroll naturally between actions
- **Mix activities**: Alternate between viewing profiles, sending messages, engaging with content
- **Time zone consistency**: Avoid activity at unnatural hours (e.g., 3 AM)

### Message Personalization (Critical)

Every message MUST include unique personalization:

- Reference specific profile details (recent post, job change, company news)
- Use 10+ dynamic variables, not just `[First Name]`
- Vary message structure and length
- If message could be sent to 50 people without modification, it's too generic

**Example of good personalization:**

> "Hi Sarah, saw you just joined Acme Corp as VP Sales. Congrats on the move. I noticed you're hiring 3 new AEs based on your LinkedIn posts about scaling the team..."

---

## Compliance Checklist

Before starting any automation:

- [ ] Using approved tools only (Chrome DevTools, official API integrations)
- [ ] Personalizing all outreach messages
- [ ] Staying within rate limits
- [ ] Mixing automated + manual engagement
- [ ] Monitoring account health metrics
- [ ] Prepared to pause if warnings appear
- [ ] Understanding GDPR/CCPA requirements if applicable

---

## Account Health Monitoring

### Key Metrics to Track

| Metric | Healthy | Warning | Action Needed |
|--------|---------|---------|---------------|
| Connection Acceptance Rate | 30-40%+ | 15-20% | Pause & review targeting |
| Message Response Rate | 2-5%+ | <1% | Pause & improve messaging |
| Connection Requests Pending | Normal | Much higher than usual | May be rate limited |

### Warning Signs to Pause Immediately

- LinkedIn asks you to verify identity
- "Temporary restriction" notification
- Messages not delivering
- Unusual number of "I don't know this person" rejections
- Reduced profile/post visibility

---

## Consequences of Violations

| Violation | Consequence | Recovery Time |
|-----------|-------------|---------------|
| First warning | Warning popup | Immediate |
| Rate limit exceeded | 24-72 hour restriction | 1-3 days |
| Repeat/spam reports | 30-90 day suspension | 1-12 weeks |
| Severe violation | Permanent ban | Nearly impossible |

---

## LinkedIn's Detection Methods

LinkedIn uses multiple methods to detect automation:

1. **Behavioral fingerprinting** — Analyzes timing, patterns, and consistency
2. **Rate limiting** — Built-in anomaly detection
3. **User reports** — Spam complaints trigger investigation
4. **Content analysis** — Identifies identical/mass-sent messages
5. **IP analysis** — Multiple accounts from same IP acting similarly

### What Triggers Flags

- Same message sent 50+ times
- 100+ connection requests in 2 hours
- Activity at 3 AM across time zones
- Sudden spike after dormant period
- Low acceptance rates (spam signal)

---

## Content-First Sequencing (Recommended)

For better results and lower risk:

1. **Days 1-5**: Engage with prospect's content (likes, thoughtful comments)
2. **Day 6**: Send connection request with personalization
3. **Day 7-10**: Send follow-up message after acceptance
4. **Day 14**: Share relevant content/insight
5. **Day 21**: Direct meeting request

This approach has 3x higher acceptance rates because prospects recognize your name before the connection request.

---

## Engagement Workflows

### Mode A: Content Engagement (Warm-Up)

**Purpose:** Get prospect familiar with your name before outreach

**Actions:**
1. Find prospect's recent posts (last 5-10 posts)
2. Like 1-2 posts (genuine engagement, not mass liking)
3. Comment something thoughtful (not generic "Great post!")

**Comment templates (rotate between):**

| Post Type | Comment |
|----------|---------|
| Industry opinion | "Interesting take. We saw something similar with {company} clients..." |
| Product launch | "This is exactly what the market needs. Curious about the dev story..." |
| Hiring news | "Team growth is exciting. What's your hiring focus for Q3?" |
| Data/Stats | "That {percentage} shift is huge. Are you seeing it in retention too?" |
| Question | "I've wondered the same thing. Our experience: {insight}" |

**Timing:**
- Engage with 10-15 prospects per day
- Space out: 5-10 minutes between each
- Limit: 20-30 likes + 5-10 comments per day

### Mode B: Profile Warming

**Purpose:** Get on prospect's "viewed your profile" notification

**Actions:**
1. View prospect's profile (full view, not quick glance)
2. Check their "About" section
3. Look at their featured content

**Note:** Profile views have reduced effectiveness in 2026. Use sparingly.

### Mode C: Full Sequence (Recommended)

**Complete workflow for each prospect:**

```
Day 1:   Like 2 of their posts + 1 thoughtful comment
Day 2:   View their profile (full)
Day 3-5:  (Active pause - let it sink in)
Day 6:   Send connection request with personalization
Day 7:   (If accepted) Send follow-up message
Day 10:  Share relevant content/insight
Day 14:  Meeting request or re-engagement
```

### Mode D: Comment-First Outreach

**Purpose:** Comment on their post, then connect in the same visit

**Workflow:**
1. Navigate to their recent post
2. Leave genuine comment referencing a specific point
3. Immediately send connection request (they'll recognize you)

---

## Enhanced Engagement Templates

### Connection Request (After Engagement)

```
Hi {first_name}, saw your thoughts on {post_topic} - really resonated.
{follow_up_personalization}
Always great to connect with others in {industry} space.
```

### Follow-Up (Post-Acceptance)

```
Thanks for connecting, {first_name}! 
{refer_to_engagement}: "I saw your updates on {topic} - made me think about {insight}."
{value_proposition}
{specific_cta}
```

### Re-Engagement (Day 14)

```
{first_name}, came across your {recent_activity} update. 
{new_personalization_angle}
Would love to chat about {topic} when you have 15 mins.
```

---

## Practical Execution

If user wants multi-step engagement:

1. **Get prospect list** with their recent post URLs or topics
2. **Select engagement type:** likes-only, comments, profile views, full sequence
3. **Generate engagement comments** using templates
4. **Execute with delays** (same anti-detection measures apply)
5. **Track** what was engaged vs. what needs follow-up

---

## Common Mistakes to Avoid

1. **Ignoring rate limits** — Don't try to max out daily limits
2. **Generic messaging** — Every message needs unique personalization
3. **"Set and forget"** — Monitor account health daily
4. **New account automation** — Warm up new accounts for 2-4 weeks first
5. **Using prohibited tools** — Chrome extensions are higher risk than cloud tools

---

## First-Time Setup (If Not Configured)

1. **Install OpenCode Chrome extension** from Chrome Web Store
2. **Log into LinkedIn** manually in Chrome
3. **Verify extension is connected** — Check for OpenCode icon
4. **Start with conservative limits** — 20 connections/day for first week
5. **Monitor metrics closely** — Adjust based on account health

---

## Proactive Triggers

Flag these without being asked:

- **Rate limit warning** — If user wants to send >50 messages/day, warn about risks
- **Generic template detected** — If message has no personalization variables, flag it
- **New account** — If account is <3 months old, recommend starting at 50% limits
- **Warning signs** — If any restrictions appear during execution, pause and advise

---

## Communication

All output follows the structured standard:

- **Bottom line first** — Answer before explanation
- **What + Why + How** — Every finding includes all three
- **Risk warnings** — Flag any potentially unsafe actions
- **Confidence tagging** — 🟢 verified / 🟡 medium / 🔴 high risk

When executing: State each action before doing it. "Opening profile 1 of 5... Typing message with 3-second delay between characters..."

---

## Related Skills

- **content-humanizer**: Use to make LinkedIn outreach messages sound more human and personalized
- **workspace-guide**: Use for onboarding new users to OpenCode before LinkedIn automation

---

## Sources

- Cykel AI: The Ultimate Guide to AI LinkedIn Automation
- Fuzzy AI: The Ultimate Complete Guide to LinkedIn Bot Automation
- Gojiberry: LinkedIn Automation Compliance Guide
