#!/bin/bash
# Stop / Notification: when Claude runs in Neovim's terminal (claudecode.nvim,
# sidekick), $NVIM is that Neovim's RPC socket. Hand the event to lua/review.lua
# in the nvim config: on Stop it reloads the buffers Claude edited and queues the
# new hunks for review, on Notification it shows Claude's message.
# Run it async: a Neovim sitting at a prompt answers RPC only once the prompt
# is dismissed, and Claude shouldn't wait for that.
set -euo pipefail

[ -n "${NVIM:-}" ] || exit 0
input=$(cat)
case $(jq -r '.hook_event_name' <<<"$input") in
Stop) expr="v:lua.require'review'.claude_stopped()" ;;
Notification)
  # a JSON string literal is also a valid Vimscript string literal
  msg=$(jq '.message // "Claude needs your attention"' <<<"$input")
  expr="v:lua.require'review'.claude_notified($msg)"
  ;;
*) exit 0 ;;
esac
# --remote-expr prints the (empty) result; errors still reach stderr. nvim exits
# 2 on a failed connection, which a Stop hook would read as "keep working", so
# report every failure as exit 1: a non-blocking error.
nvim --server "$NVIM" --remote-expr "$expr" >/dev/null || exit 1
