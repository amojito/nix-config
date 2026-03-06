{ config, pkgs, ... }:

{
  imports = [
    ../../hardware/raven.nix
    ./default.nix
  ];

  networking.hostName = "raven";

  # Boot configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;

  # Enable Wake-on-LAN for both ethernet ports
  networking.interfaces.enp1s0.wakeOnLan.enable = true;
  networking.interfaces.eno1.wakeOnLan.enable = true;

  # Add networkmanager group to amaury
  users.users.amaury.extraGroups = [ "networkmanager" ];

  # Avahi for service discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  system.stateVersion = "25.05";
}
