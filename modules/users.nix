{ config, pkgs, ... }:

{
  users.users.amaury = {
    isNormalUser = true;
    description = "Amaury";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
