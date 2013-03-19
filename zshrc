# Detect os
export PLATFORM=`uname`

if [[ "$PLATFORM" == "Darwin" ]]; then
    # Homebrew
    export HOMEBREW_PREFIX=$HOME/.homebrew
    export PATH=$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH
    # GO
    export GOBIN=$HOMEBREW_PREFIX/bin
    export GOARCH=amd64
    export GOOS=darwin
    # pkg-config
    export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOMEBREW_PREFIX/lib:$HOMEBREW_PREFIX/include
    # npm
    export NODE_PATH=$HOMEBREW_PREFIX/lib/node
    export PATH=$HOMEBREW_PREFIX/share/npm/bin:$PATH
    # compile path
    export C_INCLUDE_PATH=$C_INCLUDE_PATH:$HOMEBREW_PREFIX/include
    export CPP_INCLUDE_PATH=$CPP_INCLUDE_PATH:$HOMEBREW_PREFIX/include
    export LIBRARY_PATH=$LIBRARY_PATH:$HOMEBREW_PREFIX/lib
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOMEBREW_PREFIX/lib
    if [[ $+commands[brew] == 1 ]]; then
      # GO
      export GOROOT=`brew --prefix go`
    fi
    if [[ $+commands[npm] == 1 ]]; then
      # npm
      export NODE_PATH=$NODE_PATH:`npm root -g`
    fi
elif [[ "$PLATFORM" == "Linux" ]]; then
    # Go
    export GOARCH=amd64
    export GOOS=linux
    # Path
    export PATH=/opt/local/bin:$PATH
fi

# Add home bin
export PATH=$HOME/bin:$PATH

export EDITOR=vim

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
if [[ -s $HOME/.aliases.zsh ]]; then
    source $HOME/.aliases.zsh
fi

# keep the emacs start and end of line even if in vi-mode
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# don't use cdablevars
unsetopt cdablevarS

if [[ -s $HOME/.localrc ]]; then
    source $HOME/.localrc
fi
