---
name: lp-implementation-builder
description: Implement the approved landing page in code, reusing the project's stack, components, and design system.
metadata:
  author: github.com/niksmac
---

# lp-implementation-builder

Run only after the user explicitly approves the plan.

## Responsibilities

- Create or update the landing page route / file.
- Implement sections in the approved order, using the Component & Theme Plan.
- Reuse existing components and tokens instead of inventing new ones.
- Add basic SEO:
  - title
  - meta description
  - Open Graph tags
  - single h1 and logical heading hierarchy
- Wire analytics events if a tracking library already exists.
- Keep performance in scope (image loading, JS deferral, etc.).

## Ask before

- Installing new dependencies.
- Changing global layouts, nav, or config.
- Adding new environment variables.

## Output

```md
## Implementation Summary

- Files created:
  - path – what it does
- Files modified:
  - path – summary of changes
- Notes:
  - any follow‑ups or manual steps
```
