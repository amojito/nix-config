{ config, pkgs, ... }:

{
  programs.zsh.enable = true;

  users.users.amaury = {
    isNormalUser = true;
    description = "Amaury";
    extraGroups = [ "networkmanager" "wheel" ];
    uid = 1000;
    shell = pkgs.zsh;
  };
}
