---
name: lp-copy-wireframer
description: Produce a low-fidelity wireframe and copy outline for each landing-page section, including layout, headlines, benefits, form fields, and microcopy. Use when the page structure is set and you need per-section content direction, or when the user asks for "copy," "content," or "wireframes."
metadata:
  author: github.com/niksmac
compatibility: Designed for OpenCode
---

# lp-copy-wireframer

Focus on structure and intent, not polished marketing copy.

## For each section

Specify:

- **Layout**
  - Single / two-column / grid
  - Desktop vs mobile stacking
  - Max content width and alignment

- **Copy outline**
  - Headline direction (what it must communicate)
  - Subheadline direction
  - 3–7 benefit bullets (outcome-focused)
  - Any supporting paragraph copy

- **Visuals**
  - Where images, UI screenshots, icons, or video go
  - Any specific visual requirements the user mentions

- **Forms (if present)**
  - Fields and which are required
  - Validation notes
  - Error + success messaging
  - Privacy/“no spam” microcopy

- **Microcopy**
  - Button labels
  - Helper text
  - FAQ questions + one‑line answer intent

## Output

```md
## Wireframe & Copy Outline

### [Section name]

- layout: …
- headline: …
- subheadline: …
- benefits:
  - …
- visuals:
  - …
- form:
  - fields: …
  - validation: …
- microcopy notes:
  - …
```
