{
  description = "builds php 56 with fpm and extensions";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    phps.url = "github:fossar/nix-phps";
  };

  outputs = { self, nixpkgs, phps }: {
    packages.x86_64-linux.default = 
       phps.packages.x86_64-linux.php56.buildEnv {
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
          # sodium
          # SPL
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
      };
      fpmConfPath = ./php-fpm.conf;
      extraConfig = ''
          xdebug.mode=debug
          memory_limit = 2G
      '';
  };
}

