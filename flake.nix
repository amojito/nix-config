{
  description = "NixOS configuration for Amaury with home-manager";

  inputs = {
    # Pin to current stable until the 25.05 branch is cut.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations = {
        duck = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/duck.nix
            home-manager.nixosModules.home-manager
          ];
        };

        raven = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/raven.nix
            home-manager.nixosModules.home-manager
          ];
        };
      };
    };
}
