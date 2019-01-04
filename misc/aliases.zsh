#!/bin/sh

# Jekyll Awesomeness
alias js='jekyll clean && jekyll serve'
alias jb='jekyll build'
alias jsf='jekyll clean && jekyll serve --future'

alias c='clear'
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias tree='tree -I node_modules'

alias v='vim'
alias speed='speed-test'
alias ta='tmux a'
alias epi='elm package install'
alias lockme='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'

# youtube-dl
alias ydv='youtube-dl -i -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" --ignore-errors '
# alias yda='youtube-dl -x -i --audio-format mp3 --ignore-errors '
alias yda='youtube-dl -f bestaudio[ext=m4a] --embed-thumbnail --add-metadata '

# create password
alias genpass='LC_ALL=C tr -dc "[:alpha:][:alnum:]" < /dev/urandom | head -c 20 | pbcopy | echo "Password copied to clipboard"'

# NVM
alias loadnvm='[ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh" && nvm use'
alias brewit='brew update && brew upgrade && brew cleanup'
