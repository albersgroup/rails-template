{ pkgs }: {
  deps = [
    # Ruby (use latest stable version available)
    pkgs.ruby_3_3

    # Node.js 20
    pkgs.nodejs_20

    # Yarn package manager
    pkgs.yarn

    # PostgreSQL client and libraries
    pkgs.postgresql

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
  ];

  env = {
    # Set library paths for native extensions
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      pkgs.openssl
      pkgs.zlib
      pkgs.libxml2
      pkgs.libxslt
      pkgs.readline
      pkgs.postgresql
    ];

    # PostgreSQL library path for pg gem
    LIBRARY_PATH = "${pkgs.postgresql}/lib";

    # Configure bundle to use system libraries
    BUNDLE_BUILD__PG = "--with-pg-config=${pkgs.postgresql}/bin/pg_config";
  };
}
