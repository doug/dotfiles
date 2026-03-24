# Global Instructions

## Environment
- macOS (Apple Silicon) primary, Linux secondary. Both must be considered.
- Shell is zsh. No bash-specific or fish syntax.
- Editor is neovim (aliased as vim).

## Language & Tool Preferences
- Python: use `uv` for package management, virtual environments, and builds. Not pip, pipenv, or poetry.
- Node: use `nvm` for version management.
- Containers: use `podman` and `podman-compose`, not docker.
- Search: use `rg` (ripgrep), not grep or ag.
- Git: default branch is `main`, pull with rebase, merge with diff3 conflict style.

## Code Style
- Prefer standard library and minimal dependencies over adding packages.

## Workflow
- Don't include AI co-author attribution in commits or PRs.
- Commit messages: imperative mood, concise subject line, body only when the "why" isn't obvious.
- Don't commit unless explicitly asked.
