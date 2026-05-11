# dotfiles

Your dotfiles are how you personalize your system.

If you're interested in the philosophy behind why projects like these are awesome, you might want to [read a post on the subject](http://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/).

## Prerequisites

- **macOS**: Homebrew (will be installed automatically)
- **Ubuntu/Linux**: Homebrew (will be installed automatically) + build essentials

```sh
# Ubuntu prerequisites (run once)
sudo apt update
sudo apt install -y build-essential curl file git
```

## Install

```sh
git clone https://github.com/niksmac/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./script/install
```

After installation, restart your terminal or run:

```sh
source ~/.zshrc
```

## Shell Setup

This dotfiles uses **zsh**. Add to `~/.zshrc` (or `~/.bashrc`):

```sh
export ZSH=$HOME/.dotfiles
export ZSH_CUSTOM=$HOME/.zsh/custom

# Load zsh config
for file in $ZSH/zsh/*.zsh; do
  source $file
done
```

Or simply create a symlink:

```sh
ln -sf ~/.dotfiles/zsh/zshrc.symlink ~/.zshrc
```

## What Gets Installed

| Tool | Purpose |
|------|---------|
| `tmux` | Terminal multiplexer |
| `tree` | Directory listing |
| `vim` | Text editor |
| `dnsutils` | DNS utilities |
| `prettier` | Code formatter |
| `thefuck` | Command correction |
| `docsify-cli` | Docs generator |
| `nodemon` | Dev server |
| `pm2` | Process manager |
| `serve` | Static server |

## Upgrade

```sh
cd ~/.dotfiles
git pull
./script/install
```

## Structure

- **zsh/\*.zsh** - Shell configuration (aliases, completions, etc.)
- **system/\*.zsh** - System-specific settings (cross-platform)
- **bin/\*** - Executable scripts added to `$PATH`
- **\*.symlink** - Symlinked to `$HOME`

## Components

There's a few special files in the hierarchy:

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made available everywhere.
- **topic/\*.zsh**: Any files ending in `.zsh` get loaded into your environment.
- **topic/path.zsh**: Any file named `path.zsh` is loaded first and is expected to setup `$PATH` or similar.
- **topic/completion.zsh**: Any file named `completion.zsh` is loaded last and is expected to setup autocomplete.
- **topic/\*.symlink**: Any files ending in `*.symlink` get symlinked into your `$HOME`.

## Topical

Everything's built around topic areas. If you're adding a new area to your forked dotfiles — say, "Java" — you can simply add a `java` directory and put files in there. Anything with an extension of `.zsh` will get automatically included into your shell.

## Blocking Ads/Tracking

Run `./script/hostsinit` to modify your hosts files so that you don't see any ads. Thanks to [StevenBlack/hosts](https://github.com/StevenBlack/hosts)
