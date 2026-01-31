{ pkgs, ... }:

{
  programs.awscli = {
    enable = true;
  };

  home.packages = with pkgs; [
    ssm-session-manager-plugin
  ];
}
