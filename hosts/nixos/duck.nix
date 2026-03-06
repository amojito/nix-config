{ config, pkgs, ... }:

{
  imports = [
    ../../hardware/duck.nix
    ./default.nix
    ../../home/amaury.nix
  ];

  networking.hostName = "duck";

  nixpkgs.config.allowUnfree = true;

  services.qemuGuest.enable = true;

  # Networking
  networking.networkmanager.enable = true;

  # Desktop environment
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # XRDP
  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "startplasma-x11";
  services.xrdp.openFirewall = true;

  # Keyboard layout
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Printing
  services.printing.enable = true;

  # Firefox
  programs.firefox.enable = true;

  # Avahi for service discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  boot.kernelParams = [
    "console=tty0"
    "console=ttyS0,115200n8"
  ];
  boot.loader.grub.extraConfig = ''
     serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1
     terminal_input serial console
     terminal_output serial console
  '';

  system.stateVersion = "25.05";

  #### Mount /bay/archive from Proxmox via virtiofs ####
  fileSystems."/mnt/archive" = {
    device = "archive";   # virtiofs dirid from Proxmox
    fsType = "virtiofs";
    options = [ "rw" "nofail" ];
  };

  #### Firewall for SMB ####

  networking.firewall.allowedTCPPorts = [ 445 ];
  networking.firewall.allowedUDPPorts = [ ];

  #### Samba server ####
  services.samba = {
    enable = true;
    openFirewall = true;

    settings = {
      "global" = {
        "workgroup"      = "WORKGROUP";
        "netbios name"   = "NIX-FILESERVER";
        "server string"  = "NixOS Fileserver";

        "security"       = "user";
        "map to guest"   = "Bad User";
        "encrypt passwords" = "yes";

        "disable netbios" = "yes";
        "smb ports"       = "445";

        "vfs objects"    = "catia fruit streams_xattr recycle";
        "fruit:aapl"     = "yes";
        "fruit:encoding" = "native";
        "fruit:metadata" = "stream";
        "fruit:resource" = "stream";
        "ea support"     = "yes";

        "recycle:touch" = "yes";
        "recycle:keeptree" = "yes";
        "recycle:versions" = "yes";
        "recycle:exclude_dir" = "tmp quarantine";

      };

      # This is the [archive] share
      "archive" = {
        "path"          = "/mnt/archive";
        "comment"       = "Photo & data archive";
        "browseable"    = "yes";

        "read only"     = "no";
        "guest ok"      = "no";
        "valid users"   = "amaury";

      };
    };
  };

  services.avahi.extraServiceFiles."smb.service" = ''
      <?xml version="1.0" standalone='no'?>
      <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
      <service-group>
       <name>NIX-FILESERVER</name>
       <service>
         <type>_smb._tcp</type>
         <port>445</port>
       </service>
      </service-group>
    '';
}
