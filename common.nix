{ config, pkgs, ... }:

{
#  imports = [ ./users/fusetim.nix ];

  system.stateVersion = "22.11";

  time.timeZone = "Europe/Paris";

  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;
  networking.wireless.enable = false;

  fonts.fontconfig.enable = true;
  fonts.fontDir.enable = true;

  hardware.opengl = {
    enable = config.services.xserver.enable;
    driSupport32Bit = true;
  };

  hardware.pulseaudio = {
    enable = config.services.xserver.enable;
    support32Bit = true;
  };

  environment.systemPackages = with pkgs; [ 
    neovim git 
  ];

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.settings.auto-optimise-store = true;
}
