{ config, lib, pkgs, /* fusetim-config, */ ... }:

{
  users.extraUsers.fusetim = {
    isNormalUser = true;
    home = "/home/fusetim";
    extraGroups = [ "wheel" "networkmanager" "audio" "vboxusers"];
    shell = pkgs.unstable.fish;
  };

  programs.fish.enable = true;
  fonts.fontconfig.enable = true;
  fonts.fontDir.enable = true;

  # programs.adb.enable = true;
  # virtualisation = {
  #     podman = {
  #       enable = true;
  #       # Create a `docker` alias for podman, to use it as a drop-in replacement
  #       dockerCompat = true;
  #     };
  #   };

  home-manager.users.fusetim = {
    #home.file = builtins.removeAttrs (lib.listToAttrs (map (name:
    #  (lib.nameValuePair ".config/${name}" ({
    #    source = "${david-config}/${name}";
    #  }))) (builtins.attrNames (builtins.readDir david-config))))
    #  [ ".config/fish" ];

    xdg.mimeApps.defaultApplications = {
      "text/html" = [ "firefox.desktop" ];
    };

    home.sessionVariables.SSH_AUTH_SOCK = "/run/user/1000/gnupg/S.gpg-agent.ssh";

    home.packages = with pkgs.unstable;
      ([
        man-pages
        htop
        #ntfs3g
        tmux
        acpi
        # git
        psmisc
        pciutils
        #tor
        #torsocks
        fortune
        ponysay
        rustup
        wget
        valgrind
        cmatrix
        unrar
        unzip
        gnupg
        wget
        dig
        ffmpeg
       
        # LaTeX
        texlive.combined.scheme-small

        python python311

        # MP2I/MPI requirements
        gcc11 gdb valgrind gnumake # C

        # OCaml
        ocaml
        ocamlPackages.findlib
        ocamlPackages.graphics # need an overlay to work
        ocamlPackages.ocaml_lwt       
        ocamlPackages.ocaml_oasis     
        ocamlPackages.utop  
        ocamlPackages.core
        ocamlPackages.core_extended
        ocamlPackages.merlin
        ocamlPackages.ocp-indent

        asciidoc-full asciidoctor pandoc rubyPackages.rouge ruby cmake wrapGAppsHook gdk-pixbuf cairo pango libxml2 bison flex
      ] ++ pkgs.lib.optionals config.services.xserver.enable [ # Graphical
        glxinfo
        # minecraft
        # discord
        # thunderbird
        vlc
        vscode
        flameshot
        # element-desktop
        inxi
        neofetch
        tilix
        # inkscape
        # tmate
        # keybase-gui
        # fonts:
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        liberation_ttf
        fira-code
        fira-code-symbols
        mplus-outline-fonts.githubRelease
        powerline-fonts
#	google-fonts
      ]);

    home.keyboard = null; # Let system chose keyboard

    programs.fish = {
      enable = true;
      plugins = [{
        name = "theme-bobthefish";
        src = let
          bobthefish = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "theme-bobthefish";
            rev = "12b829e0bfa0b57a155058cdb59e203f9c1f5db4";
            sha256 = "00by33xa9rpxn1rxa10pvk0n7c8ylmlib550ygqkcxrzh05m72bw";
          };
        in pkgs.runCommand "theme-bobthefish" { } ''
          mkdir -p $out/functions
          cp -r ${bobthefish}/functions/*.fish $out/functions
          cp ${bobthefish}/*.fish $out/functions
        '';
      }];
    };

    programs.git = {
      enable = true;
      userName = "FuseTim";
      userEmail = "fusetim@gmx.com";
      signing = {
        signByDefault = true;
        key = "0CB8724AFDD5DA556CC6670C516F1BE7A8CA3DE7";
      };
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
      };
    };

    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      sshKeys = [ "EC4FE497CBD60DFCEF798EF7D558B63F6A06B6D0" ];
    };

    # services.keybase.enable = true;
    # services.kbfs.enable = true;

    programs.firefox.package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
    nixExtensions = [
      (pkgs.fetchFirefoxAddon {
        name = "ublock_origin"; # Has to be unique!
        url = "https://addons.mozilla.org/firefox/downloads/file/3816867/ublock_origin-1.37.2-an+fx.xpi";
        sha256 = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855";
      })
    ];

    extraPolicies = {
      CaptivePortal = false;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFirefoxAccounts = true;
      FirefoxHome = {
        Pocket = false;
        Snippets = false;
      };
      RequestedLocales = "fr-FR,fr,en";
      UserMessaging = {
        ExtensionRecommendations = false;
        SkipOnboarding = true;
      };
    };

    extraPrefs = ''
      // Show more ssl cert infos
      lockPref("security.identityblock.show_extended_validation", true);
    '';
  };

    dconf.settings = {
      "com/gexperts/Tilix" = {
        "quake-specific-monitor"=0;
        "profiles/2b7c4080-0ddd-46c5-8f23-563fd3ba789d/background-color"="#131313";
        "profiles/2b7c4080-0ddd-46c5-8f23-563fd3ba789d/badge-color"="#131313";
        "profiles/2b7c4080-0ddd-46c5-8f23-563fd3ba789d/badge-color-set"=true;
        "profiles/2b7c4080-0ddd-46c5-8f23-563fd3ba789d/bold-color-set"=false;
        "profiles/2b7c4080-0ddd-46c5-8f23-563fd3ba789d/cursor-colors-set"=false;
        "profiles/2b7c4080-0ddd-46c5-8f23-563fd3ba789d/font"="Source Code Pro for Powerline 10";
        "profiles/2b7c4080-0ddd-46c5-8f23-563fd3ba789d/foreground-color"="#D6DBE5";
        "profiles/2b7c4080-0ddd-46c5-8f23-563fd3ba789d/highlight-colors-set"=false;
        "profiles/2b7c4080-0ddd-46c5-8f23-563fd3ba789d/palette"=["#1F1F1F" "#F81118" "#2DC55E" "#ECBA0F" "#2A84D2" "#4E5AB7" "#1081D6" "#D6DBE5" "#D6DBE5" "#DE352E" "#1DD361" "#F3BD09" "#1081D6" "#5350B9" "#0F7DDB" "#FFFFFF"];
        "profiles/2b7c4080-0ddd-46c5-8f23-563fd3ba789d/use-system-font"=false;
        "profiles/2b7c4080-0ddd-46c5-8f23-563fd3ba789d/use-theme-colors"=false;
        "profiles/2b7c4080-0ddd-46c5-8f23-563fd3ba789d/visible-name"="Default";
      };
    };
  };


  # Unlock & mount encrypted /dev/sda6 on boot
  #systemd.services.veraboot = {
  #    description = "Unlock & mount encrypted /dev/sda6 on boot";
  #    serviceConfig = { 
  #      User = "root";
  #      ExecStart = ''
  #      ${pkgs.veracrypt}/bin/veracrypt -t --mount /dev/sda6 --non-interactive --keyfiles=/home/fusetim/Privé/data_
  #      '';
  #    };
  #    wantedBy = [ "graphical-session.target" ];
  #};

  # services.syncthing = {
  #   enable = true;
  #   user = "fusetim";
  #   dataDir = "/home/fusetim/Syncthing";
  #   configDir = "/home/fusetim/Syncthing/.config/syncthing";
  #   overrideDevices = true;     # overrides any devices added or deleted through the WebUI
  #   overrideFolders = true;     # overrides any folders added or deleted through the WebUI
  #   devices = {
  #     "athena" = { id = "QTOIIFV-3CPTOSM-TQD52YX-MQ3PT52-QSYNR6T-W7VEMG7-ITUGCFR-6IGYAAL"; };
  #     "nemesis" = { id = "DMOMXWC-6BYYZ7A-4SVUIXV-VOEQVCX-2Y6KJBS-BWS2RO6-DAFVVYP-YZLM7Q5"; };
  #     "dice" = { id = "T4OM4P2-UZTNLGI-NQIQL3P-6D6GIZM-CVEWSVN-EFPIADC-BGFRIPO-FQH4SAO"; };
  #   };
  #   folders = {
  #     "Documents" = {        # Name of folder in Syncthing, also the folder ID
  #       path = "/home/fusetim/Documents";    # Which folder to add to Syncthing
  #       devices = [ "athena" "nemesis" ];      # Which devices to share the folder with
  #     };
  #   };
  # };

}
