{ pkgs }: {
  deps = [
    # Ruby 3.4.x (using latest available in nixpkgs)
    pkgs.ruby_3_4

    # Node.js 20
    pkgs.nodejs_20

    # Yarn package manager
    pkgs.yarn

    # PostgreSQL client and libraries
    pkgs.postgresql_16

    # Essential build tools
    pkgs.gcc
    pkgs.gnumake
    pkgs.pkg-config

    # Git for version control
    pkgs.git

    # OpenSSL for secure connections
    pkgs.openssl

    # SQLite (used by SolidQueue, SolidCache, SolidCable)
    pkgs.sqlite

    # Additional libraries required by gems
    pkgs.zlib
    pkgs.libxml2
    pkgs.libxslt
    pkgs.libyaml
    pkgs.readline

    # Foreman for process management (used by bin/dev)
    pkgs.foreman

    # Language servers for IDE support
    pkgs.rubyPackages.solargraph
    pkgs.nodePackages.typescript-language-server

    # Ruby debugger
    pkgs.rubyPackages.debug
  ];

  env = {
    # Set library paths for native extensions
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.openssl
      pkgs.zlib
      pkgs.libxml2
      pkgs.libxslt
      pkgs.readline
      pkgs.postgresql_16
    ];

    # PostgreSQL library path for pg gem
    LIBRARY_PATH = "${pkgs.postgresql_16}/lib";

    # Configure bundle to use system libraries
    BUNDLE_BUILD__PG = "--with-pg-config=${pkgs.postgresql_16}/bin/pg_config";
  };
}
