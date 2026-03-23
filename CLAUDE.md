# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repo for macOS and Linux. Shell is zsh. Configs are symlinked into `$HOME` using GNU stow.

## Key Commands

- **Full setup**: `bash install.sh` (interactive, prompts for each section)
- **Symlink configs**: `cd ~/.dotfiles && stow bash vim tmux` (each arg is a stow package directory)
- **Add a new stow package**: Create `<name>/<path-relative-to-home>` then `stow <name>`

## Architecture

- Each top-level directory is a GNU stow package — its contents mirror `$HOME` structure
- `posix/` contains shell configs: `.zshrc`, `.bashrc`, `.bash_profile`, `.commonrc`
- `.zshrc` requires `fzf`, `starship`, and `zoxide` to be installed (hard fails otherwise)
- `.commonrc` is sourced by both zsh and bash — shared aliases, PATH, and functions live there
- `git/.gitconfig` includes `~/.gitconfig.local` for machine-specific user/email/credentials
- `install.sh` is interactive (y/N prompts) and handles: OS defaults, Homebrew, packages, language toolchains (Go, Rust, Node via nvm), stow symlinks, fonts, git identity, and tmux plugin manager
- Rust is installed via rustup (not brew), nvm via curl on Linux / brew on macOS, Go via package manager

## Notable Conventions

- macOS casks (GUI apps): google-chrome, vscodium, ghostty
- `.commonrc` still references `$HOME/.homebrew` (legacy path) — modern Homebrew is at `/opt/homebrew`
- `.commonrc` has an `ag`-based `fcode` function that should be updated to use `rg` (ripgrep replaced ag)
- `.commonrc` aliases `vim` to `nvim` if available, but neovim is no longer installed by default
