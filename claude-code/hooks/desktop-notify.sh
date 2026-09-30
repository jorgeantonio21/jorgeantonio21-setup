#!/bin/bash
# Notification: put Claude's message on the desktop when it is waiting on you.
# macOS uses osascript, Linux uses notify-send when a display is available;
# anywhere else (a headless host over SSH) this is a no-op rather than an error.
set -euo pipefail

msg=$(jq -r '.message // "Claude needs your attention"')
case $(uname -s) in
Darwin)
  osascript -e 'on run argv' -e 'display notification (item 1 of argv) with title "Claude Code"' -e 'end run' "$msg"
  ;;
Linux)
  [ -n "${DISPLAY:-}${WAYLAND_DISPLAY:-}" ] || exit 0
  command -v notify-send >/dev/null 2>&1 || exit 0
  notify-send "Claude Code" "$msg"
  ;;
esac
