---
description: Write a commit message following the project's commit conventions
model: opencode/big-pickle
subtask: true
---

Here are the commit rules:

!`cat ~/.dotfiles/git/README.md`

**Enforce these rules strictly:**

1. **Capitalization**: The first word after the type prefix **must** be capitalized. `feat: Add...` ✅ — `feat: add...` ❌
2. **Valid types only**: Only use: feat, fix, docs, style, refactor, perf, test, chore, build, ci, revert. Never "feature", "Feature", or any other variant.
3. **Type lowercase**: The type must be all lowercase followed by `: `.
4. **Valid imperative verb**: The first word after the type (or first word of subject for non-Conventional Commits) must be one of: Add, Allow, Bump, Build, Change, Clean, Configure, Create, Decrease, Delete, Deploy, Deprecate, Disable, Document, Enable, Enhance, Ensure, Extract, Fix, Format, Implement, Improve, Include, Increase, Inject, Integrate, Introduce, Make, Manage, Merge, Migrate, Modify, Move, Optimize, Perform, Prevent, Provide, Refactor, Refresh, Release, Remove, Rename, Render, Reorder, Replace, Resolve, Restructure, Revert, Revise, Separate, Set, Setup, Simplify, Split, Start, Stop, Support, Test, Trim, Update, Upgrade, Use, Verify.

Generate a commit message for the staged changes below following those rules.

Stage all changes:
!`git add -A`

Current staged changes:
!`git diff --cached`

Check the staged diff for hardcoded secret values — actual credentials, not variable names. Look for patterns like:
- `sk-[A-Za-z0-9\-_]{10,}` (OpenAI/LLM API keys)
- `gh[pousr]_[A-Za-z0-9]{10,}` (GitHub tokens)
- `AKIA[A-Z0-9]{16}` (AWS access keys)
- `xox[bpras]-[A-Za-z0-9\-]{10,}` (Slack tokens)
- `-----BEGIN (RSA |EC )?PRIVATE KEY-----`
- Literal URLs containing passwords (`://[^:]+:[^@]+@`)
- Strings like `"password": "plaintext"` or `PASSWORD=plaintext` where the value after `=` or `":"` looks like a plaintext credential (not a reference or env var)

Only flag if the value side of an assignment (after `=`, `:`, `=>`) looks like a real secret — ignore variable names like `API_KEY`, `SECRET`, `TOKEN` on their own.

Count the number of files changed. If **more than 3 files** are modified, a **body is required** (not optional).

Once generated and verified safe, commit with `git-commit "$subject" "$body"` (omit body if not needed).

Stop on failure.