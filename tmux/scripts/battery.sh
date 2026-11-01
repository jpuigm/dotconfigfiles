#!/usr/bin/env bash
# Prints battery icon + time remaining (or time to full when charging) for the tmux status bar (Linux and macOS).
# Falls back to the percentage when no estimate is available. Red below 20% while discharging.
eta=""   # minutes
if [ "$(uname -s)" = "Darwin" ]; then
  out=$(pmset -g batt 2>/dev/null)
  pct=$(printf '%s' "$out" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')
  [ -z "$pct" ] && exit 0
  case "$out" in
    *"AC Power"*) [ "$pct" -ge 100 ] && status="Full" || status="Charging" ;;
    *)            status="Discharging" ;;
  esac
  hm=$(printf '%s' "$out" | grep -Eo '[0-9]+:[0-9]+ remaining' | grep -Eo '^[0-9]+:[0-9]+')
  [ -n "$hm" ] && [ "$hm" != "0:00" ] && eta=$(( 10#${hm%%:*} * 60 + 10#${hm##*:} ))
else
  bat=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -1)
  [ -z "$bat" ] && exit 0
  pct=$(<"$bat/capacity")
  status=$(<"$bat/status")
  # batteries report either energy/power (µWh/µW) or charge/current (µAh/µA); the ratio is the same
  if [ -r "$bat/energy_now" ]; then
    now=$(<"$bat/energy_now"); full=$(<"$bat/energy_full"); rate=$(<"$bat/power_now")
  elif [ -r "$bat/charge_now" ]; then
    now=$(<"$bat/charge_now"); full=$(<"$bat/charge_full"); rate=$(<"$bat/current_now")
  fi
  if [ "${rate:-0}" -gt 0 ]; then
    case "$status" in
      Discharging) eta=$(( now * 60 / rate )) ;;
      Charging)    eta=$(( (full - now) * 60 / rate )) ;;
    esac
  fi
fi
case "$status" in
  Charging) icon="⚡" ;;
  Full)     icon="🔌" ;;
  *)        icon="🔋" ;;
esac
if [ "$status" = "Full" ]; then
  label="Full"
elif [ -n "$eta" ]; then
  label=$(printf '%dh%02dm' $(( eta / 60 )) $(( eta % 60 )))
else
  label="$pct%"
fi
if [ "$pct" -lt 20 ] && [ "$status" != "Charging" ]; then
  bg="#bf616a"   # red
else
  bg="brightblack"   # grey, same as the date/time
fi
echo "#[fg=white,bg=$bg,bold] $icon $label "
