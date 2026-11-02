# dotconfigfiles

My personal dotfiles. Each directory holds the files for one tool; `install.sh` symlinks them into `$HOME`, so editing a config in place edits the repo.

| Directory | Links to |
|-----------|----------|
| `emacs/`  | `~/.emacs.d/init.el`, `~/.emacs.d/erlang.el` |
| `tmux/`   | `~/.tmux.conf`, `~/.tmux/scripts/` |
| `zsh/`    | `~/.zshrc` |
| `bash/`   | `~/.bashrc`, `~/.profile` (Linux only) |
| `git/`    | `~/.gitconfig` |
| `claude/` | `~/.claude/settings.json`, `~/.claude/statusline-capture.sh`, `~/.claude/CLAUDE.md` |
| `alacritty/` | `~/.config/alacritty/alacritty.toml` |
| `bin/`    | `~/.local/bin/dotsync` |

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

Existing files are moved aside as `<name>.bak-<timestamp>`; running it again is safe. For anything it expects but can't find (the tools above, Oh My Zsh, nvm) the script asks before installing it; `./install.sh --yes` installs them all without asking, and with no terminal it just prints a note.

Afterwards:

- **tmux:** start tmux and press `prefix + I` to install the plugins (TPM is cloned by the script).
- **emacs:** packages are installed on first start by `use-package`. Settings made through `M-x customize` go to `~/.emacs.d/custom.el`, which is not tracked.
- **zsh:** expects [Oh My Zsh](https://ohmyz.sh/) in `~/.oh-my-zsh` and [nvm](https://github.com/nvm-sh/nvm) in `~/.nvm`. The script clones both rather than running their installers, which would rewrite the linked `~/.zshrc`.

## How the tmux status bar gets Claude usage

`claude/settings.json` sets `claude/statusline-capture.sh` as Claude Code's status line. It saves the session JSON to `~/.cache/claude-usage.json`, and `tmux/scripts/claude-usage.sh` reads the rate limits from it (needs `jq`).

## Keeping changes in sync

Because everything is symlinked, local edits are repo edits. `dotsync` shows what changed, then commits and pushes on confirmation:

```
dotsync                    # review, prompt for message, push
dotsync "tweak tmux keys"  # same, with the message given
./install.sh --check       # report links that are missing or replaced by a regular file
```

## Roadmap

Ideas for improving the tmux/remote/Claude workflow are tracked in [`docs/productivity-roadmap.md`](docs/productivity-roadmap.md).

## Not tracked

`~/.claude/.credentials.json`, history, sessions and anything else under `~/.claude` other than the three files above (including `skills/synced`, which is account-managed).

## History

The pre-2026 configuration (ido-mode emacs, EDTS, jabber, old tmux battery scripts) is preserved at the `legacy-2020` tag.
