# dotfiles

Fresh Mac provisioning with Homebrew Bundle + GNU Stow.

This repo manages:

- Homebrew bootstrap
- Git
- npm via Homebrew `node`
- Aerospace via Homebrew cask
- Shell/git dotfiles via GNU Stow

## Fresh Mac install

Once this repo is pushed to GitHub, a fresh Mac can be provisioned with one bootstrap command.

```sh
DOTFILES_REPO=git@github.com:jakeshoemaker/dotfiles.git \
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/jakeshoemaker/dotfiles/main/scripts/bootstrap)"
```

That script will:

1. Check/install Xcode Command Line Tools.
2. Check/install Homebrew.
3. Install Git if needed.
4. Clone this repo to `~/dotfiles` if needed.
5. Run `brew bundle` from `Brewfile`.
6. Back up conflicting home files to `~/.dotfiles-backup/<timestamp>/`.
7. Symlink dotfiles with GNU Stow.

If the repo is private and SSH is not set up yet, create an SSH key and add it to GitHub before running the bootstrap:

```sh
ssh-keygen -t ed25519 -C "you@example.com"
pbcopy < ~/.ssh/id_ed25519.pub
```

Then add the copied public key in GitHub:

`GitHub → Settings → SSH and GPG keys → New SSH key`

## Bootstrap an already-cloned repo

```sh
cd ~/dotfiles
./scripts/bootstrap
```

Or explicitly:

```sh
~/dotfiles/scripts/bootstrap --repo git@github.com:jakeshoemaker/dotfiles.git
```

## Update

```sh
cd ~/dotfiles
./scripts/update
```

## After changing installed apps

```sh
brew bundle dump --file ~/dotfiles/Brewfile --force
```

Then review the diff before committing.

See [PLAN.md](PLAN.md) for the current rollout plan.
