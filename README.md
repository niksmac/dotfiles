# Lightrains Tech dotfiles

## dotfiles

Your dotfiles are how you personalize your system.

If you're interested in the philosophy behind why projects like these are
awesome, you might want to [read a post on the
subject](http://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/).

## Install

Run this for Apple Silicon M1 & M2:

```sh
git clone https://github.com/niksmac/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/install && script/bootstrap
```

If you are not using Intel Mac, please pull [old-mac](https://github.com/niksmac/dotfiles/tree/old-mac) branch

```sh
git clone --single-branch --branch old-mac https://github.com/niksmac/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/install && script/bootstrap
```

If you are using Ubuntu, please pull [ubuntu](https://github.com/niksmac/dotfiles/tree/ubuntu) branch

```sh
git clone --single-branch --branch ubuntu https://github.com/niksmac/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/install && script/bootstrap
```

This will symlink the appropriate files in `.dotfiles` to your home directory.
Everything is configured and tweaked within `~/.dotfiles`.

The main file you'll want to change right off the bat is `zsh/zshrc.symlink`, which sets up a few paths that'll be different on your particular machine.

## Upgrade

Upgrade can be done in 2 ways

### 1. Manual

You can update the dotfiles by manually going into your `~/.dotfiles` and pulling latest updates

```sh
cd ~/.dotfiles

# Commit your local changes if any
gac "Ref: my local changes"

# Pull latest changes
git pull

# Update
script/install && script/bootstrap
```

### 2. Using `dot`

`dot` is a simple script that installs some dependencies, sets sane OS X defaults, and so on. Tweak this script, and occasionally run `dot` from time to time to keep your environment fresh and up-to-date. You can find this script in `bin/`.

> However it will not update the `dotfiles` itself from the origin-master

### Topical

Everything's built around topic areas. If you're adding a new area to your forked dotfiles — say, "Java" — you can simply add a `java` directory and put files in there. Anything with an extension of `.zsh` will get automatically included into your shell. Anything with an extension of `.symlink` will get symlinked without extension into `$HOME` when you run `script/bootstrap`.

### Blocking ads/tracking websites

Run `./script/hostsinit` to modify your hosts files so that you don't see any ads like ever. Thanks to [StevenBlack/hosts](https://github.com/StevenBlack/hosts)

### components

There's a few special files in the hierarchy.

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made
  available everywhere.
- **topic/\*.zsh**: Any files ending in `.zsh` get loaded into your
  environment.
- **topic/path.zsh**: Any file named `path.zsh` is loaded first and is
  expected to setup `$PATH` or similar.
- **topic/completion.zsh**: Any file named `completion.zsh` is loaded
  last and is expected to setup autocomplete.
- **topic/\*.symlink**: Any files ending in `*.symlink` get symlinked into
  your `$HOME`. This is so you can keep all of those versioned in your dotfiles
  but still keep those autoloaded files in your home directory. These get
  symlinked in when you run `script/bootstrap`.
