{ pkgs, ... }:

{
  home.packages = with pkgs; [
    postgresql.pg_config
    openssl
    openssl.dev
  ];

  home.sessionVariables = {
    LDFLAGS = "-L${pkgs.openssl.out}/lib";
    CPPFLAGS = "-I${pkgs.openssl.dev}/include";
  };
}
