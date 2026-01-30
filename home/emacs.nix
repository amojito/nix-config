{ pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.nix-mode
      epkgs.evil
      epkgs.evil-collection
    ];
    extraConfig = builtins.readFile ./config/emacs.el;
  };
}
