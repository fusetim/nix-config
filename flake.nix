{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
  inputs.nixpkgs_unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

  inputs.home-manager.url = "github:nix-community/home-manager/release-22.05";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";

  # inputs.fusetim-config = {
  #   url = "github:fusetim/.config";
  #   flake = false;
  # };

  outputs =
    { self, nixpkgs, nixpkgs_unstable, home-manager, /* fusetim-config */ }:
    let
      unstable-module = { config, ... }: {
        nixpkgs.overlays = [
          (final: prev: {
            unstable = import nixpkgs_unstable {
              config = config.nixpkgs.config;
              system = config.nixpkgs.localSystem.system;
              overlays = [
                (final: prev: {
                  discord = prev.discord.overrideAttrs (_: {
                    src = builtins.fetchTarball {
                      url = "https://dl.discordapp.net/apps/linux/0.0.18/discord-0.0.18.tar.gz";
                      sha256 = "1bhjalv1c0yxqdra4gr22r31wirykhng0zglaasrxc41n0sjwx0m";
                    };
                  });
                })                
              ];
            };
          })
        ];
      };
    in {
      nixosConfigurations.hermaphrodite = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
#        specialArgs = { inherit nixpkgs_unstable; };
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
    };
}
