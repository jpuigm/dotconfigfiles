#!/usr/bin/env bash
# Claude Code statusLine command: saves the session JSON for tmux, prints a short line.
in=$(cat)
printf '%s' "$in" > "$HOME/.cache/claude-usage.json.tmp" && mv "$HOME/.cache/claude-usage.json.tmp" "$HOME/.cache/claude-usage.json"
echo "$in" | jq -r '"\(.model.display_name // "claude")"'
