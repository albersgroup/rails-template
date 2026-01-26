{ pkgs }: {
  deps = [
    pkgs.ruby_3_3
    pkgs.nodejs_20
    pkgs.yarn
    pkgs.postgresql
    pkgs.openssl
    pkgs.sqlite
  ];
}
