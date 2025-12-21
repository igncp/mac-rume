#!/bin/bash

set -xeuo pipefail

RUME_BUILD_TYPE="${RUME_BUILD_TYPE:=minimal}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
export RIME_PLUGINS="hchunhui/librime-lua lotem/librime-octagram rime/librime-predict"
export BOOST_ROOT="$(find $SCRIPT_DIR/../librime/deps -maxdepth 0)/boost-1.89.0"
export CMAKE_GENERATOR=Ninja

cd librime

sed -i 's|{BOOST_ROOT=|{BOOST_ROOT:-|' ./install-boost.sh
bash ./install-boost.sh
make deps

./action-install-plugins-macos.sh || true
make test
make install

cd ..
make copy-rime-binaries

echo "librime build completed."
