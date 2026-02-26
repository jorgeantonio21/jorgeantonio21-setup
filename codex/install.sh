#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"
TARGET_DIR="$HOME/.codex"

echo "Installing codex config..."

mkdir -p "$TARGET_DIR"

FILES=("AGENTS.md" "config.toml")
for file in "${FILES[@]}"; do
    target="$TARGET_DIR/$file"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "Backing up $target to ${target}.bak.${TIMESTAMP}"
        mv "$target" "${target}.bak.${TIMESTAMP}"
    fi
    ln -sf "$SCRIPT_DIR/$file" "$target"
    echo "Symlinked $SCRIPT_DIR/$file -> $target"
done

target="$TARGET_DIR/agents"
if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "Backing up $target to ${target}.bak.${TIMESTAMP}"
    mv "$target" "${target}.bak.${TIMESTAMP}"
fi
ln -sf "$SCRIPT_DIR/agents" "$target"
echo "Symlinked $SCRIPT_DIR/agents -> $target"

echo ""
echo "WARNING: config.toml may contain environment variable placeholders."
echo "Ensure the following env vars are set before using codex:"
echo "  Check $SCRIPT_DIR/config.toml for \${...} placeholders and set them in your shell."

echo "Done."
