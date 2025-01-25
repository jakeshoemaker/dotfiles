{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ghostty
    kitty
    obsidian
    spotify
    wezterm
  ];

  # programs w/ their own module cofiguration
  programs.firefox.enable = true;
}
