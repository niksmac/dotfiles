# Landing Page Architect Skills

Anthropic-style Agent Skills for planning, designing, and implementing high‑converting landing pages (and homepage‑like entry pages).

The bundle is designed as a **composable skill family**:

- `landing-page-architect` – parent orchestrator
- `lp-intent-mapper` – clarify goal, audience, offer, and objections
- `lp-project-auditor` – read‑only scan of repo + design system
- `lp-structure-planner` – choose page type & section order
- `lp-copy-wireframer` – per‑section copy + layout outline
- `lp-visual-theming` – map sections to components and tokens
- `lp-implementation-builder` – implement the page in code
- `lp-review-optimizer` – UX/CRO review
- `lp-ux-a11y-audit` – accessibility review

## Structure

```text
skills/
  landing-page-architect/
    SKILL.md
  lp-intent-mapper/
    SKILL.md
  lp-project-auditor/
    SKILL.md
  lp-structure-planner/
    SKILL.md
  lp-copy-wireframer/
    SKILL.md
  lp-visual-theming/
    SKILL.md
  lp-implementation-builder/
    SKILL.md
  lp-review-optimizer/
    SKILL.md
  lp-ux-a11y-audit/
    SKILL.md
```

Each `SKILL.md` follows the Anthropic pattern: frontmatter (`name`, `description`) plus markdown instructions, examples, and delegation rules.[web:46][web:43]

## Usage

1. Install this repo (or copy individual skills) into your Claude Skills setup.
2. Load **`landing-page-architect`** in your agent.
3. Let it:
   - interview you (`lp-intent-mapper`),
   - read your project (`lp-project-auditor`),
   - plan sections (`lp-structure-planner`),
   - outline copy/wireframe (`lp-copy-wireframer`),
   - then, after you approve the plan, implement and review the page.

You can also call sub‑skills directly if you only need a brief, a structure plan, or a UX/a11y review.

## Design principles

These skills are opinionated around:

- **Single primary CTA** with minimal distractions.
- **Message match** between traffic source and hero.
- **Trust & objection handling** (social proof, FAQs, guarantees).
- **Accessibility and performance** as non‑negotiables (contrast, semantics, lazy‑loading, etc.).[web:32][web:24]
