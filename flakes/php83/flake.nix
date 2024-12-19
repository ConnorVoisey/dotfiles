{
  description = "builds php 83 with fpm and extensions";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    phps.url = "github:fossar/nix-phps";
  };

  outputs = { self, nixpkgs, phps }: {
    packages.x86_64-linux.default = 
       phps.packages.x86_64-linux.php83.buildEnv {
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
          pdo
          pdo_mysql
          # PDO_ODBC
          pdo_pgsql
          pdo_sqlite
          pgsql
          # phar
          posix
          readline
          # reflection
          session
          simplexml
          soap
          sockets
          sodium
          # spl
          sqlite3
          # standard
          sysvsem
          tokenizer
          xdebug
          # xml
          xmlreader
          xmlwriter
          # Zend OPcache
          zip
          zlib
          redis
        ]));
        extraConfig = ''
            xdebug.mode=debug
            memory_limit = 2G
        '';
      };
  };
}

