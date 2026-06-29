# Lightrains Tech dotfiles

Your dotfiles are how you personalize your system.

If you're interested in the philosophy behind why projects like these are awesome, you might want to read a post on the subject.

## Install

```sh
git clone https://github.com/niksmac/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/install && script/bootstrap
```

This works on macOS and Ubuntu. Each installer only runs when the script detects the matching OS.

## Upgrade

Update the dotfiles manually by going into your `~/.dotfiles` and pulling latest updates.

```sh
cd ~/.dotfiles
git pull
script/install && script/bootstrap
```

## Topical

Everything's built around topic areas. If you're adding a new area to your forked dotfiles — say, "Java" — you can simply add a `java` directory and put files in there. Anything with an extension of `.zsh` will get automatically included into your shell. Anything with an extension of `.symlink` will get symlinked without extension into `$HOME` when you run `script/bootstrap`.

## components

There's a few special files in the hierarchy.

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made available everywhere.
- **topic/\*.zsh**: Any files ending in `.zsh` get loaded into your environment.
- **topic/path.zsh**: Any file named `path.zsh` is loaded first and is expected to setup `$PATH` or similar.
- **topic/completion.zsh**: Any file named `completion.zsh` is loaded last and is expected to setup autocomplete.
- **topic/\*.symlink**: Any files ending in `.symlink` get symlinked into your `$HOME`. This is so you can keep all of those versioned in your dotfiles but still keep those autoloaded files in your home directory. These get symlinked in when you run `script/bootstrap`.
