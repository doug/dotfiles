
# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
if [[ -s $HOME/.aliases.zsh ]]; then
    source $HOME/.aliases.zsh
fi

# Increase the max number of files
ulimit -n 1024

# keep the emacs start and end of line even if in vi-mode
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# don't use cdablevars
unsetopt cdablevarS


if [[ -s $HOME/.zshrc.local ]]; then
    source $HOME/.zshrc.local
fi

