{ config, pkgs, ... }:
{
  # OpenGL & Nvidia support
  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true; # not broke now but this is expirimental (could cause sleep/suspend issues)
    open = true; # RTX20 series & greater
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable; # production driver v 550 or newer to be compatible w/ sway
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

  programs.sway.enable = true;
  programs.waybar.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = {
      exec-once = [
        "swww init"
        "swww img /home/shoe/dotfiles/wallpapers/gruvbox-landscape.png"
      ];
    };
  };

  # system packages needed for hyprland support
  environment.systemPackages = with pkgs; [
    kitty
    swww
    rofi-wayland
    dunst
    libnotify
    swaylock-effects
    wl-clipboard
  ];

  # run a startup service that sets a wallpaper
  systemd.user.services.swww = {
    description = "Wallpaper daemon";
    wantedBy = [ "hyprland-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.swww}/bin/swww init";
      ExecStartPost = "${pkgs.swww}/bin/swww img /home/shoe/dotfiles/wallpapers/gruvbox-landscape.png";
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
