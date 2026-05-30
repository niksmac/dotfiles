---
name: lp-ux-a11y-audit
description: Run a lightweight accessibility audit on the landing page and identify semantic, contrast, keyboard, and form issues.
metadata:
  author: github.com/niksmac
---

# lp-ux-a11y-audit

Check the page against basic WCAG‑aligned heuristics.

## Audit

- Semantic structure:
  - One h1, logical h2/h3 hierarchy
  - Landmarks: header, main, footer, nav
  - Skip‑to‑content link
- Contrast:
  - Body and CTA text meet AA contrast
  - Muted text still legible
- Images:
  - Meaningful images have descriptive alt
  - Decorative images use empty alt
- Forms:
  - Every field has a label
  - Errors are announced clearly and tied to the field
- Keyboard:
  - All controls reachable via keyboard
  - Visible focus states
  - Modals / drawers trap focus and close with Escape
- Motion:
  - Respects prefers‑reduced‑motion

## Output

```md
## Accessibility Review

### Passes

- …

### Issues

- …

### Fixes

- …
```
