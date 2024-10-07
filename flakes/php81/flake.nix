{
  description = "builds php 81 with fpm and extensions";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    phps.url = "github:fossar/nix-phps";
  };

  outputs = { self, nixpkgs, phps }: {
    packages.x86_64-linux.default = let
      php81 = phps.packages.x86_64-linux.php81.buildEnv {
        extensions = ({ enabled, all }: enabled ++ (with all; [
          bcmath
          calendar
          ctype
          # Core
          curl
          # date
          dom
          exif
          fileinfo
          filter
          ftp
          gd
          gettext
          gmp
          # hash
          iconv
          imap
          intl
          # json
          ldap
          # libxml
          mbstring
          mysqli
          mysqlnd
          openssl
          pcntl
          # pcre
          # PDO
          pdo_mysql
          # PDO_ODBC
          pdo_pgsql
          pdo_sqlite
          pgsql
          # Phar
          posix
          readline
          # Reflection
          session
          # SimpleXML
          soap
          sockets
          sodium
          # SPL
          sqlite3
          # standard
          sysvsem
          tokenizer
          xml
          xmlreader
          xmlwriter
          # Zend OPcache
          zip
          zlib
          redis
        ]));
      };
      fpmConfPath = ./php-fpm.conf;
    in
      php81.overrideAttrs (old: rec {
        # extensions = old.extensions ++ [ extRedis ];  # Add the Redis extension
        # Define the installPhase explicitly, or append if it exists
        postInstall = ''
          ${if old ? installPhase then old.installPhase else ""}
          # Copy custom php-fpm.conf to the output path
          mkdir -p $out/etc
          ln -s ${fpmConfPath} $out/etc/php-fpm.conf
        '';
      });
  };
}
