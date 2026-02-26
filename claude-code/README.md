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

## Manual install

```sh
cd claude-code
chmod +x install.sh
./install.sh
```

This symlinks configuration files to `~/.claude/` where Claude Code expects them.
