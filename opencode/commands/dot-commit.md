---
description: Write a commit message following the project's commit conventions
model: opencode/big-pickle
subtask: true
---

Here are the commit rules:

!`cat ~/.dotfiles/git/README.md`

Here are the valid imperative verbs:

!`cat ~/.dotfiles/git/imperative_verbs.txt`

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