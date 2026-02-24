# ~/dotfiles/home-manager/home.nix
# username and homeDirectory are injected by flake.nix via the inline module.
{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";

  imports = [
    ./common/default.nix
    ./common/shell.nix
    ./common/nvim.nix
    ./common/git.nix
    ./common/tmux.nix
  ];

  # Let Home Manager manage itself (adds `home-manager` to path)
  programs.home-manager.enable = true;
}
