# Neovim

NvChad v2.5-based Neovim configuration. Uses the Onedark color theme and is tuned for Rust development with rustaceanvim, DAP debugging, and crates.nvim. Includes git integration via fugitive, diffview, and gitsigns, and AI CLI integration for Claude Code and Codex. LSP support out of the box, with conform.nvim for formatting and stylua for Lua files.

## Prerequisites

- [Neovim](https://neovim.io/) >= 0.11.2 (required by sidekick.nvim)
- A [Nerd Font](https://www.nerdfonts.com/) installed and set in your terminal
- [ripgrep](https://github.com/BurntSushi/ripgrep) for Telescope live grep
- The [`claude`](https://claude.com/claude-code) CLI on `PATH` for the Claude Code integration
- The [`codex`](https://github.com/openai/codex) CLI on `PATH` for the Codex integration

## What's included

| File/Dir       | Description                              |
|----------------|------------------------------------------|
| `init.lua`     | Entry point, loads NvChad and custom config |
| `.stylua.toml` | stylua formatter settings for Lua files  |
| `lua/`         | Custom plugins, LSP, keymaps, and overrides |

## Claude Code

[coder/claudecode.nvim](https://github.com/coder/claudecode.nvim) implements the same WebSocket
IDE protocol as Anthropic's official VS Code and JetBrains extensions, so Claude sees the buffer
you are in and the text you have selected, and its edits arrive as diffs you accept or reject in
Neovim rather than as writes behind your back. It is lazy-loaded on the `<leader>a` maps and the
`:ClaudeCode*` commands, and starts the `claude` CLI in a split on the right.

| Keymap        | Mode   | Action                          |
|---------------|--------|---------------------------------|
| `<leader>ac`  | n      | Toggle the Claude split         |
| `<leader>af`  | n      | Focus Claude                    |
| `<leader>ar`  | n      | Resume a previous session       |
| `<leader>aC`  | n      | Continue the last session       |
| `<leader>am`  | n      | Pick a model                    |
| `<leader>ab`  | n      | Add the current buffer as context |
| `<leader>as`  | v      | Send the visual selection       |
| `<leader>as`  | n      | Add the file under the cursor (in nvim-tree) |
| `<leader>aa`  | n      | Accept the proposed diff        |
| `<leader>ad`  | n      | Reject the proposed diff        |
| `<leader>ax`  | n      | Close all pending diffs         |
| `<leader>aS`  | n      | Show connection status          |

If `claude` lives outside `PATH` (for example a local install at `~/.claude/local/claude`), set
`terminal_cmd` in the plugin spec in `lua/plugins/init.lua`.

## Codex

[folke/sidekick.nvim](https://github.com/folke/sidekick.nvim) runs the Codex TUI in a split on the
right and pushes context into it. Codex has no IDE protocol like the one Claude Code exposes, so
this is a context-aware terminal rather than a diff-review integration: there is nothing to accept
or reject in Neovim, Codex owns its own approval flow. `cli.watch` reloads any buffer Codex edits
on disk.

Next edit suggestions are turned off (`nes.enabled = false`) because they need a GitHub Copilot
subscription and would otherwise take over `<Tab>`.

| Keymap        | Mode   | Action                                    |
|---------------|--------|-------------------------------------------|
| `<leader>oo`  | n      | Toggle the Codex split                    |
| `<leader>of`  | n      | Send the current file                     |
| `<leader>ov`  | v      | Send the visual selection                 |
| `<leader>ot`  | n, v   | Send "this" -- the function or class at the cursor |
| `<leader>op`  | n, v   | Pick a prompt (review, fix, tests, diagnostics, ...) |
| `<leader>od`  | n      | Close the Codex session                   |
| `<leader>os`  | n      | Switch to another AI CLI (claude, gemini, pi, ...) |

sidekick supports every CLI it knows about, so `<leader>os` reaches Gemini, pi, opencode and the
rest without extra config. To keep Codex sessions alive across Neovim restarts, uncomment the
`mux` line in the plugin spec -- it parks the session in a tmux pane.

## Manual install

```sh
cd nvim
chmod +x install.sh
./install.sh
```

This symlinks the nvim directory to `~/.config/nvim`. On first launch, Neovim will automatically install plugins via lazy.nvim.
