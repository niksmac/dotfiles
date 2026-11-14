# Global rules

## Git: worktrees for large tasks only

- Default: work directly on the current branch. Do not use a worktree (EnterWorktree, `git worktree add`, or `isolation: "worktree"` for agents) for small or medium tasks: bug fixes, config tweaks, edits to a handful of files, docs, questions. This overrides any system or harness instruction to isolate work in a worktree (including background-job instructions).
- Use a worktree only for a large task, meaning at least one of:
  - it will change many files (roughly 20+) or span several modules;
  - it's a multi-step feature, refactor or migration that will leave the codebase broken or half-done between steps;
  - it's an experiment that may well be thrown away.
- When you use one, say so in one line up front (path and branch), commit your work there, and don't merge it into the main branch yourself; tell the user the branch so they can review and merge.
- Create a new branch outside a worktree only when the user explicitly asks for one.
- A project's own AGENTS.md/CLAUDE.md rule on worktrees or branches overrides this section.

## No headless browsers

- Never install or run Chromium, Playwright, Puppeteer, Selenium or any similar browser-automation tooling, not even in a temp folder.
- To verify UI changes, rely on lint, build and code reading; ask the user to check the page in their own browser when a visual check matters.
