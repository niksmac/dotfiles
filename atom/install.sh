#!/usr/bin/env bash

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

info "Installing Atom plugins"

ATMCOM='apm'

if ! apm check; then
  ATMCOM='apm-beta'
fi

$ATMCOM install --packages-file "${HOME}/.dotfiles/atom/package-list.txt"

yes | rm "${HOME}/.atom/config.cson"
ln -s "${HOME}/.dotfiles/atom/config.cson" "${HOME}/.atom/config.cson"

info "Installed Atom plugins"

exit 0
