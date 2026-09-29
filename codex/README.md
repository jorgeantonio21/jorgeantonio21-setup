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

## Neovim

The [`nvim/`](../nvim) config runs Codex in a side split via sidekick.nvim, with keymaps under
`<leader>o` for sending the current file, a visual selection, or the function at the cursor. See
[nvim/README.md](../nvim/README.md#codex).

## Skills

Skills live in the top-level [`skills/`](../skills) folder because they are shared with Claude Code and pi. That folder also pulls in the matpocock-skills fork. Install them separately:

```sh
cd ../skills && ./install.sh
```

That links each skill into `~/.codex/skills`, alongside the bundled `.system/` skills Codex manages itself. Skill discovery needs the `skill_search` feature, which is on by default -- check with `codex features list | grep skill`.
