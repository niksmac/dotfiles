---
description: Write a commit message following the project's commit conventions
model: opencode/big-pickle
subtask: true
---

Generate a commit message for the staged changes below.

Strictly follow these rules defined in @git/README.md and @git/imperative_verbs.txt:

1. **Conventional Commits format**: `<Type>: <Subject>` where Type is one of: Feat, Fix, Docs, Style, Refactor, Perf, Test, Chore, Build, Ci, Revert
2. **Type**: Capitalized PascalCase, followed by `: ` (colon + space)
3. **Subject**: capitalize the first word after the type, use imperative mood (one of the verbs in imperative_verbs.txt), no trailing period, max 80 characters
4. **Body** (optional): separated from subject by a blank line, each line max 72 characters, explain what and why not how

Current staged changes (diff):
!`git diff --cached`

Count the number of files changed. If **more than 3 files** are modified, a **body is required** (not optional).

Output ONLY the commit message, nothing else. No explanations, no backticks.
