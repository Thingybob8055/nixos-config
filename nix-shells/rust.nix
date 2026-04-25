{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  packages = [ pkgs.rustc pkgs.cargo ];

  shellHook = ''
    export RUST_SRC_PATH="${pkgs.rustPlatform.rustLibSrc}"
  '';
}
