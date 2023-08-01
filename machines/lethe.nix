{ pkgs, config, ... }: {

  imports = [ ../hardware/virtualbox_hw.nix ../common.nix ../users/fusetim_vm.nix ];

  networking.hostName = "lethe";
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable docker
  # virtualisation.docker.enable = true;
  # virtualisation.docker.autoPrune.enable

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "fusetim";
  
  # Enable VirtualBox Shared Folders 
  users.users.fusetim.extraGroups = [ "vboxsf" ];

  environment.systemPackages = with pkgs; [
    # KDE related packages
    ark
    dolphin
    dconf
    filelight
    firefox
    gwenview
    kate
    kcalc
    kcachegrind
    kgpg
    khelpcenter
    kig
    kompare
    kwalletmanager
    okteta
    okular
    kdeconnect
    plasma-nm
    kate
    gparted
  ];

  programs.nm-applet.enable = true;
  # programs.adb.enable = true;
  # hardware.bluetooth.enable = false;

  home-manager.useGlobalPkgs = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPortRanges = [ 
    { from = 1714; to = 1764; } # KDEConnect
  ];
  networking.firewall.allowedUDPPortRanges = [ 
    { from = 1714; to = 1764; } # KDEConnect
  ];

  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
  
