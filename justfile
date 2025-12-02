# justfile

# it me
user := "shoe"

default:
    @just --list

# Rebuilds the flakes configuration and switches to it
switch:
    home-manager switch --flake .#{{user}}@{{user}}

# Cleans up nix store & disk space
gc-full:
    home-manager generations
    home-manager expire-generations '-30 days' || true
    nix profile wipe-history --older-than 7d || true
    nix-collect-garbage -d
    nix store gc --debug
    nix store optimise
