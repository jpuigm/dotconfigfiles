#!/usr/bin/env bash
# Symlink the files in this repo into $HOME (Linux and macOS).
# Idempotent: correct links are left alone, anything else is moved to <name>.bak-<timestamp>.
# With --check, only report links that are missing or no longer point into this repo (exit 1 if any).
# Missing tools are offered for install one prompt at a time; --yes accepts them all.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d%H%M%S)"

OS="$(uname -s)"

ASSUME_YES=0
case "${1:-}" in -y|--yes) ASSUME_YES=1 ;; esac

# Ask before installing anything; --yes answers yes, and with no terminal to ask the answer is no
confirm() {
  [ "$ASSUME_YES" = 1 ] && return 0
  [ -t 0 ] || return 1
  local reply
  read -r -p "$1 [y/N] " reply
  [[ "$reply" =~ ^[Yy] ]]
}

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

# Things the configs call out to, so a missing one is not a mystery later
missing=()
for cmd in git tmux emacs zsh jq; do
  command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
done
if [ "${#missing[@]}" -gt 0 ]; then
  if [ "$OS" = Darwin ]; then pkg=(brew install); else pkg=(sudo apt install -y); fi
  if [ "$OS" = Darwin ] && ! command -v brew >/dev/null 2>&1; then
    echo "note: missing ${missing[*]}; install Homebrew first, see https://brew.sh/"
  elif confirm "Missing ${missing[*]}. Install with '${pkg[*]}'?"; then
    "${pkg[@]}" "${missing[@]}"
  else
    echo "note: missing ${missing[*]} (${pkg[*]} ${missing[*]})"
  fi
fi

# The clones below need git; without it they are left as notes
have_git() { command -v git >/dev/null 2>&1; }

# tmux plugin manager; plugins themselves are installed with prefix + I
if [ ! -d "$HOME/.tmux/plugins/tpm" ] && have_git; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# Cloned rather than run through its installer, which would replace the linked ~/.zshrc
if [ -d "$HOME/.oh-my-zsh" ]; then
  :
elif have_git && confirm "Oh My Zsh not found. Clone it into ~/.oh-my-zsh?"; then
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
else
  echo "note: Oh My Zsh not found, see https://ohmyz.sh/"
fi

# nvm's manual install (clone, check out the latest release); its installer would append to ~/.zshrc,
# which already loads it
if [ -d "$HOME/.nvm" ]; then
  :
elif have_git && confirm "nvm not found. Clone it into ~/.nvm?"; then
  git clone https://github.com/nvm-sh/nvm.git "$HOME/.nvm"
  git -C "$HOME/.nvm" checkout -q \
    "$(git -C "$HOME/.nvm" describe --abbrev=0 --tags --match "v[0-9]*" "$(git -C "$HOME/.nvm" rev-list --tags --max-count=1)")"
else
  echo "note: nvm not found, see https://github.com/nvm-sh/nvm"
fi
