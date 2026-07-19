#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

exec env DOTFILES_SKIP_BREW=1 "$ROOT_DIR/install.sh"
