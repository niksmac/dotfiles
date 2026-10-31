# The everyday shortcuts (ga, gb, gc, gco, gcb, gd, gl, glog, gp, …) come from
# oh-my-zsh's git plugin, loaded by zplug in zshrc after this file, so
# anything defined here under those names would be overridden.
# Only aliases the plugin doesn't provide belong here.

alias gs='git status -sb'
alias gac='git add -A && git commit -m'
alias gec='git commit --allow-empty -m "ci: Another Empty Commit"'

# Every remote at once
alias pushall='for i in `git remote`; do git push $i; done;'
alias pullall='for i in `git remote`; do git pull $i; done;'

# Create a local tracking branch for every remote branch, then pull them all
alias gll='git fetch --all && git branch -r | grep -v "\->" | while read remote; do git branch --track "${remote#origin/}" "$remote" 2>/dev/null; done && git pull --all'
