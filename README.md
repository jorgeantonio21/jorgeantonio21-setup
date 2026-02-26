# dotfiles

Personal development environment configuration for macOS.

## Tools

| Folder | Tool | Description |
|--------|------|-------------|
| `ghostty/` | Ghostty | Terminal emulator -- Catppuccin Mocha, transparent background |
| `tmux/` | tmux | Multiplexer -- TPM plugins, session persistence, Catppuccin theme |
| `nvim/` | Neovim | NvChad v2.5 -- Rust development, DAP debugging, git integration |
| `claude-code/` | Claude Code | AI CLI -- custom agents, commands, skills, safety hooks |
| `codex/` | Codex | AI CLI -- custom agents, MCP servers |
| `nushell/` | Nushell | Shell -- default v0.110 config |
| `zsh/` | Zsh | Shell -- Homebrew, Cargo, Oh My Posh prompt |
| `themes/` | Oh My Posh | Prompt theme -- shared across shells |

## Install

Each folder is independently installable. There is no top-level install script.

```
cd <folder> && bash install.sh
```

Run the install script inside whichever folder you need. Each script symlinks or copies its configuration to the expected location.

## Prerequisites

- macOS
- [Homebrew](https://brew.sh)
- A [Nerd Font](https://www.nerdfonts.com) (JetBrainsMono recommended)
