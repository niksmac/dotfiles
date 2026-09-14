---
description: Write a commit message following the project's commit conventions
model: opencode/big-pickle
subtask: true
---

## Enforce these rules strictly

1. **Capitalization**: The first word and the type prefix **must** be capitalized. `Feat: Add...` ✅ — `feat: add...` ❌
2. **Valid types only**: Only use: Feat, Fix, Docs, Style, Ref, Perf, Test, Chore, Build, CI, Revert. Never "feature", "Feature", or any other variant.
3. **Type Capitalization**: The type must Capitalized followed by `: `.
4. **Valid imperative verb**: The first word after the type (or first word of subject for non-Conventional Commits) must be one of: Add, Allow, Bump, Build, Change, Clean, Configure, Create, Decrease, Delete, Deploy, Deprecate, Disable, Document, Enable, Enhance, Ensure, Extract, Fix, Format, Implement, Improve, Include, Increase, Inject, Integrate, Introduce, Make, Manage, Merge, Migrate, Modify, Move, Optimize, Perform, Prevent, Provide, Refactor, Refresh, Release, Remove, Rename, Render, Reorder, Replace, Resolve, Restructure, Revert, Revise, Separate, Set, Setup, Simplify, Split, Start, Stop, Support, Test, Trim, Update, Upgrade, Use, Verify.

Generate a commit message for the staged changes below following those rules.

Stage all changes:
!`git add -A`

Current staged changes:
!`git diff --cached`

First run `git diff --cached --name-only` and flag any sensitive file types being committed: `.env`, `.env.*`, `*.pem`, `*.key`, `id_rsa*`, `id_ed25519*`, `*.p12`, `*.pfx`, `*.keystore`, `credentials*.json`, `*secrets*`.

Check the staged diff for hardcoded secret values — actual credentials, not variable names. Use this generic rule instead of a provider list:

- **Structural match**: a key name containing `key`, `secret`, `token`, `password`, `credential`, `auth`, or `api` (case-insensitive, allowing `-`/`_`/space separators, e.g. `apiKey`, `AWS_SECRET_ACCESS_KEY`, `auth_token`) assigned via `=`, `:`, `=>`, or JSON `"key": "value"` — AND —
- **High-entropy value**: the value is ≥ 16 chars of `[A-Za-z0-9\-_+/=.#]` with mixed character classes (letters + digits, or base64-like mix). Random-looking strings like `sk-9f8a7b6c...`, `hf_aB3xY9...`, `AKIAIOSFODNN7EXAMPLE`, `eyJhbGciOi...` all match this.

Also flag, regardless of key name:

- `-----BEGIN (RSA |EC |OPENSSH |PGP |ENCRYPTED )?PRIVATE KEY( BLOCK)?-----`
- Literal URLs containing passwords (`://[^:\s]+:[^@\s]+@`) and database connection strings with inline credentials
- `Basic ` + base64 blobs in headers

Ignore variable names like `API_KEY` alone, references (`${VAR}`, `process.env.X`, `os.environ[...]`), and placeholders (`changeme`, `xxx`, `<your-key>`, `REDACTED`, example/test values, and test fixtures under `test/`, `__fixtures__/`, `*.spec.*`). When unsure whether a value is real or a placeholder, treat it as a secret.

If any secret is detected: **do not commit**. Run `git reset` to unstage and tell the user which file(s) and pattern(s) matched, then stop.

Count the number of files changed. If **more than 3 files** are modified, a **body is required** (not optional).

Once generated and verified safe, commit with `git-commit "$subject" "$body"` (omit body if not needed).

Stop on failure.
