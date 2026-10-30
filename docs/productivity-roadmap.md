# Productivity roadmap

Ideas for making tmux (and the surrounding setup) better for a developer/operator
working with Claude and reaching home servers remotely from the X1 laptop.
Tick items off as they get implemented.

## Done

- [x] Right status bar: battery (red below 20%), Claude 5h and 7d usage (orange from 70%, red from 90%), date and time
- [x] Claude Code status line captures rate limits for tmux (`claude/statusline-capture.sh`)

## Staying connected on the go

- [ ] **Tailscale** for private access to the home servers, no port forwarding; MagicDNS so `ssh homeserver` works anywhere
- [ ] **Mosh** for roaming between Wi-Fi and tethering and for surviving sleep; run it with tmux on the server (mosh has no scrollback, tmux provides it)
- [ ] **SSH config**: `ControlMaster auto` + `ControlPersist 10m`, `ServerAliveInterval 30`, host aliases
- [ ] **Auto-attach** helper, e.g. `s() { ssh -t "$1" 'tmux new -As main'; }`, so every connection lands in the same session
- [ ] **Wake-on-LAN** keybinding to wake a sleeping home server

## Local and remote tmux together

- [ ] **Nested tmux**: a key such as F12 that turns the local tmux off so keys reach the remote one (or a different prefix on servers)
- [ ] **Per-host name and color** in the status bar, production in red
- [ ] **Clipboard over SSH**: `set -g set-clipboard on` (OSC52) to copy from a remote pane to the laptop clipboard

## Working with Claude

- [ ] Run Claude Code on the server inside tmux; after a dropped connection reconnect and use `claude --continue`
- [ ] **Parallel agents**: one `git worktree` per pane, one Claude session each
- [ ] **Finish alerts**: Claude Code `Stop` / `Notification` hook that flags the tmux window or sends a phone push via ntfy.sh
- [ ] **Pipe context to Claude**: a binding like `tmux capture-pane -p | claude -p "explain this error"`; `display-popup` for lazygit, btop or a scratch Claude prompt

## Operator workflow

- [ ] **Layout scripts**: a one-key "homelab" layout (`htop`, `journalctl -f`, `docker logs -f`) with tmuxp or a shell script
- [ ] **`synchronize-panes`** to type once and run on several servers
- [ ] **Remote health in the bar**: home server load/uptime and a VPN indicator

## Plugins to try

- [ ] `tmux-fzf` or `sesh` for fuzzy session switching
- [ ] `tmux-thumbs` or `tmux-fingers` to copy IPs, hashes and paths with hints
- [ ] `extrakto` to pull text out of scrollback
- [ ] `vim-tmux-navigator`, if Vim keys are in use

## Quick wins for `tmux/tmux.conf`

- [ ] `default-terminal` to `tmux-256color` plus RGB overrides, so Nord colors render properly
- [ ] `history-limit` around 50000 and `focus-events on`
- [ ] vi copy mode; split with `|` and `-` in the current directory
- [ ] Binding to reload `~/.tmux.conf`
- [ ] Enable the `C-a` prefix (currently commented out)

## Suggested order

1. Tailscale + mosh + auto-attach helper
2. Claude finish alerts
3. The quick wins above
