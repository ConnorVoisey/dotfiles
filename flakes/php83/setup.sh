#!/usr/bin/bash

set -e  # Exit on any error
set -o pipefail  # Capture failures in pipes
set -u  # Treat unset variables as errors

BASE_DIR="$(pwd)"
PHP_VER="php83"
PHP_FPM_SERVICE="${PHP_VER}-fpm.service"

# Helper function to log error and exit
function handle_error {
    echo "Error on line $1"
    exit 1
}

# Trap errors and call handle_error
trap 'handle_error $LINENO' ERR

# Build PHP and PHP-FPM
echo "Building PHP and PHP-FPM..."
nix build "$BASE_DIR" || { echo "Failed to build PHP with Nix."; exit 1; }

# Link PHP and PHP-FPM to somewhere in the path with their version number
PATH_PHP="/usr/bin/${PHP_VER}"
echo "Linking PHP binary..."
if sudo rm -f "$PATH_PHP"; then
    sudo ln -s "${BASE_DIR}/result/bin/php" "$PATH_PHP" || { echo "Failed to link PHP binary."; exit 1; }
else
    echo "Failed to remove existing PHP link."; exit 1;
fi

PATH_PHP_FPM="/usr/bin/${PHP_VER}-fpm"
echo "Linking PHP-FPM binary..."
if sudo rm -f "$PATH_PHP_FPM"; then
    sudo ln -s "${BASE_DIR}/result/bin/php-fpm" "$PATH_PHP_FPM" || { echo "Failed to link PHP-FPM binary."; exit 1; }
else
    echo "Failed to remove existing PHP-FPM link."; exit 1;
fi

# Setup systemctl things
# Link service file to systemctl services location
SERVICE_DEST="/etc/systemd/system/${PHP_FPM_SERVICE}"
echo "Linking PHP-FPM service file..."
if sudo rm -f "$SERVICE_DEST"; then
    sudo ln -s "${BASE_DIR}/${PHP_FPM_SERVICE}" "$SERVICE_DEST" || { echo "Failed to link PHP-FPM service file."; exit 1; }
else
    echo "Failed to remove existing service file link."; exit 1;
fi

# Reload systemctl services to reread the new config
echo "Reloading systemctl daemon..."
sudo systemctl daemon-reload || { echo "Failed to reload systemctl daemon."; exit 1; }

# Enable the service to launch on boot
echo "Enabling PHP-FPM service..."
if sudo systemctl enable "$PHP_FPM_SERVICE"; then
    echo "Service enabled successfully."
else
    echo "Failed to enable PHP-FPM service."; exit 1;
fi

# Start the service
echo "Starting PHP-FPM service..."
sudo systemctl start "$PHP_FPM_SERVICE" || { echo "Failed to start PHP-FPM service."; exit 1; }

echo "Script completed successfully."

