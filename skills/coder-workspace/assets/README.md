# `_coder` folder rules

Task folder for developers: issues, plans, docs, reports, specs, benchmarks. Not part of the codebase and not source truth (code wins). Read only when explicitly asked or permitted. Browse via [INDEX.md](INDEX.md).

## 1. Layout

| Folder | Type | Holds |
|---|---|---|
| `issues/` | `issue` | A problem or feature request: what is wrong, evidence, acceptance. |
| `plans/` | `plan` | How to implement something: steps, phases, verification. |
| `docs/` | `doc` | Reference or implementation notes that stay useful after the work ships. |
| `reports/` | `report` | Point-in-time findings: audits, investigations, verification results. |
| `specs/` | `spec` | External or product specs; explicit-only, load only when named. |
| `benchmarks/` | `benchmark` | A reproducible benchmark, one folder per benchmark: `NNN_benchmark_<slug>/report.md` (frontmatter, findings) plus its data files (inputs, ground truth, captured results). Harness code stays in `tool/eval/`. |
| `logs/` | — | Diagnostics and eval output. Gitignored; never indexed or renamed. |

Only `README.md`, `INDEX.md`, `index.mjs` and these folders live in the `_coder/` root. Empty folders hold a `.gitkeep`.

## 2. File names

- Pattern: `<folder>/NNN_<type>_<slug>.md`, e.g. `issues/017_issue_tts-stutter-on-resume.md`. Benchmarks are folders: `benchmarks/NNN_benchmark_<slug>/report.md`.
- `NNN`: three digits, incremental per folder, never reused or renumbered. Get it with `node _coder/index.mjs next <type>`.
- `<type>` matches the folder: `issue|plan|doc|report|spec|benchmark`.
- `<slug>`: lowercase, hyphen-separated, short and descriptive. No spaces or underscores.
- Never rename after creation. A plan that answers an issue gets its own number in `plans/` and links the issue.

## 3. Frontmatter (required)

```yaml
---
title: Short title (quote it if it contains ": ")
description: Optional, 2 sentences max.
status: open
createdDate: 2026-10-18
modifiedDate: 2026-10-18
---
```

- `status`: `open | wip | closed | abandoned`.
- Bump `modifiedDate` on every substantive edit. Extra keys (e.g. `scope`) are allowed.

## 4. Content

- One purpose per file; don't mix issue, plan and report content.
- No duplicates: update the existing file instead of creating a new one.
- Link other `_coder` files by relative path (`../plans/017_plan_x.md`); from code comments use the full path (`_coder/plans/017_plan_x.md`).
- Closed work stays in place with `status: closed`; don't delete or move it.

## 5. Index

`INDEX.md` is generated; never edit it by hand. After adding, renaming or changing frontmatter of any file, run:

```sh
node _coder/index.mjs
```

It rebuilds `INDEX.md` and exits non-zero listing any naming, numbering, frontmatter or stray-file problems. Fix them, rerun, and commit the index with the change.
