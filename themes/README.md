# Themes

[Oh My Posh](https://ohmyposh.dev/) prompt theme configuration. A minimal prompt with purple and green chevrons, current path, git branch indicator, error status, and time display. Shared across shells (Zsh, Nushell, etc.).

## Prerequisites

- [oh-my-posh](https://ohmyposh.dev/) installed (`brew install oh-my-posh`)
- A [Nerd Font](https://www.nerdfonts.com/) installed and set in your terminal

## What's included

| File              | Description                     |
|-------------------|---------------------------------|
| `oh-my-posh.json` | Oh My Posh theme definition    |

## Manual install

```sh
cd themes
chmod +x install.sh
./install.sh
```

This symlinks the theme file to `~/.config/oh-my-posh/` or the location referenced by your shell config.
