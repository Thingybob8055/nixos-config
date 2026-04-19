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
    spotify
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
    vesktop
    equibop
    (pkgs.bottles.override {
    removeWarningPopup = true;
    })
    
    (writeShellScriptBin "vesktop-themed" ''
      THEME=$(gsettings get org.gnome.desktop.interface color-scheme)

     unset ELECTRON_OZONE_PLATFORM_HINT
     unset NIXOS_OZONE_WL

     if [[ "$THEME" == *"prefer-dark"* ]]; then
        GTK_THEME=Adwaita:dark vesktop --ozone-platform=x11
    else
      GTK_THEME=Adwaita vesktop --ozone-platform=x11
   fi
   '')
   
   (writeShellScriptBin "spotify-xwayland" ''
      THEME=$(gsettings get org.gnome.desktop.interface color-scheme)

     unset ELECTRON_OZONE_PLATFORM_HINT
     unset NIXOS_OZONE_WL
     spotify --ozone-platform=x11
   '')
    
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
    gnomeExtensions.pop-shell
    #gnomeExtensions.dash-to-dock
    
    (pkgs.gnomeExtensions.dash-to-dock.overrideAttrs (old: {
       version = "102";
       src = pkgs.fetchzip {
       url = "https://extensions.gnome.org/extension-data/dash-to-dockmicxgx.gmail.com.v102.shell-extension.zip";
    sha256 = "sha256-nks4PIEVmX6THDRAb8PU7t5FuX4w781B8TzcpQRl2yw=";
    stripRoot = false;
     };
    }))
    
    pkgs-stable.nerdfonts
    pkgs-stable.corefonts
    pkgs-stable.neofetch
    
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
  
  xdg.desktopEntries.vesktop = {
    name = "Vesktop";
    comment = "Discord with proper GNOME theming";
    exec = "vesktop-themed";
    icon = "${pkgs.vesktop}/share/icons/hicolor/256x256/apps/vesktop.png";
    terminal = false;
    categories = [ "Network" "Chat" ];
    startupNotify = true;
 };
 
 xdg.desktopEntries.spotify = {
    name = "Spotify";
    comment = "Spotify";
    exec = "spotify-xwayland %U";
    icon = "${pkgs.spotify}/share/icons/hicolor/256x256/apps/spotify-client.png";
    terminal = false;
    categories = [ "Audio" "Music" "Audio" "AudioVideo"];
    startupNotify = true;
 };

  home.sessionPath = [ "/home/akshay/.local/share/yabridge" ];

  home.file.".config/pop-shell/config.json".text = builtins.toJSON {
  float = [
    {
      class = "pop-shell-example";
      title = "pop-shell-example";
    }
    {
      title = "Proton VPN";  # adjust if needed
    }
    {
      title = "MEGAsync";
    }
  ];
  skiptaskbarhidden = [];
  log_on_focus = false;
 };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  #home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    
    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  #};

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
    #inputs.spicetify-nix.homeManagerModules.default
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
      "dynamic-workspaces" = false;
    };
    
    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 10;
    };
    
    "org/gnome/desktop/sound" = {
      allow-volume-above-100-percent = true;
    };
    
    ################### KEY BINDS FOR TILING ######################

    # Media keys (screensaver, browser, etc.)
      "org/gnome/settings-daemon/plugins/media-keys" = {
        # Disable overview / "quick settings" binding (Super+S)
        # GNOME uses "toggle-overview" for this in many setups
        toggle-overview = [ "@as []" ];
      
        screensaver = [ "<Super>Escape" ];
        www = [ "<Super>b" ];

        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        ];
      };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "Nautilus";
        command = "nautilus -w";
        binding = "<Super>f";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        name = "KGX";
        command = "kgx";
        binding = "<Super>t";
      };

      # -----------------------------
      # WM keybindings
      # -----------------------------
      "org/gnome/desktop/wm/keybindings" = {
        toggle-maximized = [ "<Super>m" ];
        
        maximize = [ "@as []" ];
        unmaximize = [ "@as []" ];
        
        # Close window
        close = [
          "<Super>q"
          "<Alt>F4"
        ];
        
        switch-input-source = ["XF86Keyboard"];

        move-to-monitor-left =  [ "<Super><Shift><Control>Left" ];
        move-to-monitor-right = [ "<Super><Shift><Control>Right" ];
        move-to-monitor-up =    [ "<Super><Shift><Control>Up" ];
        move-to-monitor-down =  [ "<Super><Shift><Control>Down" ];

        # Move WINDOW to workspace (what you asked for)
       move-to-workspace-left = [ "<Super><Control>Left" ];
       move-to-workspace-right = [ "<Super><Control>Right" ];
        
        tile-window-left = [ "@as []" ];
        tile-window-right = [ "@as []" ];
        
        switch-to-workspace-1 = ["<Super>1"];
        switch-to-workspace-2 = ["<Super>2"];
        switch-to-workspace-3 = ["<Super>3"];
        switch-to-workspace-4 = ["<Super>4"];
        switch-to-workspace-5 = ["<Super>5"];
        switch-to-workspace-6 = ["<Super>6"];
        switch-to-workspace-7 = ["<Super>7"];
        switch-to-workspace-8 = ["<Super>8"];
        switch-to-workspace-9 = ["<Super>9"];
        switch-to-workspace-10 = ["<Super>0"];
        
        move-to-workspace-1 = ["<Shift><Super>1"];
        move-to-workspace-2 = ["<Shift><Super>2"];
        move-to-workspace-3 = ["<Shift><Super>3"];
        move-to-workspace-4 = ["<Shift><Super>4"];
        move-to-workspace-5 = ["<Shift><Super>5"];
        move-to-workspace-6 = ["<Shift><Super>6"];
        move-to-workspace-7 = ["<Shift><Super>7"];
        move-to-workspace-8 = ["<Shift><Super>8"];
        move-to-workspace-9 = ["<Shift><Super>9"];
        move-to-workspace-10 = ["<Shift><Super>0"];
      };

      # -----------------------------
      # Mutter (tiling system)
      # -----------------------------
       "org/gnome/mutter/keybindings" = {
          #completely disable built-in tiling shortcuts
          toggle-tiled-left = [ "@as []" ];
          toggle-tiled-right = [ "@as []" ];
       };
       
       "org/gnome/shell/keybindings" = {
          # completely disable built-in tiling shortcuts
          switch-to-application-1 = [ "@as []" ];
          switch-to-application-2 = [ "@as []" ];
          switch-to-application-3 = [ "@as []" ];
          switch-to-application-4 = [ "@as []" ];
          switch-to-application-5 = [ "@as []" ];
          switch-to-application-6 = [ "@as []" ];
          switch-to-application-7 = [ "@as []" ];
          switch-to-application-8 = [ "@as []" ];
          switch-to-application-9 = [ "@as []" ];
          toggle-quick-settings = [ "@as []" ];
          toggle-message-tray = [ "<Super>v" ];
       };

     "org/gnome/shell/extensions/forge/keybindings" = {
          window-focus-left = ["<Super>left"];
          window-focus-right = ["<Super>right"];
          window-focus-up = ["<Super>up"];
          window-focus-down = ["<Super>down"];
          workspace-active-tile-toggle = ["<Super>y"];
          con-split-layout-toggle = ["<Super>c"];
          window-toggle-float = ["<Super>g"];
          window-toggle-always-float = ["<Shift><Super>g"];
          
          window-swap-left =  ["<Shift><Super>left"];
          window-swap-right = ["<Shift><Super>right"];
          window-swap-up =    ["<Shift><Super>up"];
          window-swap-down =  ["<Shift><Super>down"];
          
          mod-mask-mouse-file = ["<Super>"];
          
          prefs-tiling-toggle = ["<Shift><Super>y"];
     };
     
     "org/gnome/shell/extensions/space-bar/behavior" = {
          toggle-overview = false;
     };
     
     "org/gnome/shell/extensions/pop-shell" = {
          hint-color-rgba = "rgba(110, 147, 204, 1)";
          #active-hint-border-radius = 17;
     };
     
     "org/gnome/shell/extensions/search-light" = {
          shortcut-search = ["<Super>space"];
     };
     
     "org/gnome/shell/extensions/dash-to-dock" = {
          hot-keys = false;
          intellihide-mode = "ALL_WINDOWS";
     };
 
   ################### KEY BINDS FOR TILING ######################

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
          pkgs.gnomeExtensions.pop-shell.extensionUuid
          #pkgs.gnomeExtensions.forge.extensionUuid
          pkgs.gnomeExtensions.dash-to-dock.extensionUuid

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

  #programs.spicetify =
  #let
  #  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  #in
  #{
  #  enable = true;
  #  wayland = false;
  #};
  
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
