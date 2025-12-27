#!/bin/bash

set -xeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
nix build -o rume-build --impure '.?submodules=1#rume'
mkdir -p bin lib

cp -Lr rume-build/lib/* lib/
cp -Lr rume-build/bin/* bin/

INSTALL_NAME_TOOL="$(xcrun -find install_name_tool)"

"$INSTALL_NAME_TOOL" -add_rpath @loader_path/../Frameworks bin/rime_deployer
"$INSTALL_NAME_TOOL" -add_rpath @loader_path/../Frameworks bin/rime_dict_manager
"$INSTALL_NAME_TOOL" -id @rpath/librume.dylib lib/librume.dylib

echo "librime build completed."
