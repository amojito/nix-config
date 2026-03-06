{ config, pkgs, ... }:

{
  imports = [
    ../../home/amaury.nix
  ];

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "amaury-macbook-pro";

  system.primaryUser = "amaury";

  users.users.amaury = {
    home = "/Users/amaury";
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    wakeonlan
  ];

  homebrew = {
    enable = true;
    brews = [
      "aws-sam-cli"
    ];
    casks = [
      "slack"
      "cursor"
      "orbstack"
      "google-chrome"
    ];
  };

  nix.enable = false;

  system.defaults = {
    NSGlobalDomain = {
      AppleTemperatureUnit = "Celsius";
    };


  };
  
  system.stateVersion = 5;
}
