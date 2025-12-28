{
  nixpkgs,
  unstable,
  system,
}: rec {
  pkgs = import nixpkgs {inherit system;};
  unstablePkgs = import unstable {inherit system;};

  nativeBuildInputs = with pkgs; [
    alejandra
    astyle # For formatting new C/C++ code
    cargo
    clippy
    cmake
    glog
    gnumake
    gtest
    leveldb
    marisa
    ninja
    opencc
    pkg-config # For discovering C/C++ library paths
    rust-analyzer
    rust-cbindgen
    rustc
    rustfmt
    unstablePkgs.boost189
    yaml-cpp
  ];

  shellHook = ''
    # Provides `swift-format` and other Swift tools
    export PATH="$PATH:/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin"

    export PATH=$(echo "$PATH:/Library/Input Methods/Squirrel.app/Contents/MacOS" |
      sed -e 's|/[^:]*libiconv[^:]*:||g' |
      sed -e 's|/[^:]*xcbuild[^:]*:||g')

    # This is important to use the system SDK and not any Nix SDK
    unset MACOSX_DEPLOYMENT_TARGET
    unset DEVELOPER_DIR
    export SDKROOT="$(/usr/bin/xcrun --sdk macosx --show-sdk-path)"

    if [ ! -d "$SDKROOT" ]; then
        echo "Error: SDKROOT path does not exist: $SDKROOT"
        exit 1
    fi

    # This should not be using any Nix paths
    # xcode-select --print-path
  '';
}
