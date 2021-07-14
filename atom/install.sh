#!/usr/bin/env bash

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

info "Installing Atom plugins"

ATMCOM='atom'

if ! apm check; then
  ATMCOM='atom-beta'
fi

## Install custom pakcages
git clone git@github.com:niksmac/atom-tailwindcss-2.git ~/.dotfiles/atom/atom-tailwindcss2
cd ~/.dotfiles/atom/atom-tailwindcss2
yarn
yarn build
$ATMCOM install
$ATMCOM link .
cd -

$ATMCOM install --packages-file "${HOME}/.dotfiles/atom/package-list.txt"

## To get the current package list use `apm-beta|apm list --installed --bare`

yes | rm "${HOME}/.atom/config.cson"
ln -sf "${HOME}/.dotfiles/atom/config.cson" "${HOME}/.atom/config.cson"

info "Installed Atom plugins"

exit 0
