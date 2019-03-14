# Skip if not interactive
[[ -o interactive ]] || return

# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update
fi

# Essential
source ~/.zplug/init.zsh

HISTFILE=~/.zsh_history

#zplug "mafredri/zsh-async", from:"github", use:"async.zsh"
zplug "denysdovhan/spaceship-prompt"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-completions"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"
# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"
# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

COMPLETION_WAITING_DOTS="true"

SPACESHIP_CHAR_SYMBOL="≡≡ "
SPACESHIP_USER_SHOW="needed"
SPACESHIP_HG_SHOW="true"
SPACESHIP_HG_BRANCH_SHOW="false"
SPACESHIP_NODE_SHOW="false"
# PURE_GIT_DOWN_ARROW="v"
# PURE_GIT_UP_ARROW="^"
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE="true"
setopt HIST_FIND_NO_DUPS
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
setopt interactivecomments

setopt PROMPT_SUBST

HISTSIZE=10000000
SAVEHIST=10000000

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    else
        echo
    fi
fi

zplug load

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f ~/.commonrc ] && source ~/.commonrc

[ -f ~/.localrc ] && source ~/.localrc
