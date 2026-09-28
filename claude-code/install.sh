#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"
TARGET_DIR="$HOME/.claude"

echo "Installing claude-code config..."

mkdir -p "$TARGET_DIR"

FILES=("CLAUDE.md" "settings.json" "statusline.sh")
for file in "${FILES[@]}"; do
    target="$TARGET_DIR/$file"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "Backing up $target to ${target}.bak.${TIMESTAMP}"
        mv "$target" "${target}.bak.${TIMESTAMP}"
    fi
    ln -sf "$SCRIPT_DIR/$file" "$target"
    echo "Symlinked $SCRIPT_DIR/$file -> $target"
done

DIRS=("agents" "commands" "skills" "hooks")
for dir in "${DIRS[@]}"; do
    target="$TARGET_DIR/$dir"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "Backing up $target to ${target}.bak.${TIMESTAMP}"
        mv "$target" "${target}.bak.${TIMESTAMP}"
    fi
    ln -sf "$SCRIPT_DIR/$dir" "$target"
    echo "Symlinked $SCRIPT_DIR/$dir -> $target"
done

echo "Done."
