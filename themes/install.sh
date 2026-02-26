#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"
TARGET_FILE="$HOME/themes.json"

echo "Installing oh-my-posh theme..."

if [ -e "$TARGET_FILE" ] && [ ! -L "$TARGET_FILE" ]; then
    echo "Backing up existing themes.json to ${TARGET_FILE}.bak.${TIMESTAMP}"
    mv "$TARGET_FILE" "${TARGET_FILE}.bak.${TIMESTAMP}"
fi

ln -sf "$SCRIPT_DIR/oh-my-posh.json" "$TARGET_FILE"
echo "Symlinked $SCRIPT_DIR/oh-my-posh.json -> $TARGET_FILE"

if ! command -v oh-my-posh &>/dev/null; then
    echo ""
    echo "WARNING: oh-my-posh is not installed."
    echo "Install it with:"
    echo "  brew install jandedobbeleer/oh-my-posh/oh-my-posh"
fi

echo "Done."
