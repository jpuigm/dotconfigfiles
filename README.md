# dotconfigfiles

My personal dotfiles. Each directory holds the files for one tool; `install.sh` symlinks them into `$HOME`, so editing a config in place edits the repo.

| Directory | Links to |
|-----------|----------|
| `emacs/`  | `~/.emacs.d/init.el`, `~/.emacs.d/erlang.el` |
| `tmux/`   | `~/.tmux.conf`, `~/.tmux/scripts/` |
| `zsh/`    | `~/.zshrc` |
| `bash/`   | `~/.bashrc`, `~/.profile` (Linux only) |
| `git/`    | `~/.gitconfig` |
| `claude/` | `~/.claude/settings.json`, `~/.claude/statusline-capture.sh` |

Works on Linux and macOS. On macOS the bash files are skipped (zsh is the default shell there) and the tmux battery indicator reads `pmset` instead of `/sys`.

## Requirements

`git`, `tmux`, `emacs` (29+, for built-in `use-package`), `zsh`, `jq`, and the JetBrains Mono font.

```
# macOS
brew install git tmux emacs zsh jq
brew install --cask font-jetbrains-mono

# Debian/Ubuntu
sudo apt install git tmux emacs zsh jq fonts-jetbrains-mono
```

## Install

```
git clone git@github.com:jpuigm/dotconfigfiles.git
cd dotconfigfiles
./install.sh
```

Existing files are moved aside as `<name>.bak-<timestamp>`; running it again is safe. The script prints a note for any missing tool it expects.

Afterwards:

- **tmux:** start tmux and press `prefix + I` to install the plugins (TPM is cloned by the script).
- **emacs:** packages are installed on first start by `use-package`. Settings made through `M-x customize` go to `~/.emacs.d/custom.el`, which is not tracked.
- **zsh:** expects [Oh My Zsh](https://ohmyz.sh/) in `~/.oh-my-zsh` and nvm in `~/.nvm`.

## How the tmux status bar gets Claude usage

`claude/settings.json` sets `claude/statusline-capture.sh` as Claude Code's status line. It saves the session JSON to `~/.cache/claude-usage.json`, and `tmux/scripts/claude-usage.sh` reads the rate limits from it (needs `jq`).

## Not tracked

`~/.claude/.credentials.json`, history, sessions and anything else under `~/.claude` other than the two files above.

## History

The pre-2026 configuration (ido-mode emacs, EDTS, jabber, old tmux battery scripts) is preserved at the `legacy-2020` tag.
