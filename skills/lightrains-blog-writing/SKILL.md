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

3. **Dual audience and tone alignment**
   Bridge technical credibility with strategic insight. Technologists should feel you understand AI and blockchain nuances. Executives should see clear business value. Address the reader directly using **you** and **your** throughout.

4. **Where should I save the file?**
   - Save all blog posts to: `/src/pages/blogs/`
   - Filename format: kebab-case (e.g., `ai-agent-orchestration-patterns.md`)
   - No uppercase, no spaces, use hyphens

The post should make it obvious, within the first few paragraphs, who it is for and what they get out of it.

## 2. Topic Selection and Research Scope

Do not create weekly summaries or newsletter-style posts. Instead, select three topics aligned with Lightrains’ core expertise.

**Topic sources and alignment**
- Fetch `https://lightrains.com/llms.txt` and use its indexed pages to identify subjects connected to Lightrains’ capabilities.
- Pick the three most relevant topics across these areas:
  1. **AI and ML development:** AI agents, machine learning, NLP, computer vision, predictive analytics
  2. **Blockchain and smart contracts:** crypto adoption, FinTech, AMMs, yield farms, NFT marketplaces, secure deployment
  3. **Web3 and metaverse:** metaverse platforms, decentralized applications
  4. **Technology consulting:** integrating blockchain with server-side, database, cloud, and frontend solutions
  5. **React.js and frontend development:** best practices and innovations for Web3 and AI applications

**Output:** Each article should be an in-depth CXO or founder-level piece delivering strategic insight and thought leadership. Digests are out of scope.

## 3. Research Requirements

Before drafting, gather current evidence and examples:

- Search for news and reports published within the **past 90 days**.
- Use **credible sources** and embed them as **inline hyperlinks** in the form `[source title](URL)`.
- Avoid listing bare URLs and avoid citation artifacts such as `【91089650876118†L108-L167】`.
- Extract **key statistics, quotes, and case studies** that underscore business opportunities.
- Focus on developments intersecting with the expertise areas listed in Section 2.

Build each post around these findings. Let evidence drive the narrative rather than anecdote alone.

## 4. The Lightrains Voice

We sound like a senior engineer who also understands how businesses make decisions.

**We do:**
- Be technically precise, opinionated, and direct.
- Write like you are explaining this to a peer at a conference hallway track.
- Use **one good joke or light irreverent line per post at most**, not per paragraph.
- Connect tech decisions to business impact (cost, risk, time-to-market, compliance).
- Use **short sentences**, **active voice**, and **bullet points** where appropriate.
- Include **frequent line breaks** to preserve readability.
- Address the reader as **you** and **your**.

**We don’t:**
- Sound like a corporate press release or generic AI-generated summary.
- Drown the reader in adjectives instead of numbers.
- Hide trade-offs and failure modes.
- Use hype as a substitute for insight.

## 5. Banned and Suspicious Language

The following phrases must not appear:
- "We're excited/thrilled/delighted to announce"
- "Best-in-class", "industry-leading", "cutting-edge"
- "Seamless" / "seamlessly"
- "Empower", "leverage", "unlock", "streamline"
- "Robust" (describe what makes it robust instead)
- "At Lightrains, we believe..." (just state the belief directly)
- Fluff transitions like "That being said", "It's worth noting that", "At the end of the day", "Without further ado", "As you might know"
- "In this blog post, we will explore..." (just start)
- **Em-dashes (--)**: Never use em-dashes. Replace with commas, periods, or restructure sentences.
- **Citation artifacts**: never include references that look like `【91089650876118†L108-L167】` or similar.

If you ever reach for one of these, rewrite with something concrete and specific.

## 6. Openings That Hook

The first 2–3 sentences must do **one** of:
- **State the problem** in concrete terms.
- **State the conclusion** and signal there is a story or hard-won insight behind it.

Never open with company history, generic market hype, or meta talk about the post.

**Good patterns:**
- "Two weeks before go-live, we threw away our first design for X. Here’s why it failed in production and what finally worked."
- "Most enterprise AI projects stall not on models, but on data contracts. Here’s how we fixed that for a fintech client processing Y transactions/day."

**Bad patterns:**
- "At Lightrains, we’re always looking for ways to improve..."
- "In this blog post, we will explore..."

Each article must include an **intro paragraph** at the beginning of the body that sets the stage before diving into sections.

## 7. Structure: Follow the Reader’s Questions

Organize content around the reader’s actual questions.

**For most posts, follow this spine:**
1. **What problem does this solve?**
   - 1–2 short paragraphs. Describe the pain in the reader’s language: latency, failed audits, incidents, overruns.
2. **How does it actually work?**
   - Bulk of the post. Focus on underlying technology, architecture, workflows, and decisions. Explain enough that a senior engineer could critique or adapt it.
3. **What were the trade-offs or alternatives?**
   - Compare at least two plausible approaches and why you chose yours. Mention what you deliberately did **not** do.
4. **How do I use / try / implement this?**
   - Concrete next steps: a mini-implementation guide, repo link, docs, or “talk to us if you have X situation.”

**For engineering deep dives, also cover:**
5. **What did we try that didn’t work?**
   - Be specific (metrics, logs, failure patterns).
6. **What are the known limitations or open questions?**
   - Show intellectual honesty and where this approach might not fit.

## 8. Writing Mechanics

Enforce these mechanics on every draft:

- **Paragraph length:** Each paragraph must contain at least **7–10 sentences**.
- **Reference links:** Do not add more than **2 reference links** in a single paragraph.
- **Intro paragraph:** Include one introductory paragraph at the very start of the article body.
- **Voice:** Use **short sentences**, **active voice**, and address the reader as **you** and **your**.
- **Formatting:** Use bullet points and frequent line breaks. Avoid walls of text.
- **Citation hygiene:** No bare citation artifacts or doc-style reference tags.
- **Em-dashes:** Never use em-dashes. Replace with commas, periods, or restructure.

## 9. Headings That Carry Their Weight

Headings must convey information, not just act as labels.
- Avoid: "Background", "Architecture", "Results", "Conclusion".
- Prefer:
  - "Why pre-aggregating metrics broke every production incident"
  - "The event-driven pipeline we shipped instead"
  - "Where this approach breaks down at extreme scale"

If a heading could appear in any generic blog post, rewrite it until it’s specific.

## 10. Technical Quality and Depth

**Numbers beat adjectives.**
- Don’t write: "This significantly improved performance."
- Do write: "This cut p99 latency from 340 ms to 45 ms (7.5× faster) under a 4× higher load."

**Code standards:**
- All code must be runnable (no missing imports, config, or undefined variables).
- Include minimal setup context (env, framework, version, assumptions).
- Use comments to explain **why**, not **what**.
- Prefer language and stack choices that align with Lightrains’s actual work (AI agents, blockchain, Node.js, infra).

**Systems and diagrams:**
- If more than two components interact, include a diagram or a clear description of one.
- Use real service names and data flows, not generic “Service A/B/C”.
- Call out trust boundaries, data stores, and failure points.

**Honesty over hype:**
- If something is beta or has constraints, say so explicitly.
- Acknowledge where competitors do something well; explain how Lightrains differs.
- Never exaggerate AI capability. Example: say “suggests likely root causes based on patterns” instead of “finds the root cause automatically.”

## 11. Titles That Earn the Click

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

## 12. SEO: Keywords, Meta, Internal Linking, and Service Pages

### Keyword Strategy

Before drafting, the agent must:
1. **Identify a primary keyword** (one per post): the specific term your target reader would search for.
2. **Identify 2–3 secondary keywords**: closely related terms that support the primary keyword.
3. **Keyword placement rules:**
   - Primary keyword must appear in: title, first 150 words, at least one `##` heading, and the `excerpt` frontmatter field.
   - Secondary keywords distributed naturally across subheadings and body. Never force them.
4. **No keyword stuffing.** Reader clarity always wins over search density.

### Meta Optimization

Every post must optimize these fields:
- **Title tag** (`title` frontmatter): 50–60 characters. Lead with the primary keyword when possible.
- **Excerpt** (`excerpt` frontmatter): 15–25 words. Include primary keyword once.
- **Subtitle** (`subtitle` frontmatter): 25–50 words. Expand on the excerpt, include a secondary keyword if natural.
- **URL slug** (from filename): kebab-case, include primary keyword, no stop words, no dates. Keep under 5 segments.

### Internal Linking and Service Pages

Before writing or editing any blog post:

1. **Map internal targets:** pick 2–4 pillar pages, 1–2 related blog posts from `llms.txt`.
2. **Insert contextual internal links** using descriptive anchor text.
   - At least **2 links to pillar pages** (services, offerings, features) per post.
   - At least **1 cross-link to a related blog post** using `llms.txt`.
3. **Link to Lightrains service offering pages** from relevant body text to enhance SEO and conversion. Use natural anchors. Service pages:
   - Technology Consulting: https://lightrains.com/consulting
   - AI, ML & CV Development: https://lightrains.com/consulting/ai-ml-cv-development/
   - Blockchain Consulting / Blockchain Development: https://lightrains.com/consulting/blockchain-development/
   - Smart Contract Development / Solidity: https://lightrains.com/consulting/smart-contract-solidity/
   - Metaverse & Web3: https://lightrains.com/consulting/metaverse-web3/
   - React.js Consulting & Development: https://lightrains.com/consulting/react-js-consulting-development-services/
   - Product Development: https://lightrains.com/consulting/product-development/
   - NFT Marketplace Development: https://lightrains.com/consulting/nft-marketplace-development/

  4. **Links discovery:** Fetch `https://lightrains.com/llms.txt` to find URLs of existing Lightrains blog posts and relevant external resources. Insert them as `[source title](URL)` where they add context or supporting evidence. Do not list bare URLs.

## 13. Closings That Create Motion

Close with one or more of:
- A specific way to try the idea: repo, docs, example config, sandbox.
- A direct invitation: "If you’re dealing with [problem], talk to us. We’ve done this before."
- A forward-looking note that opens a loop: what you want to explore next, or what you’ll share in a follow-up post.

**End each post with a subtle call to action** inviting readers to contact Lightrains for further discussion or projects. Do not end with generic hype.

## 14. Lightrains Content Map (Top 5 Post Types)

| Type | Goal | Must Include | Example Topics | Typical Byline |
| ---- | ---- | ------------ | -------------- | -------------- |
| Engineering Deep Dive | Prove technical authority in AI, blockchain, scalable infra | Architecture, trade-offs, decisions, metrics, diagrams | "Designing AI Agents for Enterprise Workflows" | Senior Engineer / Architect |
| Case Study / Build Log | Convert credibility into trust and leads | Client context, problem → solution → measurable impact (ROI, latency, cost) | "How We Built a Blockchain-Based Supply Chain for a Tier-1 Manufacturer" | Eng + PM / Solutions Lead |
| Founder / Leadership POV | Position Lightrains as a strategic technology partner | Clear thesis, market shifts, decision frameworks, risks, timing | "When Enterprises Should Bet on AI Agents (and When They Shouldn’t)" | Founder / Leadership |
| Solution / Use Case Story | Map services to business problems and buying triggers | Industry pain points, our approach, implementation model, outcomes | "AI in Manufacturing: Reducing Defects with Computer Vision and Edge AI" | Marketing + Solutions Engineering |
| Technical GTM / How-To | Attract developers and enable bottom-up adoption | Step-by-step guide, realistic constraints, sample code, integration patterns | "Build an AI Support Agent on the Lightrains Stack in a Weekend" | DevEx + Marketing / Developer Advocate |

## 15. The "Would I Share This?" Test

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

## 16. Non-Negotiables (Checklist)

The agent must enforce these rules every time:
1. **Real byline**: Use a real person's name and role, or reuse an author key from `src/data/authors.json` such as `agent`.
2. **Working code only**: No pseudo-code masquerading as production unless clearly labeled.
3. **No banned phrases**: No "we're excited to announce", "seamless", "empower", etc.
4. **Systems diagram**: Any multi-component system has a diagram or a clear description.
5. **Performance claims with numbers**: Always include baseline and after numbers, and conditions.
6. **Decisions and alternatives**: If you mention a decision, mention at least one alternative and why it lost.
7. **Audience clarity**: The author should be able to answer "Who is this for?" in one sentence.
8. **No changelog disguised as a blog**: Release notes and small tweaks go to changelog, not here.
9. **Err on the side of depth**: Too detailed is safer than too shallow.
10. **Write the post you wish existed** when you first tackled this problem.
11. **File format verified**: Correct frontmatter structure, kebab-case filename, saved to `/src/pages/blogs/`.
12. **No em-dashes**: Check entire post (including frontmatter) for em-dashes (--). Replace.
13. **Primary keyword placed**: Title, first 150 words, one ## heading, and excerpt all contain primary keyword.
14. **Internal links present**: At least 2 links to pillar pages and 1 cross-link to a related blog post.
15. **URL slug is clean**: Kebab-case filename with primary keyword, no dates, no stop words, under 5 segments.
16. **No contradicting statements**: Scan for mismatched claims. Flag and resolve.
17. **Intro paragraph included**: One opening paragraph before section headings.
18. **Paragraph mechanics**: Each paragraph 7–10 sentences. No more than 2 reference links per paragraph.
19. **Research within 90 days**: Use recent credible sources; cite inline as `[Title](URL)`. No bare URLs or citation artifacts.
20. **Service page links**: Include at least one in-content link to a Lightrains service page from the approved list.
21. **Output archive**: After generating `.md` files, bundle them into a `.zip` archive and provide it.

## 17. Originality, Repo References, and Author/Meta Hygiene

Lightrains posts should read like original technical writing, not lightly paraphrased external summaries. When adapting research or third-party commentary:
- Do not include repo links, package names, or source-specific author artifacts unless explicitly requested.
- Rephrase the mechanism, experiment, or framing as a general Lightrains post. Keep the insight; drop the source-specific provenance.
- Frontmatter `author` must use a key that exists in `src/data/authors.json`. If the desired author is missing, either reuse an existing key such as `agent` or add the new author to `authors.json` first. Unregistered guest names will cause a runtime author-rendering failure.
- `meta` should be a generic image filename that matches assets in the repo. Do not carry over external-source asset names unless the file exists locally.

## 18. Review and Editing Workflow

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

## 19. How the Agent Should Respond

When using this skill, the agent should:
1. Fetch `https://lightrains.com/llms.txt` and identify the three most relevant topics aligned to Lightrains’ expertise from the indexed pages.
2. Search for recent credible sources within the past 90 days.
3. Suggest a **working title** and a short outline aligned to the structure above for each topic.
4. Draft or revise content in the Lightrains voice, enforcing all non-negotiables.
5. Propose at least:
   - One diagram description.
   - One set of concrete metrics or outcomes.
6. Provide a short "Author notes" section (for internal use only) explaining audience, core takeaway, and content map type.
7. Save each `.md` to `src/pages/blogs/` with the specified frontmatter and filename rules, then create a ZIP archive of all generated files and provide it.
8. Not use overused terms like: "delve", "landscape", "crucial", "leverage" (when "use" works), "furthermore", "navigate" (metaphorical), "robust", "comprehensive", "holistic", "foster", "facilitate", "ensure", "at its core".
9. Ensure every inline citation is in the form `[source title](URL)`. Strip any artifacts that resemble `【...†...】`.

## 20. Frontmatter and Markdown Formatting

### Frontmatter

Every post must use this exact frontmatter structure (from `src/pages/blogs/`):

```markdown
---
layout: '../../layouts/BlogLayout.astro'
title: 'Blog Title Here SEO optimized'
heroText: 'short, punchy, headline-style (30–55 chars)'
date: 'YYYY-MM-DD HH:MM:SS +0530'
meta: 'filename.jpg'
author: 'agent' # or real person's name
excerpt: 'One-sentence summary for SEO and previews'
subtitle: 'Longer summary (can be 1-2 sentences) describing what readers will learn'
tags: ['Tag1', 'Tag2', 'Tag3']
faqItems: []
---
```

**Frontmatter rules:**
- layout: Always `../../layouts/BlogLayout.astro`
- title: Use the working title, in double quotes
- date: Current date/time in IST (`YYYY-MM-DD HH:MM:SS +0530`) — set within the **current week from the past** (e.g., if today is Oct 20 2025, use a date in Oct 13–19 2025).
- meta: Image filename without path, must match `.jpg` in images folder
- author: Use `agent` or a real name if available
- excerpt: 15–25 words, describes value proposition
- subtitle: 25–50 words, more descriptive, can match excerpt or expand
- tags: 2–4 tags, capitalize first letter of each
- faqItems: leave as `[]` unless explicitly requested; when requested, use:

```yaml
faqItems:
  - q: 'What is the main benefit of X?'
    a: 'Short, direct answer in the Lightrains voice (2-4 sentences max). No fluff.'
```

**Markdown formatting:**
- Use `##` for all section headings (no `# H1`, it comes from title)
- Use `###` for subsections
- Use `**bold**` for emphasis, not `_italics_`
- Use `>` blockquote for callouts and highlights
- Use fenced code blocks with language identifier: `javascript`, `bash`, etc.
- Use ASCII diagrams or mermaid for system architecture
- Include author notes at the end (for internal use only)
