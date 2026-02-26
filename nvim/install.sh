#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"
TARGET_DIR="$HOME/.config/nvim"

echo "Installing nvim config..."

mkdir -p "$HOME/.config"

if [ -d "$TARGET_DIR" ] && [ ! -L "$TARGET_DIR" ]; then
    echo "Backing up existing nvim directory to ${TARGET_DIR}.bak.${TIMESTAMP}"
    mv "$TARGET_DIR" "${TARGET_DIR}.bak.${TIMESTAMP}"
elif [ -L "$TARGET_DIR" ]; then
    rm "$TARGET_DIR"
fi

mkdir -p "$TARGET_DIR"

ITEMS=("init.lua" ".stylua.toml" "lua")
for item in "${ITEMS[@]}"; do
    target="$TARGET_DIR/$item"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "Backing up $target to ${target}.bak.${TIMESTAMP}"
        mv "$target" "${target}.bak.${TIMESTAMP}"
    fi
    ln -sf "$SCRIPT_DIR/$item" "$target"
    echo "Symlinked $SCRIPT_DIR/$item -> $target"
done

echo "Done."
