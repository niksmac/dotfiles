---
name: lightrains-blog-writing
description: Write, review, and improve posts for the Lightrains engineering blog in our specific voice. Use this for blog posts, technical articles, case studies, product announcements, deep dives, postmortems, and thought-leadership pieces aimed at engineers, founders, and CXOs.
---

# Lightrains Blog Writing Skill

Use this skill whenever someone is creating or editing content for the Lightrains blog or developer audience. Treat this document as the source of truth for tone, structure, and quality.

Trigger this skill when the user mentions:

- "blog post", "blog draft", "engineering post", "deep dive", "postmortem"
- "case study", "build log", "use case", "solution overview"
- "product announcement", "launch post", "feature announcement"
- "thought leadership", "POV piece", "founder essay"

If it could plausibly live on the Lightrains blog, use this skill.

## Before Starting

**Check for context first:**
If `marketing-context.md` exists, read it. It contains brand voice guidelines, writing examples, and the specific tone this brand uses. That context is your voice blueprint. Use it — don't improvise a voice when the brief already defines one.

Gather what you need before starting:

### What you need

- **The content** — paste the draft to humanize
- **Brand voice notes** — if no `marketing-context.md`, ask: "Is your voice direct/casual/technical/irreverent? Give me one example of writing you love."
- **Audience** — who reads this? (This changes what "human" sounds like)
- **Goal** — what should this piece do? (Knowing the goal tells you how much personality is appropriate)

One question if needed: "Before I rewrite this, give me an example of content you've written or read that felt right. Specific is better than descriptive."

---

## 1. Audience and Intent

Before writing, the agent must infer and keep in mind:

1. **Primary audience (pick one):**
   - Practicing engineers / architects
   - Technical decision-makers (VP Eng, CTO, Head of Product)
   - Business leaders and CXOs in AI/blockchain-heavy domains

2. **Primary intent (pick one):**
   - Teach something **concrete** and technically useful
   - Demonstrate Lightrains’s ability to deliver real outcomes
   - Change how the reader thinks about a problem or approach
   - Drive a next step: contact us, talk to sales, try a demo, download a resource
3. Where should I save the file?
   - Save all blog posts to: `/src/pages/blogs/`
   - Filename format: kebab-case (e.g., scaling-rag-pipeline-qdrant-production.md)
   - No uppercase, no spaces, use hyphens

The post should make it obvious, within the first few paragraphs, who it is for and what they get out of it.

---

## 2. The Lightrains Voice

We sound like a senior engineer who also understands how businesses make decisions.

**We do:**

- Be technically precise, opinionated, and direct.
- Write like you are explaining this to a peer at a conference hallway track.
- Use "we" (Lightrains) and "you" (the reader).
- Use one **good** joke or light irreverent line per post at most, not per paragraph.
- Connect tech decisions to business impact (cost, risk, time-to-market, compliance).

**We don’t:**

- Sound like a corporate press release or generic AI‑generated summary.
- Drown the reader in adjectives instead of numbers.
- Hide trade-offs and failure modes.
- Use hype as a substitute for insight.

---

## 3. Banned and Suspicious Language

The following phrases must not appear:

- "We're excited/thrilled/delighted to announce"
- "Best-in-class", "industry-leading", "cutting-edge"
- "Seamless"/"seamlessly"
- "Empower", "leverage", "unlock", "streamline"
- "Robust" (describe what makes it robust instead)
- "At Lightrains, we believe..." (just state the belief directly)
- Fluff transitions like:
  - "That being said", "It's worth noting that", "At the end of the day"
  - "Without further ado", "As you might know"
- "In this blog post, we will explore..." (just start)
- **Em-dashes (--)**: Never use em-dashes in content. Replace with commas, periods, or restructure sentences. This applies to both regular text and frontmatter.

If you ever reach for one of these, rewrite with something concrete and specific.

---

## 4. Openings That Hook

The first 2–3 sentences must do **one** of:

- **State the problem** in concrete terms.
- **State the conclusion** and signal there is a story or hard‑won insight behind it.

Never open with company history, generic market hype, or meta talk about the post.

**Good patterns:**

- "Two weeks before go-live, we threw away our first design for X. Here’s why it failed in production and what finally worked."
- "Most enterprise AI projects stall not on models, but on data contracts. Here’s how we fixed that for a fintech client processing Y transactions/day."

**Bad patterns:**

- "At Lightrains, we’re always looking for ways to improve..."
- "In this blog post, we will explore..."

---

## 5. Structure: Follow the Reader’s Questions

Organize content around the reader’s actual questions, not internal narratives.

**For most posts, follow this spine:**

1. **What problem does this solve?**
   - 1–2 short paragraphs.
   - Describe the pain in the reader’s language (latency, failed audits, incidents, overruns).

2. **How does it actually work?**
   - Bulk of the post.
   - Focus on underlying technology, architecture, workflows, and decisions.
   - Explain enough that a senior engineer could critique or adapt it.

3. **What were the trade-offs or alternatives?**
   - Compare at least two plausible approaches and why you chose yours.
   - Mention what you deliberately did **not** do.

4. **How do I use/try/implement this?**
   - Concrete next steps: a mini-implementation guide, repo link, docs, or “talk to us if you have X situation.”

**For engineering deep dives, also cover:** 5. **What did we try that didn’t work?**  
 Be specific (metrics, logs, failure patterns). 6. **What are the known limitations or open questions?**  
 Show intellectual honesty and where this approach might not fit.

---

## 6. Headings That Carry Their Weight

Headings must convey information, not just act as labels.

- Avoid: "Background", "Architecture", "Results", "Conclusion".
- Prefer:
  - "Why pre-aggregating metrics broke every production incident"
  - "The event-driven pipeline we shipped instead"
  - "Where this approach breaks down at extreme scale"

If a heading could appear in any generic blog post, rewrite it until it’s specific.

---

## 7. Technical Quality and Depth

**Numbers beat adjectives.**

- Don’t write: "This significantly improved performance."
- Do write: "This cut p99 latency from 340 ms to 45 ms (7.5× faster) under a 4× higher load."

**Code standards:**

- All code must be runnable (no missing imports, config, or undefined variables).
- Include minimal setup context (env, framework, version, assumptions).
- Use comments to explain **why**, not **what**.
- Prefer language and stack choices that align with Lightrains’s actual work (AI agents, blockchain, Node.js, infra).

**Systems and diagrams:**

- If more than two components interact, include a diagram (or instructions for one).
- Use real service names and data flows, not generic “Service A/B/C”.
- Call out trust boundaries, data stores, and failure points.

**Honesty over hype:**

- If something is beta or has constraints, say so explicitly.
- It is okay to acknowledge where competitors do something well; explain how we differ.
- Never exaggerate AI capability.  
  Example: say "suggests likely root causes based on patterns" instead of "finds the root cause automatically".

---

## 8. Titles That Earn the Click

Titles must stop a developer or CXO scrolling and make a specific promise.

**Strong titles:**

- Make a specific claim.
- Tell a story or decision.
- Promise a concrete payoff.

Examples:

- "We killed a working analytics product. Here’s why the second version finally stuck."
- "How we cut deployment lead time by 30% for a regulated fintech using GitOps and policy-as-code."
- "Your JavaScript bundle is half dead code. Here’s how to prove it to your CFO."

**Weak titles:**

- "Introducing our new metrics product"
- "Performance improvements in Lightrains"
- "AI-powered debugging with X"

When in doubt, rewrite the title after the draft is done to reflect the sharpest insight.

---

## 9. SEO: Keywords, Meta, and Internal Linking

### Keyword Strategy

Before drafting, the agent must:

1. **Identify a primary keyword** (one per post): the specific term your target reader would search for. Prefer problem-oriented or solution-oriented phrases over generic category terms.
   - Good: "AI agent orchestration production patterns"
   - Bad: "AI agents"

2. **Identify 2-3 secondary keywords**: closely related terms that support the primary keyword. These appear naturally in headings, image alt text, and body copy.

3. **Keyword placement rules:**
   - Primary keyword must appear in: the title, the first 150 words, at least one `##` heading, and the `excerpt` frontmatter field.
   - Secondary keywords should be distributed across subheadings and body paragraphs. Never force them; reword the heading so the keyword fits naturally.

4. **No keyword stuffing.** If a keyword feels awkward in context, remove it. Reader clarity always wins over search density.

### Meta Optimization

Every post must optimize these fields:

- **Title tag** (the `title` frontmatter): 50-60 characters. Lead with the primary keyword when possible. Make it specific and click-worthy (see Section 8 for title quality rules).
- **Excerpt** (`excerpt` frontmatter): 15-25 words. Include the primary keyword once. This doubles as the meta description in search results.
- **Subtitle** (`subtitle` frontmatter): 25-50 words. Expand on the excerpt, include a secondary keyword if it fits naturally.
- **URL slug** (derived from filename): kebab-case, include primary keyword, no stop words, no dates. Keep it under 5 hyphenated segments.
  - Good: `ai-agent-orchestration-production-patterns.md`
  - Bad: `how-we-built-ai-agents-for-our-client-in-2024.md`

### Internal Linking

Internal links connect blog posts to high-value pages on the site. They drive readers toward conversion points and signal topic authority to search engines.

**Before writing or editing any blog post, the agent must:**

1. **Scan the project directory structure** to map the site. Use `list_directory` and `find_path` to discover:
   - Service pages (commonly under `/src/pages/services/` or similar)
   - Offering or solution pages (e.g., `/src/pages/solutions/`, `/src/pages/offerings/`)
   - Feature or product pages (e.g., `/src/pages/features/`, `/src/pages/products/`)
   - Other blog posts in `/src/pages/blogs/`

2. **Identify pillar content.** A pillar page is any top-level page that represents a core business capability. Detect them by:
   - Directory: pages in `/services/`, `/solutions/`, `/offerings/`, `/features/`, `/products/`
   - Filename: matches a core business term (e.g., `ai-consulting.astro`, `blockchain-development.astro`, `smart-contract-audit.astro`)
   - Navigation: pages linked from main nav or footer layout components

3. **Build an internal link map** for the current post. Identify 3-5 relevant targets:
   - Services or solutions related to the post's subject.
   - Features or capabilities mentioned or demonstrated in the post.
   - Adjacent blog posts covering related topics.

4. **Insert contextual internal links:**
   - Place 2-4 internal links to pillar pages per post (not counting blog-to-blog links).
   - Link from relevant body text using descriptive anchor text. Never use "click here" or "learn more."
     - Good: "our [AI agent development services](/services/ai-agents) help teams..."
     - Bad: "[click here](/services/ai-agents) to learn about our AI services"
   - Link to at least one service or offering page within the first half of the post.
   - Link to at least one feature or capability page in the second half.
   - Cross-link to 1-2 related blog posts where the connection adds value.

5. **Link format:** Use the resolved URL path for consistency.
   - Blog to service page: `/services/ai-agents`
   - Blog to blog: `/blogs/related-post-slug`

---

## 10. Closings That Create Motion

Never end with generic hype ("We can’t wait to see what you build!") or a recap of headings.

Close with one or more of:

- A specific way to try the idea: repo, docs, example config, sandbox.
- A direct invitation: "If you’re dealing with [problem], talk to us. We’ve done this before."
- A forward-looking note that opens a loop: what you want to explore next, or what you’ll share in a follow-up post.

---

## 11. Lightrains Content Map (Top 5 Post Types)

Use this table to pick the right format before writing.

| Type                      | Goal                                                        | Must Include                                                                 | Example Topics                                                           | Typical Byline                         |
| ------------------------- | ----------------------------------------------------------- | ---------------------------------------------------------------------------- | ------------------------------------------------------------------------ | -------------------------------------- |
| Engineering Deep Dive     | Prove technical authority in AI, blockchain, scalable infra | Architecture, trade-offs, decisions, metrics, diagrams                       | "Designing AI Agents for Enterprise Workflows"                           | Senior Engineer / Architect            |
| Case Study / Build Log    | Convert credibility into trust and leads                    | Client context, problem → solution → measurable impact (ROI, latency, cost)  | "How We Built a Blockchain-Based Supply Chain for a Tier-1 Manufacturer" | Eng + PM / Solutions Lead              |
| Founder / Leadership POV  | Position Lightrains as a strategic technology partner       | Clear thesis, market shifts, decision frameworks, risks, timing              | "When Enterprises Should Bet on AI Agents (and When They Shouldn’t)"     | Founder / Leadership                   |
| Solution / Use Case Story | Map services to business problems and buying triggers       | Industry pain points, our approach, implementation model, outcomes           | "AI in Manufacturing: Reducing Defects with Computer Vision and Edge AI" | Marketing + Solutions Engineering      |
| Technical GTM / How-To    | Attract developers and enable bottom-up adoption            | Step-by-step guide, realistic constraints, sample code, integration patterns | "Build an AI Support Agent on the Lightrains Stack in a Weekend"         | DevEx + Marketing / Developer Advocate |

---

## 12. The "Would I Share This?" Test

Before considering a draft "done", the agent must check:

- Would a senior engineer or CXO **share this** with a colleague?
- Could it plausibly show up on Hacker News, Reddit, or an internal Slack as "worth reading"?

A post is shareable if it contains at least one of:

- A technical decision explained with trade-offs and data.
- Original data, benchmarks, or research.
- A real debugging or failure story with specifics.
- An honest retrospective on something that went wrong.
- A how-to that clearly saves time or reduces risk for the reader.

If none of these are present, the content probably belongs in docs or changelog, not the blog.

---

## 13. Non-Negotiables (Checklist)

The agent must enforce these rules every time:

1. **Real byline**: Use a real person's name and role (no "The Lightrains Team").
2. **Working code only**: No pseudo-code masquerading as production unless clearly labeled.
3. **No "we're excited to announce"** or other banned phrases.
4. **Systems diagram**: Any multi-component system must have a diagram or at least a clear description of one.
5. **Performance claims numbers**: Always include baseline and after numbers, and conditions.
6. **Decisions alternatives**: If you mention a decision, mention at least one alternative and why it lost.
7. **Audience clarity**: The author should be able to answer "Who is this for?" in one sentence.
8. **No changelog disguised as a blog**: Release notes and small tweaks go to changelog, not here.
9. **Err on the side of depth**: Too detailed is safer than too shallow.
10. **Write the post you wish existed** when you first tackled this problem.
11. **File format verified**: Correct frontmatter structure, kebab-case filename, saved to `/src/pages/blogs/`
12. **No em-dashes**: Check entire post (including frontmatter) for em-dashes (--). Replace with commas, periods, or restructure.
13. **Primary keyword placed**: Title, first 150 words, one ## heading, and excerpt all contain the primary keyword.
14. **Internal links present**: At least 2 links to pillar pages (services, offerings, features) and 1 cross-link to a related blog post.
15. **URL slug is clean**: Kebab-case filename with primary keyword, no dates, no stop words, under 5 segments.

---

## 14. Review and Editing Workflow

When the agent is asked to review or edit a draft, it should:

### Technical Review

- Verify technical claims for correctness and realism.
- Flag missing context (versions, constraints, assumptions).
- Ensure code samples work in a plausible environment.
- Check architecture descriptions against internal reality (if provided).
- Replace vague claims with quantified ones where possible.

### Editorial Review

- Confirm the opening hooks within 2–3 sentences.
- Check that the piece passes the "would I share this?" test.
- Remove corporate language, filler, and fluff.
- Ensure headings convey information, not just structure.
- Check pacing and length: no padding, no thin treatment of complex topics.
- Sharpen the title for specificity and payoff.

### Feedback Style

When giving feedback:

- Quote the weak passage.
- Explain briefly **why** it fails the standard (e.g., too vague, too salesy, missing numbers).
- Propose a rewritten version that meets the Lightrains standard.

---

## 15. How the Agent Should Respond

When using this skill, the agent should:

1. Ask (or infer) the **post type** and **primary audience** if not specified.
2. Suggest a **working title** and a short outline aligned to the structure above.
3. Draft or revise content in the Lightrains voice, enforcing all non-negotiables.
4. Propose at least:
   - One diagram description (what components, what flows).
   - One set of concrete metrics or outcomes (real or clearly hypothetical if needed).
5. Provide a short "Author notes" section (for internal use) explaining:
   - Who this is for.
   - The core takeaway.
   - Where this fits in the content map (which of the 5 post types).
6. Not use overused terms like;
   - "delve," "delve into," "delve deeper"
   - "landscape" (as in "the current AI landscape")
   - "crucial," "vital," "pivotal"
   - "leverage" (when "use" works fine)
   - "furthermore," "moreover," "in addition"
   - "navigate" (metaphorical: "navigate this challenge")
   - "robust," "comprehensive," "holistic"
   - "foster," "facilitate," "ensure"
   - "at its core"

### 15.1. Lightrains Blog File Format

#### All blog posts must use this exact frontmatter structure:

```markdown
---
layout: '../../layouts/BlogLayout.astro'
title: 'Blog Title Here SEO optimized'
heroText: 'short, punchy, headline-style (30–55 chars)' # Example: `"2026 Outsourcing Trends: How AI-First Offshore Teams Help You Ship Faster"` → `"Then vs Now: Outsourcing 2026"`
date: 'YYYY-MM-DD HH:MM:SS +0530'
meta: 'filename.jpg'
author: 'agent' # or real person's name
excerpt: 'One-sentence summary for SEO and previews'
subtitle: 'Longer summary (can be 1-2 sentences) describing what readers will learn'
tags: ['Tag1', 'Tag2', 'Tag3']
faqs: []
---
```

**Frontmatter field rules:**

- layout: Always ../../layouts/BlogLayout.astro (relative path from blogs folder)
- title: Use the same working title from the outline, in double quotes
- date: Current date in IST timezone format YYYY-MM-DD HH:MM:SS +0530
- meta: Image filename without path, must match .jpg file in images folder
- author: Use 'agent' for now, or real name if available
- excerpt: 15-25 words, describes value proposition
- subtitle: 25-50 words, more descriptive, can match excerpt or expand
- tags: Array of 2-4 relevant tags, capitalize first letter of each
- faqs: Array of FAQ objects. Leave as `[]` unless the user explicitly asks for FAQs. When requested, use this structure:
  ```yaml
  faqs:
    - question: 'What is the main benefit of X?'
      answer: 'Short, direct answer in the Lightrains voice (2-4 sentences max). No fluff.'
  ```

  - Generate 3-6 FAQs that address real reader questions, not softball filler.
  - Each answer must be factually grounded in the post content.
  - Use the same voice and banned-language rules as the rest of the post.
  - Prioritize questions that a reader would actually search for (SEO-minded).

**Markdown formatting rules:**

- Use ## for all section headings (no # H1, it's in title)
- Use ### for subsections
- Use **bold** for emphasis, not _italics_
- Use > blockquote for callouts and highlights
- Use code blocks with language identifier: javascript, bash, etc.
- Use ASCII diagrams or mermaid for system architecture
- Include author notes at the end (for internal use only):
- This keeps the content opinionated, technically credible, and useful for both engineers and CXO-level readers who care about outcomes.

Do you already have 2–3 flagship topics or case studies in mind that you want this skill to be especially good at (for example, AI agents in enterprise, a specific blockchain project, or a standout client win)?
