# Lightrains Tech dotfiles

Your dotfiles are how you personalize your system.

If you're interested in the philosophy behind why projects like these are awesome, you might want to read a post on the subject.

## Install

Works on macOS and Linux.

**Before you start**

- macOS: the Xcode Command Line Tools (`xcode-select --install`).
- Linux: `git`, `curl`, `zsh` and Homebrew's build dependencies, e.g. on
  Ubuntu/Debian: `sudo apt install build-essential procps curl file git zsh`.

**Then**

```sh
git clone https://github.com/niksmac/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap && script/install
```

Run `script/bootstrap` first: some installers (e.g. `git/install.sh`) write
to `~/.gitconfig`, and on a fresh machine that would create a real file where
bootstrap wants to put its symlink.

- `script/bootstrap` asks for your git and npm author details, creates
  `~/.localrc` and `~/.zshrc.d`, and symlinks every `*.symlink` file into
  `$HOME` (asking before replacing anything that already exists).
- `script/install` installs Homebrew if it's missing, installs the packages in
  `homebrew/brew-install.sh`, then runs every `install.sh`: fonts,
  Ghostty, tmux, Vim, Zed, mpv, git settings, npm globals, OpenCode config and
  the agent skills. Installers in `macos/` and `linux/` only run on that OS.
  It asks for your password for the few steps that need `sudo`.

**Afterwards**

- Linux: make zsh your login shell with `chsh -s /usr/bin/zsh` (macOS already
  uses zsh), then log out and back in.
- Linux: run `gh auth login` once so git can use the gh credential helper.
- Open a new terminal to load the shell config.
- Optional: `script/hostsinit` replaces `/etc/hosts` with an ad-blocking one.

## Upgrade

```sh
cd ~/.dotfiles
git pull
script/bootstrap && script/install
```

Both scripts are safe to re-run. To only update Homebrew and the packages in
`homebrew/brew-install.sh`, run `dot` (from `bin/`).

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
| `ghostty/` | `config` | `config` + `linux-keybinds.conf` (linked as `linux.conf`); installs Ghostty on Ubuntu/Debian from mkasberg/ghostty-ubuntu if missing and makes it the default terminal (`xdg-terminals.list`, `x-terminal-emulator`) |
| `mpv/` | `~/.config/mpv` and `~/Library/Application Support/mpv` | `~/.config/mpv` |
| `bin/clip` | `pbcopy` | `wl-copy`, `xclip` or `xsel` |
| git credentials | `osxkeychain` | `gh auth git-credential` |
| `linux/` | — | generates the `en_US.UTF-8` locale |
| `macos/`, `iterm/` | system defaults, iTerm | — |

**Fonts.** Ghostty, iTerm2 and Zed use Monaco on both OSes. Monaco is Apple's
and can't be committed, so `misc/install.sh` keeps a gitignored local copy in
`misc/fonts/Monaco`: on macOS it copies the system font there; on Linux it
installs from there. On a new Linux machine, copy it over from a Mac first:

```sh
mkdir -p ~/.dotfiles/misc/fonts/Monaco
scp <mac>:.dotfiles/misc/fonts/Monaco/Monaco.ttf ~/.dotfiles/misc/fonts/Monaco/
```

Until then, apps fall back to another monospace font. If an old Monaco is
installed (the 1991 FontMonger conversion that floats around, with no bold
or symbols) or one that differs from the local copy, the script moves it to
`~/.local/share/fonts.backup/` first. The script also installs every other
font in `misc/fonts` that isn't already installed.

**Keys.** Ghostty and iTerm2 use the same keys: cmd+c/v copy and paste,
alt+←/→ word jump (left Option is Alt; right Option still types accents),
cmd+←/→ line start/end, cmd+backspace delete line, cmd+t/w/n tabs and
windows, cmd+d / cmd+shift+d splits. Ghostty declares the editing keys so
they work on Linux too; iTerm2 loads its profile and key mappings from
`iterm/` (pointed there by `iterm/install.sh`).

On Linux, [Toshy](https://github.com/RedBearAK/toshy) makes the Mac-layout
keyboard (Logitech MX Mechanical Mini for Mac) behave as on macOS in every
app: Cmd+C/V/T/W/… work everywhere, in terminals they become the terminal's
ctrl+shift+… shortcuts, and Ctrl stays Ctrl there, so Ctrl+C interrupts.
`toshy/install.sh` installs Toshy if it's missing, disables keyd and removes
GNOME modifier swaps (Toshy must be the only remapper), resets custom Ptyxis
shortcuts to its defaults (backed up to
`~/.config/ptyxis-shortcuts.backup.ini`), points GNOME's app switcher
(Cmd+Tab), same-app window switcher (Cmd+\`) and close (Cmd+Q) at the keys
Toshy sends and frees Ctrl+Space and Ctrl+Tab for apps, asks GNOME on
Wayland to install the Focused Window D-Bus extension Toshy needs, and
writes each `toshy/slices/<name>.py` into the matching `SLICE_MARK` section
of `~/.config/toshy/toshy_config.py` (the sections Toshy keeps across
upgrades). Edit the slices in this repo and re-run `toshy/install.sh`;
`slices/kbtype_override.py` marks the keyboard as Apple layout. Check the
keyboard's name with `toshy-devices` if Cmd and Option seem swapped.

**Keyboard and mouse.** OpenLogi's settings (`openlogi/config.toml`, for the
MX Mechanical Mini and MX Anywhere 3S) are shared by both machines:
`openlogi/install.sh` links `~/.config/openlogi` to `openlogi/`.

**Clipboard.** Use `clip` (in `bin/`) instead of `pbcopy` in scripts and
aliases; tmux and Vim copy through the same tools. Selecting never copies:
select with the mouse, then copy with Cmd+C and paste with Cmd+V. In tmux a
drag, double-click or triple-click only selects; Cmd+C (or y / Enter)
copies, a click elsewhere or q / Esc drops the selection.

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

- Each skill directory is linked as a whole (`~/.claude/skills/<name>` →
  `skills/<name>`), so edits and new files show up immediately and skills can
  point at their own files (e.g. `landing-page-architect` loads
  `skills/lp-*/SKILL.md`). Only re-run the script after adding, renaming or
  removing a whole skill.
- Anything an agent writes into a linked skill directory lands in this repo;
  check `git status` before committing.
- Links left over from skills removed from the repo are pruned, and old
  per-file link mirrors are replaced with a directory link. Skills you
  installed in those directories some other way are never touched.

```sh
~/.dotfiles/skills/sync-skills.sh
```

To add a skill, create `skills/<name>/SKILL.md` with `name` and `description`
frontmatter (`name` in lowercase-hyphen form, matching the directory) and run
the script. Restart an agent that's already running to pick it up.

OpenCode's own config (`opencode.json` and `commands/`) is linked into
`~/.config/opencode` by `opencode/install.sh`.

Claude Code's global rules, `claude/CLAUDE.md`, are linked to
`~/.claude/CLAUDE.md` (or `$CLAUDE_CONFIG_DIR/CLAUDE.md`) by
`claude/install.sh`. Edit the file in this repo; an existing local
`CLAUDE.md` that differs is kept as `CLAUDE.md.backup`.

In zsh, `claude` is wrapped by `functions/claude`: bare `claude` and
`claude agents` open the agent view listing only the sessions started under
the current directory (Claude Code's default is every folder). Type a prompt
there to start a session, or pass one (`claude "…"`); every other argument
goes to Claude Code unchanged. `command claude` skips the wrapper. Pressing ←
in a session started with arguments (`claude "…"`, `claude -c`) still lists
every folder, since Claude Code can't filter the view it opens there.

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
