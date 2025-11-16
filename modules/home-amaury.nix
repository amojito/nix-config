{ config, pkgs, ... }:

{
  home-manager.users.amaury = { pkgs, ... }: {
    home.stateVersion = "25.05";

    home.packages = with pkgs; [
      kdePackages.kate
      neofetch
      htop
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

    programs.bash.enable = true;
  };
}
