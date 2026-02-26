# tmux

tmux configuration with the Catppuccin theme, TPM plugin manager, session persistence via tmux-resurrect and tmux-continuum, fzf-url for URL picking, mouse support, and the status bar positioned at the top.

## Prerequisites

- [tmux](https://github.com/tmux/tmux) installed
- TPM (Tmux Plugin Manager):
  ```sh
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  ```

## What's included

| File         | Description           |
|--------------|-----------------------|
| `.tmux.conf` | Main tmux configuration |

## Manual install

```sh
cd tmux
chmod +x install.sh
./install.sh
```

This symlinks `.tmux.conf` to `~/.tmux.conf`. After launching tmux, press `prefix + I` to install plugins via TPM.
