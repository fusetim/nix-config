{ pkgs, config, ... }: {

  imports = [ ../hardware/hp_240_g7.nix ../common.nix ../users/fusetim.nix ];

  networking.hostName = "hermaphrodite";
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable docker
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
    listenOptions = [
      "/run/docker.sock"
      "/var/run/docker.sock"
    ];
  };

  # Enable the Plasma 5 Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "fusetim";

  environment.systemPackages = with pkgs; [
    # KDE related packages
    # pkgs.unstable.nixgl.auto.nixGLDefault
    pkgs.unstable.nixgl.nixGLIntel
    pkgs.unstable.nixgl.nixVulkanIntel
    pkgs.unstable.discord

    mgba    
    ark
    dolphin-emu
    xwiimote
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
    prismlauncher
    openjdk17
    # Bluetooth utilities
    # bluedevil
    # bluez
    # and veracrypt...
#    veracrypt
    gparted
    vlc
    appimage-run

    ncdu

    # obs-studio

    # Eagle AutoCAD
    eagle
    # Microsoft Teams
    teams-for-linux
  ];

  programs.nm-applet.enable = true;
  programs.adb.enable = true;
  # hardware.bluetooth.enable = false;

  home-manager.useGlobalPkgs = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPortRanges = [ 
    { from = 1714; to = 1764; } # KDEConnect
    { from = 9999; to = 9999; } # PPII2
  ];
  networking.firewall.allowedUDPPortRanges = [ 
    { from = 1714; to = 1764; } # KDEConnect
    { from = 9999; to = 9999; } # PPII2
  ];

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Oracle VirtualBox (HOST)
  virtualisation.virtualbox.host.enable = true;

  # UDEV
  ## Dolphin-Emu
  services.udev.packages = [
    pkgs.dolphin-emu
    (pkgs.writeTextFile {
      name = "40-dolphin.rules";
      text = ''
          SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0306", MODE="0666";
      '';
      destination = "/etc/udev/rules.d/40-dolphin.rules";
    })
  ];
}
  
