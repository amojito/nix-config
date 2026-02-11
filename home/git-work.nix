{ config, ... }:

{
  programs.git = {
    includes = [
      {
        path = "${config.home.homeDirectory}/.config/git/work.gitconfig";
        condition = "gitdir:${config.home.homeDirectory}/Documents/ml/";
      }
    ];
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
}
