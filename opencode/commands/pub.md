---
description: Publish a new version tag (major|minor|patch) and push
model: opencode/big-pickle
subtask: true
---

Run the following steps:

1. Checkout develop and pull latest
2. Checkout master and merge develop with message "Merge branch develop"
3. Run `npm version $1 --force -m "Version %s"` to create the version tag
4. Push commits and tags
5. Checkout develop back

Execute each step sequentially. Stop on first failure.
