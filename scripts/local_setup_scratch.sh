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

export PATH="$HOME/.rustup/toolchains/stable-aarch64-apple-darwin/bin:/bin:/usr/bin:$HOME/homebrew/bin:/Applications/CMake.app/Contents/bin"
env -i PATH="$PATH" /bin/bash --norc -c 'bash scripts/local_setup.sh'

rm -rf ~/development/mac-rume-test

echo "All setups tested successfully."
