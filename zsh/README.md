# Zsh

Zsh shell configuration. Sets up Homebrew, adds Rust/Cargo to PATH, defines Python 3.12 aliases, enables Terraform completions, configures the Oh My Posh prompt, and loads zsh-autosuggestions.

## Prerequisites

- [Homebrew](https://brew.sh/) installed
- [oh-my-posh](https://ohmyposh.dev/) installed (`brew install oh-my-posh`)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) installed (`brew install zsh-autosuggestions`)

## What's included

| File        | Description                          |
|-------------|--------------------------------------|
| `.zshrc`    | Main shell config (plugins, aliases, prompt) |
| `.zshenv`   | Environment variables loaded by all shells   |
| `.zprofile` | Login shell setup (Homebrew PATH)            |

## Manual install

```sh
cd zsh
chmod +x install.sh
./install.sh
```

This symlinks `.zshrc`, `.zshenv`, and `.zprofile` to your home directory (`~/`).
