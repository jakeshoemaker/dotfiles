# justfile

user := `whoami`
host := `hostname -s`

default:
    @just --list

# Rebuilds the flakes configuration and switches to it (auto-detects user@host)
switch:
    home-manager switch --flake .#{{user}}@{{host}}

# Rebuilds for a specific profile (e.g. `just switch-profile jake@work-mbp`)
switch-profile profile:
    home-manager switch --flake .#{{profile}}

# Cleans up nix store & disk space
gc-full:
    home-manager generations
    home-manager expire-generations '-30 days' || true
    nix profile wipe-history --older-than 7d || true
    nix-collect-garbage -d
    nix store gc --debug
    nix store optimise
