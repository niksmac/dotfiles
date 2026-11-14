---
name: coder-workspace
description: Manage a repo's `_coder/` task folder of numbered markdown issues, plans, docs, reports, specs and benchmarks with frontmatter and a generated INDEX.md. Use when asked to set up or add `_coder` to a project, to file, write, update or close an issue, plan, doc, report, spec or benchmark, to track work in a plan, or to list what is open in `_coder`.
---

# `_coder` task folder

A per-repo folder of developer task files: `issues/ plans/ docs/ reports/ specs/ benchmarks/`, each file `NNN_<type>_<slug>.md` with frontmatter, plus a generated `INDEX.md`. This skill carries the rules of the stock `_coder/README.md`. Before writing, run `cmp -s _coder/README.md <this skill's directory>/assets/README.md`; only if it differs, read the repo's copy, which wins where they differ.

## Set up in a repo

Run `scripts/init.sh <repo-root>` (this skill's directory). It:

- creates `_coder/` with `README.md` and `index.mjs` from `assets/`, plus the six type folders (`.gitkeep` while empty);
- adds `_coder/logs/` to `.gitignore` (diagnostics and eval output, never indexed);
- appends `assets/agents-snippet.md` to `AGENTS.md` (creates it if missing) unless it already has the snippet's heading;
- builds `INDEX.md`.

It never overwrites existing files. If it notes that `CLAUDE.md` is missing or does not reference `AGENTS.md`, add a line `@AGENTS.md` to `CLAUDE.md` (create it if needed); the import loads the file, so the agent always sees the section. If it notes older `_coder/` mentions in `AGENTS.md`, remove the rules there that conflict with the new section. Adapt the snippet's wording to the repo's AGENTS.md style if it differs. Commit the result only when the user asks.

## Add a file

1. Pick the type by purpose: problem or request -> `issue`; how to build it -> `plan`; lasting reference -> `doc`; point-in-time findings -> `report`; external or product spec -> `spec`; reproducible benchmark -> `benchmark` (a folder `NNN_benchmark_<slug>/report.md` plus data; harness code stays in the codebase).
2. Look for an existing file on the topic with `node _coder/index.mjs find <word>…` (every word must match name, title or description; try a few key terms) instead of reading `INDEX.md`; update a match instead of duplicating.
3. Number: `node _coder/index.mjs next <type>`.
4. Write `<folder>/NNN_<type>_<slug>.md` (slug lowercase-hyphen) starting with:

   ```yaml
   ---
   title: Short title (quote it if it contains ": ")
   description: Optional, 2 sentences max.
   status: open
   createdDate: YYYY-MM-DD
   modifiedDate: YYYY-MM-DD
   ---
   ```

   `status`: `open | wip | closed | abandoned`. Use today's date.
5. Link related files by relative path (`../issues/012_issue_x.md`); from code comments use `_coder/plans/012_plan_x.md`. A plan answering an issue gets its own number in `plans/` and links the issue. Data a file needs (images, CSVs) goes in a folder of the same name beside it: `plans/012_plan_x/` next to `plans/012_plan_x.md`.
6. Run `node _coder/index.mjs`; fix every problem it lists and rerun until clean. When committing, include `INDEX.md` in the same commit.

## Find what is open

`node _coder/index.mjs open` lists open and wip files with path and title. Use it rather than reading `INDEX.md`, which grows large.

## Plans while working

When work is tracked in a plan: write it before the first code edit with `status: wip`; after each step or commit record decisions, measured results, commit hashes and what is still open; set `status: closed` (or `abandoned`, with the reason) when done. Bump `modifiedDate` on every substantive edit and rerun the index.

## Rules

- Never rename or renumber a file; numbers are never reused.
- Never hand-edit `INDEX.md`.
- Closed work stays in place with its status; never delete or move it.
- One purpose per file: don't mix issue, plan and report content.
- Only `README.md`, `INDEX.md`, `index.mjs`, the type folders and `logs/` live in `_coder/`'s root.
- `_coder` is not source truth: code wins. Read existing files only when the user asks or the task names them.
