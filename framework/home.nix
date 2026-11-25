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
    # ArtCraft Launcher (official flake, see flake.nix). The upstream package ships only
    # the binary, so add its own .desktop entry and icon from the same source.
    (let
      src = inputs.craft-launcher;
      # Upstream's flake (marked experimental) fails to build as of 0.19.2: Cargo.toml
      # [patch.crates-io] lists crates (egui_demo_lib, ...) that Cargo.lock marks [[patch.unused]], so
      # Nix's offline vendor dir lacks them and cargo aborts. Drop those unused patch lines.
      bin = inputs.craft-launcher.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
        postPatch = (old.postPatch or "") + ''
          for crate in $(sed -n '/^\[\[patch\.unused\]\]/{n;s/^name = "\(.*\)"/\1/p}' Cargo.lock); do
            echo "artcraft: dropping unused cargo patch $crate"
            sed -i "/^$crate *= *{.*git/d" Cargo.toml
          done
        '';
      });
    in pkgs.symlinkJoin {
      name = "artcraft-launcher-${bin.version}";
      paths = [ bin ];
      postBuild = ''
        install -Dm644 ${src}/packaging/linux/ai.storyteller.artcraft-launcher.desktop \
          $out/share/applications/ai.storyteller.artcraft-launcher.desktop
        install -Dm644 ${src}/assets/app-icon/artcraft-launcher.svg \
          $out/share/icons/hicolor/scalable/apps/ai.storyteller.artcraft-launcher.svg
      '';
    })
    # MitCad 3D CAD: self-updating launcher for the official AppImage (see the file).
    (pkgs.callPackage ../user/pkgs/mitcad.nix { })
    # Zen browser, native build (flake input `zen-browser`), replacing the Flatpak.
    # Uses system Mesa: the Flatpak's Mesa hung the Intel GPU on WebGL (Ultimate Guitar)
    # and took Hyprland down; native Firefox with system Mesa doesn't.
    # Profile: ~/.config/zen, migrated from ~/.var/app/app.zen_browser.zen/.zen.
    # Package only, not the flake's home-manager module, so profiles.ini and
    # zen-sessions (spaces/pins) are never rewritten by Nix.
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.beta
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
    # MEGAsync is Qt 5 (no light/dark support): pick the adwaita-qt style at launch.
    # theme-sync restarts it when the mode changes (see hyprland/theme-switch.nix).
    (pkgs.symlinkJoin {
      name = "megasync-themed-${pkgs.megasync.version}";
      paths = [ pkgs.megasync ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        rm $out/bin/megasync
        makeWrapper ${pkgs.megasync}/bin/megasync $out/bin/megasync \
          --run 'case "$(${pkgs.glib}/bin/gsettings get org.gnome.desktop.interface color-scheme)" in *dark*) export QT_STYLE_OVERRIDE=Adwaita-Dark ;; *) export QT_STYLE_OVERRIDE=Adwaita ;; esac'
      '';
    })
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
    (pkgs-stable.bottles.override {
    removeWarningPopup = true;
    })
    # pkgs-stable.bottles
    
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
    # wofi
    libsForQt5.qt5ct
    qt6Packages.qt6ct
    kdePackages.qtstyleplugin-kvantum
    kdePackages.breeze-icons
    copyq
    # hyprlock
    # hypridle
    # sherlock-launcher

    adw-gtk3
    adwaita-qt
    adwaita-qt6
    intel-gpu-tools
    adwaita-icon-theme
    hicolor-icon-theme
    # awww
    kitty-themes
    google-fonts
    icomoon-feather
    nerd-fonts.iosevka
    satty
    grimblast
    opencode
    opencode-desktop
    claude-code
    # ACP adapter for Claude Code: lets ACP clients (SolidCraft's agent chat, Zed, ...)
    # drive Claude Code. OpenCode speaks ACP itself; Claude Code needs this.
    claude-agent-acp

    #wofi
    #hyprlauncher
    # swayosd
    jq
    # sound-theme-freedesktop

    zerotierone
    vital

    dejavu_fonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    pkgs.inter

    thunar
    thunar-archive-plugin
    thunar-media-tags-plugin
    thunar-vcs-plugin
    thunar-volman
    # tumbler
    ffmpegthumbnailer
    file-roller

    hydra-check

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
    
    # Electron 43 follows the system light/dark preference live through the portal,
    # so no GTK_THEME (that fixed the look for the whole run).
    (writeShellScriptBin "moises" ''
    exec appimage-run /home/akshay/AppImages/moises.appimage "$@"
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
      dnxhr_sq) 
        ffmpeg -y -i "$INFILE" \
          -c:v dnxhd -profile:v dnxhr_sq \
          -pix_fmt yuv422p \
          -c:a "$AUDIO_CODEC" \
          "$OUTFILE" ;;
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
          hyprctl eval 'hl.monitor({ output = "eDP-1", disabled = true })'
        else
          #loginctl lock-session
          #sleep 0.5
          #systemctl suspend -i
          noctalia msg session lock-and-suspend
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
    gnomeExtensions.dash-to-dock
    
    # (pkgs.gnomeExtensions.dash-to-dock.overrideAttrs (old: {
    #    version = "102";
    #    src = pkgs.fetchzip {
    #    url = "https://extensions.gnome.org/extension-data/dash-to-dockmicxgx.gmail.com.v102.shell-extension.zip";
    # sha256 = "sha256-nks4PIEVmX6THDRAb8PU7t5FuX4w781B8TzcpQRl2yw=";
    # stripRoot = false;
    #  };
    # }))
    
    # pkgs-stable.nerdfonts
    # pkgs-stable.fira
    pkgs-stable.roboto
    pkgs-stable.corefonts
    pkgs-stable.hyfetch

    ns-usbloader

    # Noctalia's Noctes plugin runs a python3 helper; NixOS has no python3 on PATH by default.
    python3

    # fix-desktop-exec FILE|DIR...  — rewrite Exec= lines so Noctalia's launcher can run them.
    # Noctalia v5 only treats spaces/backslashes as literal inside double quotes, so
    # shell-style escapes like Wine's `wine C:\\\\Start\\ Menu\\\\App.lnk` get split into
    # junk arguments. This re-parses Exec the way GNOME/GLib does and re-emits every
    # argument in spec-compliant double-quoted form (same command, new quoting).
    # Directories are searched recursively for *.desktop. Keeps FILE.bak unless --no-backup.
    (pkgs.writers.writePython3Bin "fix-desktop-exec" { flakeIgnore = [ "E501" ]; } ''
      import argparse
      import os
      import shlex
      import shutil
      import sys

      # Characters that the desktop-entry spec says must be quoted inside Exec.
      RESERVED = set(" \t\n\"'\\><~|&;$*?#()`")


      def unescape_value(value):
          """Key-file string unescape (\\s \\n \\t \\r \\\\), as GLib does before parsing Exec."""
          out = []
          i = 0
          while i < len(value):
              c = value[i]
              if c == "\\" and i + 1 < len(value):
                  nxt = value[i + 1]
                  mapping = {"s": " ", "n": "\n", "t": "\t", "r": "\r", "\\": "\\"}
                  out.append(mapping.get(nxt, "\\" + nxt))
                  i += 2
                  continue
              out.append(c)
              i += 1
          return "".join(out)


      def quote_arg(arg):
          if arg and not any(c in RESERVED for c in arg):
              return arg
          for ch in ("\\", "\"", "`", "$"):
              arg = arg.replace(ch, "\\" + ch)
          return "\"" + arg + "\""


      def fix_exec(raw):
          argv = shlex.split(unescape_value(raw), posix=True)
          cmdline = " ".join(quote_arg(a) for a in argv)
          # Re-apply key-file escaping: every backslash is written doubled.
          return cmdline.replace("\\", "\\\\")


      def desktop_files(paths):
          for p in paths:
              if os.path.isdir(p):
                  for root, _dirs, files in os.walk(p):
                      for name in sorted(files):
                          if name.endswith(".desktop"):
                              yield os.path.join(root, name)
              else:
                  yield p


      def process(path, dry_run, backup):
          try:
              with open(path, encoding="utf-8") as f:
                  lines = f.read().splitlines(keepends=True)
          except OSError as e:
              print(f"skip {path}: {e}", file=sys.stderr)
              return False
          changed = False
          for i, line in enumerate(lines):
              if not line.startswith("Exec="):
                  continue
              body = line[len("Exec="):]
              eol = body[len(body.rstrip("\r\n")):]
              old = body.rstrip("\r\n")
              try:
                  new = fix_exec(old)
              except ValueError as e:
                  print(f"skip {path}: cannot parse Exec ({e}): {old}", file=sys.stderr)
                  continue
              if new != old:
                  print(f"{path}\n  - Exec={old}\n  + Exec={new}")
                  lines[i] = "Exec=" + new + eol
                  changed = True
          if changed and not dry_run:
              if backup:
                  shutil.copy2(path, path + ".bak")
              with open(path, "w", encoding="utf-8") as f:
                  f.write("".join(lines))
          return changed


      def main():
          ap = argparse.ArgumentParser(
              description="Rewrite .desktop Exec= lines into the quoted form Noctalia's launcher understands.")
          ap.add_argument("paths", nargs="+", help=".desktop files or directories (searched recursively)")
          ap.add_argument("-n", "--dry-run", action="store_true", help="show changes without writing")
          ap.add_argument("--no-backup", action="store_true", help="do not keep FILE.bak")
          args = ap.parse_args()
          count = sum(process(p, args.dry_run, not args.no_backup) for p in desktop_files(args.paths))
          verb = "would fix" if args.dry_run else "fixed"
          print(f"{verb} {count} file(s)")


      if __name__ == "__main__":
          main()
    '')

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

  home.file.".vst3/Vital.vst3".source =
    "${pkgs.vital}/lib/vst3/Vital.vst3";

  home.file.".vst/Vital.so".source =
    "${pkgs.vital}/lib/vst/Vital.so";

  home.file.".clap/Vital.clap".source =
    "${pkgs.vital}/lib/clap/Vital.clap";

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

  xdg.desktopEntries.cockos-reaper = {
      name = "REAPER";
      comment = "REAPER DAW";
      exec = "bash -lc reaper";
      icon = "${pkgs.reaper}/share/icons/hicolor/256x256/apps/cockos-reaper.png";
      terminal = false;

      categories = ["Audio" "Video" "AudioVideo" "AudioVideoEditing" "Music" ];

      startupNotify = true;
    };


  xdg.configFile = {
  "hypr/hyprsplit" = {
    source = "${inputs.hyprsplit.packages.${pkgs.stdenv.hostPlatform.system}.hyprsplitlua}/share/hyprsplit";
    recursive = true;
    };
  # hyprtasking: workspace overview plugin (hyprexpo was dropped upstream in May 2026).
  # Built by nixpkgs against the same pkgs.hyprland the system runs; loaded from
  # hyprland.lua via hl.plugin.load(). A Hyprland update needs a rebuild + re-login.
  #
  # nixpkgs' hyprtasking (2026-09-20) doesn't compile against Hyprland 0.57, so it's
  # pinned to upstream's commit that merged 0.57 support (PR #140, 2026-11-10).
  # Drop this override once nixpkgs' version is newer than that.
  "hypr/plugins/libhyprtasking.so".source =
    let
      hyprtasking = pkgs.hyprlandPlugins.hyprtasking.overrideAttrs (_: {
        version = "0-unstable-2026-11-10";
        src = pkgs.fetchFromGitHub {
          owner = "raybbian";
          repo = "hyprtasking";
          rev = "04d2365d37f032af537b8d5c55efbfe15f01adc7";
          hash = "sha256-KzxmA0lqTvZKq/AHdSu2juugkfXwLC6ywR4BeAfiIIg=";
        };
      });
    in
    "${hyprtasking}/lib/libhyprtasking.so";
  };

  xdg.configFile."xfce4/helpers.rc".text = ''
    TerminalEmulator=kitty
  '';

  xdg.configFile."Thunar/uca.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <actions>

      <action>
        <icon>code</icon>
        <name>Open Folder in VSCode</name>
        <command>code %f</command>
        <patterns>*</patterns>
        <directories/>
      </action>

      <action>
        <icon>terminal</icon>
        <name>Open Terminal Here</name>
        <command>kitty --directory=%f</command>
        <patterns>*</patterns>
        <directories/>
     </action>

    </actions>
    '';

   xdg.configFile."mimeapps.list".force = true;
   xdg.mimeApps = {
  enable = true;

  defaultApplications = {
    "application/pdf" = "org.gnome.Papers.desktop";
    "image/png" = "org.gnome.Loupe.desktop";
    "image/jpeg" = "org.gnome.Loupe.desktop";
    "image/jpg" = "org.gnome.Loupe.desktop";
    "image/webp" = "org.gnome.Loupe.desktop";
    "image/gif" = "org.gnome.Loupe.desktop";
    "inode/directory" = "thunar.desktop";
    "x-directory/normal" = "thunar.desktop";
    # Native Zen (zen-browser flake) as the default browser.
    "text/html" = "zen-beta.desktop";
    "application/xhtml+xml" = "zen-beta.desktop";
    "x-scheme-handler/http" = "zen-beta.desktop";
    "x-scheme-handler/https" = "zen-beta.desktop";
    "x-scheme-handler/about" = "zen-beta.desktop";
    "x-scheme-handler/unknown" = "zen-beta.desktop";
  };
};

  # Keep MitCad current even if it isn't launched (downloads only when a new release
  # exists; verified against the official manifest's sha256). See user/pkgs/mitcad.nix.
  systemd.user.services.mitcad-update = {
    Unit = {
      Description = "Update MitCad AppImage from official GitHub releases";
      After = [ "network-online.target" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${(pkgs.callPackage ../user/pkgs/mitcad.nix { }).update}/bin/mitcad-update";
      Nice = 10;
      IOSchedulingClass = "idle";
    };
  };
  systemd.user.timers.mitcad-update = {
    Unit.Description = "Daily MitCad update check";
    Timer = {
      OnCalendar = "daily";
      OnStartupSec = "10min";
      Persistent = true;
      RandomizedDelaySec = "30min";
    };
    Install.WantedBy = [ "timers.target" ];
  };

  systemd.user.services.tumblerd = {
    Unit = {
      Description = "Tumbler Thumbnailing Service";
    };

    Service = {
      ExecStart = "${pkgs.tumbler}/lib/tumbler-1/tumblerd";
      Restart = "on-failure";
    };
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
    # Qt follows the portal's light/dark color-scheme live (tested: Qt 6 Fusion switches
    # palette). qt6ct and QT_STYLE_OVERRIDE=Adwaita-Dark pinned dark mode.
    QT_QPA_PLATFORMTHEME = "xdgdesktopportal";
    FILE_MANAGER = "thunar";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (ps: with ps; [ python311 ripgrep ]);
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
    inputs.noctalia.homeModules.default
    #inputs.spicetify-nix.homeManagerModules.default
    ../user/app/flatpak.nix
    # ../hyprland/hyprland-conf.nix
    # ../hyprland/waybar.nix
    # ../hyprland/rofi.nix
    # ../hyprland/nwg-drawer.nix
    # ../hyprland/hyprlock.nix
    # ../hyprland/wleave.nix
    # ../hyprland/swaync.nix
    # ../hyprland/battery-notif.nix
    # ../hyprland/hypridle.nix
    # ../hyprland/hyprshell.nix
    ../hyprland/noctalia.nix
    ../hyprland/theme-switch.nix
  ];
  
  dconf = {
     enable = true;
     settings = { 
     "org/gnome/desktop/interface" = {
      icon-theme = "Adwaita";  # Use any installed theme like 'Papirus', 'Breeze', etc.
      cursor-theme = "Adwaita";  # Set the cursor theme declaratively
      # color-scheme and gtk-theme are NOT set here: Noctalia's light/dark switch owns
      # them (hyprland/theme-switch.nix). Setting them here reset dark on every rebuild.
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
    # Colors: dark-/light-theme.auto.conf (hyprland/theme-switch.nix) follow the
    # system light/dark mode live; a fixed include here would pin one.
  };

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
    dev-rust = "nix develop /home/akshay/Documents/nixos-config#rust-dev";
    dev-embed = "nix develop /home/akshay/Documents/nixos-config#embed-dev";
    nix-rebuild = "sudo nixos-rebuild switch --flake /home/akshay/Documents/nixos-config#default";
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

  sessionVariables = {
      PATH = "/usr/bin:/usr/sbin:$PATH";
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
}
