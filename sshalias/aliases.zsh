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

# Jekyll Awesomeness
alias jkserve='jekyll clean && jekyll serve'
alias jkbuild='jekyll build'
alias jkbuildp='jekyll build --destination /Users/niksmac/iWork/projects/niksmac.github.io'

# Drupal coding standards phpcs
alias drupalcs="phpcs --standard=Drupal --extensions='php,module,inc,install,test,profile,theme,js,css,info,txt'"
