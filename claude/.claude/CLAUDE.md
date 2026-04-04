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

## CLI Tools (globally installed)
- `amazon-cli` — Browse Amazon products, compare, generate add-to-cart URLs. Source: `~/src/amazon-cli/`
- `bosch-cli` — Control Bosch Home Connect appliances over local network. Source: `~/src/bosch-cli/`
- `crawler-cli` — Agent-friendly web browsing via crawl4ai. Source: `~/src/crawler-cli/`
- `finance-cli` — Stock quotes, news, portfolio via Schwab API. Source: `~/src/finance-cli/`
- `lowes-cli` — Browse Lowe's products, search, manage shopping carts. Source: `~/src/lowes-cli/`
- `maps-cli` — Google Maps directions, places, family locations. Source: `~/src/maps-cli/`
- `realtor-cli` — Property search and watchlists from realtor.com. Source: `~/src/realtor-cli/`

Run with `--help` for usage. Source repos are in `~/src/`. Rebuild with `npm link` from source dir.

## Code Style
- Prefer standard library and minimal dependencies over adding packages.

## Workflow
- Don't include AI co-author attribution in commits or PRs.
- Commit messages: imperative mood, concise subject line, body only when the "why" isn't obvious.
- Don't commit unless explicitly asked.
