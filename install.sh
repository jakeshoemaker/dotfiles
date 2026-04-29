#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
BACKUPS_MADE=0
BREW_BIN=""
SKIP_BREW="${DOTFILES_SKIP_BREW:-0}"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33mWARN:\033[0m %s\n' "$*"; }
fail() { printf '\033[1;31mERROR:\033[0m %s\n' "$*" >&2; exit 1; }

find_brew() {
  if command -v brew >/dev/null 2>&1; then
    command -v brew
  elif [ -x /opt/homebrew/bin/brew ]; then
    printf '/opt/homebrew/bin/brew\n'
  elif [ -x /usr/local/bin/brew ]; then
    printf '/usr/local/bin/brew\n'
  fi
}

ensure_xcode_clt() {
  [ "$(uname -s)" = "Darwin" ] || return 0

  if xcode-select -p >/dev/null 2>&1; then
    return 0
  fi

  info "Installing Xcode Command Line Tools"
  xcode-select --install || true
  warn "Finish the Xcode Command Line Tools install, then rerun ./install.sh"
  exit 1
}

ensure_homebrew() {
  BREW_BIN="$(find_brew || true)"
  [ -n "$BREW_BIN" ] && return 0

  if [ "$(uname -s)" != "Darwin" ]; then
    warn "Homebrew not found; skipping Brewfile install on non-macOS system"
    return 0
  fi

  ensure_xcode_clt

  info "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  BREW_BIN="$(find_brew || true)"
  [ -n "$BREW_BIN" ] || fail "Homebrew install finished, but brew was not found. Open a new terminal and rerun ./install.sh"
}

setup_brew_env() {
  [ -n "$BREW_BIN" ] || return 0
  eval "$("$BREW_BIN" shellenv)"
}

install_packages() {
  [ -f "$ROOT_DIR/Brewfile" ] || return 0

  if [ "$SKIP_BREW" = "1" ]; then
    warn "Skipping Brewfile install because DOTFILES_SKIP_BREW=1"
    return 0
  fi

  ensure_homebrew
  [ -n "$BREW_BIN" ] || return 0
  setup_brew_env

  info "Installing packages from Brewfile"
  brew bundle --file "$ROOT_DIR/Brewfile"
}

home_relative_path() {
  local path="$1"
  local rel="${path#$HOME/}"

  if [ "$rel" = "$path" ]; then
    rel="${path#$HOME}"
    rel="${rel#/}"
  fi

  printf '%s\n' "$rel"
}

backup_existing() {
  local dest="$1"
  local rel

  rel="$(home_relative_path "$dest")"
  mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
  mv "$dest" "$BACKUP_DIR/$rel"
  BACKUPS_MADE=1
  info "Backed up ~/$rel"
}

link_item() {
  local src="$1"
  local dest="$2"
  local rel current

  [ -e "$src" ] || return 0

  mkdir -p "$(dirname "$dest")"
  rel="$(home_relative_path "$dest")"

  if [ -L "$dest" ]; then
    current="$(readlink "$dest" || true)"
    if [ "$current" = "$src" ]; then
      info "Already linked ~/$rel"
      return 0
    fi
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    backup_existing "$dest"
  fi

  ln -s "$src" "$dest"
  info "Linked ~/$rel"
}

main() {
  install_packages

  info "Linking dotfiles"
  link_item "$ROOT_DIR/shell/.zshrc" "$HOME/.zshrc"
  link_item "$ROOT_DIR/shell/.zprofile" "$HOME/.zprofile"
  link_item "$ROOT_DIR/git/.gitconfig" "$HOME/.gitconfig"
  link_item "$ROOT_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
  link_item "$ROOT_DIR/nvim/.config/nvim" "$HOME/.config/nvim"
  link_item "$ROOT_DIR/aerospace/.aerospace.toml" "$HOME/.aerospace.toml"
  link_item "$ROOT_DIR/ghostty/.config/ghostty" "$HOME/.config/ghostty"

  info "Done"
  printf '\nNext steps:\n'
  printf '  1. Restart your terminal or run: source ~/.zshrc\n'
  printf '  2. Open Neovim once to let plugins/bootstrap finish if needed\n'
  printf '  3. Start or reload AeroSpace to pick up ~/.aerospace.toml\n'

  if [ "$BACKUPS_MADE" -eq 1 ]; then
    printf '\nBackups: %s\n' "$BACKUP_DIR"
  fi
}

main "$@"
