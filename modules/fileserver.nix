{ config, pkgs, ... }:

{
  #### Mount /bay/archive from Proxmox via virtiofs ####

  fileSystems."/mnt/archive" = {
    device = "archive";   # virtiofs dirid from Proxmox
    fsType = "virtiofs";
    options = [ "rw" "nofail" ];
  };

  #### Firewall for SMB ####

  networking.firewall.allowedTCPPorts = [ 139 445 ];
  networking.firewall.allowedUDPPorts = [ 137 138 ];

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

        # macOS friendliness + recycle bin
        "vfs objects"    = "catia fruit streams_xattr recycle";
        "fruit:aapl"     = "yes";
        "fruit:encoding" = "native";
        "fruit:metadata" = "stream";
        "fruit:resource" = "stream";
        "ea support"     = "yes";

        "recycle:touch"      = "yes";
        "recycle:keeptree"   = "yes";
        "recycle:versions"   = "yes";
        "recycle:exclude_dir" = "tmp quarantine";
      };

      # This is your [archive] share
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

  #### Avahi / mDNS so macOS gives you a nice icon ####

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish = {
      enable = true;
      userServices = true;
    };

    extraServiceFiles."smb.service" = ''
      <?xml version="1.0" standalone='no'?>
      <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
      <service-group>
       <name replace-wildcards="yes">%h</name>
       <service>
         <type>_smb._tcp</type>
         <port>445</port>
       </service>
      </service-group>
    '';
  };
}
