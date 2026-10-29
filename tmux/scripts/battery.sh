#!/usr/bin/env bash
# Prints battery icon + percentage for the tmux status bar (Linux and macOS).
if [ "$(uname -s)" = "Darwin" ]; then
  out=$(pmset -g batt 2>/dev/null)
  pct=$(printf '%s' "$out" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')
  [ -z "$pct" ] && exit 0
  case "$out" in
    *"AC Power"*) [ "$pct" -ge 100 ] && status="Full" || status="Charging" ;;
    *)            status="Discharging" ;;
  esac
else
  bat=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -1)
  [ -z "$bat" ] && exit 0
  pct=$(<"$bat/capacity")
  status=$(<"$bat/status")
fi
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
