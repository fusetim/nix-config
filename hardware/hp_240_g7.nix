{ config, lib, pkgs, modulesPath, ... }:
 
{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b37032dc-6234-48b3-90d7-39eacbed587b";
      fsType = "ext4";
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/9F68-423B";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/e2479084-61c8-4436-a943-4a8052ffb2ec"; }
    ];

  # Boot sections
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true;
    useOSProber = true;
  };
  boot.initrd = {
    luks.devices."root" = {
      device = "/dev/disk/by-uuid/d3b6e759-8ca7-4c0b-b75f-f17585c5d426";
      preLVM = true;
      keyFile = "/keyfile0.bin";
    };
    secrets = {
      "keyfile0.bin" = "/etc/secrets/initrd/keyfile0.bin";
    };
  };
 
  # Locale settings
  i18n.defaultLocale = "fr_FR.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };
  services.xserver.layout = "fr";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  nixpkgs.config.pulseaudio = true;
  # Fix sound
  nixpkgs.overlays = [(self: super: { sof-firmware = pkgs.unstable.sof-firmware; } ) ];
  hardware.pulseaudio.package = pkgs.unstable.pulseaudioFull; #will soon be fixed!!

  # Enable touchpad support
  services.xserver.libinput.enable = true;

  # Enable bluetooth
  # hardware.bluetooth.enable=true;

  # Optimize batterie usage
  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  # Network settings
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];
  networking.enableIPv6 = true;
}