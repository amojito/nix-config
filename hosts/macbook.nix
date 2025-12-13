{ config, pkgs, ... }:

{
  imports = [
    ../home/amaury.nix
    ../home/work.nix
  ];

  networking.hostName = "amaury-macbook-pro";

  users.users.amaury = {
    home = "/Users/amaury";
  };

  services.nix-daemon.enable = true;
  programs.zsh.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = 5;
}
