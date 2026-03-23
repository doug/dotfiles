# - - - - - - - - - - - - - - - - - - - -
# Environment (loaded for ALL zsh invocations)
# - - - - - - - - - - - - - - - - - - - -

# Homebrew
if [ -d /opt/homebrew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export HOMEBREW_NO_ANALYTICS=1
fi

# Golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Local bins
export PATH=$HOME/.local/bin:$HOME/bin:$PATH

# Rust
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Editor
if command -v code >/dev/null 2>&1; then
  export EDITOR=code
else
  export EDITOR=vim
fi
export VISUAL=$EDITOR

# Podman
export PODMAN_COMPOSE_PROVIDER_NO_WARNING=1
