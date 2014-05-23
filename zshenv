#
# Defines environment variables.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

# Detect os
export PLATFORM=`uname`

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
    export CGO_LDFLAGS="-Wl,-rpath,/usr/local/lib"
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

# Add NaCl SDK
if [[ -s $HOME/bin/nacl-sdk ]]; then
  export NACL_SDK=$HOME/bin/nacl-sdk
  PATH=$NACL_SDK:$PATH
fi

# Add Android tools
if [[ -s $HOME/bin/android-sdk ]]; then
  PATH=$PATH:$HOME/bin/android-sdk/sdk/platform-tools:$HOME/bin/android-sdk/sdk/tools
fi

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

# Export the PATH
export PATH

