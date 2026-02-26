#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"
TARGET_DIR="$HOME"

echo "Installing zsh config..."

FILES=(".zshrc" ".zshenv" ".zprofile")
for file in "${FILES[@]}"; do
    target="$TARGET_DIR/$file"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "Backing up $target to ${target}.bak.${TIMESTAMP}"
        mv "$target" "${target}.bak.${TIMESTAMP}"
    fi
    ln -sf "$SCRIPT_DIR/$file" "$target"
    echo "Symlinked $SCRIPT_DIR/$file -> $target"
done

echo "Done."
