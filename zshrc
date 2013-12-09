# Detect os
export PLATFORM=`uname`

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Add home bin
PATH=$HOME/bin:$PATH
# Go
export GOPATH=$HOME/.go:$HOME/go:$HOME/.gogae
PATH=$HOME/.go/bin:$HOME/go/bin:$PATH

export EDITOR=vim
export VISUAL=$EDITOR
if [[ "$PLATFORM" == "Darwin" ]]; then
    # Homebrew
    export HOMEBREW_PREFIX=$HOME/.homebrew
    PATH=$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH
    # GO
    #export GOBIN=$HOMEBREW_PREFIX/bin
    export GOARCH=amd64
    export GOOS=darwin
    # Ruby
    export PATH=$PATH:$HOME/.rvm/bin
    # pkg-config
    export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOMEBREW_PREFIX/lib:$HOMEBREW_PREFIX/include
    # npm
    export NODE_PATH=$HOMEBREW_PREFIX/lib/node
    PATH=$HOMEBREW_PREFIX/share/npm/bin:$PATH
    # compile path
    export C_INCLUDE_PATH=$C_INCLUDE_PATH:$HOMEBREW_PREFIX/include
    export CPP_INCLUDE_PATH=$CPP_INCLUDE_PATH:$HOMEBREW_PREFIX/include
    export LIBRARY_PATH=$LIBRARY_PATH:$HOMEBREW_PREFIX/lib
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOMEBREW_PREFIX/lib
    # python
    PATH=$HOMEBREW_PREFIX/share/python:$PATH
    # ruby
    PATH=$HOMEBREW_PREFIX/opt/ruby/bin:$PATH
    if (( $+commands[brew] )); then
      # GO
      export GOROOT=`brew --prefix go`/libexec
    fi
    if (( $+commands[npm] )); then
      # npm
      export NODE_PATH=$NODE_PATH:`npm root -g`
    fi
elif [[ "$PLATFORM" == "Linux" ]]; then
    # Go
    export GOARCH=amd64
    export GOOS=linux
    # Path
    PATH=/opt/local/bin:$PATH
fi



# Add Google Cloud SDK
if [[ -s $HOME/bin/google-cloud-sdk ]]; then
  CLOUD_SDK=$HOME/bin/google-cloud-sdk
  PATH=$PATH:$CLOUD_SDK/bin
  PATH=$PATH:$CLOUD_SDK/platform/google_appengine_go_amd64
  PATH=$PATH:$CLOUD_SDK/platform/google_appengine
fi

# Add Dart SDK
if [[ -s $HOME/bin/dart-sdk ]]; then
  export DART_SDK=$HOME/bin/dart-sdk
  PATH=$PATH:$DART_SDK/bin
fi

# Add Android tools
if [[ -s $HOME/bin/android ]]; then
  PATH=$PATH:$HOME/bin/android/tools:$HOME/bin/android/platform-tools
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

if [[ -s $HOME/.pyenv ]] then
  PATH=$HOME/.pyenv/bin:$PATH
  eval "$(pyenv init -)"
fi

if [[ -s $HOME/.rvm/scripts/rvm ]] then
  source $HOME/.rvm/scripts/rvm
fi

if [[ -s $HOME/.nvm/nvm.sh ]]; then
    source $HOME/.nvm/nvm.sh
fi

if [[ -s $HOME/.zshrc.local ]]; then
    source $HOME/.zshrc.local
fi

# Export the PATH
export PATH
