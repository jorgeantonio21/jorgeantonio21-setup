#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"
TARGET_DIR="$HOME/Library/Application Support/com.mitchellh.ghostty"
TARGET_FILE="$TARGET_DIR/config"

echo "Installing ghostty config..."

mkdir -p "$TARGET_DIR"

if [ -e "$TARGET_FILE" ] && [ ! -L "$TARGET_FILE" ]; then
    echo "Backing up existing config to ${TARGET_FILE}.bak.${TIMESTAMP}"
    mv "$TARGET_FILE" "${TARGET_FILE}.bak.${TIMESTAMP}"
fi

ln -sf "$SCRIPT_DIR/config" "$TARGET_FILE"
echo "Symlinked $SCRIPT_DIR/config -> $TARGET_FILE"

echo "Done."
