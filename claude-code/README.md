# Claude Code

Configuration for the [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI. Includes 8 custom domain-specialist agents, slash commands (fix-issue, review-pr, merge-dependabot), 7 domain skills, safety hooks that block dangerous operations (rm -rf, force-push to main), a custom statusline, and MCP server integrations.

## Prerequisites

- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) installed

## What's included

| File            | Description                                    |
|-----------------|------------------------------------------------|
| `CLAUDE.md`     | Global instructions and coding standards       |
| `settings.json` | Agents, slash commands, skills, hooks, MCP servers |
| `statusline.sh` | Custom prompt statusline script                |
| `hooks/`        | Hook scripts for the Neovim review flow        |

## Manual install

```sh
cd claude-code
chmod +x install.sh
./install.sh
```

This symlinks configuration files to `~/.claude/` where Claude Code expects them.

## Neovim

The [`nvim/`](../nvim) config talks to Claude Code over the same IDE protocol as the VS Code and
JetBrains extensions via claudecode.nvim, with keymaps under `<leader>a`. See
[nvim/README.md](../nvim/README.md#claude-code).

The hooks in `hooks/` feed that config's review flow: `git-intent-to-add.sh` (PostToolUse on
`Write`) makes files Claude creates visible to `git diff`, and `nvim-notify.sh` (Stop and
Notification, async) tells the Neovim that Claude runs in when a turn ends or Claude is waiting on
you. See [Reviewing agent changes](../nvim/README.md#reviewing-agent-changes).
