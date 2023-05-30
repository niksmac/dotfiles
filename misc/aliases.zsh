#!/bin/sh

# Jekyll Awesomeness
alias js='jekyll clean && jekyll serve'
alias jb='jekyll build'
alias jsf='jekyll clean && jekyll serve --future'

alias c='clear'
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias tree='tree -I node_modules'

alias v='vim'
alias speed='open https://fast.com'
alias ta='tmux a'
alias lockme='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'

# create password
alias genpass='pwgen 18 1 --numerals 3 --symbols 3 --secure | pbcopy | echo "Password copied to clipboard"'

# NVM
alias loadnvm='[ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh" && nvm use'
alias brewit='brew update && brew upgrade && brew cleanup'

alias pushall='for i in `git remote`; do git push $i; done;'
alias pullall='for i in `git remote`; do git pull $i; done;'

alias spoofmac='sudo ifconfig en0 ether $(openssl rand -hex 6 | sed "s%\(..\)%\1:%g; s%.$%%")'

# Code beautify
alias prettify="prettier --write '**/*.{ts,js,jsx,css,html}'"

# Confirm before overwriting something
alias cp="cp -i"

# Human-readable sizes
alias df='df -h']

# Show sizes in MB
alias free='free -m'

# Flush DNS cache
alias flushdns="sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder"


## Start projects

# - react
alias projr="open . && code . && yarn start"
# - fastify
alias projf="open . && code . && yarn dev"


## Generate secret key

alias genkey="node -e  \"console.log(require('crypto').randomBytes(256).toString('base64'));\""

alias thefuck='fuck'

alias ff="open -n -a Firefox.app --args -no-remote -P"

## Add code alias
alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
