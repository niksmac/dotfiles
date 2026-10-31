# AGENTS.md

Guide for coding agents working in this repository.

## What this repo is

The single source of truth for the configuration of every configurable piece
of software the owner uses: shell, terminals, editors, git, tmux, fonts,
keyboard and mouse, package lists, and AI agents. If a program has settings
worth keeping, they live here and get installed from here.

The same `master` branch is used on **macOS and Linux**. Every change must
work on both, and behave the same on both: same keys, clipboard, fonts,
aliases and packages. The repo is **public**.

## Ground rules

1. **Both platforms, always.** Before finishing, ask "what does this do on
   the other OS?" Use the equivalent tool there, guard the OS-only part, or
   say plainly why it can't apply.
   - Shell files: `[ "$IS_MAC" = true ]` / `[ "$IS_LINUX" = true ]`, set by
     `init/env`.
   - Installers: `uname -s`. An installer for an OS-only app starts with
     `[ "$(uname -s)" = "Darwin" ] || exit 0` (or `Linux`). Anything under
     `macos/` or `linux/` already runs only on that OS.
   - `bin/` scripts are POSIX `sh` and must run on both. Use `clip`, never
     `pbcopy`, for the clipboard.
2. **Same behaviour everywhere.** If you change a key, alias or setting for one
   app or OS, update its counterparts (see "Keyboard and clipboard").
3. **Installers are idempotent.** `script/bootstrap` and `script/install` are
   re-run routinely. Re-running must do nothing harmful and print what it did.
   Never silently overwrite a real file the user may have edited: skip it, or
   back it up first (see `claude/install.sh`, which keeps `*.backup`).
4. **No secrets in the repo.** Keys and tokens go in `~/.localrc` (sourced by
   zsh, gitignored; template in `zsh/localrc.example`). `git/gitconfig.symlink`
   and `npm/npmrc.symlink` are generated from their `.example` by bootstrap.
5. **Track source config, not runtime state.** Lock files, sockets, caches
   and backups an app writes next to its config are gitignored (see
   `openlogi/.gitignore`).
6. **Check before you remove anything.** Delete or rewrite config only after
   confirming it's dead, for example an alias that's overridden or a tool that
   isn't installed. Say what you removed and why.

## How things load and install

| Pattern | What happens |
| --- | --- |
| `<topic>/*.zsh` | Sourced by `zsh/zshrc.symlink` on every shell: all `path.zsh` first, then the rest (alphabetical by path), then all `completion.zsh` after `compinit`. zplug and its oh-my-zsh plugins load **after** all of these. |
| `<topic>/*.symlink` | `script/bootstrap` links it to `~/.<name>` (depth ≤ 2), asking before replacing anything. |
| `<topic>/install.sh` | `script/install` runs every one with bash, sorted by path, after Homebrew and `homebrew/brew-install.sh`. |
| `bin/*` | On `PATH` everywhere. |
| `functions/<name>` | Autoloaded zsh function: one per file, the file is the function **body** (no `name() {}` wrapper). `_<name>` files are completions. |
| `init/env` | POSIX `sh`. OS detection (`IS_MAC`, `IS_LINUX`) and tool homes on `PATH`. Sourced by zshrc, bootstrap and install. |
| `~/.localrc`, `~/.zshrc.d/*.zsh` | Machine-local, never tracked. |

## Where things go

- **Aliases.** Git-only aliases go in `git/aliases.zsh`; everything else goes
  in `system/aliases.zsh`, grouped by section. Don't create one-alias files.
- **Functions.** Anything with logic goes in `functions/<name>` (autoloaded),
  not in an alias file.
- **PATH.** A topic's `path.zsh`, or `init/env` for tool homes needed outside
  zsh too.
- **Packages.** `homebrew/brew-install.sh`: `COMMON_PACKAGES` (both OSes),
  `MACOS_PACKAGES`, `LINUX_PACKAGES`, `MACOS_CASKS`. Prefer common packages;
  add an OS-specific package only when the other OS has its own equivalent.
- **A new program's config.** Give it its own topic folder holding the config
  plus an `install.sh` that links it into place on both OSes. Use the app's
  real config path on each OS (see `mpv/`), and document it in
  `README.md`.
- **Apps that rewrite their own config** (atomic temp-file + rename). Link the
  **directory**, not the file, or the first save replaces the symlink
  (`openlogi/`). If the app owns a large generated file, manage only your
  sections of it (`toshy/slices/`).

## What's managed

| Topic | Software | Installed to |
| --- | --- | --- |
| `zsh/`, `system/`, `functions/` | zsh: prompt, options, aliases, functions | `~/.zshrc` |
| `git/` | git config, global ignore, aliases | `~/.gitconfig`, `~/.gitignore_global` |
| `tmux/` | tmux (prefix is backtick), tpm plugins | `~/.tmux.conf` |
| `vim/` | Vim, vim-plug, hybrid colours | `~/.vimrc` |
| `ghostty/` | Ghostty (primary terminal); `linux-keybinds.conf` on Linux only | `~/.config/ghostty/config.ghostty` (one link only, or `config-file` reports a cycle) |
| `iterm/` | iTerm2 profile, colours, key mappings (macOS) | iTerm loads prefs from `iterm/` |
| `zed/` | Zed settings, snippets, prompts | `~/.config/zed` |
| `mpv/` | mpv | `~/.config/mpv`, plus Application Support on macOS |
| `npm/`, `prettier/` | npm config and globals, Prettier | `~/.npmrc`, `~/.prettierrc` |
| `misc/` | Fonts; Monaco as a gitignored local copy (Apple licence) | `~/Library/Fonts` / `~/.local/share/fonts` |
| `openlogi/` | OpenLogi (MX Mechanical Mini, MX Anywhere 3S) | `~/.config/openlogi` → `openlogi/` |
| `toshy/` | Toshy: macOS shortcuts on Linux (Linux only) | slices in `~/.config/toshy/toshy_config.py` |
| `claude/` | Claude Code global rules (`CLAUDE.md` for all projects) | `~/.claude/CLAUDE.md` |
| `opencode/` | OpenCode config and commands | `~/.config/opencode` |
| `skills/` | Agent skills shared by Claude Code, OpenCode, Hermes | each agent's skills dir |
| `homebrew/`, `init/` | Homebrew / Linuxbrew and the package list | — |
| `macos/`, `linux/` | OS settings (`defaults`, locale) | — |

`claude/CLAUDE.md` holds the owner's rules for *every* project. This file,
`AGENTS.md`, is about *this* repo.

## Keyboard and clipboard: keep them in sync

The goal is that the keys behave as on a Mac keyboard in every terminal and
app on both OSes:

- **Cmd+C / Cmd+V:** copy and paste.
- **Ctrl+C:** interrupt.
- **Option+← / →:** move by word.
- **Cmd+← / →:** start / end of line.
- **Cmd+⌫:** delete the line.
- **Cmd+T / W / N:** new tab, close tab, new window.
- **Cmd+D / Cmd+Shift+D:** split right / split down.

Left Option is Alt; right Option still types accents.

- **Ghostty.** The shared keys live in `ghostty/config`; Linux additions go in
  `ghostty/linux-keybinds.conf`.
- **iTerm2.** Its key mappings in `iterm/com.googlecode.iterm2.plist` must
  match Ghostty.
- **Linux.** Toshy turns Cmd shortcuts into each app's defaults. In terminals
  they become `ctrl+shift+…`, and Ctrl stays Ctrl. So on Linux never rebind
  `ctrl+<letter>` in Ghostty and never change apps' default shortcuts; Toshy
  relies on them. Toshy must be the only key remapper (no keyd, no GNOME
  modifier swaps).
- **zsh.** `zsh/config.zsh` binds the escape sequences these send (word
  jumps, Home/End variants).
- **Clipboard.** `bin/clip`, tmux's `copy-command` and Vim's clipboard
  settings all reach the system clipboard on both OSes. Ghostty and iTerm2
  allow OSC 52 writes. Ptyxis/VTE doesn't support them, which is why tmux
  also pipes every copy through `copy-command`.

## Known pitfalls

- **oh-my-zsh's `git` plugin** is loaded by zplug after this repo's files and
  overrides `gl`, `gp`, `gc`, `gco`, `gcb`, `glog`, etc. Don't define those
  names; check with `zsh -ic 'alias <name>'`.
- **Autoloaded functions** expand aliases when first called (`ls` is aliased
  to `gls -F --color`). Use `command ls` and the like inside them.
- **zsh globs** that may match nothing need `(N)`; prefer
  `*.(a|b)(N.om[1])` over `ls -t` pipelines.
- **macOS sandboxed apps** (Safari, TextEdit) keep prefs in
  `~/Library/Containers`, writable only with Full Disk Access. Guard them like
  `sandboxed_write` in `macos/install.sh`.
- **iTerm2 plist.** Edit it with `plutil -replace` (zero formatting noise),
  never Python `plistlib`, which rewrites every float. Quit iTerm2 first: it
  saves prefs back to `iterm/` on quit.
- **Ghostty.** Bindings are always consumed unless prefixed `performable:`.
  `+show-config` / `+list-keybinds` don't print prefixes and ignore
  `--config-file`. To validate a config, copy it into a temp
  `$XDG_CONFIG_HOME/ghostty/` and run `ghostty +validate-config`.
- **`brew --prefix <formula>`** prints a path even when the formula isn't
  installed; check that the file exists.
- **Shared working copy.** Other sessions or the owner may have uncommitted
  edits. Stage only the files you changed (`git add <paths>`), never
  `git add -A` blindly, and check `git diff --cached` before committing.

## Verifying changes

There's no test suite; verify by running things.

- **Never** install or run headless browsers (Playwright, Puppeteer,
  Chromium, Selenium). For UI, ask the owner to check.
- **Syntax:** `zsh -n <file>`, `bash -n <script>`, `shellcheck` if available,
  `plutil -lint` for plists.
- **Shell changes:** diff `zsh -ic 'alias' | sort` before and after; confirm
  `zsh -ic true` prints nothing to stderr.
- **App configs:** use the app's own validator where one exists (e.g.
  `ghostty +validate-config`).
- **The other OS.** You usually can't run it. Test OS-specific logic with stub
  commands or fake input on the OS you have. Then say exactly what was **not**
  tested on the other OS and give the owner the command to run there.
- **Installers:** run them twice. The second run should change nothing.
  Test against a temp `$HOME` or config dir when they touch real files.

## Git and commits

- Work directly on `master`. Commit when a change is done and verified.
  **Push only when the owner asks.**
- Commit messages follow `git/RULES.md`, as enforced by the `/dot-commit`
  OpenCode command:
  - The subject is `<Type>: <Imperative verb> …`. Type is one of **Feat, Fix,
    Docs, Style, Ref, Perf, Test, Chore, Build, CI, Revert**, capitalized.
    (`Add:` is not a type; write `Feat: Add …`.)
  - Subject ≤ 80 characters with no trailing period. Body wrapped at 72
    characters, explaining what and why.
  - A body is required when more than 3 files change.
  - Allowed verbs: `git/imperative_verbs.txt`.
- Before committing, check the staged diff for secrets (keys, tokens, private
  keys, credentials in URLs). If any are found, unstage and stop.
- Update `README.md` when installed behaviour, layout or setup steps change.
