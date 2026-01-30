{ config, pkgs, ... }:

{
  imports = [
    ../home/amaury.nix
    # ../home/work.nix
  ];

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "amaury-macbook-pro";

  system.primaryUser = "amaury";

  users.users.amaury = {
    home = "/Users/amaury";
  };

  programs.zsh.enable = true;

  services.tailscale.enable = true;

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

  system.defaults.CustomUserPreferences = {
    "com.apple.notificationcenterui" = {
      # Disables notifications from showing on the lock screen
      "lock-screen-notifications-enabled" = false;
    };
  };
  
  # Set Terminal to close window after Ctrl+D (clean shell exit)
  # system.activationScripts.extraActivation.text = ''
  #  sudo -u amaury /usr/bin/defaults write com.apple.Terminal shellExitAction -int 1
  #'';

  system.stateVersion = 5;
}
