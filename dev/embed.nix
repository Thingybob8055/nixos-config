{ pkgs }:

pkgs.mkShell {
 name = "embed-dev";

  packages = [
    pkgs.gcc
    pkgs.cmake
    pkgs.libusb1
    pkgs.openocd
    pkgs.stlink
    pkgs.stlink-tool
    pkgs.python311
    pkgs.python3Packages.pip
  ];
  shellHook = ''
    # Optional: tell VS Code and other tools where to find cmake automatically
    export PATH=$PATH
    if [ -z "$ZSH_VERSION" ]; then
      exec zsh
    fi
  '';

}
