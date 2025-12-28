{
  nixpkgs,
  unstable,
  system,
}: let
  common = import ./common.nix {
    inherit nixpkgs unstable system;
  };

  inherit (common) pkgs nativeBuildInputs shellHook;
in {
  default = nixpkgs.legacyPackages."${system}".mkShellNoCC {
    inherit (pkgs) stdenvNoCC;
    inherit shellHook nativeBuildInputs;
    packages = with pkgs; [
      doxygen
      nix
      nodejs
      shfmt
      statix
    ];
  };
}
