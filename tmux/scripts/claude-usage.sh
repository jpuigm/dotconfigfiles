#!/usr/bin/env bash
# Usage: claude-usage.sh five_hour|seven_day
# Reads the rate-limit snapshot written by ~/.claude/statusline-capture.sh.
# Base color per window (blue/purple); orange from 70%, red from 90%.
case "$1" in
  five_hour) label="5h"; base="#88c0d0" ;;
  *)         label="7d"; base="#b48ead" ;;
esac
f="$HOME/.cache/claude-usage.json"
pct=$(jq -r --arg k "$1" '.rate_limits[$k].used_percentage // empty | round' "$f" 2>/dev/null)
if [ -z "$pct" ]; then
  echo "#[fg=#2e3440,bg=$base,bold] $label --% "
  exit 0
fi
bg=$base
[ "$pct" -ge 70 ] && bg="#d08770"
[ "$pct" -ge 90 ] && bg="#bf616a"
echo "#[fg=#2e3440,bg=$bg,bold] $label $pct% "
