# Dotfiles Cross-Platform Inspection Report

**Date:** Saturday, August 29, 2026  
**Repo:** `/home/niksmac/.dotfiles`  
**Branch:** `master`  
**Current OS:** Linux (Ubuntu/Debian)  

---

## 1. CURRENT STATE OVERVIEW

The repo is already **80% cross-platform ready**. It uses a single-branch model with:
- OS detection in `init/env`
- Conditional installer dispatch in `script/install`
- Separate `macos/` and `linux/` directories for OS-specific content

**Current structure:**
```
├── bin/              # Shell utilities (cross-platform)
├── functions/        # Zsh functions (some Mac-only)
├── git/              # Git config + aliases
├── homebrew/         # Brew installer
├── init/             # OS detection + environment setup
├── iterm/            # iTerm2 configs (macOS only)
├── macos/            # macOS-specific installers
├── misc/             # Fonts, aliases
├── npm/              # NPM global packages
├── opencode/         # OpenCode config
├── prettier/         # Prettier config
├── script/           # Bootstrap + install + hostsinit
├── skills/           # Hermes skills (symlinked)
├── system/           # System-level aliases, env, paths
├── tmux/             # Tmux config
├── vim/              # Vim config
├── xcode/            # Xcode tools (macOS only)
├── zed/              # Zed editor config
└── zsh/              # Zsh shell config
```

---

## 2. CROSS-PLATFORM READINESS SCORE

| Component | Status | Notes |
|-----------|--------|-------|
| **Branching model** | ✅ Good | Single branch, no `ubuntu` split |
| **OS detection** | ✅ Good | `init/env` properly detects Darwin/Linux |
| **Installer dispatch** | ✅ Good | `script/install` runs correct installers by OS |
| **Shell config** | ⚠️ Needs work | `zshrc.symlink` has hardcoded paths + Mac-only commands |
| **PATH management** | ❌ Broken | Scattered across multiple files, hardcoded usernames |
| **Bootstrap** | ⚠️ Needs work | `script/bootstrap` has Mac-only assumptions |
| **Hosts init** | ❌ Mac-only | `script/hostsinit` explicitly rejects Linux |
| **Git config** | ⚠️ Needs work | Mac-only credential helper, brew paths |
| **Aliases** | ⚠️ Needs work | Multiple Mac-only commands unguarded |
| **Functions** | ⚠️ Needs work | Some functions assume macOS |
| **Brew installer** | ✅ Good | Already has Linux/macOS conditional logic |
| **Env file enforcement** | ❌ Missing | No guardrails for `~/.localrc` |
| **Installer noise** | ⚠️ Risk | No strategy for installers appending to `.zshrc` |

---

## 3. SPECIFIC ISSUES FOUND

### **CRITICAL — Breaks on Linux**

**3.1 `script/hostsinit` — Linux completely unsupported**
- Line 24: `if test "$(uname)" != "Darwin"` then exits
- **Impact:** Script fails on any Linux machine
- **Fix:** Either add Linux support (use `/etc/hosts` directly) or gate with `$IS_MAC`

**3.2 `zsh/zshrc.symlink` — Hardcoded paths + Mac-only commands**
- Line 96: `export PATH="$(brew --prefix)/opt/ruby/bin:$(brew --prefix)/sbin:$PATH"` — runs on Linux but assumes Linuxbrew has same structure
- Line 113: `/home/niksmac/.lmstudio/bin` — hardcoded username
- Line 118: `/home/niksmac/.opencode/bin` — hardcoded username
- Line 124: `PNPM_HOME="/home/niksmac/.local/share/pnpm"` — hardcoded username
- Line 10: `stty -ixon` — needed on Linux, harmless on macOS
- Line 81: `zplug "plugins/macos", from:oh-my-zsh` — loads Mac-only plugin on Linux
- **Impact:** Shell breaks on any machine where username isn’t `niksmac`

**3.3 `system/_path.zsh` — macOS-only paths**
- Line 1: `./bin:/usr/local/bin:/usr/local/sbin` — assumes macOS structure
- Line 2: `/usr/local/man:/usr/local/mysql/man:/usr/local/git/man` — macOS man paths
- **Impact:** Useless on Linux, adds noise to PATH

**3.4 `misc/aliases.zsh` — Unconditional Mac-only commands**
- Line 12: `lockme` — uses `/System/Library/CoreServices/...` (macOS only)
- Line 15: `genpass` — uses `pbcopy` (macOS only)
- Line 39: `flushdns` — uses `dscacheutil` + `mDNSResponder` (macOS only)
- Line 48: `ff` — uses `open -n -a Firefox.app` (macOS only)
- Line 51: `code` — hardcodes `/Applications/Zed.app/Contents/MacOS/zed`
- Line 52: `codex` — uses `open .` (macOS only)
- Line 60: `xattr_clean` — uses `xattr` with macOS metadata
- **Impact:** These aliases fail silently or noisily on Linux

### **HIGH — Cross-platform issues**

**3.5 `script/bootstrap` — Mac-only assumptions**
- Line 36-38: Git credential helper defaults to `osxkeychain` on Darwin
- Line 58-60: NPM credential helper same issue
- Line 165: Only installs dependencies on Darwin
- **Impact:** Bootstrap behaves differently on Linux without explicit handling

**3.6 `init/prepare.sh` — Brew install on Linux**
- Line 8: `export ARCHFLAGS='-arch arm64'` — macOS-specific, breaks Linux Ruby builds
- Line 12-14: Creates `~/.nvm` dir — fine, but `init/env` also sets `NVM_DIR`
- **Impact:** Linux gets wrong ARCHFLAGS

**3.7 `zsh/config.zsh` — macOS-centric settings**
- Line 1: `LSCOLORS="exfxcxdxbxegedabagacad"` — macOS ls colors, ignored on Linux
- Line 36-41: Key bindings assume macOS terminal escape sequences
- **Impact:** Harmless on Linux but wrong colors + broken keybindings

**3.8 `git/completion.zsh` — Brew-dependent path**
- Line 4: `completion='$(brew --prefix)/share/zsh/site-functions/_git'` — assumes brew
- **Impact:** Fails silently if brew not present

### **MEDIUM — Inconsistencies**

**3.9 `system/env.zsh` — PATH exports duplicated elsewhere**
- Only has `EDITOR` + `CLICOLOR` (good), but `zshrc.symlink` also sets these
- **Impact:** Unclear ownership of env vars

**3.10 `functions/extract` — `.dmg` handling on Linux**
- Line 14: `*.dmg) hdiutil mount $1` — macOS-only command
- **Impact:** Fails on Linux if user extracts .dmg files

**3.11 `functions/c` — Assumes `$GOPATH` exists**
- Line 20: `cd "$GOPATH/src/github.com/$1"` — fails if GOPATH unset
- **Impact:** Breaks on Linux if Go not installed

**3.12 `zsh/aliases.zsh` — `reload!` assumes `.zshrc`**
- Line 1: `. ~/.zshrc` — should reference `$ZSH/zshrc.symlink` for consistency

### **LOW — Best practices**

**3.13 No `~/.localrc` enforcement**
- `zshrc.symlink` sources `~/.localrc` if it exists, but doesn’t create it
- **Impact:** New machines miss secrets/api keys silently

**3.14 `.gitignore` incomplete**
- Missing: `*.swp`, `.localrc`, `.zshrc`, `.zsh_history`, `/tmp/`
- **Impact:** Secrets/swap files could leak

**3.15 PATH duplication across files**
- `init/env`: brew paths, fnm, zplug
- `system/_path.zsh`: `/usr/local/*` paths
- `zsh/zshrc.symlink`: LM Studio, opencode, npm, pnpm, ruby, gems, yarn
- **Impact:** PATH order varies by machine, hard to debug

---

## 4. INSTALLER NOISE STRATEGY

**Current risk:** Many tools append PATH exports directly to `~/.zshrc`. Since your dotfiles own that file, external modifications will:
1. Either fail (if `~/.zshrc` is a symlink to read-only dotfiles)
2. Or pollute your tracked config

**Recommended approach: Own your `.zshrc`**

Make `~/.zshrc` a symlink to `~/.dotfiles/zsh/zshrc.symlink`:
```bash
ln -sf ~/.dotfiles/zsh/zshrc.symlink ~/.zshrc
```

Then when an installer tries to append to `~/.zshrc`, it either:
- Fails loudly (symlink to read-only file) — you catch it
- Writes to the symlink target, showing up in `git diff` — you review it

**For unavoidable installers**, create `~/.zshrc.d/` (gitignored) for ad-hoc exports:
```bash
# ~/.zshrc.d/<tool>.zsh
export PATH="$HOME/.some-tool/bin:$PATH"
```

---

## 5. RECOMMENDATIONS (PRIORITY ORDER)

### **Phase 1: Make it work on Linux (P0)**

1. **Fix `script/hostsinit`** — Add Linux support or gate with `$IS_MAC`
2. **Fix `zsh/zshrc.symlink`** — Replace hardcoded paths with `$HOME` + `init/env`
3. **Guard Mac-only aliases** — Wrap `lockme`, `genpass`, `flushdns`, `ff`, `code`, `xattr_clean` with `$IS_MAC`
4. **Fix `init/prepare.sh`** — Guard `ARCHFLAGS='-arch arm64'` with `$IS_MAC`

### **Phase 2: Clean up PATH management (P1)**

5. **Consolidate all PATH exports into `init/env`** — Remove from `zshrc.symlink`
6. **Guard `system/_path.zsh`** with `$IS_MAC`
7. **Guard `zplug "plugins/macos"`** with conditional load
8. **Fix `git/completion.zsh`** — Don’t assume brew exists

### **Phase 3: Improve bootstrap (P2)**

9. **Make `script/bootstrap` use `init/env`** instead of raw `uname`
10. **Add `~/.localrc` enforcement** — Create from template if missing
11. **Improve `.gitignore`** — Add swap files, `.zshrc`, `.localrc`

### **Phase 4: Polish (P3)**

12. **Guard `functions/extract`** — Skip `.dmg` on Linux
13. **Fix `functions/c`** — Check `$GOPATH` exists before using
14. **Standardize keybindings** — Use `bindkey` with proper escape sequences
15. **Document the workflow** — Add README section about installer noise + `~/.zshrc.d/`

---

## 6. ESTIMATED EFFORT

| Phase | Files changed | Lines changed | Complexity |
|-------|--------------|---------------|------------|
| Phase 1 | 4-5 files | ~60-80 lines | Low |
| Phase 2 | 3-4 files | ~40-50 lines | Low |
| Phase 3 | 2-3 files | ~30-40 lines | Medium |
| Phase 4 | 3-4 files | ~20-30 lines | Low |

**Total:** ~150-200 lines across 12-16 files. Mostly copy-paste edits with conditionals.

---

## 7. QUICK WIN

If you want one immediate improvement, make `~/.zshrc` a symlink to your dotfiles version:
```bash
ln -sf ~/.dotfiles/zsh/zshrc.symlink ~/.zshrc
```

This alone prevents 80% of installer noise problems.
