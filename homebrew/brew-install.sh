#!/bin/bash

# Disable analytics before doing anything else
brew analytics off

# Function to install a package if not already installed
install_if_not_present() {
  if ! brew list "$1" &>/dev/null; then
    echo "Installing $1..."
    brew install "$1"
  else
    echo "$1 is already installed, skipping."
  fi
}

# Function to install a cask if not already installed
install_cask_if_not_present() {
  if ! brew list --cask "$1" &>/dev/null; then
    echo "Installing cask $1..."
    brew install --cask "$1"
  else
    echo "Cask $1 is already installed, skipping."
  fi
}

# Common packages for all platforms
COMMON_PACKAGES=(
  git
  tmux
  vim
  node
  tree
  yt-dlp # Modern replacement for youtube-dl
  ripgrep # Faster alternative to ag/the_silver_searcher
  fd # Better alternative to find
  bat # Better cat
  zsh
)

# macOS specific packages
MACOS_PACKAGES=(
  coreutils
  grc
  git-flow-avh
  wrk
  imagemagick
  ffmpeg
)

# macOS cask apps
MACOS_CASKS=(
  iterm2
  firefox
  discord
  telegram
  keepingyouawake
)

if [ "$(uname)" = "Darwin" ]; then
  echo "Installing macOS packages..."

  # Install common and macOS-specific packages
  for pkg in "${COMMON_PACKAGES[@]}" "${MACOS_PACKAGES[@]}"; do
    install_if_not_present "$pkg"
  done

  # Install casks
  for cask in "${MACOS_CASKS[@]}"; do
    install_cask_if_not_present "$cask"
  done

elif [ "$(uname)" = "Linux" ]; then
  echo "Installing Linux packages..."

  # Install common packages
  for pkg in "${COMMON_PACKAGES[@]}"; do
    install_if_not_present "$pkg"
  done
fi

exit 0
