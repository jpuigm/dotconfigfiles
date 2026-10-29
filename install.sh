#!/usr/bin/env bash
# Symlink the files in this repo into $HOME.
# Idempotent: correct links are left alone, anything else is moved to <name>.bak-<timestamp>.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d%H%M%S)"

# repo path (relative to this dir) -> target path (relative to $HOME)
LINKS=(
  "emacs/init.el:.emacs.d/init.el"
  "emacs/erlang.el:.emacs.d/erlang.el"
  "tmux/tmux.conf:.tmux.conf"
  "tmux/scripts:.tmux/scripts"
  "zsh/zshrc:.zshrc"
  "bash/bashrc:.bashrc"
  "bash/profile:.profile"
  "git/gitconfig:.gitconfig"
  "claude/settings.json:.claude/settings.json"
  "claude/statusline-capture.sh:.claude/statusline-capture.sh"
)

for entry in "${LINKS[@]}"; do
  src="$REPO/${entry%%:*}"
  dst="$HOME/${entry##*:}"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "ok       $dst"
    continue
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mv -v "$dst" "$dst.bak-$STAMP"
  fi
  ln -sv "$src" "$dst"
done

# tmux plugin manager; plugins themselves are installed with prefix + I
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
