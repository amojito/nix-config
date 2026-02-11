{ config, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Amaury";
        email = "amaury.jaffrain@gmail.com";
      };
      core.editor = "emacs -nw";
      init.defaultBranch = "main";
    };
  };
}
