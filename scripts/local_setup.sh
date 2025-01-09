#!/bin/bash

set -e

# Moved to flake.nix ---
# # For rume, from the original GH actions
# brew install llvm ninja clang-format

# # For mac-rume
# brew install swiftlint cmake boost
#
# cargo install cbindgen
# ---

git submodule update --init --recursive

bash scripts/build_librime.sh

bash ./scripts/install_package.sh
