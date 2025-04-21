# Git Commit Message Hook

This Git hook enforces standardized commit message formatting according to best practices and the Conventional Commits specification.

## Features

- Enforces subject line capitalization
- Validates commit message structure
- Supports Conventional Commits format
- Checks for imperative mood verbs
- Enforces character limits for readability
- Ensures proper message body formatting

## Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles

# Run the installation script
~/.dotfiles/git/install.sh
```

The installation script configures Git to use these hooks globally for all repositories.

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
<type>: <Subject>

<Body>
```

- **Supported Types**: feat, fix, docs, style, refactor, perf, test, chore, build, ci, revert
- **Type Format**: All lowercase followed by a colon and a space
- **Subject Format**: First word after the type must be capitalized and an imperative verb

## Examples

### Valid Conventional Commits

```
feat: Add user authentication feature
fix: Resolve API timeout issue
docs: Update installation instructions
refactor: Simplify data processing logic
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

The hook validates that commits begin with verbs in the imperative mood. Some examples include:

- Add, Allow, Build, Change
- Create, Delete, Disable, Enable
- Fix, Implement, Improve, Make
- Move, Optimize, Refactor, Remove
- Rename, Resolve, Update, Use

For a complete list, see the [imperative_verbs.txt](/git/imperative_verbs.txt) file.

## Customization

### Adding Custom Verbs

To add more imperative verbs to the validation list, edit the `~/.git-templates/hooks/imperative_verbs.txt` file.

### Modifying the Hook

You can edit the hook directly at `~/.git-templates/hooks/commit-msg` to change validation rules or formatting requirements.

## Troubleshooting

If you encounter issues with the hook:

1. Ensure the hook is executable: `chmod +x ~/.git-templates/hooks/commit-msg`
2. Verify the imperative verbs file exists: `cat ~/.git-templates/hooks/imperative_verbs.txt`
3. Check for syntax errors: `sh -n ~/.git-templates/hooks/commit-msg`

## License

This project is licensed under the MIT License - see the LICENSE file for details.
