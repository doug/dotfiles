# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repo for macOS and Linux. Shell is zsh. Configs are symlinked into `$HOME` using GNU stow.

## Key Commands

- **Full setup**: `bash install.sh` (interactive, prompts for each section)
- **Symlink configs**: `cd ~/.dotfiles && stow zsh vim tmux git` (each arg is a stow package directory)
- **Add a new stow package**: Create `<name>/<path-relative-to-home>` then `stow <name>`
- **Force stow on conflicts**: `stow --adopt <packages>` then `git checkout -- <packages>`

## Architecture

- Each top-level directory is a GNU stow package — its contents mirror `$HOME` structure
- `zsh/.zshrc` is the main shell config; requires `fzf`, `starship`, and `zoxide`
- `git/.gitconfig` includes `~/.gitconfig.local` for machine-specific user/email/credentials
- `install.sh` is interactive (y/N prompts) and handles: OS defaults, Homebrew, packages, language toolchains (Go, Rust, Node via nvm), stow symlinks, fonts, git identity, and tmux plugin manager

## Stow Packages

Default packages stowed on both platforms: `zsh vim tmux git ghostty claude gemini yazi jj ssh`

Linux-only packages: `i3 linux conky`

The `jj` package ships shared jujutsu config in `jj/.config/jj/config.toml`.
Machine-specific jj identity stays untracked in `~/.config/jj/conf.d/00-identity.toml`
(written by `install.sh`); jj merges that with the shared config.

The `claude` package's `CLAUDE.md` imports `~/.claude/CLAUDE.local.md` for
machine-specific instructions (local tools, VMs, network details). That file stays
untracked; keep anything personal there, since this repo is public.
`settings.json` has no include mechanism, so keep it free of machine-specific
blocks such as `autoMode.environment`.

## Tool Installation

- Rust: rustup (not brew)
- Node: nvm (brew on macOS, curl script on Linux)
- Go: package manager (brew on macOS, apt/pacman on Linux)
- jj: cargo on Linux, brew on macOS
- podman-compose: installed via `uv tool install`

## Tmux

After stowing tmux config, install tpm and press `prefix + I` to install plugins:
```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
