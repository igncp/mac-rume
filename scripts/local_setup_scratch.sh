#!/bin/bash

set -exuo pipefail

# This script tests all the setups from a clean repository.
# It should be run always before running into main.

if [ -n "$(echo $PWD | grep mac-rume-test)" ]; then
    echo "Already in mac-rume-test directory. Exiting."
    exit 1
fi

mkdir -p ~/development
rm -rf ~/development/mac-rume-test
git clone ~/development/mac-rume ~/development/mac-rume-test
cd ~/development/mac-rume-test

git submodule set-url -- rume $HOME/development/mac-rume/rume

# Use all available cores and favor substituters to speed up a clean build.
CPU_CORES=$(sysctl -n hw.ncpu || echo 4)

env -i PATH="/bin:/usr/bin:$HOME/homebrew/bin" HOME="$HOME" /bin/bash --norc \
    -c "
        $HOME/.nix-profile/bin/nix \
            --option cores $CPU_CORES \
            --option max-jobs auto \
            --option http-connections 50 \
            --accept-flake-config \
            develop \
            --command scripts/local_setup.sh
    "

echo "All setups tested successfully."
