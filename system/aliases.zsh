# General-purpose aliases. Topic-specific ones live with their topic
# (git/aliases.zsh), and shell functions are autoloaded from functions/.

# Shell
alias reload!='exec zsh'
alias c='clear'
alias python=python3

# ls: GNU flags, via coreutils' `gls` on macOS (`brew install coreutils`)
if $(gls &>/dev/null)
then
  alias ls="gls -F --color"
  alias l="gls -lAh --color"
  alias ll="gls -l --color"
  alias la='gls -A --color'
elif ls --color -d . &>/dev/null  # GNU ls (Linux) has the same flags
then
  alias ls="ls -F --color"
  alias l="ls -lAh --color"
  alias ll="ls -l --color"
  alias la='ls -A --color'
fi

# Files & disk
alias cp="cp -i" # confirm before overwriting something
alias df='df -h'
alias tree='tree -I node_modules'
if [ "$IS_LINUX" = true ]; then
  alias free='free -m' # no `free` on macOS
fi

# Network
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
if [ "$IS_MAC" = true ]; then
  alias speed='open https://fast.com'
else
  alias speed='xdg-open https://fast.com'
fi

# Keys & secrets (copied to the clipboard via bin/clip)
alias pubkey="clip < ~/.ssh/id_(ed25519|rsa).pub(N[1]) && echo '=> Public key copied to pasteboard.'"
alias genpass='pwgen 36 1 --numerals 6 --symbols 5 | tr -d "<,>\`^%" | cut -c 1-18 | clip'
alias genkey="node -e  \"console.log(require('crypto').randomBytes(256).toString('base64'));\""

# Editors & tools
alias v='vim'
alias z='zed .'
if [ "$IS_MAC" = true ]; then
  alias code='/Applications/Zed.app/Contents/MacOS/zed'
else
  alias code='zed'
fi
alias ta='tmux a'
alias oc='opencode'
alias occ='opencode --continue'
alias hs='hermes --tui'
alias hsc='hermes --tui --continue'
alias brewit='brew update && brew upgrade && brew cleanup'
alias prettify="prettier --write '**/*.{ts,js,jsx,css,html}'"
if [ "$IS_MAC" = true ]; then
  alias ff="open -n -a Firefox.app --args -no-remote -P"
else
  alias ff="firefox --no-remote -P"
fi

# Metadata
alias meta_clean='exiftool -all= -overwrite_original'

# macOS only
if [ "$IS_MAC" = true ]; then
  alias lockme='pmset displaysleepnow' # locks when "require password" is on
  alias ios="open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"
  alias xattr_clean='xattr -d com.apple.metadata:kMDItemWhereFroms'
  alias spoofmac='sudo ifconfig en0 ether $(openssl rand -hex 6 | sed "s%\(..\)%\1:%g; s%.$%%")'
fi
