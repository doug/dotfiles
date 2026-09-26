# - - - - - - - - - - - - - - - - - - - -
# Environment (loaded for ALL zsh invocations)
# - - - - - - - - - - - - - - - - - - - -

typeset -U path fpath

# Homebrew (equivalent to `brew shellenv`, without spawning brew on every shell)
if [[ -d /opt/homebrew ]]; then
  export HOMEBREW_PREFIX=/opt/homebrew
  export HOMEBREW_CELLAR=$HOMEBREW_PREFIX/Cellar
  export HOMEBREW_REPOSITORY=$HOMEBREW_PREFIX
  export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH:-}"
  export HOMEBREW_NO_ANALYTICS=1
  path=($HOMEBREW_PREFIX/bin $HOMEBREW_PREFIX/sbin $path)
  fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath)
fi

# Golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Local bins
export PATH=$HOME/.local/bin:$HOME/bin:$PATH

# Rust
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Editor
if (( $+commands[nvim] )); then
  export EDITOR=nvim
else
  export EDITOR=vim
fi
export VISUAL=$EDITOR

# Podman
export PODMAN_COMPOSE_PROVIDER_NO_WARNING=1
