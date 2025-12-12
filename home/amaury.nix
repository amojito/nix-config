{ config, pkgs, ... }:

{
  home-manager.users.amaury = { pkgs, config, ... }:
    let
      inherit (pkgs) lib;
    in {
      home.stateVersion = "24.11";

      home.packages =
        (with pkgs; [
          # Base CLI
          neofetch
          htop
          tree
          watch
          rsync
          jq

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

          # Developement
          postgresql_14
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

    programs.git = {
      enable = true;
      userName = "Amaury";
      userEmail = "amaury.jaffrain@gmail.com";
      extraConfig = {
        # You can switch to emacsclient when you’re ready:
        # core.editor = "emacsclient -c -a emacs";
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

      # FIXME: Define the full zshrc in git
      initExtra = ''
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
      '';
    };

  };
}
