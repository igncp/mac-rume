#!/usr/bin/env bash

set -e

rime_version=1.13.1
rime_git_hash="1c23358"
sparkle_version=2.6.2

# This is currently only used for the opencc json files, try to build them
rime_deps_archive="rime-deps-${rime_git_hash}-macOS-universal.tar.bz2"
rime_deps_download_url="https://github.com/rime/librime/releases/download/${rime_version}/${rime_deps_archive}"

sparkle_archive="Sparkle-${sparkle_version}.tar.xz"
sparkle_download_url="https://github.com/sparkle-project/Sparkle/releases/download/${sparkle_version}/${sparkle_archive}"

mkdir -p download && (
    cd download
    [ -z "${no_download}" ] && curl -LO "${rime_deps_download_url}"
    tar --bzip2 -xf "${rime_deps_archive}"
    [ -z "${no_download}" ] && curl -LO "${sparkle_download_url}"
    tar -xJf "${sparkle_archive}"
)

mkdir -p rume/share
mkdir -p Frameworks
cp -R download/share/opencc rume/share/
cp -R download/Sparkle.framework Frameworks/

make copy-opencc-data
rime_dir=plum/output bash plum/rime-install ${SQUIRREL_BUNDLED_RECIPES}
make copy-plum-data
