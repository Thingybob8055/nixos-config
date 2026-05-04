{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "nixpkgs/nixos-24.05";

    #nix-flatpak.url = "github:gmodena/nix-flatpak"; # unstable branch. Use github:gmodena/nix-flatpak/?ref=<tag> to pin releases.

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

   # minegrub-theme.url = "github:Lxtharia/minegrub-theme";

     home-manager = {
       url = "github:nix-community/home-manager";
       inputs.nixpkgs.follows = "nixpkgs";
     };
  };

   outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      #pkgs = import nixpkgs {
      #  system = system;
      #  config.allowUnfree = true; # Enable unfree packages globally
      #};

      ##### USER SETTINGD
      userSettings = rec {
          username = "akshay";
	  name = "Akshay";
          email= "akshay8055.007@gmail.com";
      };

       # ---- SYSTEM SETTINGS ---- #
      systemSettings = {
        system = "x86_64-linux"; # system arch
        hostname = "nixos"; # hostname
        profile = "gnome"; # select a profile defined from my profiles directory
      };

      pkgs-stable = import inputs.nixpkgs-stable {
       system = systemSettings.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

  
    in {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; inherit pkgs-stable;};
        modules = [
          #(./. + "/hosts" + ("/" + systemSettings.profile) + "/configuration.nix")
          inputs.nix-flatpak.nixosModules.nix-flatpak
          inputs.nixos-hardware.nixosModules.framework-12th-gen-intel
          ./system/app/flatpak.nix
          ./framework/configuration.nix
          {
           nixpkgs.config.allowUnfree = true;
          }
          inputs.home-manager.nixosModules.default
          {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
          }
          #inputs.minegrub-theme.nixosModules.default
          #inputs.disko.nixosModules.disko
        ];

      };
      
      devShells.x86_64-linux = {
           rust-dev = import ./dev/rust.nix { pkgs = nixpkgs.legacyPackages.x86_64-linux; };

           embed-dev = import ./dev/embed.nix { pkgs = nixpkgs.legacyPackages.x86_64-linux; };
     };

      #homeConfigurations = {
      #  akshay = inputs.home-manager.lib.homeManagerConfiguration {
      #    pkgs = import nixpkgs {
      #      system = system;
      #      config.allowUnfree = true; # Enable unfree for home-manager too
      #    };
      #    extraSpecialArgs = { inherit inputs; inherit systemSettings;
      #      inherit userSettings;  inherit pkgs-stable;};
      #    modules = [
      #      (./. + "/hosts" + ("/" + systemSettings.profile) + "/home.nix")
      #      #inputs.plasma-manager.homeManagerModules.plasma-manager
      #      #inputs.nix-flatpak.homeManagerModules.nix-flatpak
      #    ];
      #  };
      #};
      
    };
}
