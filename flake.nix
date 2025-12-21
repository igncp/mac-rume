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
            # pkg-config
            # clang
            # llvm

            cmake
            ninja
            rustc
            clippy
            rust-analyzer
            cargo
            python3 # For building `opencc`
          ];
          packages = with pkgs; [swiftlint rust-cbindgen doxygen nodejs];
          # @TODO:
          # 1. Support .ccls in the `librime` directory
          shellHook = ''
            export PATH=$(echo "$PATH" |
              sed -e 's|/[^:]*libiconv[^:]*:||g' |
              sed -e 's|/[^:]*xcbuild[^:]*:||g')
            echo "Hello from ${system}!"
          '';
        };
      }
    );
}
