## Commit Message Rules

### Basic Format

```
<Subject line>

<Body>
```

### Subject Line Rules

1. **Length**: Limited to 80 characters maximum
2. **Capitalization**: First word must be capitalized
3. **Punctuation**: No period at the end
4. **Imperative Mood**: First word must be an imperative verb (e.g., Add, Fix, Update)

### Body Rules

1. **Separation**: Must be separated from subject by a blank line
2. **Line Length**: Each line limited to 72 characters
3. **Content**: Should explain what and why, not how

### Conventional Commits Format

The hook supports and enforces the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<Type>: <Subject>

<Body>
```

- **Supported Types**: Feat, Fix, Docs, Style, Ref, Perf, Test, Chore, Build, CI, Revert
- **Type Format**: All lowercase followed by a colon and a space
- **Subject Format**: First word after the type must be capitalized and an imperative verb

## Examples

### Valid Conventional Commits

```
Feat: Add user authentication feature
Fix: Resolve API timeout issue
Docs: Update installation instructions
Refactor: Simplify data processing logic
```

### Valid Standard Commits

```
Update database schema for performance
Add new login screen
Implement customer feedback changes
```

### Invalid Commits

```
updated files  # Not capitalized, not imperative
feat: added new feature  # 'added' not capitalized
Adds user authentication.  # Ends with period, not imperative mood
feature: Add authentication  # 'feature' not a standard type
```

## Supported Imperative Verbs

Some examples include:

- Add, Allow, Build, Change
- Create, Delete, Disable, Enable
- Fix, Implement, Improve, Make
- Move, Optimize, Refactor, Remove
- Rename, Resolve, Update, Use

For a complete list, see the [imperative_verbs.txt](./git/imperative_verbs.txt) file.
