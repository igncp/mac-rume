{
  nixpkgs,
  unstable,
  system,
}: let
  common = import ./common.nix {
    inherit nixpkgs unstable system;
  };
  inherit (common) pkgs nativeBuildInputs shellHook;

  rime_version = "1.13.1";
  rime_git_hash = "1c23358";
  rime_deps_archive = "rime-deps-${rime_git_hash}-macOS-universal.tar.bz2";
  rime_deps_download_url = "https://github.com/rime/librime/releases/download/${rime_version}/${rime_deps_archive}";
  rimeDepsSrc = pkgs.fetchurl {
    url = rime_deps_download_url;
    sha256 = "sha256-K0/EReqoc/jDpkXaqymL+ioHKsOLJJQDuxQC0bhcjfw=";
  };

  # Consider building it locally, confirmed that it works with Xcode with a small change to use /bin/ld instead of ld
  sparkle_version = "2.6.2";
  sparkle_archive = "Sparkle-${sparkle_version}.tar.xz";
  sparkle_download_url = "https://github.com/sparkle-project/Sparkle/releases/download/${sparkle_version}/${sparkle_archive}";
  sparkleSrc = pkgs.fetchurl {
    url = sparkle_download_url;
    sha256 = "sha256-IwCn3CVFpJaOVGIbfzUdOI3fGly0nnn2yZ6aCdgm9eg=";
  };

  plumRepo = pkgs.fetchgit {
    url = "https://github.com/rime/plum.git";
    rev = "4c28f11f451facef809b380502874a48ba964ddb";
    sha256 = "sha256-4KrOYSNN2sjDhnMr4jZxF+0bPwRzj8oDsW0qSX23/dg=";
  };

  rumeCommitHash =
    pkgs.lib.traceValFn (x: "RUME_COMMIT_HASH: ${x}") (builtins.getEnv "RUME_COMMIT_HASH");
in rec {
  mac-rume-deps = pkgs.stdenvNoCC.mkDerivation {
    pname = "mac-rume-deps";
    version = "unstable";
    dontUnpack = true;
    packages = with pkgs; [
      gnutar
      xz
    ];
    buildPhase = "true";
    installPhase = ''
      set -euo pipefail
      mkdir -p "$out/rime-deps" "$out/sparkle"
      tar -xjf "${rimeDepsSrc}" -C "$out/rime-deps"
      tar -xJf "${sparkleSrc}" -C "$out/sparkle"
    '';
  };
  plum-data = pkgs.stdenvNoCC.mkDerivation {
    pname = "plum-data";
    version = "unstable";
    src = [plumRepo];
    buildPhase = "rime_dir=output bash rime-install";
    nativeBuildInputs = with pkgs; [
      cacert
      git
    ];
    installPhase = ''
      mkdir -p $out
      cp -r output $out/
      cp rime-install $out/
    '';
  };
  rume-extension = pkgs.rustPlatform.buildRustPackage {
    pname = "rume-extension";
    version = "unstable";
    src = ../rume/deps/rume_extension;
    cargoLock = {lockFile = ../rume/deps/rume_extension/Cargo.lock;};
    testPhase = "true";
    buildPhase = ''
      set -e
      make rume-extension
    '';
    nativeBuildInputs = with pkgs; [
      rust-cbindgen
      clippy
      gnumake
    ];
    installPhase = ''
      mkdir -p $out
      cp target/release/librume_extension.a $out/
      cp rume_extension.h $out/
    '';
  };
  rume-rust = pkgs.rustPlatform.buildRustPackage {
    pname = "rume-rust";
    version = "unstable";
    src = ../rume;
    cargoLock = {lockFile = ../rume/Cargo.lock;};
    testPhase = "true";
    buildPhase = ''
      set -e
      export TZ=Asia/Hong_Kong
      ${pkgs.lib.optionalString (rumeCommitHash != null) ''
        export RUME_COMMIT_HASH=${rumeCommitHash}
      ''}
      make librume
    '';
    nativeBuildInputs = with pkgs; [
      rust-cbindgen
      clippy
      gnumake
      astyle
      diffutils
      coreutils
    ];
    installPhase = ''
      mkdir -p $out
      cp target/release/librume.dylib $out/
      cp include/rume_api.h $out/
    '';
  };
  librime = pkgs.stdenvNoCC.mkDerivation {
    inherit shellHook;
    nativeBuildInputs =
      nativeBuildInputs
      ++ (with pkgs; [
        cacert
        git
      ]);
    pname = "librime";
    version = "unstable";
    src = ../rume;
    buildPhase = ''
      set -e
      ${shellHook}
      export RIME_PLUGINS="hchunhui/librime-lua lotem/librime-octagram rime/librime-predict"
      export CMAKE_GENERATOR=Ninja
      cp ${rume-extension}/rume_extension.h ./include/
      cp ${rume-extension}/librume_extension.a ./lib/
      ./scripts/action-install-plugins-macos.sh
      make test
      make install
    '';
    configurePhase = "echo skip";
    installPhase = ''
      mkdir -p $out/lib $out/bin $out/tools
      cp -L build/lib/librime.1.dylib $out/lib/
      cp -pR build/lib/rime-plugins $out/lib/
      cp build/bin/* $out/bin/
    '';
  };
}
