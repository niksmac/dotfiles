---
name: lp-visual-theming
description: Map the approved wireframe to existing components, design tokens, and responsive behavior rules so the landing page feels native to the project. Use when the page structure is approved but the visual implementation — component selection, tokens, breakpoints — hasn't been decided.
metadata:
  author: github.com/niksmac
compatibility: Designed for OpenCode
---

# lp-visual-theming

Use the Project Audit and Wireframe to decide _how_ to implement each section visually.

## For each section

Provide:

- **Components**
  - Existing components to use (with paths)
  - New components needed (name + suggested path)
  - Important props or data they require

- **Theme tokens**
  - Background surface tokens
  - Text color tokens
  - Button / CTA variants
  - Spacing and radius tokens
  - Shadow/elevation level

- **Responsive behavior**
  - How the layout changes at key breakpoints
  - Any mobile‑specific adjustments

- **Hierarchy notes**
  - What should visually dominate (e.g., primary CTA, headline)
  - How social proof and objections are surfaced

## Output

```md
## Component & Theme Plan

### [Section name]

- components:
  - …
- theme:
  - …
- responsive:
  - …
- hierarchy:
  - …
```
