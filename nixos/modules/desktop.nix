{ config, pkgs, ... }:
{
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

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for xorg and wayland
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    # modesetting required for wayland
    modesetting.enable = true;
    powerManagement.enable = true;

    # enable proprietary drivers
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # session vars to support nvidia
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
}
