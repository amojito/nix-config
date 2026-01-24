{ config, pkgs, ... }:

{
  home-manager.users.amaury = { pkgs, config, ... }:
    let
      inherit (pkgs) lib;
    in {
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
          nodejs_22  # Required for Claude Code and VS Code extensions

          # Python
          pyenv

          # Database
          postgresql.pg_config
          openssl
          openssl.dev

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

          # Editor
          vscode

        ])
        ++ lib.optionals pkgs.stdenv.isLinux (with pkgs; [
          # Linux-only
          kdePackages.kate
        ]);

    programs.awscli = {
      enable = true;
      settings = {
        "sso-session mli" = {
          sso_start_url = "https://d-92670fa2ad.awsapps.com/start#/";
          sso_region = "us-west-2";
          sso_registration_scopes = "sso:account:access";
        };

        "profile buildmatrix" = {
          sso_session = "mli";
          sso_account_id = "051826710928";
          sso_role_name = "CICDReadOnly";
          region = "us-west-2";
          cli_pager = "";
        };

        "profile buildmatrix-sandbox" = {
          sso_session = "mli";
          sso_account_id = "180294176216";
          sso_role_name = "DevPowerUserAccess";
          region = "us-west-2";
          cli_pager = "";
        };

        "profile andor" = {
          sso_session = "mli";
          sso_account_id = "195275634322";
          sso_role_name = "DevPowerUserAccess";
          region = "us-west-2";
          cli_pager = "";
        };

        "profile andor-ro" = {
          sso_session = "mli";
          sso_account_id = "195275634322";
          sso_role_name = "CustomerAccountReadOnlyAccess";
          region = "us-west-2";
          cli_pager = "";
        };

        "profile korra-sandbox" = {
          sso_session = "mli";
          sso_account_id = "418484241502";
          sso_role_name = "DevPowerUserAccess";
          region = "us-west-2";
          cli_pager = "";
        };

        "profile pentest" = {
          sso_session = "mli";
          sso_account_id = "588922096474";
          sso_role_name = "DevPowerUserAccess";
          region = "us-west-2";
          cli_pager = "";
        };

        "profile devone" = {
          sso_session = "mli";
          sso_account_id = "251326346975";
          sso_role_name = "DevPowerUserAccess";
          region = "us-west-2";
          cli_pager = "";
        };

        "profile devtwo" = {
          sso_session = "mli";
          sso_account_id = "767067015463";
          sso_role_name = "DevPowerUserAccess";
          region = "us-west-2";
          cli_pager = "";
        };
      };
    };

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

    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Amaury";
          email = "amaury.jaffrain@gmail.com";
        };
        core.editor = "emacs -nw";
      };
      includes = [
        {
          path = "${config.home.homeDirectory}/.config/git/work.gitconfig";
          condition = "gitdir:${config.home.homeDirectory}/Documents/ml/";
        }
      ];
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
        # Set OpenSSL paths for compiling Python packages
        export LDFLAGS="-L${pkgs.openssl.out}/lib"
        export CPPFLAGS="-I${pkgs.openssl.dev}/include"

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

    home.file.".config/git/work.gitconfig" = {
      text = ''
        [user]
          name = Amaury Jaffrain
          email = amaury@multiplylabs.com
          signingkey = ~/.ssh/id_ed25519_work.pub
        [core]
          sshCommand = ssh -i ~/.ssh/id_ed25519_work
        [gpg]
          format = ssh
        [commit]
          gpgsign = true
      '';
    };

  };
}
