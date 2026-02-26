# Neovim

NvChad v2.5-based Neovim configuration. Uses the Onedark color theme and is tuned for Rust development with rustaceanvim, DAP debugging, and crates.nvim. Includes git integration via fugitive, diffview, and gitsigns. LSP support out of the box, with conform.nvim for formatting and stylua for Lua files.

## Prerequisites

- [Neovim](https://neovim.io/) >= 0.10
- A [Nerd Font](https://www.nerdfonts.com/) installed and set in your terminal
- [ripgrep](https://github.com/BurntSushi/ripgrep) for Telescope live grep

## What's included

| File/Dir       | Description                              |
|----------------|------------------------------------------|
| `init.lua`     | Entry point, loads NvChad and custom config |
| `.stylua.toml` | stylua formatter settings for Lua files  |
| `lua/`         | Custom plugins, LSP, keymaps, and overrides |

## Manual install

```sh
cd nvim
chmod +x install.sh
./install.sh
```

This symlinks the nvim directory to `~/.config/nvim`. On first launch, Neovim will automatically install plugins via lazy.nvim.
