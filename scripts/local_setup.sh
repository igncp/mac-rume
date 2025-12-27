#!/bin/bash

set -e

if ! type brew &>/dev/null; then
    echo "sudo rm -rf /Library/Developer/CommandLineTools && xcode-select --install"
    echo "brew install libiconv llvm"
    echo 'PATH="/bin:/usr/bin:$HOME/homebrew/bin" /bin/bash --norc'
    exit 1
fi

# The `-c ...` part is needed for the file transport when testing locally
git -c protocol.file.allow=always submodule update --init --recursive

swift-format lint -r -s sources

# Should be 3.X
cmake --version

bash scripts/build_librime.sh

bash scripts/install_deps.sh

make package

make install

echo "mac-rume setup completed."
