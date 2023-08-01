{
  inputs.nixos.url = "github:nixos/nixpkgs/nixos-unstable";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  inputs.nixpkgs_unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

  inputs.home-manager.url = "github:nix-community/home-manager/release-23.05";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  inputs.discord-src.url = "tarball+https://discord.com/api/download?platform=linux&format=tar.gz";
  inputs.discord-src.flake = false;

  inputs.nixgl.url = "github:guibou/nixGL";
  inputs.nixgl.inputs.nixpkgs.follows = "nixpkgs";

  # inputs.fusetim-config = {
  #   url = "github:fusetim/.config";
  #   flake = false;
  # };

  outputs =
    { self, nixos, nixpkgs, nixpkgs_unstable, home-manager, discord-src, nixgl /* fusetim-config */ }:
    let
      unstable-module = { config, ... }: {
        nixpkgs.overlays = [
          # Discord Overlay
          (final: prev: {
            unstable = import nixpkgs_unstable {
              config = config.nixpkgs.config;
              system = config.nixpkgs.localSystem.system;
              overlays = [
                 nixgl.overlay
#                (self: super: {
#                  vlc = super.vlc.override {
#                    libbluray = super.libbluray.override {
#                      withAACS = true;
#                      withBDplus = true;
#                    };
#                  };
#                })
                (final: prev: {
                  discord = prev.discord.overrideAttrs (_: {
#                    src = builtins.fetchTarball {
#                      url = "https://dl.discordapp.net/apps/linux/0.0.21/discord-0.0.21.tar.gz";
#                      sha256 = "1pw9q4290yn62xisbkc7a7ckb1sa5acp91plp2mfpg7gp7v60zvz";
#                    };
                     src = discord-src;
                  });
                })
                # OCaml and Graphics overlay
                (final: prev: {
                  ocaml = final.symlinkJoin rec {
                    inherit (prev.ocaml) name;
                    version = final.lib.getVersion prev.ocaml;
                    paths = [ prev.ocaml ];
                    buildInputs = [ final.makeWrapper ];
                    postBuild = ''
                    wrapProgram $out/bin/ocaml \
                        --add-flags "-I ${final.ocamlPackages.findlib}/lib/ocaml/${version}/site-lib"
                    '';
                  };
                })
              ];
            };
          })
        ];
      };
    in {
      nixosConfigurations.hermaphrodite = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit nixpkgs_unstable; };
        modules = [
          (_args: {
            system.configurationRevision =
              nixpkgs.lib.mkIf (self ? rev) self.rev;
          })
          (import ./machines/hermaphrodite.nix)
          unstable-module
          home-manager.nixosModules.home-manager
        ];
      };
      nixosConfigurations.lethe = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit nixpkgs_unstable; };
        modules = [
          (_args: {
            system.configurationRevision =
              nixpkgs.lib.mkIf (self ? rev) self.rev;
          })
          (import ./machines/lethe.nix)
          unstable-module
          home-manager.nixosModules.home-manager
#          "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ];
      };

    };
}
