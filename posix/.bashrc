#!/usr/bin/env bash

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Unified history
shopt -s histappend
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# Set up fzf key bindings and fuzzy completion
source <(fzf --bash)

# Set up zoxide to move between folders efficiently
eval "$(zoxide init bash)"

# Set up the Starship prompt
eval "$(starship init bash)"

# Shared posix configurations valid for both zsh and bash.
[ -f ~/.commonrc ] && source ~/.commonrc

# User-specific local configurations.
[ -f ~/.localrc ] && source ~/.localrc

