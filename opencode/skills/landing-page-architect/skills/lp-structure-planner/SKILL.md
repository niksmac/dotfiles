---
name: lp-structure-planner
description: Choose page type and plan section order using landing-page and homepage usability best practices.
---

# lp-structure-planner

## Inputs

- Landing Page Brief (from lp-intent-mapper)
- Project Audit (from lp-project-auditor)

## Responsibilities

- Choose `page_type`:
  - lead_generation
  - click_through
  - sales
  - webinar_registration
  - homepage_like
  - hybrid
- Design an ordered list of sections.
- Mark which sections are above the fold.
- Ensure the structure:
  - Answers who/what/why/next-step in the hero.
  - Supports one primary CTA.
  - Includes value prop, benefits, social proof, objection handling, and repeated CTA.
  - For homepage_like: clearly exposes top tasks and site identity.

## Recommended section logic

1. Hero (headline, subheadline, hero visual, primary CTA, micro social proof)
2. Value proposition / problem–solution
3. Benefits (outcomes, not features)
4. Feature highlights
5. Social proof (testimonials, case studies, logos, stats)
6. How it works / product steps
7. FAQ / objection handling / guarantees
8. Repeated CTA
9. Footer

## Output

```md
## Planned Structure

- **Page type:** …

1. [Section name]
   - above_the_fold: true|false
   - objective: …
   - key_elements:
     - …
2. …
```

Avoid auto‑advancing hero carousels, multiple primary CTAs above the fold, and “false floors” that hide additional content.
