{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # Filesystem configruations
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/34561d1d-4542-4178-9f5d-bab07da3a265";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5082-9E85";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  # LUKS Configuration
  boot.initrd.luks.devices."luks-faf8489c-999c-43a5-b471-c310c01beed2".device = "/dev/disk/by-uuid/faf8489c-999c-43a5-b471-c310c01beed2";

  # Swap configuration
  swapDevices = [ { device = "/dev/disk/by-uuid/44426694-d294-41f0-8548-4521db7346d8"; }];

  # Boot loader configuration
  # Boot loader configuration
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub.enable = false;
  };

  # Windows boot entry
  boot.loader.systemd-boot.extraEntries = {
    "windows.conf" = ''
      title Windows
      efi /EFI/Microsoft/Boot/bootmgfw.efi
    '';
  };

  # Sound hardware configuration
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };


  # Platform specific settings
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Hardware specific networking
  networking.useDHCP = lib.mkDefault true;

  # Enable OpenGL
  harware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
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
