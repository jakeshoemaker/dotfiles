# ~/dotfiles/home-manager/home.nix
{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";

  # Basic user info
  home.username = "shoe";
  home.homeDirectory = "/home/${config.home.username}";

  imports = [
    ./common/default.nix # default packages added to home
    ./common/shell.nix   # zsh + plugins
    ./common/nvim.nix    
    ./common/git.nix     
  ];

  # Let Home Manager manage itself (adds `home-manager` to path)
  programs.home-manager.enable = true;
}
