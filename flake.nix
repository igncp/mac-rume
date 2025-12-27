{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  inputs.unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    flake-utils,
    nixpkgs,
    self,
    unstable,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
        unstablePkgs = import unstable {inherit system;};
        nativeBuildInputs = with pkgs; [
          astyle # For formatting new C/C++ code
          cargo
          clippy
          cmake
          glog
          gnumake # Ensure consistent GNU Make is available
          gtest
          leveldb
          marisa
          ninja
          opencc
          pkg-config # For discovering C/C++ library paths
          python3 # For building `opencc`
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
      in {
        packages.rume = pkgs.stdenvNoCC.mkDerivation {
          inherit shellHook;
          nativeBuildInputs = nativeBuildInputs ++ (with pkgs; [
            cacert
            git
          ]);
          pname = "rume";
          version = "unstable";
          src = ./rume;
          buildPhase = ''
            ${shellHook}
            export CARGO_HOME=$PWD/.cargo
            export RIME_PLUGINS="hchunhui/librime-lua lotem/librime-octagram rime/librime-predict"
            export CMAKE_GENERATOR=Ninja
            make deps
            ./scripts/action-install-plugins-macos.sh
            export TZ=Asia/Hong_Kong
            make test
            make install
          '';
          configurePhase = "echo skip";
          installPhase = ''
            mkdir -p $out/lib $out/bin
            cp -L build/lib/librime.1.dylib $out/lib/
            cp -pR build/lib/rime-plugins $out/lib/
            cp build/bin/rime_deployer $out/bin/
            cp build/bin/rime_dict_manager $out/bin/
            cp target/release/librume.dylib $out/lib/
          '';
        };
        devShells.default = nixpkgs.legacyPackages."${system}".mkShellNoCC {
          inherit (pkgs) stdenvNoCC;
          inherit shellHook nativeBuildInputs;
          packages = with pkgs; [
            doxygen
            nodejs
            nix
          ];
        };
      }
    );
}
