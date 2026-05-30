---
name: landing-page-architect
description: Orchestrate a family of landing-page skills to plan, design, and implement high-converting pages with an explicit approval gate before code changes.
---

# Landing Page Architect

Use this as the **entry point** when a user wants help with any landing page or homepage-like entry page. Your job is to:

1. interview the user,
2. understand the existing project,
3. design a page strategy,
4. get explicit approval,
5. implement the page,
6. review UX and accessibility,

by delegating work to subskills instead of doing everything yourself.

Subskills you coordinate:

- `lp-intent-mapper`
- `lp-project-auditor`
- `lp-structure-planner`
- `lp-copy-wireframer`
- `lp-visual-theming`
- `lp-implementation-builder`
- `lp-review-optimizer`
- `lp-ux-a11y-audit`

---

## When to use this skill

Use `landing-page-architect` whenever:

- A user asks to create or redesign a landing page for a product, feature, campaign, or event.
- A user wants to tune an existing landing page for conversions, but you’re allowed to edit code.
- A user wants to turn a generic homepage into something more focused and goal‑driven.

Do **not** use this skill when:

- The user only wants copy tweaks for a single section → you can answer directly or call `lp-copy-wireframer` alone.
- The user wants general UX advice, not implementation → consider `lp-review-optimizer` without the build step.

---

## Overall workflow and delegation

Always follow this high‑level sequence:

1. **Intent → `lp-intent-mapper`**
2. **Project context → `lp-project-auditor`**
3. **Structure → `lp-structure-planner`**
4. **Wireframe & copy outline → `lp-copy-wireframer`**
5. **Approval gate (no code yet)**
6. **Visual theming → `lp-visual-theming`**
7. **Implementation → `lp-implementation-builder`**
8. **UX/CRO review → `lp-review-optimizer`**
9. **Accessibility review → `lp-ux-a11y-audit`**

You may loop through steps 3–5 multiple times if the user wants to adjust the plan.

---

## Step 1 – Map intent (delegate to `lp-intent-mapper`)

**When to call**: Immediately after the user asks for a landing page, unless a complete brief is already present.

**What to do**:

- Load `lp-intent-mapper`.
- Let it question the user and produce a `Landing Page Brief` containing:
  - primary goal
  - page role (campaign_landing / product_landing / homepage_like)
  - target audience
  - main offer
  - traffic sources + message match notes
  - success metric
  - key objections
  - homepage tagline and top tasks (if homepage_like)

**Your responsibility**: Once the brief is confirmed by the user, summarise it in your own words before moving on, so later steps can reference it unambiguously.

**Example prompt to user**:

> “I’ll start by clarifying what this page should accomplish and who it’s for, then I’ll propose structure and sections. First, let’s map your goals.”

---

## Step 2 – Audit the project (delegate to `lp-project-auditor`)

**When to call**: Once intent is clear and you’re connected to a codebase or project.

**What to do**:

- Load `lp-project-auditor` to scan:
  - framework & routing,
  - CSS/system & design tokens,
  - reusable components (hero, CTA, testimonials, pricing, FAQ, etc.),
  - constraints (auth wrappers, layout requirements, performance budgets).

**Your responsibility**: Note anything that strongly influences structure, e.g.:

- “We already have a `HeroSection` and `TestimonialCarousel` we should reuse.”
- “Global nav is heavy; we may want to hide it on pure campaign pages.”

---

## Step 3 – Plan structure (delegate to `lp-structure-planner`)

**When to call**: After you have both the intent brief and the project audit.

**What to do**:

- Load `lp-structure-planner` with:
  - the Landing Page Brief, and
  - the Project Audit summary.
- Ask it to return:
  - `page_type`,
  - ordered sections,
  - above‑the‑fold flags,
  - per‑section objectives and key elements.

**Your responsibility**: Check the structure against the goal:

- For lead_gen: simple hero + benefit + social proof + short form + FAQ.
- For sales: longer story with more benefits, objections, and guarantees.
- For homepage_like: add identity, top tasks, and stronger navigation.

If the structure feels mismatched, you can call the planner again with hints like:

> “Prioritise a very short page; user wants a simple email capture.”

---

## Step 4 – Wireframe & copy outline (delegate to `lp-copy-wireframer`)

**When to call**: After the structure looks reasonable.

**What to do**:

- Load `lp-copy-wireframer` with:
  - section list,
  - brief (including objections and traffic messages).
- Ask it to produce:
  - layout pattern for each section,
  - headline/subheadline directions,
  - benefits bullets,
  - visual placement,
  - form specs and microcopy notes.

**Your responsibility**: Make sure each section has a clear job, and the flow from top to bottom reads like a story, not a pile of blocks.

---

## Step 5 – Present plan and get approval (you do this yourself)

This is the **mandatory approval gate**. Do not delegate.

Present the plan to the user in exactly this structure:

```md
## Intent

- …

## Rationale

- Why this page type and structure fit the goal and traffic.

## Plan summary

- 4–6 bullets describing the experience from top to bottom.

## Detailed Page Structure

1. Section name
   - above_the_fold: true|false
   - objective: …
   - key elements: …
2. …
```

Then say something like:

> “Please review this plan. Reply ‘approved’ to move on to implementation, or tell me what you’d like changed (sections to add/remove/reorder, more or fewer details, etc.).”

If the user requests changes:

- call `lp-structure-planner` and/or `lp-copy-wireframer` again as needed,
- update the plan, and
- repeat the approval step.

Only proceed when the user explicitly approves.

---

## Step 6 – Visual theming (delegate to `lp-visual-theming`)

**When to call**: After user approval of the structure and outline.

**What to do**:

- Load `lp-visual-theming` with:
  - Project Audit,
  - Planned Structure,
  - Wireframe & copy outline.
- Ask it to produce a **Component & Theme Plan** mapping each section to:
  - existing components (with paths),
  - any new lightweight components,
  - design tokens and variants,
  - responsive behavior rules.

Use this plan as the blueprint for code changes in the next step.

---

## Step 7 – Implement (delegate to `lp-implementation-builder`)

**When to call**: Only after user approval and after theming is done.

**What to do**:

- Make clear you are now switching to implementation.
- Load `lp-implementation-builder` with:
  - Component & Theme Plan,
  - structure and wireframe.

Ensure it:

- respects project conventions,
- reuses existing components,
- adds SEO/analytics as appropriate,
- asks before installing new packages or touching global layouts.

After it reports an Implementation Summary, offer to show or diff the key files, if the environment allows.

---

## Step 8 – Review (delegate to `lp-review-optimizer` and `lp-ux-a11y-audit`)

**When to call**: After implementation.

**What to do**:

- Load `lp-review-optimizer` for UX & CRO.
- Load `lp-ux-a11y-audit` for accessibility.

Summarise back to the user:

- strengths,
- issues,
- top improvement suggestions,
- any critical accessibility fixes.

Offer to apply specific fixes if the user wants another iteration.

---

## Example usage patterns

### Example 1 – New SaaS trial landing page

- User: “I need a landing page to drive free-trial signups for my B2B SaaS.”
- You: run full workflow, ending with a `/trial` route using existing SaaS layout; short form; strong social proof and FAQ tied to B2B concerns like security and onboarding.

### Example 2 – Audit and refine existing homepage

- User: “Our homepage gets traffic but doesn’t convert; we’re okay changing copy and layout.”
- You: still call `lp-intent-mapper` and `lp-project-auditor`, but skip `lp-implementation-builder` initially and run `lp-review-optimizer` + `lp-ux-a11y-audit` first to produce a prioritized change list, then implement only the agreed changes.

---

## Style and constraints

- Prefer **clarity over cleverness** in copy and structure.
- Preserve **message match** with traffic sources.
- Always keep **one clearly dominant primary CTA**.
- Treat **accessibility and performance** as non‑optional; if implementation conflicts with them, call that out and suggest alternatives.
