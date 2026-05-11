# Path configuration - cross-platform

# Add local bin
export PATH="$HOME/.local/bin:$HOME/.bin:$PATH"

# System paths (works on both macOS and Linux)
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
export MANPATH="/usr/local/man:$MANPATH"

# Homebrew paths (both macOS and Linuxbrew)
if [ -d "/opt/homebrew/bin" ]; then
  export PATH="/opt/homebrew/bin:$PATH"
fi
if [ -d "$HOME/.linuxbrew/bin" ]; then
  export PATH="$HOME/.linuxbrew/bin:$PATH"
fi
if [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then
  export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
fi
