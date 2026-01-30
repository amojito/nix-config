{ pkgs, ... }:

{
  home.packages = with pkgs; [
    postgresql
    postgresql.pg_config
    openssl
    openssl.dev
    pkg-config
  ];

  home.sessionVariables = {
    LDFLAGS = "-L${pkgs.openssl.out}/lib";
    CPPFLAGS = "-I${pkgs.openssl.dev}/include";
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig:${pkgs.postgresql.dev}/lib/pkgconfig";
  };
}
