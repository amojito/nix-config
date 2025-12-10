{ config, pkgs, ... }:

{
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

  #### Avahi / mDNS for macOS 

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
