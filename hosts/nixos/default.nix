{ config, pkgs, ... }:

{
  # Common server configuration shared between raven and sparrow

  # Time and locale
  time.timeZone = "America/Los_Angeles";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # SSH server
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };

  # Tailscale VPN
  services.tailscale.enable = true;

  # Beszel monitoring agent
  services.beszel.agent = {
    enable = true;
    environmentFile = "/etc/beszel/agent.env";
    environment = {
      PORT = "45876";
    };
  };

  # Open port for Beszel agent
  networking.firewall.allowedTCPPorts = [ 45876 ];

  # User configuration
  programs.zsh.enable = true;

  users.users.amaury = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHt+wQARnwJ+5+64aT6mtWQiwGtjOJXu2IJdKPBz+p3o"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  # Network tools
  environment.systemPackages = with pkgs; [
    ethtool
    wakeonlan
  ];
}
