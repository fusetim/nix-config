{ config, pkgs, ... }:

{
  imports = [ ./users/fusetim.nix ];

  system.stateVersion = "21.05";

  time.timeZone = "Europe/Paris";

  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;
  networking.wireless.enable = false;

  fonts.fontconfig.enable = true;

  hardware.opengl = {
    enable = config.services.xserver.enable;
    driSupport32Bit = true;
  };

  hardware.pulseaudio = {
    enable = config.services.xserver.enable;
    support32Bit = true;
  };

  environment.systemPackages = with pkgs; [ neovim git ];
}