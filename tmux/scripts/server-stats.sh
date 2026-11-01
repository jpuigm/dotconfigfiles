#!/usr/bin/env bash
# Host, load, memory and disk pills for the tmux status bar (Linux and macOS).
# The host pill is always shown; load/memory/disk only on machines WITHOUT a battery
# (servers, mini), since laptops already have those in the desktop bar.
# Set TMUX_STATS=1 to force output anyway (for testing).

has_battery() {
  if [ "$(uname -s)" = "Darwin" ]; then
    pmset -g batt 2>/dev/null | grep -q InternalBattery
  else
    ls /sys/class/power_supply/BAT* >/dev/null 2>&1
  fi
}
# color for a percentage: grey, orange from $2, red from $3
color() {
  if   [ "$1" -ge "$3" ]; then echo "#bf616a"
  elif [ "$1" -ge "$2" ]; then echo "#d08770"
  else echo "brightblack"; fi
}
pill() { printf '#[fg=white,bg=%s,bold] %s #[default]' "$1" "$2"; }

# host
pill "#5e81ac" "$(hostname -s)"

# laptops stop here
[ -z "$TMUX_STATS" ] && has_battery && exit 0

# load (1 min), orange above core count, red above twice that
if [ "$(uname -s)" = "Darwin" ]; then
  cores=$(sysctl -n hw.ncpu)
  load=$(sysctl -n vm.loadavg | awk '{print $2}')
else
  cores=$(nproc)
  load=$(cut -d' ' -f1 /proc/loadavg)
fi
lpct=$(awk -v l="$load" -v c="$cores" 'BEGIN{printf "%d", l/c*100}')
pill "$(color "$lpct" 100 200)" "L $load"

# memory used %
if [ "$(uname -s)" = "Darwin" ]; then
  vm=$(vm_stat)
  psize=$(printf '%s' "$vm" | grep -Eo 'page size of [0-9]+' | grep -Eo '[0-9]+')
  pages=$(printf '%s' "$vm" | awk '/Pages active|Pages wired down|occupied by compressor/ {gsub(/\./,"",$NF); s+=$NF} END{print s}')
  total=$(sysctl -n hw.memsize)
  mpct=$(awk -v p="$pages" -v s="$psize" -v t="$total" 'BEGIN{printf "%d", p*s/t*100}')
else
  mpct=$(awk '/MemTotal/{t=$2} /MemAvailable/{a=$2} END{printf "%d", (t-a)/t*100}' /proc/meminfo)
fi
pill "$(color "$mpct" 85 95)" "M $mpct%"

# disk used % on /
dpct=$(df -P / | awk 'NR==2{gsub(/%/,"",$5); print $5}')
pill "$(color "$dpct" 80 90)" "D $dpct%"
