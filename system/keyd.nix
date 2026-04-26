{ config, pkgs, lib, ... }:

{
  services.keyd = {
    enable = true;

    keyboards.default = {
      ids = [ "*" ];

      settings = {
        main = {
          rightcontrol = "delete";
        };
      };
    };
  };
}
