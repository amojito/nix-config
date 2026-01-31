{ config, pkgs, ... }:

{
  imports = [
    ./awscli.nix
    ./git.nix
    ./database.nix
  ];

  home.username = "amaury";
  home.homeDirectory = "/home/amaury";
  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # Base CLI
    neofetch
    htop
    tree
    watch
    rsync
    jq

    # Development
    nodejs_22

    # Python
    pyenv

    # Docker tools
    docker-compose

    # Networking
    nmap
    iperf3
    mosh

    # Media
    yt-dlp
    kepubify

    # Fun
    cmatrix
    lolcat
    sl
  ];

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;

    sessionVariables = {
      PAGER = "less -FR";
    };

    shellAliases = {
      # Remove the darwin-specific dot alias
    };

    initExtra = ''
      if [ -f "${config.home.homeDirectory}/.zshrc.local" ]; then
        source "${config.home.homeDirectory}/.zshrc.local"
      fi
    '';

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = ["git" "aws" "docker"];
    };
  };

  # Explicitly disable programs that may have Darwin dependencies
  programs.firefox.enable = false;
  programs.vscode.enable = false;
}
