{ config, pkgs, ... }:

{
 
  # Keeping existing gnome config for now
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS for printing
  services.printing.enable = true;

  # Wayland dependencies for hyprland
  environment.systemPackages = with pkgs; [
    swww
    rofi-wayland
    dunst
    libnotify
    swaylock-effects
    wl-clipboard
  ];

  # Enable hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
}
