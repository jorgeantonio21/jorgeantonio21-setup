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

DIRS=("agents" "commands" "skills")
for dir in "${DIRS[@]}"; do
    target="$TARGET_DIR/$dir"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "Backing up $target to ${target}.bak.${TIMESTAMP}"
        mv "$target" "${target}.bak.${TIMESTAMP}"
    fi
    ln -sf "$SCRIPT_DIR/$dir" "$target"
    echo "Symlinked $SCRIPT_DIR/$dir -> $target"
done

# Other tools keep their own scripts in ~/.claude/hooks, so link each hook
# script on its own instead of replacing the directory. A hooks directory that
# an earlier install left as a symlink is replaced by a real one first.
HOOKS_DIR="$TARGET_DIR/hooks"
if [ -L "$HOOKS_DIR" ]; then
    rm "$HOOKS_DIR"
fi
mkdir -p "$HOOKS_DIR"
for hook in "$SCRIPT_DIR"/hooks/*.sh; do
    target="$HOOKS_DIR/$(basename "$hook")"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "Backing up $target to ${target}.bak.${TIMESTAMP}"
        mv "$target" "${target}.bak.${TIMESTAMP}"
    fi
    ln -sf "$hook" "$target"
    echo "Symlinked $hook -> $target"
done

echo "Done."
