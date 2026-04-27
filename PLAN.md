# Dotfiles provisioning plan

Goal: make a fresh Mac reproducible with simple, boring tools.

## Principles

- **One repo is the source of truth:** `~/dotfiles`.
- **Simple tools:** Homebrew Bundle for packages, GNU Stow for symlinks, shell scripts for orchestration.
- **Safe by default:** scripts should be idempotent and avoid overwriting local files without a backup.
- **Small steps:** bootstrap first, then iterate on apps, macOS defaults, and secrets.

## Repo layout

```text
~/dotfiles
├── Brewfile              # Homebrew taps, formulae, casks, Mac App Store apps
├── home/                 # Files symlinked into $HOME via stow
│   ├── .zprofile
│   ├── .zshrc
│   └── .gitconfig
├── scripts/
│   ├── bootstrap         # One entrypoint: install deps, clone if needed, brew bundle, stow
│   └── update            # Update packages and re-apply dotfiles
└── PLAN.md               # This plan
```

## Phase 1 — baseline repo

- [x] Initialize `~/dotfiles` as a git repo.
- [x] Add `Brewfile`.
- [x] Add initial shell/git dotfiles under `home/`.
- [x] Add bootstrap script.
- [x] Add update script.
- [ ] Make first commit.
- [ ] Create a private GitHub repo and push it.

## Phase 2 — fresh Mac bootstrap

Fresh Mac order of operations:

1. Set up SSH for GitHub if the repo is private.
2. Run the remote bootstrap command from `README.md` with `DOTFILES_REPO=...`.

The bootstrap script should:

1. Verify Xcode Command Line Tools are installed, prompting if missing.
2. Install Homebrew if missing.
3. Install Git if missing.
4. Clone `DOTFILES_REPO` to `~/dotfiles` if the repo is not already present.
5. Run `brew bundle --file ~/dotfiles/Brewfile`.
6. Install baseline tools from the `Brewfile`, including Git, Stow, Node/npm, and Aerospace.
7. Back up conflicting home files to `~/.dotfiles-backup/<timestamp>/`.
8. Run `stow --dir ~/dotfiles --target ~ home`.
9. Print next manual steps.

## Phase 3 — update workflow

The update script should:

1. Pull latest repo changes.
2. Run `brew update && brew bundle --file ~/dotfiles/Brewfile`.
3. Re-run `stow`.
4. Optionally run `brew cleanup`.

## Phase 4 — macOS defaults

Add a small `scripts/macos-defaults` only for settings you actually care about. Keep it readable and reversible where possible.

Candidates:

- Finder: show extensions, show hidden files, default to list view.
- Dock: reduce animation, set size, autohide preference.
- Keyboard: fast key repeat.
- Screenshots: choose location.

## Phase 5 — secrets and machine-specific config

Do **not** commit secrets. Use one of:

- `~/.config/private/*` ignored by git.
- `1Password` CLI later if needed.
- `.gitconfig.local` included from `.gitconfig` for per-machine identity.

## Daily usage

```sh
cd ~/dotfiles
./scripts/update
```

After installing/removing apps:

```sh
brew bundle dump --file ~/dotfiles/Brewfile --force
```

Then review and commit the diff.
