# Neovim

NvChad v2.5-based Neovim configuration. Uses the Onedark color theme and is tuned for Rust development with rustaceanvim, DAP debugging, and crates.nvim. Includes git integration via fugitive, gitsigns, and codediff, a Cursor-style review flow for agent edits, and AI CLI integration for Claude Code, Codex and pi. LSP support out of the box, with conform.nvim for formatting and stylua for Lua files.

## Prerequisites

- [Neovim](https://neovim.io/) >= 0.11.2 (required by sidekick.nvim); 0.12 adds character-level
  highlighting to every diff view
- A C compiler (`cc`): codediff.nvim builds its diff library from source instead of downloading it
- A [Nerd Font](https://www.nerdfonts.com/) installed and set in your terminal
- [ripgrep](https://github.com/BurntSushi/ripgrep) for Telescope live grep
- The [`claude`](https://claude.com/claude-code) CLI on `PATH` for the Claude Code integration
- The [`codex`](https://github.com/openai/codex) CLI on `PATH` for the Codex integration
- The [`pi`](https://github.com/badlogic/pi) CLI with its `pi-nvim` extension (`pi install npm:pi-nvim`) for the pi integration

## What's included

| File/Dir       | Description                              |
|----------------|------------------------------------------|
| `init.lua`     | Entry point, loads NvChad and custom config |
| `.stylua.toml` | stylua formatter settings for Lua files  |
| `lua/`         | Custom plugins, LSP, keymaps, and overrides |

## Claude Code

[coder/claudecode.nvim](https://github.com/coder/claudecode.nvim) implements the same WebSocket
IDE protocol as Anthropic's official VS Code and JetBrains extensions, so Claude sees the buffer
you are in and the text you have selected. In the default permission mode each edit arrives as an
inline diff you accept (`<leader>aa`) or reject (`<leader>ad`) before it is written. In accept-edits
or auto mode (Shift+Tab in Claude) edits land on disk and you review them together afterwards; see
[Reviewing agent changes](#reviewing-agent-changes). It is lazy-loaded on the `<leader>a` maps and
the `:ClaudeCode*` commands, and starts the `claude` CLI in a split on the right.

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

## Reviewing agent changes

Review what Claude or Codex changed after it lands, the way Cursor does. The git index is the
baseline: stage your own work before prompting, and everything left unstaged is the agent's.
Accepting a hunk stages it; rejecting one restores it from the index. `lua/review.lua` holds the
glue.

| Keymap                      | Mode | Action                                                            |
|-----------------------------|------|-------------------------------------------------------------------|
| `<leader>gd`                | n    | Review list of every unstaged hunk: `<Tab>` accepts, `<c-r>` rejects |
| `<leader>go`                | n    | CodeDiff: changed files with `+/-` counts beside a VSCode-style diff |
| `<leader>gh`                | n    | Every unstaged hunk into the quickfix list; `]q` / `[q` walk them across files |
| `<leader>gA`                | n    | Accept all (stage everything)                                     |
| `]h` / `[h`                 | n    | Next / previous hunk in the buffer                                |
| `<leader>hs` / `<leader>hr` | n, v | Accept / reject the hunk, or just the selected lines              |
| `<leader>hp`                | n    | Show the hunk's old lines inline                                  |
| `<leader>ht`                | n    | Toggle line and word highlights for changes in the buffer         |

In CodeDiff, `t` flips between inline and side-by-side, `]c` / `[c` walk hunks and carry on into
the next file, `]f` / `[f` walk files, `-` stages a file, and `g?` lists the rest. Its explorer
refreshes while the agent works. To throw away a whole Claude turn, use Claude's own rewind
(`Esc Esc` or `/rewind`).

Two Claude Code hooks from [`claude-code/hooks`](../claude-code/hooks) close the loop:

- `git-intent-to-add.sh` marks files Claude creates with `git add -N`, so they show up as hunks.
- `nvim-notify.sh` runs when Claude runs inside Neovim. When a turn ends it reloads the buffers
  Claude edited, fills the quickfix list, and reports how many files and hunks are unreviewed.
  Claude's permission prompts show up as notifications.

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

## pi

[carderne/pi-nvim](https://github.com/carderne/pi-nvim) sends context from Neovim into a pi session
that is already running in another terminal. pi's `pi-nvim` extension opens a unix socket under
`/tmp/pi-nvim-sockets/` and the plugin picks the session whose cwd matches yours. Nothing runs inside
Neovim and there is nothing to accept or reject here; review pi's edits with the flow above.

| Keymap        | Mode   | Action                                                        |
|---------------|--------|---------------------------------------------------------------|
| `<leader>p`   | n, v   | Send-to-pi dialog: file, selection or whole buffer plus a prompt |
| `<leader>pp`  | n      | Type a prompt and send it                                     |
| `<leader>pf`  | n      | Send the current file path with a prompt                      |
| `<leader>ps`  | v      | Send the visual selection with a prompt                       |
| `<leader>pb`  | n      | Send the whole buffer with a prompt                           |
| `<leader>pi`  | n      | Check that pi is reachable                                    |
| `<leader>pS`  | n      | List and switch between running pi sessions                   |

## Manual install

```sh
cd nvim
chmod +x install.sh
./install.sh
```

This symlinks the nvim directory to `~/.config/nvim`. On first launch, Neovim will automatically install plugins via lazy.nvim.
