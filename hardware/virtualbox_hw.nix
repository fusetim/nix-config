{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
      (modulesPath + "/virtualisation/virtualbox-image.nix")
    ];

  boot.initrd.availableKernelModules = [ ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # UUID are broken in VM
  boot.loader.grub.fsIdentifier = "provided";

  # Allow mounting of shared folders.
  # users.users.demo.extraGroups = [ "vboxsf" ];

  # Add some more video drivers to give X11 a shot at working in
  # VMware and QEMU.
  services.xserver.videoDrivers = [ "virtualbox" "vmware" "cirrus" "vesa" "modesetting" ];

  # Locale settings
  i18n.defaultLocale = "fr_FR.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };
  services.xserver.layout = "fr";
  services.xserver.xkbOptions = "eurosign:e";
  services.xserver.digimend.enable = true; # Support for HUION Graphic Tablets

  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  nixpkgs.config.pulseaudio = true;
  # Fix sound - not needed?
  # nixpkgs.overlays = [(self: super: { sof-firmware = pkgs.unstable.sof-firmware; } ) ];
  # hardware.pulseaudio.package = pkgs.unstable.pulseaudioFull; #will soon be fixed!!

  # Enable touchpad support - not needed
  # services.xserver.libinput.enable = true;

  # Enable bluetooth - definitely not needed
  # hardware.bluetooth.enable=true;

  # Disable unusable power management.
  powerManagement.enable = false;

  # Network settings
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];
  networking.enableIPv6 = true;
  networking.proxy.default = "http://192.168.232.1:3128";
  networking.proxy.noProxy = "127.0.0.1,localhost,192.168.232.1,lstl.fr";
}
