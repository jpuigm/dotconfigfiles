#!/usr/bin/env bash
# Prints battery icon + percentage for the tmux status bar.
bat=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -1)
[ -z "$bat" ] && exit 0
pct=$(<"$bat/capacity")
status=$(<"$bat/status")
case "$status" in
  Charging) icon="⚡" ;;
  Full)     icon="🔌" ;;
  *)        icon="🔋" ;;
esac
if [ "$pct" -lt 20 ] && [ "$status" != "Charging" ]; then
  bg="#bf616a"   # red
else
  bg="brightblack"   # grey, same as the date/time
fi
echo "#[fg=white,bg=$bg,bold] $icon $pct% "
