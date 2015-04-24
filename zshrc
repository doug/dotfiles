# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="tjkirch"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$HOME/.oh-my-zsh-custom

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
if [[ "$OSTYPE" == darwin* ]]; then
  plugins=(git docker wd autojump history-substring-search extract osx brew)
elif [[ "$OSTYPE" == linux* ]]; then
  plugins=(git docker wd autojump history-substring-search extract)
fi

source $ZSH/oh-my-zsh.sh

# User configuration

# Add home bin
PATH=$HOME/bin:$PATH

# Go
PATH=$HOME/.go/bin:$HOME/go/bin:$PATH

# Docker
if (( $+commands[boot2docker] )); then
  $(boot2docker shellinit 2>/dev/null)
#else
  #DOCKER_HOST=tcp://localhost:2375
  #DOCKER_TLS_VERIFY=1
  #DOCKER_CERT_PATH=$HOME/.docker
  ## /etc/default/docker
  ## DOCKER_OPTS="-d -H unix:///var/run/docker.sock -H tcp://localhost:2375"
fi

# Add Google Cloud SDK
if [[ -s $HOME/bin/google-cloud-sdk ]]; then
  CLOUD_SDK=$HOME/bin/google-cloud-sdk
  source $CLOUD_SDK/completion.zsh.inc
  PATH=$PATH:$CLOUD_SDK/bin:$CLOUD_SDK/platform/google_appengine
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
  export ANDROID_SDK=$HOME/bin/android-sdk/sdk
  PATH=$ANDROID_SDK/platform-tools:$ANDROID_SDK/tools:$PATH
fi

if [[ -s $HOME/.nvm/nvm.sh ]]; then
  source $HOME/.nvm/nvm.sh
fi

if [[ -s $HOME/.pyenv ]] then
  PATH=$HOME/.pyenv/bin:$PATH
  eval "$(pyenv init -)"
fi

if [[ -s $HOME/.rvm/scripts/rvm ]] then
  source $HOME/.rvm/scripts/rvm
fi

# homebrew cask
export HOMEBREW_CASK_OPTS="--caskroom=$HOME/.caskroom --binarydir=$HOME/bin"

# Export the PATH
export PATH

export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  if (( $+commands[vim] )); then
		export EDITOR='vim'
	else
		export EDITOR='vi'
	fi
else
  if [[ $OSTYPE == darwin* ]]; then
    if (( $+commands[subl] )); then
      export EDITOR='subl -w'
    else
      export EDITOR='vim'
    fi
  else
    export EDITOR='vim'
  fi
fi
export VISUAL=$EDITOR

# Autojump
if [[ $OSTYPE == darwin* ]]; then
  [[ -s $HOMEBREW_PREFIX/etc/autojump.sh ]] && . $HOMEBREW_PREFIX/etc/autojump.sh
fi

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# keep the emacs start and end of line even if in vi-mode
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# Aliases
if [[ -s $HOME/.aliases.zsh ]]; then
  source $HOME/.aliases.zsh
fi

# Local overrides
if [[ -s $HOME/.zshrc.local ]]; then
  source $HOME/.zshrc.local
fi



