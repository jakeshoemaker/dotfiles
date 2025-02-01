{ config, pkgs, ... }:
{
  # Enable nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable unfree
  nixpkgs.config = {
    allowUnfree = true;
  };

  # Boot loader settings
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Basic system settings
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  # Time and locale settings
  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # User configuration
  users.users.jake = {
    isNormalUser = true;
    description = "jake shoemaker";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Enable SSH
  services.openssh.enable = true;

  # System state version
  system.stateVersion = "24.11";
  
  # Hardware specific networking
  networking.useDHCP = lib.mkDefault true;
}
