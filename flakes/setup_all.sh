#!/usr/bin/bash

set -e  # Exit on any error
set -o pipefail  # Capture failures in pipes
set -u  # Treat unset variables as errors

for version in php56 php71 php74 php80 php81 php82 php83 php84; do
    echo "started $version"
    cd "$version" && ./setup.sh && cd ..
    echo "finished $version"
done
