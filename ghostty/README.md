# Ghostty

Terminal emulator configuration for [Ghostty](https://ghostty.org/). Sets up the Catppuccin Mocha color scheme, JetBrainsMono Nerd Font, semi-transparent background with blur, and a block cursor style.

## Prerequisites

- [Ghostty](https://ghostty.org/) installed
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com/) installed

## What's included

| File     | Description                                      |
|----------|--------------------------------------------------|
| `config` | Ghostty configuration (theme, font, transparency, cursor) |

## Manual install

```sh
cd ghostty
chmod +x install.sh
./install.sh
```

This symlinks the config file to Ghostty's expected location (`~/.config/ghostty/config`).
