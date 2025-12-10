{ config, pkgs, ... }:

{
  # Enable networking
  networking.networkmanager.enable = true;

  # Firewall: keep default for now.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;
}
