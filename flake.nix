{
  description = "NixOS configuration for Amaury with home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-darwin, home-manager, nix-darwin, nix-homebrew, homebrew-core, homebrew-cask, ... }:
    let
      linuxSystem = "x86_64-linux";
      darwinSystem = "aarch64-darwin";
    in {
      nixosConfigurations = {
        duck = nixpkgs.lib.nixosSystem {
          system = linuxSystem;
          modules = [
            ./hosts/nixos/duck.nix
            home-manager.nixosModules.home-manager
          ];
        };

        raven = nixpkgs.lib.nixosSystem {
          system = linuxSystem;
          modules = [
            ./hosts/nixos/raven.nix
            home-manager.nixosModules.home-manager
          ];
        };

        sparrow = nixpkgs.lib.nixosSystem {
          system = linuxSystem;
          modules = [
            ./hosts/nixos/sparrow.nix
            home-manager.nixosModules.home-manager
          ];
        };
      };

      homeConfigurations = {
        monarch = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${linuxSystem};
          modules = [
            ./home/monarch.nix
          ];
        };
      };

      darwinConfigurations = {
        macbook = nix-darwin.lib.darwinSystem {
          system = darwinSystem;
          modules = [
            ./hosts/darwin/macbook.nix
            { networking.hostName = "amaury-macbook-pro"; }
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = true;
                user = "amaury";
                autoMigrate = true;
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                };
                mutableTaps = false;
              };
            }
          ];
        };

        macbook-mli = nix-darwin.lib.darwinSystem {
          system = darwinSystem;
          modules = [
            ./hosts/darwin/macbook.nix
            { networking.hostName = "amaury-multiplylabs"; }
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = true;
                user = "amaury";
                autoMigrate = true;
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                };
                mutableTaps = false;
              };
            }
          ];
        };
      };
    };
}
