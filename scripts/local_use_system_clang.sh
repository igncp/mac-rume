#!/bin/bash

set -e

# This is important to use the system SDK and not any Nix SDK
unset MACOSX_DEPLOYMENT_TARGET
unset DEVELOPER_DIR
export SDKROOT="$(/usr/bin/xcrun --sdk macosx --show-sdk-path)"

echo "Using SDKROOT: $SDKROOT"

if [ ! -d "$SDKROOT" ]; then
    echo "Error: SDKROOT path does not exist: $SDKROOT"
    exit 1
fi

# This should not be using any Nix paths
echo 'XCode Path:'
xcode-select --print-path
