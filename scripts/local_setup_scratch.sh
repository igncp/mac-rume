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

env -i PATH="/bin:/usr/bin:$HOME/homebrew/bin" HOME="$HOME" /bin/bash --norc \
  -c "$HOME/.nix-profile/bin/nix develop --command scripts/local_setup.sh"

rm -rf ~/development/mac-rume-test

echo "All setups tested successfully."
