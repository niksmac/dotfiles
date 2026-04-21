# LinkedIn Automation Skill

Safe, compliant LinkedIn outreach automation that respects LinkedIn's terms of service.

## What This Skill Does

- **Content engagement** — Like posts, comment thoughtfully, view profiles
- **Connection outreach** — Send personalized connection requests
- **Follow-up sequences** — Multi-touch messaging with anti-detection
- **Full warm-up campaigns** — Engage first, then connect (3x better results)

## Trigger Phrases

The skill activates when you say:

- "message LinkedIn people"
- "LinkedIn automation"
- "send connection requests on LinkedIn"
- "LinkedIn outreach"
- "LinkedIn bot"
- "message people on LinkedIn"

## How to Use

### 1. Prerequisites

- OpenCode Chrome extension installed
- LinkedIn account logged in

### 2. Invoke the Skill

Simply describe what you want to do. Examples:

> "Message these LinkedIn people with this message"

> "I need to send connection requests to 10 profiles"

> "Send personalized messages from my leads.csv file"
> "Like and comment on these people's posts first"
> "Run a full warm-up campaign for these prospects"

### 3. Input Options

#### Option A: Simple List

Just provide profile URLs:

```
linkedin.com/in/johndoe
linkedin.com/in/sarahsmith
```

#### Option B: CSV File with Data

Provide a CSV with columns like:

| first_name | company | role | linkedin_url | recent_activity |
|-----------|---------|------|--------------|-----------------|
| John | Acme | VP Sales | ... | hiring 3 new AEs |
| Sarah | TechCorp | CTO | ... | launched new API |

### 4. Variable Syntax

Use `{column_name}` in your message template:

```csv
first_name,company,role,linkedin_url
John,Acme,VP Sales,...
Sarah,TechCorp,CTO,...
```

**Template:**
```
Hi {first_name}, saw you're now {role} at {company}. Would love to connect!
```

**Result:**
- "Hi John, saw you're now VP Sales at Acme. Would love to connect!"
- "Hi Sarah, saw you're now CTO at TechCorp. Would love to connect!"

### 5. CSV Example

Create a file named `leads.csv`:

```csv
first_name,company,role,linkedin_url,recent_post
John,Acme Corp,VP Sales,linkedin.com/in/johndoe,hiring 3 new AEs
Sarah,Tech Inc,CTO,linkedin.com/in/sarahsmith,launched new API
Mike,StartupXYZ,Founder,linkedin.com/in/miketest,raised Series A
```

**Template:**
```
Hi {first_name}, noticed {recent_post} at {company}. As a {role}, I think this could be valuable for you. Let's connect!
```

**Output:**
- "Hi John, noticed hiring 3 new AEs at Acme Corp. As a VP Sales, I think this could be valuable for you. Let's connect!"
- "Hi Sarah, noticed launched new API at Tech Inc. As a CTO, I think this could be valuable for you. Let's connect!"
- "Hi Mike, noticed raised Series A at StartupXYZ. As a Founder, I think this could be valuable for you. Let's connect!"

---

## Engagement Modes

### Option A: Likes Only
- Like 2-3 of their recent posts
- Quick warm-up, low effort

### Option B: Like + Comment
- Like their posts + leave thoughtful comment
- Much higher recognition rate

### Option C: Full Warm-Up (Recommended)
```
Day 1:   Like 2 posts + 1 comment
Day 2:   View their full profile  
Day 3-5: (pause)
Day 6:   Send connection request
Day 7:   Follow-up message
```

**Result: 3x higher acceptance rate** because they recognize your name!

### Comment Templates

| Post Type | Comment |
|-----------|---------|
| Industry opinion | "Interesting take. We saw the same thing with our clients..." |
| Hiring news | "Team growth is exciting! What's your hiring focus?" |
| Product launch | "This is what the market needs. Curious about the dev story..." |
| Data/Stats | "That {percentage} shift is huge. Are you seeing it too?" |

---

## Safety Limits (Applied Automatically)

| Action | Daily Limit |
|--------|------------|
| Connections | 40-50 |
| Messages | 20-50 |

## Quick Start

```
User: Message these people on LinkedIn
- linkedin.com/in/johndoe
- linkedin.com/in/janesmith
With: "Hi! Saw your work on X and would love to connect."

OpenCode: [Activates linkedin-automation skill]
✓ Checking Chrome connection... ✓ Logged in
Opening profile 1 of 2...
Sending message with anti-detection delays...
✓ Message sent
Opening profile 2 of 2...
...
✓ Complete - 2 messages sent
```

## Safety Features Included

- 2-5 second delays between actions
- Character-by-character typing
- Hover-before-click (human behavior)
- Rate limit enforcement
- Warning sign monitoring

## Files

```
linkedin-automation/
├── SKILL.md    # Full skill documentation
└── README.md   # This file
```

## Related Skills

- `content-humanizer` — Use to make outreach messages more conversational