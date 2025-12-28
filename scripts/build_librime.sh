#!/bin/bash

set -xeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
mkdir -p bin lib

nix build -o nix-rume-build '.?submodules=1#rume'
cp --no-preserve=mode -Lr nix-rume-build/lib/* lib/
cp --no-preserve=mode -Lr nix-rume-build/bin/* bin/

nix build -o nix-rume-rust-build '.?submodules=1#rume-rust'
cp --no-preserve=mode -Lr nix-rume-rust-build/librume.dylib lib/
cp --no-preserve=mode -Lr nix-rume-rust-build/rume_api.h rume/include/

INSTALL_NAME_TOOL="$(xcrun -find install_name_tool)"
"$INSTALL_NAME_TOOL" -add_rpath @loader_path/../Frameworks bin/rime_deployer
"$INSTALL_NAME_TOOL" -add_rpath @loader_path/../Frameworks bin/rime_dict_manager
"$INSTALL_NAME_TOOL" -id @rpath/librume.dylib lib/librume.dylib

echo "librime build completed."
