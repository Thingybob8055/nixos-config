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
    unityhub
    steam
    stm32cubemx
    megasync
    fastfetch
    dconf-editor
    #flameshot
    xeyes
    wl-clipboard
    appimage-run
    proton-vpn
    yabridge
    yabridgectl
    dxvk
    vesktop
    equibop
    davinci-resolve
    ffmpeg
    (pkgs.bottles.override {
    removeWarningPopup = true;
    })
    
    waybar
    wdisplays
    brightnessctl
    pamixer
    pavucontrol
    wireplumber
    playerctl
    adwaita-icon-theme
    nerd-fonts.jetbrains-mono
    lexend
    nwg-look
    
    grim
    slurp
    swappy
    wl-clipboard
    cliphist
    libnotify
    swaynotificationcenter
    wofi
    libsForQt5.qt5ct
    qt6Packages.qt6ct
    kdePackages.qtstyleplugin-kvantum
    kdePackages.breeze-icons
    copyq
    hyprlock
    hypridle
    hyprshell
    # sherlock-launcher

    adw-gtk3
    adwaita-qt
    adwaita-qt6
    intel-gpu-tools
    wleave
    adwaita-icon-theme
    hicolor-icon-theme
    awww
    kitty-themes
    google-fonts
    icomoon-feather
    nerd-fonts.iosevka
    satty
    grimblast

    #wofi
    #hyprlauncher
    swayosd
    jq

    # (pkgs.catppuccin-gtk.override {
    #   accents = [ "blue" ]; # Choose your accent
    #   size = "standard";
    #   variant = "mocha";    # Change from "frappe" to "mocha", "macchiato", or "latte"
    # })

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
    
    (writeShellScriptBin "resolve-transcode" ''
     #!/usr/bin/env bash

     set -e

     INPUT="$1"
     CODEC="''${2:-dnxhr}"   # dnxhr | prores | cineform
     AUDIO_BITS="''${3:-16}" # 16 or 24

     if [ -z "$INPUT" ]; then
        echo "Usage: resolve-transcode <file|directory> [dnxhr|prores|cineform] [16|24]"
        exit 1
     fi

     # Audio setting
     if [ "$AUDIO_BITS" = "24" ]; then
       AUDIO_CODEC="pcm_s24le"
     else
       AUDIO_CODEC="pcm_s16le"
     fi

     convert_file() {
       INFILE="$1"
       BASENAME=$(basename "$INFILE")
       NAME="''${BASENAME%.*}"
       OUTFILE="''${NAME}_resolve.mov"

    echo "Converting: $INFILE -> $OUTFILE"

    case "$CODEC" in
      dnxhr)
         ffmpeg -y -i "$INFILE" \
          -c:v dnxhd -profile:v dnxhr_hq \
          -pix_fmt yuv422p \
          -c:a "$AUDIO_CODEC" \
          "$OUTFILE"
        ;;
    prores)
      ffmpeg -y -i "$INFILE" \
        -c:v prores -profile:v 3 \
        -pix_fmt yuv422p10le \
        -c:a "$AUDIO_CODEC" \
        "$OUTFILE"
      ;;
    cineform)
      ffmpeg -y -i "$INFILE" \
        -c:v cfhd -quality 3 \
        -pix_fmt yuv422p \
        -c:a "$AUDIO_CODEC" \
        "$OUTFILE"
      ;;
    *)
      echo "Unknown codec: $CODEC"
      exit 1
      ;;
    esac
  }

  if [ -f "$INPUT" ]; then
     convert_file "$INPUT"
  elif [ -d "$INPUT" ]; then
     for f in "$INPUT"/*; do
     [ -f "$f" ] && convert_file "$f"
   done
  else
  echo "Invalid input: $INPUT"
  exit 1
  fi
  '')

  (writeShellScriptBin "screenshot" ''
      set -e

      dir="$HOME/Pictures/Screenshots"
      mkdir -p "$dir"

      file="$dir/screen-$(date +%Y-%m-%d-%H-%M-%S).png"

      mode="$1"

      if [ "$mode" = "area" ]; then
        grim -g "$(slurp)" - | tee "$file" | wl-copy
      else
        grim "$file"
        cat "$file" | wl-copy
      fi

      swappy -f "$file"
    '')

    (writeShellScriptBin "screenshot-satty-file" ''
      set -e

      dir="$HOME/Pictures/Screenshots"
      mkdir -p "$dir"

      file="$dir/screen-$(date +%Y-%m-%d-%H-%M-%S).png"
      mode="$1"

      if [ "$mode" = "area" ]; then
        grim -g "$(slurp)" "$file"
      else
        grim "$file"
      fi

      satty --filename "$file" --copy-command wl-copy
    '')
    
    (pkgs.writeShellScriptBin "hypr-lid" ''
       #!/usr/bin/env bash

      EXTERNAL=$(hyprctl monitors -j | jq '[.[] | select(.name != "eDP-1")] | length')

      EVENT="$1"

      echo "External monitors: $EXTERNAL"

      if [[ "$EVENT" == "close" ]]; then
        if [[ "$EXTERNAL" -gt 0 ]]; then
          hyprctl keyword monitor eDP-1,disable
        else
          loginctl lock-session
          sleep 0.5
          systemctl suspend -i
        fi
      fi

      if [[ "$EVENT" == "open" ]]; then
        if [[ "$EXTERNAL" -gt 0 ]]; then
          hyprctl reload
        fi
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
    pkgs-stable.fira
    pkgs-stable.roboto
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

  # gtk.gtk4.theme = config.gtk.theme;

  # gtk = {
  #   enable = true;

  #   theme = {
  #     name = "catppuccin-mocha-blue-standard";
  #     package = pkgs.catppuccin-gtk.override {
  #       variant = "mocha";
  #       accents = [ "blue" ];
  #       size = "standard";
  #     };
  #   };
  # };

  home.sessionVariables = {
    # Add environment variables if needed
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    TERM = "kitty";
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland;xcb";  # Use Wayland, fallback to XCB
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    # QT_STYLE_OVERRIDE = "Adwaita-Dark";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [ python311 ]);
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

  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
    };
    extraConfig = ''
      include ${pkgs.kitty-themes}/share/kitty-themes/themes/adwaita_dark.conf
    '';
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    plugins = with pkgs; [
      rofi-calc
      rofi-power-menu
    ];
  };

  xdg.configFile."rofi/config.rasi".text = ''
    configuration {
    /*---------- General setting ----------*/
    modi: "drun,run,filebrowser,window";
    case-sensitive: false;
    cycle: true;
    filter: "";
    scroll-method: 0;
    normalize-match: true;
    show-icons: true;
    icon-theme: "Papirus";
  /*	cache-dir: ;*/
    steal-focus: false;
  /*	dpi: -1;*/

    /*---------- Matching setting ----------*/
    matching: "normal";
    tokenize: true;

    /*---------- SSH settings ----------*/
    ssh-client: "ssh";
    ssh-command: "{terminal} -e {ssh-client} {host} [-p {port}]";
    parse-hosts: true;
    parse-known-hosts: true;

    /*---------- Drun settings ----------*/
    drun-categories: "";
    drun-match-fields: "name,generic,exec,categories,keywords";
    drun-display-format: "{name} [<span weight='light' size='small'><i>({generic})</i></span>]";
    drun-show-actions: false;
    drun-url-launcher: "xdg-open";
    drun-use-desktop-cache: false;
    drun-reload-desktop-cache: false;
    drun {
      /** Parse user desktop files. */
      parse-user:   true;
      /** Parse system desktop files. */
      parse-system: true;
      }

    /*---------- Run settings ----------*/
    run-command: "{cmd}";
    run-list-command: "";
    run-shell-command: "{terminal} -e {cmd}";

    /*---------- Fallback Icon ----------*/
    run,drun {
      fallback-icon: "application-x-addon";
    }

    /*---------- Window switcher settings ----------*/
    window-match-fields: "title,class,role,name,desktop";
    window-command: "wmctrl -i -R {window}";
    window-format: "{w} - {c} - {t:0}";
    window-thumbnail: false;

    /*---------- Combi settings ----------*/
  /*	combi-modi: "window,run";*/
  /*	combi-hide-mode-prefix: false;*/
  /*	combi-display-format: "{mode} {text}";*/

    /*---------- History and Sorting ----------*/
    disable-history: false;
    sorting-method: "normal";
    max-history-size: 25;

    /*---------- Display setting ----------*/
    display-window: "Windows";
    display-windowcd: "Window CD";
    display-run: "Run";
    display-ssh: "SSH";
    display-drun: "Apps";
    display-combi: "Combi";
    display-keys: "Keys";
    display-filebrowser: "Files";

    /*---------- Misc setting ----------*/
    terminal: "rofi-sensible-terminal";
    font: "Mono 12";
    sort: false;
    threads: 0;
    click-to-exit: true;
  /*	ignored-prefixes: "";*/
  /*	pid: "/run/user/1000/rofi.pid";*/

    /*---------- File browser settings ----------*/
      filebrowser {
  /*	  directory: "/home";*/
        directories-first: true;
        sorting-method:    "name";
      }

    /*---------- Other settings ----------*/
      timeout {
        action: "kb-cancel";
        delay:  0;
      }

    /*---------- Keybindings ----------*/
  /*
    kb-primary-paste: "Control+V,Shift+Insert";
    kb-secondary-paste: "Control+v,Insert";
    kb-clear-line: "Control+w";
    kb-move-front: "Control+a";
    kb-move-end: "Control+e";
    kb-move-word-back: "Alt+b,Control+Left";
    kb-move-word-forward: "Alt+f,Control+Right";
    kb-move-char-back: "Left,Control+b";
    kb-move-char-forward: "Right,Control+f";
    kb-remove-word-back: "Control+Alt+h,Control+BackSpace";
    kb-remove-word-forward: "Control+Alt+d";
    kb-remove-char-forward: "Delete,Control+d";
    kb-remove-char-back: "BackSpace,Shift+BackSpace,Control+h";
    kb-remove-to-eol: "Control+k";
    kb-remove-to-sol: "Control+u";
    kb-accept-entry: "Control+j,Control+m,Return,KP_Enter";
    kb-accept-custom: "Control+Return";
    kb-accept-custom-alt: "Control+Shift+Return";
    kb-accept-alt: "Shift+Return";
    kb-delete-entry: "Shift+Delete";
    kb-mode-next: "Shift+Right,Control+Tab";
    kb-mode-previous: "Shift+Left,Control+ISO_Left_Tab";
    kb-mode-complete: "Control+l";
    kb-row-left: "Control+Page_Up";
    kb-row-right: "Control+Page_Down";
    kb-row-down: "Down,Control+n";
    kb-page-prev: "Page_Up";
    kb-page-next: "Page_Down";
    kb-row-first: "Home,KP_Home";
    kb-row-last: "End,KP_End";
    kb-row-select: "Control+space";
    kb-screenshot: "Alt+S";
    kb-ellipsize: "Alt+period";
    kb-toggle-case-sensitivity: "grave,dead_grave";
    kb-toggle-sort: "Alt+grave";
    kb-cancel: "Escape,Control+g,Control+bracketleft";
    kb-custom-1: "Alt+1";
    kb-custom-2: "Alt+2";
    kb-custom-3: "Alt+3";
    kb-custom-4: "Alt+4";
    kb-custom-5: "Alt+5";
    kb-custom-6: "Alt+6";
    kb-custom-7: "Alt+7";
    kb-custom-8: "Alt+8";
    kb-custom-9: "Alt+9";
    kb-custom-10: "Alt+0";
    kb-custom-11: "Alt+exclam";
    kb-custom-12: "Alt+at";
    kb-custom-13: "Alt+numbersign";
    kb-custom-14: "Alt+dollar";
    kb-custom-15: "Alt+percent";
    kb-custom-16: "Alt+dead_circumflex";
    kb-custom-17: "Alt+ampersand";
    kb-custom-18: "Alt+asterisk";
    kb-custom-19: "Alt+parenleft";
    kb-select-1: "Super+1";
    kb-select-2: "Super+2";
    kb-select-3: "Super+3";
    kb-select-4: "Super+4";
    kb-select-5: "Super+5";
    kb-select-6: "Super+6";
    kb-select-7: "Super+7";
    kb-select-8: "Super+8";
    kb-select-9: "Super+9";
    kb-select-10: "Super+0";
    ml-row-left: "ScrollLeft";
    ml-row-right: "ScrollRight";
    ml-row-up: "ScrollUp";
    ml-row-down: "ScrollDown";
    me-select-entry: "MousePrimary";
    me-accept-entry: "MouseDPrimary";
    me-accept-custom: "Control+MouseDPrimary";
  */
  }
  '';

   xdg.dataFile."rofi/themes/custom-theme.rasi".text = ''
    /*****----- Configuration -----*****/
    configuration {
      modi:                       "drun,run,filebrowser,window,calc";
        show-icons:                 true;
        display-drun:               "APPS";
        display-run:                "RUN";
        display-filebrowser:        "FILES";
        display-window:             "WINDOW";
      drun-display-format:        "{name}";
      window-format:              "{w} · {c} · {t}";
    }

    /*****----- Global Properties -----*****/
    * {
        font:                        "JetBrains Mono Nerd Font 10";
        background:     #1E1D2FFF;
        background-alt: #282839FF;
        foreground:     #D9E0EEFF;
        selected:       #7AA2F7FF;
        active:         #ABE9B3FF;
        urgent:         #F28FADFF;
    }

    /*****----- Main Window -----*****/
    window {
        /* properties for window widget */
        transparency:                "real";
        location:                    center;
        anchor:                      center;
        fullscreen:                  false;
        width:                       1000px;
        x-offset:                    0px;
        y-offset:                    0px;

        /* properties for all widgets */
        enabled:                     true;
        border-radius:               15px;
        cursor:                      "default";
        background-color:            @background;
    }

    /*****----- Main Box -----*****/
    mainbox {
        enabled:                     true;
        spacing:                     0px;
        background-color:            transparent;
        orientation:                 horizontal;
        children:                    [ "imagebox", "listbox" ];
    }

    imagebox {
        padding:                     20px;
        background-color:            transparent;
        background-image:            url("~/.wallpapers/a.png", height);
        orientation:                 vertical;
        children:                    [ "inputbar", "dummy", "mode-switcher" ];
    }

    listbox {
        spacing:                     20px;
        padding:                     20px;
        background-color:            transparent;
        orientation:                 vertical;
        children:                    [ "message", "listview" ];
    }

    dummy {
        background-color:            transparent;
    }

    /*****----- Inputbar -----*****/
    inputbar {
        enabled:                     true;
        spacing:                     10px;
        padding:                     15px;
        border-radius:               10px;
        background-color:            @background-alt;
        text-color:                  @foreground;
        children:                    [ "textbox-prompt-colon", "entry" ];
    }
    textbox-prompt-colon {
        enabled:                     true;
        expand:                      false;
        str:                         "";
        background-color:            inherit;
        text-color:                  inherit;
    }
    entry {
        enabled:                     true;
        background-color:            inherit;
        text-color:                  inherit;
        cursor:                      text;
        placeholder:                 "Search";
        placeholder-color:           inherit;
    }

    /*****----- Mode Switcher -----*****/
    mode-switcher{
        enabled:                     true;
        spacing:                     20px;
        background-color:            transparent;
        text-color:                  @foreground;
    }
    button {
        padding:                     15px;
        border-radius:               10px;
        background-color:            @background-alt;
        text-color:                  inherit;
        cursor:                      pointer;
    }
    button selected {
        background-color:            @selected;
        text-color:                  @foreground;
    }

    /*****----- Listview -----*****/
    listview {
        enabled:                     true;
        columns:                     1;
        lines:                       8;
        cycle:                       true;
        dynamic:                     true;
        scrollbar:                   false;
        layout:                      vertical;
        reverse:                     false;
        fixed-height:                true;
        fixed-columns:               true;
        
        spacing:                     10px;
        background-color:            transparent;
        text-color:                  @foreground;
        cursor:                      "default";
    }

    /*****----- Elements -----*****/
    element {
        enabled:                     true;
        spacing:                     15px;
        padding:                     8px;
        border-radius:               10px;
        background-color:            transparent;
        text-color:                  @foreground;
        cursor:                      pointer;
    }
    element normal.normal {
        background-color:            inherit;
        text-color:                  inherit;
    }
    element normal.urgent {
        background-color:            @urgent;
        text-color:                  @foreground;
    }
    element normal.active {
        background-color:            @active;
        text-color:                  @foreground;
    }
    element selected.normal {
        background-color:            @selected;
        text-color:                  @foreground;
    }
    element selected.urgent {
        background-color:            @urgent;
        text-color:                  @foreground;
    }
    element selected.active {
        background-color:            @urgent;
        text-color:                  @foreground;
    }
    element-icon {
        background-color:            transparent;
        text-color:                  inherit;
        size:                        32px;
        cursor:                      inherit;
    }
    element-text {
        background-color:            transparent;
        text-color:                  inherit;
        cursor:                      inherit;
        vertical-align:              0.5;
        horizontal-align:            0.0;
    }

    /*****----- Message -----*****/
    message {
        background-color:            transparent;
    }
    textbox {
        padding:                     15px;
        border-radius:               10px;
        background-color:            @background-alt;
        text-color:                  @foreground;
        vertical-align:              0.5;
        horizontal-align:            0.0;
    }
    error-message {
        padding:                     15px;
        border-radius:               20px;
        background-color:            @background;
        text-color:                  @foreground;
}
    '';

  #programs.spicetify =
  #let
  #  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  #in
  #{
  #  enable = true;
  #  wayland = false;
  #};
  
  home.file.".vscode/argv.json".text = ''
    {
      // Fixes the "an OS keyring couldn't be identified for
      // storing the encryption..." error
      
      "password-store":"gnome-libsecret"
    }
  '';

  services.swayosd.enable = true;

  programs.zsh =
  let
  # My shell aliases
  myAliases = {
    dev-rust = "nix develop /etc/nixos\#rust-dev";
    dev-embed = "nix develop /etc/nixos\#embed-dev";
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

   initContent = ''
  nix_shell_info() {
    if [[ -n "$IN_NIX_SHELL" ]]; then
      if [[ -n "$name" ]]; then
        echo "%F{blue}❄️ ($name)%f "
      else
        echo "%F{blue}❄️ nix%f "
      fi
    fi
  }
 
    PROMPT='$(nix_shell_info)'$PROMPT
  '';

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

  # ==============================
# WAYBAR (Hyprland setup)
# ==============================

programs.waybar = {
  enable = true;
  systemd.enable = true;

  settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 34;
      spacing = 6;

      modules-left = [
        "hyprland/workspaces"
        "hyprland/window"
      ];

      modules-center = [
        "clock"
      ];

      modules-right = [
        "backlight"
        "pulseaudio"
        "tray"
        "mpris"
        "custom/power-profile"
        "battery"
        "custom/notifications"
        "custom/power"
      ];

      clock = {
        format = "{:%H:%M  %a %d %b}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt>{calendar}</tt>";
      };

      # -----------------------------
      # WINDOW (with emoji fallback)
      # -----------------------------
      "hyprland/window" = {
        format = "{title}";
        rewrite = {
          "" = "🚀 Desktop";
        };
      };

      # -----------------------------
      # WORKSPACES
      # -----------------------------
      "hyprland/workspaces" = {
        format = "{name}";
        on-click = "activate";
      };

      # -----------------------------
      # BACKLIGHT (brightness)
      # -----------------------------
      backlight = {
        format = "☀ {percent}%";
        device = "intel_backlight";
      };

      # -----------------------------
      # AUDIO (fixed icons)
      # -----------------------------
      pulseaudio = {
        format = "{volume}% {icon}";
        format-muted = " Muted";

        format-icons = {
          default = [ "" "" "" ];
          headphone = "";
        };

        on-click = "pavucontrol";
        on-click-right = "pamixer -t";
        on-scroll-up = "pamixer -i 5";
        on-scroll-down = "pamixer -d 5";
      };

      # -----------------------------
      # MEDIA CONTROLS
      # -----------------------------
      mpris = {
        format = "{player_icon} {title}";
        format-paused = " {title}";
        interval = 1;
        max-length = 30;

        on-click = "playerctl play-pause";
        on-scroll-up = "playerctl next";
        on-scroll-down = "playerctl previous";
      };

      # -----------------------------
      # TRAY
      # -----------------------------
      tray = {
        spacing = 10;
      };

      # -----------------------------
      # POWER MENU
      # -----------------------------
      "custom/power" = {
        format = "⏻";
        on-click = "wleave";
        tooltip = true;
        tooltip-format = "Power Menu";
      };

      "custom/power-profile" = {
        format = "⚡ {}";
        exec = "powerprofilesctl get";
        interval = 5;

        on-click = ''
          bash -c '
            case "$(powerprofilesctl get)" in
              performance) powerprofilesctl set balanced ;;
              balanced) powerprofilesctl set power-saver ;;
              power-saver) powerprofilesctl set performance ;;
            esac
          '
        '';
      };

      battery = {
        states = {
          warning = 30;
          critical = 15;
        };

        format = "{icon}  {capacity}%";
        format-charging = " {capacity}%";
        format-plugged = " {capacity}%";

        format-icons = ["" "" "" "" ""];
      };

      "custom/notifications" = {
        format = "🔔";
        tooltip = true;
        exec = "swaync-client -swb";
        on-click = "swaync-client -t";
      };

    };
  };

  style = ''
    * {
      min-height: 0;
      min-width: 0;
      font-family: "Lexend", "JetBrainsMono Nerd Font";
      font-size: 14px;
      font-weight: 500;
    }

    window#waybar {
      background: rgba(17, 17, 27, 0.75);
      border-radius: 12px;
      margin: 6px 10px;
    }

    #workspaces button {
      padding: 0.3rem 0.6rem;
      margin: 0.3rem 0.2rem;
      border-radius: 8px;
      background-color: rgba(30, 30, 46, 0.5);
      color: #cdd6f4;
      transition: all 0.2s ease;
    }

    #workspaces button:hover {
      background-color: rgba(137, 180, 250, 0.25);
      color: white;
    }

    #workspaces button.active {
      background-color: #89b4fa;
      color: #11111b;
    }

    #clock,
    #pulseaudio,
    #backlight,
    #tray,
    #window,
    #mpris,
    #custom-power {
      padding: 0.3rem 0.7rem;
      margin: 0.3rem 0.2rem;
      border-radius: 10px;
      background: rgba(30, 30, 46, 0.5);
      color: #cdd6f4;
    }

    #backlight { color: #f9e2af; }
    #clock { color: #74c7ec; }
    #pulseaudio { color: #b4befe; }
    #mpris { color: #a6e3a1; }
    #custom-power { color: #f38ba8; }

    #network,
    #bluetooth,
    #battery,
    #custom-power-profile {
      padding: 0.3rem 0.7rem;
      margin: 0.3rem 0.2rem;
      border-radius: 10px;
      background: rgba(30, 30, 46, 0.5);
      color: #cdd6f4;
      transition: all 0.2s ease;
    }

    #custom-power-profile {
      color: #f9e2af;
      font-weight: 600;
    }

    #custom-power-profile:hover {
      background: rgba(249, 226, 175, 0.15);
    }

    #battery {
      color: #a6e3a1;
    }

    #battery.charging {
      color: #89b4fa;
    }

    #battery.warning {
      color: #f9e2af;
    }

    #battery.critical {
      color: #f38ba8;
      animation: blink 1s infinite;
    }

    #network {
      color: #89b4fa;
    }

    #network.disconnected {
      color: #6c7086;
    }

    #bluetooth {
      color: #b4befe;
    }

    #bluetooth.disabled {
      color: #6c7086;
    }

    #bluetooth.connected {
      color: #89dceb;
    }

    tooltip {
      background: rgba(17, 17, 27, 0.95);
      border-radius: 10px;
      border: 1px solid rgba(137, 180, 250, 0.4);
    }
  '';
};


xdg.configFile."hypr/hyprlock.conf".text = ''
  source = ~/.cache/wal/colors-hyprland.conf

  # -------------------------
  # BACKGROUND
  # -------------------------
  background {
      monitor =
      path = /home/akshay/.wallpapers/2026-04-13-01-30-57-2mn8bo9krcx71.png

      blur_passes = 2
      contrast = 1
      brightness = 0.5
      vibrancy = 0.2
      vibrancy_darkness = 0.2
  }

  # -------------------------
  # GENERAL
  # -------------------------
  general {
      no_fade_in = true
      no_fade_out = true
      hide_cursor = false
      grace = 0
      disable_loading_bar = true
  }

  # -------------------------
  # INPUT FIELD
  # -------------------------
  input-field {
      monitor =
      size = 250, 60
      outline_thickness = 2
      dots_size = 0.2
      dots_spacing = 0.35
      dots_center = true

      outer_color = rgba(0, 0, 0, 0)
      inner_color = rgba(0, 0, 0, 0.2)
      font_color = rgba(255, 255, 255, 0.9)

      fade_on_empty = false
      rounding = -1
      check_color = rgb(204, 136, 34)

      placeholder_text = Input Password...

      hide_input = false

      position = 0, -200
      halign = center
      valign = center
  }

  # -------------------------
  # DATE
  # -------------------------
  label {
      text = cmd[update:1000] echo "$(date +'%A, %B %d')"
      color = rgba(242, 243, 244, 0.75)
      font_size = 22
      font_family = JetBrains Mono

      position = 0, 300
      halign = center
      valign = center
  }

  # -------------------------
  # TIME
  # -------------------------
  label {
      text = cmd[update:1000] echo "$(date +'%H:%M')"
      color = rgba(242, 243, 244, 0.75)
      font_size = 95
      font_family = JetBrains Mono Extrabold

      position = 0, 200
      halign = center
      valign = center
  }

  # -------------------------
  # PROFILE IMAGE
  # -------------------------
  image {
      path = /home/akshay/Pictures/hk.png
      size = 100
      border_size = 2
      border_color = rgba(255, 255, 255, 0.8)
      rounding = 999 

      position = 0, -50
      halign = center
      valign = center
  }

  # -------------------------
  # USERNAME
  # -------------------------
  label {
      text = cmd[update:1000] echo "hi there $(whoami)"
      color = rgba(255, 255, 255, 0.8)
      font_size = 14
      font_family = JetBrains Mono

      position = 0, -10
      halign = center
      valign = top
  }
  '';

  xdg.configFile."hypr/hypridle.conf".text = ''
      general {
          ignore_dbus_inhibit = false
          lock_cmd = hyprlock
          before_sleep_cmd = hyprlock
          after_sleep_cmd = hyprctl dispatch dpms on
      }

      # -------------------------
      # 5 MIN → DIM SCREEN
      # -------------------------
      listener {
          timeout = 300
          on-timeout = brightnessctl -s set 30%
          on-resume = brightnessctl -r
      }

      # -------------------------
      # 10 MIN → LOCK SCREEN
      # -------------------------
      listener {
          timeout = 600
          on-timeout = hyprlock
      }

      # -------------------------
      # 15 MIN → SUSPEND (BATTERY ONLY)
      # -------------------------
      listener {
          timeout = 900
          on-timeout = systemd-ac-power || systemctl suspend
      }
    '';


    xdg.configFile."wleave/layout.json".text = ''
    {
      "button-layout": "grid",
      "buttons-per-row": "3",

      "margin": 200,
      "column-spacing": 12,
      "row-spacing": 12,

      "close-on-lost-focus": true,
      "protocol": "layer-shell",
      "show-keybinds": false,
      "no-version-info": true,

      "buttons": [
        {
          "label": "lock",
          "text": "Lock",
          "action": "hyprlock",
          "icon": "${pkgs.wleave}/share/wleave/icons/lock.svg",
          "keybind": "l"
        },
        {
          "label": "logout",
          "text": "Logout",
          "action": "loginctl terminate-user $USER",
          "icon": "${pkgs.wleave}/share/wleave/icons/logout.svg",
          "keybind": "o"
        },
        {
          "label": "suspend",
          "text": "Suspend",
          "action": "systemctl suspend",
          "icon": "${pkgs.wleave}/share/wleave/icons/suspend.svg",
          "keybind": "s"
        },
        {
          "label": "reboot",
          "text": "Restart",
          "action": "systemctl reboot",
          "icon": "${pkgs.wleave}/share/wleave/icons/reboot.svg",
          "keybind": "r"
        },
        {
          "label": "poweroff",
          "text": "Power",
          "action": "systemctl poweroff",
          "icon": "${pkgs.wleave}/share/wleave/icons/shutdown.svg",
          "keybind": "p"
        }
      ]
    }
    '';

    xdg.configFile."swaync/config.json".text = builtins.toJSON {
      positionX = "right";
      positionY = "top";
      position = "center";
      layer = "overlay";

      "control-center-layer" = "top";
      "layer-shell" = true;

      "control-center-width" = 400;
      "control-center-height" = 850;

      "control-center-margin-top" = 10;
      "control-center-margin-bottom" = 10;
      "control-center-margin-right" = 10;
      "control-center-margin-left" = 0;

      "notification-window-width" = 380;
      "notification-icon-size" = 50;

      timeout = 5;
      "timeout-low" = 6;
      "timeout-critical" = 0;

      "fit-to-screen" = true;
      "keyboard-shortcuts" = true;

      "hide-on-clear" = false;
      "hide-on-action" = true;

      "text-empty" = "No Notifications";

      widgets = [
        "volume"
        "backlight"
        "dnd"
        "title"
        "notifications"
        "mpris"
      ];

      "widget-config" = {
        mpris = {
          "image-radius" = 0;
          autohide = true;
          blacklist = [ "playerctld" ];
        };

        volume = {
          label = "󰕾";
          "show-per-app" = true;
          "show-per-app-icon" = true;
        };

        backlight = {
          label = "󰃞";
        };

        dnd = {
          text = "Do Not Disturb";
        };

        title = {
          text = "Notifications Center";
          "clear-all-button" = true;
          "button-text" = "󰆴";
        };
      };
    };

    xdg.configFile."swaync/style.css".text = ''
          /* -----------------------------------
      🟤 Catppuccin Mocha – Crust Palette
    -------------------------------------- */
    @define-color background rgba(18, 17, 27, 0.8);
    @define-color background-alt rgba(18, 17, 27, 0.8);
    @define-color background-faded rgba(18, 17, 27, 0.5);
    /* @define-color background rgb(18, 17, 27); */
    /* @define-color background-alt rgb(18, 17, 27); */
    /* @define-color background-faded rgb(18, 17, 27); */

    @define-color crust #11111b;
    @define-color foreground #cdd6f4;
    @define-color red #f38ba8;
    @define-color green #a6e3a1;
    @define-color yellow #f9e2af;
    @define-color blue #89b4fa;
    @define-color gray #313244;
    @define-color select #585b70;

    /* 🎵 MPRIS */
    @define-color mpris-album-art-overlay rgba(0, 0, 0, 0.55);
    @define-color mpris-button-hover rgba(0, 0, 0, 0.5);
    @define-color mpris-button-bg @foreground;
    @define-color mpris-button-fg @crust;

    /* -----------------------------------
      🔤 Global Defaults
    -------------------------------------- */
    * {
      outline: none;
      font-family: "JetBrainsMono Font";
      font-size: 18px;
      text-shadow: none;
      color: @foreground;
      background-color: transparent;
      border-radius: 10px;
      border: none
    }

    /* -----------------------------------
      🧩 Control Center
    -------------------------------------- */
    .control-center {
      background-color: alpha(@background, 1);
      /* box-shadow: 0 0 10px rgba(0, 0, 0, 0.65); */
      box-shadow: none;
      padding: 10px;
      border: none
        /* border-bottom: 9px solid @blue; */
    }

    .notification-row .notification-background {
      border-radius: 10px;
      margin: 5px 0 15px;
    }

    /* -----------------------------------
      🔔 Notifications
    -------------------------------------- */
    .notification {
      background-color: @background;
      border: 1px solid alpha(@foreground, 0.05);
      border-radius: 10px;
      padding: 6px 10px;
      margin-bottom: 6px;
      min-height: 50px;
      box-shadow: none;
    }

    .notification .summary {
      font-size: 1rem;
      font-weight: 500;
      margin-bottom: 2px;
    }

    .notification .time {
      font-size: 0.75rem;
      color: alpha(@foreground, 0.6);
    }

    .notification .body {
      font-size: 0.95rem;
      color: @foreground;
    }

    .notification-action>button {
      padding: 5px 10px;
      font-size: 0.9rem;
      background-color: @select;
      color: @foreground;
      border-radius: 2px;
      border: none;
      margin: 6px 6px 0 0;
    }

    .notification-action>button:hover {
      background-color: @blue;
    }

    .notification-action>button:hover label {
      background-color: @blue;
      color: @crust;
    }

    /* Urgency */
    .notification.critical {
      border: none;
      outline: none;
      background: @red;
      border-left: 9px solid red;
    }

    .notification.critical .title,
    .notification.critical .body,
    .notification.critical .summary {
      color: alpha(@crust, 0.9);
      font-weight: bold;
    }

    .notification.low,
    .notification.normal {
      border: none;
      outline: none;
      background-color: alpha(@background, 0.95);
      border-left: 9px solid @blue;
    }

    /* -----------------------------------
      🖼️ Image/Icon
    -------------------------------------- */
    .image {
      margin-right: 10px;
      min-width: 36px;
      min-height: 36px;
      border: none;
    }

    /* -----------------------------------
      ❌ Close Buttons
    -------------------------------------- */
    .close-button {
      background-color: @red;
      border-radius: 8px;
    }

    .close-button label {
      color: aliceblue;
    }

    .close-button:hover {
      background-color:transparent;
    }

    /* -----------------------------------
      🔃 Group Header Buttons
    -------------------------------------- */
    .notification-group-collapse-button,
    .notification-group-close-all-button {
      background-color: @gray;
      color: @foreground;
      border-radius: 6px;
    }

    .notification-group-collapse-button:hover {
      background-color: @blue;
      color: @crust;
    }

    .notification-group-close-all-button:hover {
      background-color: @red;
      color: @crust;
    }

    /* -----------------------------------
      📊 Sliders (Volume/Brightness)
    -------------------------------------- */
    scale trough {
      margin: 0 1rem;
      background-color: @gray;
      min-height: 8px;
      min-width: 70px;

      border-radius: 30px;
    }

    trough highlight {
      background: @blue;

      border-radius: 30px;
    }

    slider {
      border-radius: 30px;
      background-color: @foreground;
    }

    /* -----------------------------------
      💬 Tooltip
    -------------------------------------- */
    tooltip {
      background-color: @gray;
      color: @foreground;
    }

    /* -----------------------------------
      🔘 Buttons Grid
    -------------------------------------- */
    .widget-buttons-grid {
      font-size: 1rem;
      padding: 20px 20px 10px;
    }

    .widget-buttons-grid button {
      background: @crust;
      color: #fff;
      border-radius: 50px;
      min-width: 60px;
      min-height: 30px;
      margin: 0 3px;
      padding: 6px;
    }

    .widget-buttons-grid button:hover {
      background: @select;
    }

    .widget-buttons-grid button.toggle:checked {
      background: @blue;
    }

    .widget-buttons-grid button.toggle:checked label {
      background: @blue;
      color: @background;
    }


    .widget-buttons-grid button.toggle:checked:hover {
      background: alpha(@blue, 0.8);
    }

    /* -----------------------------------
      🎵 MPRIS Player
    -------------------------------------- */
    .widget-mpris .widget-mpris-player {
      padding: 6px;
      margin: 6px 10px;
      background-color: transparent;
      box-shadow: none;
      border-radius: 10px;
    }

    .widget-mpris label,
    .widget-mpris-title,
    .widget-mpris-subtitle {
      color: @foreground;
    }

    .widget-mpris-title {
      font-size: 1.2rem;
      font-weight: bold;
      margin: 0 8px 8px;
      text-align: center;
    }

    .widget-mpris-subtitle {
      font-size: 1rem;
      text-align: center;
    }

    .widget-mpris-album-art.art {
      border-radius: 999px;
      min-width: 128px;
      min-height: 128px;
      background-size: cover;
      background-repeat: no-repeat;
      overflow: hidden;
      box-shadow: none;
      background: red;
    }

    picture.mpris-background {
      opacity: 0;
      background: none;
      box-shadow: none;
      border: none;
    }


    /* -----------------------------------
      🔊 Volume Widget
    -------------------------------------- */
    .widget-volume {
      padding: 6px 5px 5px;
      font-size: 1.3rem;
    }

    .widget-volume button {
      border: none;
    }

    /* -----------------------------------
      🎚️ Per-App Volume
    -------------------------------------- */
    .per-app-volume {
      padding: 4px 8px 8px;
      margin: 0 8px 8px;
    }

    /* -----------------------------------
      💡 Backlight
    -------------------------------------- */
    .widget-backlight {
      padding: 0 0 3px 16px;
      font-size: 1.1rem;
    }

    /* -----------------------------------
      🔕 DND
    -------------------------------------- */
    .widget-dnd {
      font-weight: bold;
      padding: 15px 15px 15px;
    }

    .widget-dnd>switch {
      background: @yellow;
      border: none;
      border-radius: 100px;
      padding: 3px;
    }

    .widget-dnd>switch:checked {
      background: @green;
    }

    .widget-dnd>switch slider {
      background: @background;
      border-radius: 12px;
      min-width: 18px;
      min-height: 18px;
    }

    /* -----------------------------------
      🏷️ Title
    -------------------------------------- */
    .widget-title {
      padding: 15px;
      font-weight: bold;
    }

    .widget-title>label {
      font-size: 1.5rem;
    }

    .widget-title>button {
      background: @red;
      border: none;
      border-radius: 100px;
      padding: 0 6px;
      transition: all 0.7s ease;
    }

    .widget-title>button label {
      color: @crust;
    }

    .widget-title>button:hover {
      background: alpha(@red, 0.8);
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.65);
    }
    '';

  
}
