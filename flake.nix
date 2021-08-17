{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
  inputs.nixpkgs_unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

  inputs.home-manager.url = "github:nix-community/home-manager/release-21.05";
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
            };
          })
        ];
      };
    in {
      nixosConfigurations.hermaphrodite = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # specialArgs = { inherit nixpkgs_unstable; };
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
