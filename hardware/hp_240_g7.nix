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
    { device = "/dev/disk/by-uuid/5b1f5763-bfff-4407-bdad-bf2decbdb685";
      fsType = "ext4";
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/6037-3394";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/fc1ddd4f-e440-4fa4-b484-a331b5766cd1"; }
    ];

  # Boot sections
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true;
    useOSProber = true;
  };
  boot.initrd = {
    luks.devices."root" = {
      device = "/dev/disk/by-uuid/4ec35b05-edbb-4536-9b41-1cc86f5099eb";
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
  services.xserver.xkb.layout = "fr";
  services.xserver.xkb.options = "eurosign:e";
  services.xserver.digimend.enable = true; # Support for HUION Graphic Tablets

  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  nixpkgs.config.pulseaudio = true;
  # Fix sound
  nixpkgs.overlays = [(self: super: { sof-firmware = pkgs.unstable.sof-firmware; } ) ];
  hardware.pulseaudio.package = pkgs.unstable.pulseaudioFull; #will soon be fixed!!

  # OpenGL (with OpenCL)
  hardware.opengl = {
    enable = true;
    extraPackages = [
      pkgs.intel-ocl
    ];
  };

  # Enable touchpad support
  services.libinput.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable=true;
  hardware.bluetooth.powerOnBoot=true;

  # Optimize batterie usage
  nix.settings.max-jobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  # Network settings
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];
  networking.enableIPv6 = true;
}
