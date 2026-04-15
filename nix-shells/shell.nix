{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
    packages = [pkgs.gcc pkgs.cmake pkgs.libusb1 pkgs.rustc pkgs.stlink pkgs.stlink-tool pkgs.libusb1 pkgs.openocd pkgs.python311 pkgs.python3Packages.pip];
    shellHook = ''
    # Optional: tell VS Code and other tools where to find cmake automatically
    export PATH=$PATH
  '';
}
