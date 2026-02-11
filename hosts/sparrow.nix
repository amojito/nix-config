{ config, modulesPath, pkgs, lib, ... }:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ../modules/time-locale.nix
    ../home/sparrow.nix
  ];

  networking.hostName = "sparrow";

  nix.settings = {
    sandbox = false;
  };

  proxmoxLXC = {
    manageNetwork = false;
    privileged = false;
  };

  security.pam.services.sshd.allowNullPassword = true;

  services.fstrim.enable = false; # Let Proxmox host handle fstrim

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
      PermitEmptyPasswords = "yes";
    };
  };

  # Cache DNS lookups to improve performance
  services.resolved = {
    extraConfig = ''
      Cache=true
      CacheFromLocalhost=true
    '';
  };

  system.stateVersion = "25.05";
}
