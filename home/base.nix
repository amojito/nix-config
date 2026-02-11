{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Essential CLI tools
    htop
    tree
    rsync
    jq
    curl
    wget
    vim
  ];

  programs.bash = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      ll = "ls -lah";
      la = "ls -A";
      l = "ls -CF";
    };

    bashrcExtra = ''
      # Simple colorful prompt
      PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    '';
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-nox;  # Terminal-only emacs (lighter for containers)
  };
}
