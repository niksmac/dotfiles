#!/usr/bin/env bash
#
# VIM

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

info "Installing tpm for manage tmux plugins!"

git clone htitps://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

exit 0
