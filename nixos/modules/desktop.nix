{ config, pkgs, ... }:

{
  # Enable X11 windowing system
  services.xserver.enable = true;

  # Enable GNOME Desktop Environment
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS for printing
  services.printing.enable = true;

  # Keep Hyprland enabled but not configured yet
  programs.hyprland.enable = true;
}
