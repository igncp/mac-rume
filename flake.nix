{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    flake-utils,
    nixpkgs,
    unstable,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        builds = import ./nix/builds.nix {
          inherit nixpkgs unstable system;
        };
        shell = import ./nix/shell.nix {
          inherit nixpkgs unstable system;
        };
      in {
        packages = {
          inherit (builds) mac-rume-deps plum-data rume rume-rust rume-extension;
        };
        devShells.default = shell.default;
      }
    );
}
