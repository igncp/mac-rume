#!/usr/bin/env bash

set -e

nix build -o nix-mac-rume-deps '.#mac-rume-deps'

rm -rf data/opencc data/plum Frameworks
mkdir -p data/opencc data/plum Frameworks

cp --no-preserve=mode -R nix-mac-rume-deps/rime-deps/share/opencc data/
cp --no-preserve=mode -R nix-mac-rume-deps/sparkle/Sparkle.framework Frameworks/

nix build -o nix-plum-data --impure '.?submodules=1#plum-data'

cp --no-preserve=mode nix-plum-data/output/*.* data/plum/
cp --no-preserve=mode nix-plum-data/rime-install bin/
cp --no-preserve=mode nix-plum-data/output/opencc/*.* data/opencc/ >/dev/null 2>&1 || true
