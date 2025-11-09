#!/bin/sh


alias c='clear'
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias tree='tree -I node_modules'

alias v='vim'
alias z='zed .'
alias speed='open https://fast.com'
alias ta='tmux a'
alias lockme='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'

# create password
alias genpass='pwgen 36 1 --numerals 6 --symbols 5 | tr -d "<,>\`^%" | cut -c 1-18 | pbcopy | echo "Password copied to clipboard"'

# NVM
alias loadnvm='[ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh" && nvm use'
alias brewit='brew update && brew upgrade && brew cleanup'

alias pushall='for i in `git remote`; do git push $i; done;'
alias pullall='for i in `git remote`; do git pull $i; done;'
alias gll='git fetch --all && git branch -r | grep -v "\->" | while read remote; do git branch --track "${remote#origin/}" "$remote" 2>/dev/null; done && git pull --all'

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
alias code='/Applications/Zed.app/Contents/MacOS/zed'

## Remove metadata
alias meta_clean='exiftool -all= -overwrite_original'
alias xattr_clean='xattr -d com.apple.metadata:kMDItemWhereFroms'


# Best size/quality with album art:
# - Keeps original YouTube codec (Opus or AAC) to avoid re-encode.
# - Embeds thumbnail as cover art (works well for .m4a and .opus).
# - Converts thumbnail to JPG for player compatibility.
# - Adds metadata and fixes missing Album from Artist.
# - Accepts optional format parameter (e.g., mp3, m4a, opus)

ydla() {
  # Check if first argument is a format specification
  local format="best"
  if [ $# -gt 0 ] && [[ "$1" =~ ^(mp3|m4a|opus|aac|flac|wav)$ ]]; then
    format="$1"
    shift
  fi

  yt-dlp -f ba -S "acodec:opus,abr" \
    --extract-audio \
    --audio-format "$format" \
    --audio-quality 0 \
    --write-thumbnail \
    --convert-thumbnails jpg \
    --embed-thumbnail \
    --add-metadata \
    --restrict-filenames \
    --no-overwrites \
    --no-post-overwrites \
    --download-archive ".ydla-archive.txt" \
    -o "%(title)s-%(id)s.%(ext)s" "$@"

  # Pick the newest audio file
  file=$(ls -t -- *.mp3 *.m4a *.opus *.webm *.ogg *.aac *.flac *.wav 2>/dev/null | head -n1) || true
  [ -f "$file" ] || return 0

  # If it's Opus inside .webm/.ogg, remux to .opus with no re-encode (only if format is "best")
  if [ "$format" = "best" ]; then
    codec=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$file")
    if [ "$codec" = "opus" ] && [[ "$file" =~ \.(webm|ogg)$ ]]; then
      out="${file%.*}.opus"
      ffmpeg -hide_banner -loglevel error -y -i "$file" -c copy "$out" \
        && touch -r "$file" "$out" \
        && rm -f "$file" \
        && file="$out"
    fi
  fi

  # Fill Album with Artist if Album is missing
  album=$(exiftool -s3 -Album "$file")
  artist=$(exiftool -s3 -Artist "$file")
  if [ -z "$album" ] && [ -n "$artist" ]; then
    exiftool -overwrite_original "-Album=$artist" "$file" >/dev/null
  fi
}

alias ydla=ydla
