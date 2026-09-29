#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TIMESTAMP="$(date +%Y%m%d%H%M%S)"

# Skill source trees, searched recursively for SKILL.md. The first is this
# repo's own skills; the rest are separate checkouts (see README for the clone
# commands). A missing source is skipped with a warning, not an error.
MATPOCOCK_SKILLS="${MATPOCOCK_SKILLS:-$HOME/dev/matpocock-skills}"
SOURCE_DIRS=("$SCRIPT_DIR" "$MATPOCOCK_SKILLS/skills")

# Every harness below discovers a skill as an immediate subdirectory holding a
# SKILL.md, so each skill is linked individually rather than linking the whole
# directory. Codex materializes its own bundled skills into .system/ inside its
# skills directory, and ~/.agents/skills is shared with any other agent that
# follows the Agent Skills convention -- neither can be replaced wholesale.
#
#   ~/.claude/skills   Claude Code
#   ~/.codex/skills    Codex CLI (>= 0.153, `skill_search` feature)
#   ~/.agents/skills   pi (harness-neutral location, scanned with no config)
TARGET_DIRS=("$HOME/.claude/skills" "$HOME/.codex/skills" "$HOME/.agents/skills")

echo "Installing skills..."

names=()
srcs=()
roots=()

# Prune roots cover every configured source, resolved or not: a link is stale
# precisely when its source tree is gone, so the roots list cannot be built
# from the sources that happen to exist right now.
for source_dir in "${SOURCE_DIRS[@]}"; do
    if [ -d "$source_dir" ]; then
        roots+=("$(cd "$source_dir" && pwd)")
    else
        roots+=("$source_dir")
    fi
done

for source_dir in "${SOURCE_DIRS[@]}"; do
    if [ ! -d "$source_dir" ]; then
        echo ""
        echo "WARNING: skill source $source_dir not found -- skipping."
        echo "Clone it with:"
        echo "  git clone https://github.com/jorgeantonio21/matpocock-skills $MATPOCOCK_SKILLS"
        continue
    fi

    count=0
    while IFS= read -r -d '' skill_md; do
        src="$(cd "$(dirname "$skill_md")" && pwd)"
        name="$(basename "$src")"

        # Flat namespace across every source: a duplicate name would silently
        # shadow one skill with another depending on link order.
        for i in $(seq 0 $((${#names[@]} - 1))); do
            if [ "${names[$i]}" = "$name" ]; then
                echo "error: duplicate skill name '$name'" >&2
                echo "  ${srcs[$i]}" >&2
                echo "  $src" >&2
                echo "Rename one of them and re-run." >&2
                exit 1
            fi
        done

        names+=("$name")
        srcs+=("$src")
        count=$((count + 1))
    done < <(find "$source_dir" -name SKILL.md -not -path '*/node_modules/*' -not -path '*/deprecated/*' -print0 | sort -z)

    echo "  $count skills from $source_dir"
done

if [ "${#names[@]}" -eq 0 ]; then
    echo "No skills found in any source." >&2
    exit 1
fi

echo "Linking ${#names[@]} skills into ${#TARGET_DIRS[@]} directories."

for target_dir in "${TARGET_DIRS[@]}"; do
    echo ""
    echo "-> $target_dir"

    # An older install may have symlinked the whole directory.
    if [ -L "$target_dir" ]; then
        if [ -e "$target_dir" ]; then
            echo "Backing up $target_dir to ${target_dir}.bak.${TIMESTAMP}"
            mv "$target_dir" "${target_dir}.bak.${TIMESTAMP}"
        else
            echo "Removing dangling symlink $target_dir"
            rm "$target_dir"
        fi
    fi

    mkdir -p "$target_dir"

    # Drop links left by a previous run whose skill has since been renamed,
    # removed, or had its source checkout deleted. Only links pointing into a
    # known source tree are touched.
    for existing in "$target_dir"/*; do
        [ -L "$existing" ] || continue
        [ -e "$existing" ] && continue
        link="$(readlink "$existing")"
        for root in "${roots[@]}"; do
            case "$link" in
                "$root"/*)
                    rm "$existing"
                    echo "Removed stale symlink $existing"
                    break
                    ;;
            esac
        done
    done

    for i in $(seq 0 $((${#names[@]} - 1))); do
        name="${names[$i]}"
        src="${srcs[$i]}"
        target="$target_dir/$name"

        if [ -e "$target" ] && [ ! -L "$target" ]; then
            echo "Backing up $target to ${target}.bak.${TIMESTAMP}"
            mv "$target" "${target}.bak.${TIMESTAMP}"
        fi
        ln -sfn "$src" "$target"
    done

    echo "Linked ${#names[@]} skills."
done

echo ""
echo "Done. Restart any running claude, codex, or pi session to pick up the skills."
