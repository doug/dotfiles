# - - - - - - - - - - - - - - - - - - - -
# Login shells (after /etc/zprofile, before .zshrc)
# - - - - - - - - - - - - - - - - - - - -

# macOS's /etc/zprofile runs path_helper, which moves system dirs ahead of
# Homebrew; put Homebrew back in front.
if [[ -d /opt/homebrew ]]; then
  path=(/opt/homebrew/bin /opt/homebrew/sbin $path)
fi

# Machine-specific login settings
[[ -f ~/.zprofile.local ]] && source ~/.zprofile.local
