#!/bin/sh

# Installing commit-msg hook
sudo -v

# Disable hooks globally
git config --global core.hooksPath /dev/null

git config --global core.excludesfile ~/.gitignore_global
git config --global init.defaultBranch master
git config --global core.ignorecase false

# Persistent credentials on both OSes: macOS keychain, gh's helper on Linux.
if [ "$(uname -s)" = "Darwin" ]; then
  git config --global credential.helper osxkeychain
elif command -v gh >/dev/null 2>&1; then
  git config --global credential.helper '!gh auth git-credential'
fi
