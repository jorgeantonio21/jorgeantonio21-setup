#!/bin/bash
# PostToolUse(Write): a file Claude creates is untracked, so `git diff` and every
# hunk-based review tool skip it. Intent-to-add lists it as one all-added hunk
# without staging its content. Tracked, ignored, and non-git files are left alone.
set -euo pipefail

file=$(jq -r '.tool_input.file_path // empty')
[ -f "$file" ] || exit 0
cd "$(dirname "$file")"
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
git ls-files --error-unmatch -- "$file" >/dev/null 2>&1 && exit 0
git check-ignore -q -- "$file" && exit 0
git add --intent-to-add -- "$file"
