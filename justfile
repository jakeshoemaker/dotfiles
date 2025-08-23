# justfile

# it me
user := "shoe"

default:
    @just --list

# Rebuilds the flakes configuration and switches to it
switch:
    home-manager switch --flake .#{{user}}@{{user}}
