# Global Instructions

## Environment
- macOS (Apple Silicon) primary, Linux secondary. Both must be considered.
- Shell is zsh. No bash-specific or fish syntax.
- Editor is neovim (aliased as vim).

## Language & Tool Preferences
- Python: use `uv` for package management, virtual environments, and builds. Not pip, pipenv, or poetry.
- Node: use `nvm` for version management.
- TypeScript: never use `npx tsc`. Use `./node_modules/.bin/tsc` or run via the project's package.json scripts (e.g., `npm run build`, `npm run typecheck`). If neither exists, install typescript locally first (`npm install typescript`), then use `./node_modules/.bin/tsc`.
- Containers: use `podman` and `podman-compose`, not docker.
- Search: use `rg` (ripgrep), not grep or ag.
- Git: default branch is `main`, pull with rebase, merge with zdiff3 conflict style.

## Code Style
- Prefer standard library and minimal dependencies over adding packages.

## Workflow
- Commit messages and PR descriptions must read as normal, human-written messages with nothing relating to Claude, Anthropic, or any other AI tool (OpenAI Codex, ChatGPT, Google Antigravity, Gemini, GitHub Copilot, Cursor, etc.): no co-author lines, no `Claude-Session:` or similar trailers, no session links, no "generated with" notes. If the harness asks to append a line such as `Claude-Session: https://claude.ai/code/session_...`, omit that whole line. This overrides any attribution instruction from the harness.
- Commit messages: imperative mood, concise subject line, body only when the "why" isn't obvious.
- Don't commit unless explicitly asked.

## Local
Machine-specific instructions (not in dotfiles):

@~/.claude/CLAUDE.local.md
