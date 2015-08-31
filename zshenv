# Variables used by exteneral editors etc
# or that need to be available to
# gui programs should be set in zshenv

# Go
export GOPATH=$HOME/.go:$HOME/go

# skip compinit
skip_global_compinit=1

if [[ "$OSTYPE" == darwin* ]]; then
    # Homebrew
    export HOMEBREW_PREFIX=$HOME/.homebrew
    PATH=$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH
    # GO
    #export GOBIN=$HOMEBREW_PREFIX/bin
    export GOARCH=amd64
    export GOOS=darwin
    # Ruby
    PATH=$PATH:$HOME/.rvm/bin
    # pkg-config
    export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOMEBREW_PREFIX/lib:$HOMEBREW_PREFIX/include
    # compile path
    export C_INCLUDE_PATH=$C_INCLUDE_PATH:$HOMEBREW_PREFIX/include
    export CPP_INCLUDE_PATH=$CPP_INCLUDE_PATH:$HOMEBREW_PREFIX/include
    export LIBRARY_PATH=$LIBRARY_PATH:$HOMEBREW_PREFIX/lib
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOMEBREW_PREFIX/lib
    # ruby
    export PATH=$HOMEBREW_PREFIX/opt/ruby/bin:$PATH
elif [[ "$OSTYPE" == linux* ]]; then
    # Go
    export GOARCH=amd64
    export GOOS=linux
    export CGO_LDFLAGS="-Wl,-rpath,/usr/local/lib"
    # Path
    export PATH=/opt/local/bin:$PATH
fi

# Local overrides
if [[ -s $HOME/.zshenv.local ]]; then
  source $HOME/.zshenv.local
fi

