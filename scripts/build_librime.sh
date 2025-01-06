#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
export BOOST_ROOT="$(find $SCRIPT_DIR/../librime/deps/boost-1.84.0 -maxdepth 0)"
export boost_version="1.84.0"
export RIME_PLUGINS="hchunhui/librime-lua lotem/librime-octagram rime/librime-predict"
export CMAKE_GENERATOR=Ninja
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

cd librime
./install-boost.sh || true
make deps || true
./action-install-plugins-macos.sh || true
make test
make install

cd ..
make copy-rime-binaries
