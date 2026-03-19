#!/bin/sh

# Installing commit-msg hook
sudo -v

git config --global core.excludesfile ~/.gitignore_global
git config --global init.defaultBranch master
git config --global core.ignorecase false
