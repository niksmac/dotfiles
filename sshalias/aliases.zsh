# This file carries all the SSH aliases with password, so this file should be
# kept out of public

# Usage

# RSA keypair
# Well, you know it. On OSX you can use this https://github.com/beautifulcode/ssh-copy-id-for-OSX


# The rest of our fun ssh aliases
alias sshpegke='ssh root@128.199.76.62'
alias sshlight='ssh light@192.168.27.100'
alias sshksum='ssh root@192.168.52.211'
alias sshgodady='ssh ligh5599@118.139.175.1'
alias sshether='ssh root@192.168.27.101'
alias ssheth='ssh root@37.139.31.106'

# Jekyll Awesomeness
alias jkserve='jekyll clean && jekyll serve'
alias jkbuild='jekyll build'

alias c='clear'
alias yd='youtube-dl'
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias tree='tree -I node_modules'

alias copyssh="pbcopy < $HOME/.ssh/id_rsa.pub"
alias v='nvim'
