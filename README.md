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

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made available everywhere.
- **topic/\*.zsh**: Any files ending in `.zsh` get loaded into your environment.
- **topic/path.zsh**: Any file named `path.zsh` is loaded first and is expected to setup `$PATH` or similar.
- **topic/completion.zsh**: Any file named `completion.zsh` is loaded last and is expected to setup autocomplete.
- **topic/\*.symlink**: Any files ending in `.symlink` get symlinked into your `$HOME`. This is so you can keep all of those versioned in your dotfiles but still keep those autoloaded files in your home directory. These get symlinked in when you run `script/bootstrap`.

## Cross-platform support

The repo uses a single-branch `master` model with OS detection in `init/env` and conditional installer dispatch in `script/install`.

- `init/env` detects macOS vs Linux and sets `IS_MAC` / `IS_LINUX`.
- `script/install` only runs installers from `*/macos/*` on macOS and `*/linux/*` on Linux.
- macOS-specific content lives in `macos/`, `iterm/`, `xcode/`.
- Linux-specific content lives in `linux/`.

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
