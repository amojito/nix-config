{ config, modulesPath, pkgs, lib, ... }:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ./default.nix
    ../../home/sparrow.nix
  ];

  networking.hostName = "sparrow";

  nix.settings = {
    sandbox = false;
  };

  proxmoxLXC = {
    manageNetwork = false;
    privileged = true;
  };

  services.fstrim.enable = false; # Let Proxmox host handle fstrim

  # Cache DNS lookups to improve performance
  services.resolved = {
    extraConfig = ''
      Cache=true
      CacheFromLocalhost=true
    '';
  };

  # Tailscale VPN - configured as exit node
  services.tailscale = {
    useRoutingFeatures = "server";  # Enable exit node/subnet router features
    interfaceName = "userspace-networking";  # Use userspace networking for LXC compatibility
  };

  # Fix for exit node internet access
  networking.firewall.checkReversePath = "loose";

  # Beszel monitoring agent
  services.beszel.agent = {
    enable = true;
    environmentFile = "/etc/beszel/agent.env";
    environment = {
      PORT = "45876";  # Default Beszel agent port
    };
  };

  # WireGuard VPN configuration
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "192.168.27.66/32" ];
      dns = [ "212.27.38.253" ];
      privateKeyFile = "/etc/wireguard/privatekey";
      mtu = 1360;

      # Preserve local network access
      postUp = ''
        ${pkgs.iproute2}/bin/ip route add 10.8.10.0/24 dev eth0 || true
      '';

      preDown = ''
        ${pkgs.iproute2}/bin/ip route del 10.8.10.0/24 || true
      '';

      peers = [
        {
          publicKey = "DRwEfC9bRrKJCsS02zWIcaiqWMmamgWiUT1NdXjRyxM=";
          presharedKeyFile = "/etc/wireguard/presharedkey";
          endpoint = "va.amojito.fr:43609";
          allowedIPs = [ "0.0.0.0/0" "192.168.27.64/27" "192.168.25.0/24" ];
          persistentKeepalive = 25;
        }
      ];
    };
  };

  networking.firewall = {
    allowedUDPPorts = [ 51820 41641 ]; # WireGuard + Tailscale default ports
    allowedTCPPorts = [ 45876 ]; # Beszel agent port
    trustedInterfaces = [ "tailscale0" "wg0" ]; # Trust Tailscale and WireGuard interfaces
  };

  # WireGuard tools available
  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];

  system.stateVersion = "25.05";
}
