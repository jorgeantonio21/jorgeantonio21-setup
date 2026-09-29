# dotfiles

Personal development environment configuration for macOS.

## Tools

| Folder | Tool | Description |
|--------|------|-------------|
| `ghostty/` | Ghostty | Terminal emulator -- Catppuccin Mocha, transparent background |
| `tmux/` | tmux | Multiplexer -- TPM plugins, session persistence, Catppuccin theme |
| `nvim/` | Neovim | NvChad v2.5 -- Rust development, git integration, Claude Code, Codex and pi |
| `claude-code/` | Claude Code | AI CLI -- custom agents, commands, safety hooks |
| `codex/` | Codex | AI CLI -- custom agents, MCP servers |
| `skills/` | Claude Code, Codex, pi | Shared agent skills -- 7 local plus the matpocock-skills fork, symlinked into all three |
| `nushell/` | Nushell | Shell -- default v0.110 config |
| `zsh/` | Zsh | Shell -- Homebrew, Cargo, Oh My Posh prompt |
| `themes/` | Oh My Posh | Prompt theme -- shared across shells |

## Install

Each folder is independently installable. There is no top-level install script.

```
cd <folder> && bash install.sh
```

Run the install script inside whichever folder you need. Each script symlinks or copies its configuration to the expected location.

`skills/` is shared: its install script links every skill into `~/.claude/skills`, `~/.codex/skills`, and `~/.agents/skills` (pi), so all three agents see the same set. It also pulls in the [matpocock-skills](https://github.com/jorgeantonio21/matpocock-skills) fork, which must be cloned separately:

```
git clone https://github.com/jorgeantonio21/matpocock-skills ~/dev/matpocock-skills
```

## Prerequisites

- macOS
- [Homebrew](https://brew.sh)
- A [Nerd Font](https://www.nerdfonts.com) (JetBrainsMono recommended)
