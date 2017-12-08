#!/usr/bin/env bash
#
# VIM

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

info "Installing vim-plug for you!"


curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

exit 0
