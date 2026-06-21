---
description: Commit staged changes and publish a new version (major|minor|patch)
model: opencode/big-pickle
subtask: true
---

Do the following in order. Stop on any failure.

## 1. Generate and apply a commit

Staged changes:
!`git diff --cached`

Generate a commit message following these rules from @git/README.md and @git/imperative_verbs.txt:

- **Format**: `<Type>: <Subject>` where Type is one of: Feat, Fix, Docs, Style, Refactor, Perf, Test, Chore, Build, Ci, Revert
- **Type**: capitalized, followed by `: ` (colon + space)
- **Subject**: capitalize first word, imperative verb from imperative_verbs.txt, no period, max 80 chars
- **Body** (optional): blank line separator, 72 chars per line, explain what/why. **Required if more than 3 files changed.**

Once generated, commit it with:
- `git commit -m "$subject"` (no body)
- `git commit -m "$subject" -m "$body"` (with body)

## 2. Publish

Run the publish workflow sequentially:
- `git checkout develop && git pull`
- `git checkout master && git merge develop -m "Merge branch develop"`
- `npm version ${1:-patch} --force -m "Version %s"`
- `git push && git push --tags`
- `git checkout develop`
