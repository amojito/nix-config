{ config, pkgs, ... }:

{
  imports = [
    ../hardware-raven.nix
    ../modules/networking.nix
    ../modules/desktop.nix
    ../modules/sound.nix
    ../modules/services.nix
    ../modules/users.nix
    ../modules/home-amaury.nix
    ../modules/time-locale.nix
  ];

  networking.hostName = "raven";

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.05";
}
