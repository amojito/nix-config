{ config, pkgs, ... }:

{
  home-manager.users.amaury = { pkgs, config, ... }:
    let
      inherit (pkgs) lib;
    in {
      imports = [
        ./alacritty.nix
        ./awscli.nix
        ./git.nix
        ./vscode.nix
        ./database.nix
      ];

      home.stateVersion = "25.11";

      home.packages =
        (with pkgs; [
          # Base CLI
          neofetch
          htop
          tree
          watch
          rsync
          jq
          claude-code

          # Development
          nodejs_22

          # Python
          pyenv

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

        ])
        ++ lib.optionals pkgs.stdenv.isLinux (with pkgs; [
          # Linux-only
          kdePackages.kate
        ]);

    programs.emacs = {
      enable = true;
      extraPackages = epkgs: [
        epkgs.nix-mode
      ];
    };

    programs.firefox = {
      enable = true;
      profiles.amaury = {
        settings = {
          # Privacy and security
          "privacy.donottrackheader.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;

          # Performance
          "browser.sessionstore.interval" = 15000000; # Reduce session save frequency
          "gfx.webrender.all" = true; # Enable WebRender

          # UI preferences
          "browser.startup.page" = 3; # Restore previous session
          "browser.tabs.warnOnClose" = false;
          "browser.download.useDownloadDir" = false; # Always ask where to save

          # Disable annoyances
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
        };

        search = {
          default = "DuckDuckGo";
          force = true;
        };
      };
    };

    programs.zsh = {
      enable = true;

      enableCompletion = true;
      autosuggestion.enable = true;

      shellAliases = {
        dot = "/Users/amaury/Documents/ml/dot/.venv/bin/dot";
      };

      # FIXME: Define the full zshrc in git
      initContent = ''
        if [ -f "${config.home.homeDirectory}/.zshrc.local" ]; then
          source "${config.home.homeDirectory}/.zshrc.local"
        fi
      '';

      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = ["git" "aws"];
      };
    };

  };
}
