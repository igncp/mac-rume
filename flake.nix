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
            echo "Hello from ${system}!"
          '';
        };
      }
    );
}
