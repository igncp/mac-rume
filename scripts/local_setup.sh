#!/bin/bash

set -e

# For rume, from the original GH actions
brew install llvm ninja clang-format

# For mac-rume
brew install swiftlint cmake boost

git submodule update --init --recursive

cargo install cbindgen

bash scripts/build_librime.sh

bash ./scripts/install_package.sh
