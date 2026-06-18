dotfiles
========

everybody has one, these are mine.

macOS (Apple Silicon) and Linux. Shell is zsh; editor is neovim. Core setup is
zsh + tmux + neovim + ghostty + yazi + mosh, with i3 on Linux. Version control is
git and jj (jujutsu).

Configs are symlinked into `$HOME` with GNU stow — each top-level directory is a
stow package that mirrors the `$HOME` layout.

## Install

Interactive setup (prompts for each section: OS defaults, packages, toolchains,
symlinks, fonts, git identity):

```
bash install.sh
```

Or symlink packages by hand:

```
cd ~/.dotfiles
stow zsh vim tmux git ghostty claude gemini yazi ssh   # both platforms
stow i3 linux conky                                     # Linux only
```

Force past conflicts: `stow --adopt <packages>` then `git checkout -- <packages>`.

## Local overrides

Machine-specific settings stay out of git via local include files:
`~/.gitconfig.local`, `~/.ssh/config.local`, `~/.vimrc.local`, `~/.localrc`.

## tmux

After stowing, install the plugin manager and plugins:

```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then open tmux and press `prefix + I` to install the configured plugins.
