---
name: lp-project-auditor
description: Read the current project to identify the tech stack, design system, reusable UI patterns, and constraints before planning a landing page.
---

# lp-project-auditor

Operate strictly in read-only mode.

## Discover

- **Framework & routing** – e.g., Next.js App Router, Astro pages, Rails views, etc.
- **CSS & design tokens** – Tailwind, CSS variables, SCSS, design system files.
- **Layouts & shells** – main layout components, nav, footer, page templates.
- **Reusable components** – hero, CTA, forms, testimonials, logos strip, pricing, FAQ, card grids.
- **Constraints** – auth wrappers, SSR/ISR rules, i18n, performance budgets, files not to touch.

## Output

Return:

```md
## Project Audit

### Tech summary

- …

### Design summary

- …

### Reusable components

- component path – short description
- …

### Constraints

- …
```

Do not modify any files.
