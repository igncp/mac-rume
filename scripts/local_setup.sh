#!/bin/bash

set -e

if ! type cmake &>/dev/null; then
    echo "Error: cmake is not installed. Please install cmake and try again."
    echo "Download v3.31.10 from: cmake-3.31.10-macos-universal.dmg - https://cmake.org/download/"
    echo "sudo rm -rf /Library/Developer/CommandLineTools && xcode-select --install"
    echo "brew install ninja libiconv cmake llvm cbindgen"
    echo 'PATH="$HOME/.rustup/toolchains/stable-aarch64-apple-darwin/bin:/bin:/usr/bin:$HOME/homebrew/bin:/Applications/CMake.app/Contents/bin" /bin/bash --norc'
    exit 1
fi

if [ -n "$MACOSX_DEPLOYMENT_TARGET" ]; then
    echo "Warning: MACOSX_DEPLOYMENT_TARGET is set to '$MACOSX_DEPLOYMENT_TARGET'. Stopping."
    exit 1
fi

git submodule update --init --recursive

# This should not be using any Nix paths
xcode-select --print-path

bash scripts/build_librime.sh

bash scripts/install_deps.sh

make package

make install

echo "mac-rume setup completed."
