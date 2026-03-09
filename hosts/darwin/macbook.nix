{ config, pkgs, ... }:

{
  imports = [
    ../../home/amaury.nix
  ];

  nixpkgs.config.allowUnfree = true;

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
    screencapture = {
      target = "file";
      location = "/Users/amaury/Screenshots";
    };


  };
  
  system.stateVersion = 5;
}
