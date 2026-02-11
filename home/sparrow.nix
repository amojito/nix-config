{ config, pkgs, ... }:

{
  home-manager.users.root = { pkgs, ... }: {
    imports = [
      ./base.nix
      ./git.nix
    ];

    home.stateVersion = "25.05";
  };
}
