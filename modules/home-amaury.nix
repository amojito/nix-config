{ config, pkgs, ... }:

{
  home-manager.users.amaury = { pkgs, ... }: {
    home.stateVersion = "25.05";

    home.packages = with pkgs; [
      kdePackages.kate
      neofetch
      htop
      tree
    ];

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
    };

    programs.zsh = {
      enable = true;

      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = ["git"];
      };
    };

  };
}
