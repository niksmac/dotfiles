#!/bin/sh
#
# Teamocil
#
# Teamocil is a simple tool used to automatically create windows and panes in
# tmux with YAML files.


# Install teamocil gem
gem install teamocil
mkdir -p ~/.teamocil

cp ./tmpanes.yml ~/.teamocil

exit 0
