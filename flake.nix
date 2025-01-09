{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    flake-utils,
    nixpkgs,
    self,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
        enable-flake = true; # Flag to quickly disable the flake
      in
        if enable-flake
        then {
          devShells.default = nixpkgs.legacyPackages."${system}".mkShellNoCC {
            nativeBuildInputs = with pkgs; [cmake pkg-config clang ninja llvm];
            packages = with pkgs; [swiftlint rust-cbindgen doxygen nodejs];
            # @TODO:
            # 1. Support .ccls in the `librime` directory
            # 2. Support building the XCode project
            shellHook = ''
              echo "Hello from ${system}!"
            '';
          };
        }
        else {}
    );
}
