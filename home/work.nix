{ config, pkgs, ... }:

{
  home-manager.users.amaury = { pkgs, lib, ... }: {
    home.packages = lib.mkAfter (with pkgs; [
          dot
          postgresql
        ]);
  };
}
