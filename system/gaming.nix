{config, pkgs, inputs, ... }:

{
    hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver   # Modern Intel GPUs
      intel-vaapi-driver           # Legacy fallback
      libva-vdpau-driver
      libvdpau-va-gl
      vulkan-tools
      vulkan-validation-layers
      intel-compute-runtime
    ];
  };

   #hardware.graphics.enable32Bit = true;

     services.xserver.videoDrivers = ["intel"];
  # hardware.opengl has beed changed to hardware.graphics
  
  # Steam
  programs.steam = {
    enable = true;
  };

  # Lutris
  environment.systemPackages = with pkgs; [
    lutris
    mangohud
    wineWow64Packages.yabridge
    winetricks
    gamemode
    protonup-qt
    heroic
    steam-run
    vkbasalt
  ];

  # Gamepad support
  hardware.steam-hardware.enable = true;
  services.udev.packages = with pkgs; [ 
    game-devices-udev-rules 
  ];

  # Gaming performance tools
  programs.gamemode.enable = true;

  # Vulkan
  #hardware.graphics.extraPackages = with pkgs; [
  #  vulkan-tools
  #  vulkan-validation-layers
  #];


}

