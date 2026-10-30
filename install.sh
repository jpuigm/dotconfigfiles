#!/usr/bin/env bash
# Symlink the files in this repo into $HOME (Linux and macOS).
# Idempotent: correct links are left alone, anything else is moved to <name>.bak-<timestamp>.
# With --check, only report links that are missing or no longer point into this repo (exit 1 if any).
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d%H%M%S)"

OS="$(uname -s)"

# repo path (relative to this dir) -> target path (relative to $HOME)
LINKS=(
  "emacs/init.el:.emacs.d/init.el"
  "emacs/erlang.el:.emacs.d/erlang.el"
  "tmux/tmux.conf:.tmux.conf"
  "tmux/scripts:.tmux/scripts"
  "zsh/zshrc:.zshrc"
  "git/gitconfig:.gitconfig"
  "claude/settings.json:.claude/settings.json"
  "claude/statusline-capture.sh:.claude/statusline-capture.sh"
  "claude/CLAUDE.md:.claude/CLAUDE.md"
  "alacritty/alacritty.toml:.config/alacritty/alacritty.toml"
  "bin/dotsync:.local/bin/dotsync"
)

# The bash files are Ubuntu's stock ones plus tweaks; macOS uses zsh and its own defaults
if [ "$OS" = "Linux" ]; then
  LINKS+=("bash/bashrc:.bashrc" "bash/profile:.profile")
fi

if [ "${1:-}" = "--check" ]; then
  bad=0
  for entry in "${LINKS[@]}"; do
    src="$REPO/${entry%%:*}"
    dst="$HOME/${entry##*:}"
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
      continue
    elif [ -L "$dst" ]; then
      echo "wrong    $dst -> $(readlink "$dst")"
    elif [ -e "$dst" ]; then
      echo "not-link $dst (regular file, changes here are not tracked)"
    else
      echo "missing  $dst"
    fi
    bad=1
  done
  [ "$bad" = 0 ] && echo "all links ok"
  exit "$bad"
fi

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

# Things the configs call out to, so a missing one is not a mystery later
for cmd in git tmux emacs zsh jq; do
  command -v "$cmd" >/dev/null 2>&1 || echo "note: '$cmd' not found" \
    "(${OS}: $([ "$OS" = Darwin ] && echo "brew install $cmd" || echo "apt install $cmd"))"
done
[ -d "$HOME/.oh-my-zsh" ] || echo "note: Oh My Zsh not found, see https://ohmyz.sh/"
[ -d "$HOME/.nvm" ] || echo "note: nvm not found, see https://github.com/nvm-sh/nvm"
