{ config, pkgs, ... }:

{
  home-manager.users.root = { pkgs, ... }: {
    imports = [
      ./base.nix
      ./git.nix
    ];

    home.stateVersion = "25.05";
  };

  home-manager.users.amaury = { pkgs, ... }: {
    imports = [
      ./base.nix
      ./git.nix
    ];

    home.stateVersion = "25.05";
  };
}
