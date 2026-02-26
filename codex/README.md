# Codex

Configuration for the [OpenAI Codex CLI](https://github.com/openai/codex). Includes custom agents mirroring Claude Code's specialist agents and MCP server integrations for Context7, Exa, Slack, Telegram, and Notion.

**Note:** `config.toml` uses environment variable placeholders. Set the following in your environment before use:

- `EXA_API_KEY`
- `SLACK_BOT_TOKEN`
- `SLACK_TEAM_ID`
- `TELEGRAM_BOT_TOKEN`

## Prerequisites

- [Codex CLI](https://github.com/openai/codex) installed

## What's included

| File          | Description                               |
|---------------|-------------------------------------------|
| `AGENTS.md`   | Custom specialist agent definitions       |
| `config.toml` | MCP server integrations and settings      |

## Manual install

```sh
cd codex
chmod +x install.sh
./install.sh
```

This symlinks configuration files to `~/.codex/` where the Codex CLI expects them.
