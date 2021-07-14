#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."

  # Install the correct homebrew for each OS type
  if test "$(uname)" = "Darwin"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"
  fi

fi

# Install the correct homebrew for each OS type
if test "$(uname)" = "Darwin"
then
  # Install homebrew packages
  brew install zsh zsh-completions grc coreutils spark tmux youtube-dl the_silver_searcher vim node wget git tree tor highlight git-flow wrk zplug
  # Tap cask
  brew tap homebrew/cask
  # Install cask items
  brew install --cask flux transmission vlc gpg-suite iterm2 brave-browser
elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
then
  # Install homebrew packages
  brew install grc spark tmux youtube-dl the_silver_searcher vim node tree tor pre-commit
fi

# Disable analytics https://docs.brew.sh/Analytics
brew analytics off
exit 0
