# Variables used by exteneral editors etc
# or that need to be available to
# gui programs should be set in zshenv

# Go
export GOPATH=$HOME/.go:$HOME/go:$HOME/.gogae

# skip compinit
skip_global_compinit=1

# Local overrides
if [[ -s $HOME/.zshenv.local ]]; then
  source $HOME/.zshenv.local
fi

