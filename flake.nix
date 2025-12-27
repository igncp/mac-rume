{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    flake-utils,
    nixpkgs,
    self,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        devShells.default = nixpkgs.legacyPackages."${system}".mkShellNoCC {
          inherit (pkgs) stdenvNoCC;
          nativeBuildInputs = with pkgs; [
            cmake
            ninja
            rustc
            clippy
            rust-analyzer
            rustfmt
            astyle # For formatting new C/C++ code
            cargo
            python3 # For building `opencc`
          ];
          packages = with pkgs; [rust-cbindgen doxygen nodejs];
          # @TODO:
          # 1. Support .ccls in the `librime` directory
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
        };
      }
    );
}
