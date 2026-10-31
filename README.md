# Lightrains Tech dotfiles

Your dotfiles are how you personalize your system.

If you're interested in the philosophy behind why projects like these are awesome, you might want to read a post on the subject.

## Install

```sh
git clone https://github.com/niksmac/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/install && script/bootstrap
```

This works on macOS and Linux. Each installer only runs when the script detects the matching OS.

## Upgrade

Update the dotfiles manually by going into your `~/.dotfiles` and pulling latest updates.

```sh
cd ~/.dotfiles
git pull
script/install && script/bootstrap
```

## Topical

Everything's built around topic areas. If you're adding a new area to your forked dotfiles — say, "Java" — you can simply add a `java` directory and put files in there. Anything with an extension of `.zsh` will get automatically included into your shell. Anything with an extension of `.symlink` will get symlinked without extension into `$HOME` when you run `script/bootstrap`.

## Components

There's a few special files in the hierarchy.

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made available everywhere. Scripts here should work on both macOS and Linux.
- **topic/\*.zsh**: Any files ending in `.zsh` get loaded into your environment.
- **topic/path.zsh**: Any file named `path.zsh` is loaded first and is expected to setup `$PATH` or similar.
- **topic/completion.zsh**: Any file named `completion.zsh` is loaded last and is expected to setup autocomplete.
- **topic/\*.symlink**: Any files ending in `.symlink` get symlinked into your `$HOME`. This is so you can keep all of those versioned in your dotfiles but still keep those autoloaded files in your home directory. These get symlinked in when you run `script/bootstrap`.

## Cross-platform support

The same `master` branch runs on macOS and Linux, and shared tools are set up
to behave the same on both: same fonts, keys, clipboard, aliases and packages.

- `init/env` detects macOS vs Linux and sets `IS_MAC` / `IS_LINUX` (and the
  shared `PATH`). Shell files guard OS-only bits with `[ "$IS_MAC" = true ]`.
- `script/install` runs every `install.sh` with bash. Installers under
  `macos/` run only on macOS, under `linux/` only on Linux; the rest run on
  both and branch on `uname` internally where paths differ.
- `homebrew/brew-install.sh` installs one shared package list on both OSes
  (Homebrew / Linuxbrew), plus a few per-OS extras.

| Topic | macOS | Linux |
| --- | --- | --- |
| `misc/` fonts | `~/Library/Fonts` | `~/.local/share/fonts` + `fc-cache` |
| `ghostty/` | `config` | `config` + `linux-keybinds.conf` (linked as `linux.conf`) |
| `mpv/` | `~/.config/mpv` and `~/Library/Application Support/mpv` | `~/.config/mpv` |
| `bin/clip` | `pbcopy` | `wl-copy`, `xclip` or `xsel` |
| git credentials | `osxkeychain` | `gh auth git-credential` |
| `linux/` | — | generates the `en_US.UTF-8` locale |
| `macos/`, `iterm/`, `xcode/` | system defaults, iTerm, Xcode | — |

**Fonts.** Ghostty and Zed use Geist Mono. `misc/install.sh` downloads it into
`misc/fonts/Geist_Mono` if it's missing, then installs every font in
`misc/fonts` that isn't already installed.

**Keys.** Ghostty's config declares the macOS editing keys (alt+←/→ word jump,
cmd+←/→ line start/end, cmd+backspace delete line) so they work on Linux too.
On a Mac-layout keyboard under Linux the Cmd key sends ctrl, so
`linux-keybinds.conf` maps the same shortcuts (copy, paste, tabs, line
editing) to ctrl+.

**Clipboard.** Use `clip` (in `bin/`) instead of `pbcopy` in scripts and
aliases; tmux and Vim copy through the same tools.

After installing on Linux, run `gh auth login` once so git can use the gh
credential helper.

## AI agents: Claude Code, OpenCode, Hermes

Shared skills live in `skills/<name>/SKILL.md`, one directory per skill.
`skills/sync-skills.sh` (run by `skills/install.sh`) links them into each
agent's personal skills directory:

| Agent | Skills directory | Shell aliases |
| --- | --- | --- |
| Claude Code | `~/.claude/skills` (or `$CLAUDE_CONFIG_DIR/skills`) | — |
| OpenCode | `~/.config/opencode/skills` | `oc`, `occ` (continue) |
| Hermes | `~/.hermes/skills` (or `$HERMES_HOME/skills`) | `hs`, `hsc` (continue) |

- Every file in a skill is linked, not just `SKILL.md`, so skills can point
  at their own files (e.g. `landing-page-architect` loads `skills/lp-*/SKILL.md`).
- Links are symlinks back into this repo, so edits show up immediately; only
  re-run the script after adding, renaming or removing a skill or a file in one.
- Links left over from skills removed from the repo are pruned. Skills you
  installed in those directories some other way are never touched.

```sh
~/.dotfiles/skills/sync-skills.sh
```

To add a skill, create `skills/<name>/SKILL.md` with `name` and `description`
frontmatter (`name` in lowercase-hyphen form, matching the directory) and run
the script. Restart an agent that's already running to pick it up.

OpenCode's own config (`opencode.json` and `commands/`) is linked into
`~/.config/opencode` by `opencode/install.sh`.

## Local overrides and secrets

- `~/.localrc` is sourced by `zsh/zshrc.symlink` and is **gitignored**. It's created
  from `zsh/localrc.example` by `script/bootstrap` if missing. Put API keys, tokens,
  and machine-local env vars there so they never land in this public repo.

## Installer noise (`~/.zshrc.d`)

`script/bootstrap` symlinks your `~/.zshrc` to `zsh/zshrc.symlink` inside this repo.
When a tool installer tries to append PATH exports to `~/.zshrc` it will either fail
loudly or write into the tracked file (visible in `git diff`).

```sh
mkdir -p ~/.zshrc.d
echo 'export PATH="$HOME/.some-tool/bin:$PATH"' > ~/.zshrc.d/some-tool.zsh
```

Any `*.zsh` file in `~/.zshrc.d/` is sourced early by your shell (this directory is
gitignored), giving unavoidable installers a safe place to write machine-specific
exports without touching your tracked config.
