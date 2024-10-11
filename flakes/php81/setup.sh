#!/usr/bin/bash

BASE_DIR="$(pwd)"
PHP_VER="php81"
PHP_FPM_SERICE="${PHP_VER}-fpm.service"

# Build php and php-fpm
nix build $BASE_DIR

# link both php and php-fpm to somewhere in the path with their version number
PATH_PHP="/usr/bin/${PHP_VER}"
sudo rm -f $PATH_PHP
sudo ln -s "${BASE_DIR}/result/bin/php" $PATH_PHP

PATH_PHP_FPM="/usr/bin/${PHP_VER}-fpm"
sudo rm -f $PATH_PHP_FPM
sudo ln -s "${BASE_DIR}/result/bin/php-fpm" $PATH_PHP_FPM

# Setup systemctl things
# link this file to systemctl services location
SERVICE_DEST="/etc/systemd/system/multi-user.target.wants/${PHP_FPM_SERICE}"
sudo rm -f $SERVICE_DEST
sudo ln "${BASE_DIR}/${PHP_FPM_SERICE}" $SERVICE_DEST

# Reload systemctl services to reread the new config
sudo systemctl daemon-reload

# Enable the service to launch on boot
sudo systemctl enable $PHP_FPM_SERICE
echo "If theres an error \"Failed to enable unit\", it might be fine so just ignore it."

sudo systemctl start $PHP_FPM_SERICE
