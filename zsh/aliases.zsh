alias reload!='. ~/.zshrc'

alias c='clear'
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias tree='tree -I node_modules'

alias v='vim'
alias speed='xdg-open https://fast.com'
alias ta='tmux a'

alias loadnvm='[ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh" && nvm use'

alias pushall='for i in `git remote`; do git push $i; done;'
alias pullall='for i in `git remote`; do git pull $i; done;'

alias prettify="prettier --write '**/*.{ts,js,jsx,css,html}'"

alias cp="cp -i"

alias df='df -h'

alias free='free -m'

alias projr="code . && yarn start"
alias projf="code . && yarn dev"

alias genkey="node -e  \"console.log(require('crypto').randomBytes(256).toString('base64'));\""

if command -v thefuck >/dev/null 2>&1; then
  eval $(thefuck --alias)
fi
