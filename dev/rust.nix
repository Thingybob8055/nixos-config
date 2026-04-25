{ pkgs }:

pkgs.mkShell {
 name = "rust-dev";

  packages = [
    pkgs.cargo
    pkgs.rustc
  ];

  shellHook = ''
    export RUST_SRC_PATH="${pkgs.rustPlatform.rustLibSrc}"
  '';
}
