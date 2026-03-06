{ pkgs, lib, ... }:

{
  programs.emacs = {
    enable = true;
    package = lib.mkForce pkgs.emacs;  # Override base.nix to use GUI version
    extraPackages = epkgs: [
      epkgs.nix-mode
      epkgs.evil
      epkgs.evil-collection
    ];
    extraConfig = builtins.readFile ./config/emacs.el;
  };
}
