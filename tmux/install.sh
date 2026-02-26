#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"
TARGET_FILE="$HOME/.tmux.conf"

echo "Installing tmux config..."

if [ -e "$TARGET_FILE" ] && [ ! -L "$TARGET_FILE" ]; then
    echo "Backing up existing config to ${TARGET_FILE}.bak.${TIMESTAMP}"
    mv "$TARGET_FILE" "${TARGET_FILE}.bak.${TIMESTAMP}"
fi

ln -sf "$SCRIPT_DIR/.tmux.conf" "$TARGET_FILE"
echo "Symlinked $SCRIPT_DIR/.tmux.conf -> $TARGET_FILE"

if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo ""
    echo "WARNING: TPM (Tmux Plugin Manager) is not installed."
    echo "Install it with:"
    echo "  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"
    echo "Then press prefix + I inside tmux to install plugins."
fi

echo "Done."
