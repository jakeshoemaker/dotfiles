# dotfiles

my simple dotfiles for macos, just the basics: git, Neovim, tmux, AeroSpace, and Ghostty.

## Install

```sh
git clone https://github.com/jakeshoemaker/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

If you only want to relink configs and skip Homebrew:

```sh
DOTFILES_SKIP_BREW=1 ./install.sh
```

## What `./install.sh` does

- installs Xcode Command Line Tools if needed
- installs Homebrew if needed
- runs `brew bundle`
- backs up conflicting files to `~/.dotfiles-backup/<timestamp>/`
- symlinks the configs into your home directory

## Linked configs

- `shell/.zshrc` -> `~/.zshrc`
- `shell/.zprofile` -> `~/.zprofile`
- `git/.gitconfig` -> `~/.gitconfig`
- `nvim/.config/nvim` -> `~/.config/nvim`
- `tmux/.tmux.conf` -> `~/.tmux.conf`
- `aerospace/.aerospace.toml` -> `~/.aerospace.toml`
- `ghostty/.config/ghostty` -> `~/.config/ghostty`

## Default key ideas

### tmux
- vi copy mode
- pane movement with `prefix + h/j/k/l`
- pane resizing with `prefix + H/J/K/L`
- split vertically with `prefix + -`
- split horizontally with `prefix + \\`

### AeroSpace
- focus with `alt-h/j/k/l`
- move windows with `alt-shift-h/j/k/l`
- switch workspaces with `alt-1` through `alt-9`
- move windows to workspaces with `alt-shift-1` through `alt-shift-9`
- open Ghostty with `alt-enter`

## Adding more dotfiles

Add the config under its own app folder, then add one link line in `install.sh`.
