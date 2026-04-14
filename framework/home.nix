{ config, pkgs, inputs, pkgs-stable, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "akshay";
  home.homeDirectory = "/home/akshay";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    obsidian
    reaper
    libreoffice
    discord
    #spotify
    rustc
    unityhub
    steam
    stm32cubemx
    megasync
    fastfetch
    dconf-editor
    flameshot
    xeyes
    wl-clipboard
    appimage-run
    proton-vpn
    yabridge
    yabridgectl
    dxvk
    
    (writeShellScriptBin "moises" ''
    THEME=$(gsettings get org.gnome.desktop.interface color-scheme)

    if [[ "$THEME" == *"prefer-dark"* ]]; then
      GTK_THEME=Adwaita:dark appimage-run /home/akshay/AppImages/moises.appimage
    else
      GTK_THEME=Adwaita appimage-run /home/akshay/AppImages/moises.appimage
    fi
  '')
    
    gnomeExtensions.blur-my-shell
    gnomeExtensions.appindicator
    gnomeExtensions.rounded-window-corners-reborn
    gnomeExtensions.appimage-manager
    gnomeExtensions.tiling-assistant
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.forge
    gnomeExtensions.tiling-shell
    gnomeExtensions.search-light
    gnomeExtensions.space-bar
    gnomeExtensions.mosaic
    gnomeExtensions.launch-new-instance
    
    pkgs-stable.nerdfonts
    pkgs-stable.corefonts
    
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Now add the xdg.desktopEntries block outside of home.packages
  xdg.desktopEntries.moises = {
    name = "Moises";
    comment = "Moises Desktop App";
    exec = "moises";
    terminal = false;
    categories = [ "Utility" ];
    icon = "/home/akshay/AppImages/.icons/moises";  # Adjust icon path as needed
    startupNotify = true;
  };

  home.sessionPath = [ "/home/akshay/.local/share/yabridge" ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    
    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/akshay/etc/profile.d/hm-session-vars.sh
  #

  #home.sessionVariables = {
    # EDITOR = "emacs";
  #};

  home.sessionVariables = {
    # Add environment variables if needed
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    TERM = "kitty";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland;xcb";  # Use Wayland, fallback to XCB
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };
  
  programs.git = {
      enable = true;
      settings = {
        user.name = "Akshay Gopinath";
        user.email = "akshay8055.007@gmail.com";
      };
    };

  
  imports = [
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
    inputs.spicetify-nix.homeManagerModules.default
    ../user/app/flatpak.nix
  ];
  
  dconf = {
     enable = true;
     settings = { 
     "org/gnome/desktop/interface" = {
      icon-theme = "Adwaita";  # Use any installed theme like 'Papirus', 'Breeze', etc.
      cursor-theme = "Adwaita";  # Set the cursor theme declaratively
      gtk-theme = "Adwaita-dark";
    };
  
   "org/gnome/desktop/wm/preferences" = {
      theme = "Adwaita-dark";
    };

   "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" "xwayland-native-scaling"];  # Enables fractional scaling
       edge-tiling = true;  # Enables edge tiling (dragging windows to screen edges)
    };

  "org/gnome/mutter" = {
      "enable-native-xwayland" = true;
    };
    
    "org/gnome/desktop/sound" = {
      allow-volume-above-100-percent = true;
    };

    "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          # Put UUIDs of extensions that you want to enable here.
          # If the extension you want to enable is packaged in nixpkgs,
          # you can easily get its UUID by accessing its extensionUuid
          # field (look at the following example).
          pkgs.gnomeExtensions.blur-my-shell.extensionUuid
          pkgs.gnomeExtensions.appindicator.extensionUuid
          pkgs.gnomeExtensions.rounded-window-corners-reborn.extensionUuid
          pkgs.gnomeExtensions.clipboard-indicator.extensionUuid
          pkgs.gnomeExtensions.search-light.extensionUuid
          pkgs.gnomeExtensions.space-bar.extensionUuid
          pkgs.gnomeExtensions.launch-new-instance.extensionUuid
          # pkgs.gnomeExtensions.dash-to-dock.extensionUuid

          # Alternatively, you can manually pass UUID as a string.  
          # ...
        ];
      };
      
   };

 };
 
 xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [
        "kitty.desktop"
      ];
    };
  };

  programs.spicetify =
  let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in
  {
    enable = true;
    wayland = false;
  };
  
  programs.zsh =
  let
  # My shell aliases
  myAliases = {
    #ls = "eza --icons -l -T -L=1";
    #cat = "bat";
    #htop = "btm";
    #fd = "fd -Lu";
    #w3m = "w3m -no-cookie -v";
    #neofetch = "disfetch";
    #fetch = "disfetch";
    #gitfetch = "onefetch";
    #"," = "comma";
  };
in
{
    enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    shellAliases = myAliases;
  
   oh-my-zsh = {
    enable = true;
    plugins = [
      "git"         # also requires `programs.git.enable = true;`
    ];
    theme = "robbyrussell";
  };

  #home.packages = with pkgs; [
  #  disfetch lolcat cowsay onefetch
  #  gnugrep gnused
  #  bat eza bottom fd bc
  #  direnv nix-direnv
  #];
  dotDir = config.home.homeDirectory;
  #programs.direnv.enable = true;
  #programs.direnv.enableZshIntegration = true;
  #programs.direnv.nix-direnv.enable = true;
 };
 
  #programs.bash = {
  #  enable = true;
  #  enableCompletion = true;
  #  shellAliases = myAliases;
  #};
 
  
}
