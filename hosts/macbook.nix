{ config, pkgs, ... }:

{
  imports = [
    ../home/amaury.nix
    # ../home/work.nix
  ];

  networking.hostName = "amaury-macbook-pro";

  users.users.amaury = {
    home = "/Users/amaury";
  };

  programs.zsh.enable = true;

  nix.enable = false;

  system.stateVersion = 5;
}
