# System-wide light/dark switching, Adwaita in both modes.
#
# One source of truth: Noctalia's theme mode ([theme].mode). It is flipped by the
# `theme_mode` bar widget (far right), `noctalia msg theme-mode-toggle`, or Noctalia's
# settings / control center. When it changes:
#
#   - Noctalia itself writes org.gnome.desktop.interface color-scheme
#     (sync_color_scheme, on by default). Everything that reads it through the desktop
#     portal follows live: libadwaita/GTK4, Firefox/Zen and websites, Chromium/Electron,
#     Flatpaks, kitty, and Qt 6 (QT_QPA_PLATFORMTHEME=xdgdesktopportal).
#   - Its theme_mode_changed hook runs `theme-sync`, which covers the rest:
#       GTK3       gtk-theme adw-gtk3 / adw-gtk3-dark (live) + gtk-3.0/settings.ini
#                  (for X11/XWayland GTK3 apps and Flatpak GTK3 via the portal)
#       GTK4       gtk-4.0/settings.ini without forced theme/dark keys
#       Qt 5       MEGAsync is restarted with the matching adwaita-qt style; Qt 5
#                  Flatpaks (VLC, OpenSCAD) get the matching Adwaita style on next start
#       CopyQ      restarted (it only reads the palette at startup)
#       Flatpak    KDE-runtime Qt apps (Qt 5 and 6) get Adwaita / Adwaita-Dark on next start
#       NS-USBloader  its own THEME preference (JavaFX), applies on next start
#
# Not switchable from outside: Proton VPN forces its own dark-only theme (by design).
#
# `theme-sync` also runs on Noctalia's `started` hook, so a login always matches the
# saved mode. Don't set color-scheme/gtk-theme anywhere else (home-manager dconf,
# Hyprland exec, GTK_THEME, QT_STYLE_OVERRIDE): that is what used to pin dark mode.
{ config, pkgs, lib, ... }:

let
  themeSync = pkgs.writeShellApplication {
    name = "theme-sync";
    runtimeInputs = with pkgs; [ glib coreutils gnused gnugrep gawk procps util-linux flatpak ];
    text = ''
      # Usage: theme-sync [dark|light]   (default: $NOCTALIA_THEME_MODE, else Noctalia's mode)
      mode="''${1:-''${NOCTALIA_THEME_MODE:-}}"
      if [ -z "$mode" ]; then
        mode=$(noctalia msg theme-mode-get 2>/dev/null || true)
      fi
      case "$mode" in
        *dark*)  mode=dark;  scheme=prefer-dark;  gtk=adw-gtk3-dark ;;
        *light*) mode=light; scheme=prefer-light; gtk=adw-gtk3 ;;
        *) echo "theme-sync: unknown mode '$mode' (want dark or light)" >&2; exit 2 ;;
      esac

      cfg="''${XDG_CONFIG_HOME:-$HOME/.config}"

      # Portal preference (Noctalia already does this; repeated so `theme-sync` works alone).
      gsettings set org.gnome.desktop.interface color-scheme "$scheme"
      # GTK3 theme: native Wayland GTK3 apps switch live; Flatpak GTK3 reads it via the portal.
      gsettings set org.gnome.desktop.interface gtk-theme "$gtk"

      # settings.ini <file> <key> <value>: set or add a key in [Settings].
      setini() {
        mkdir -p "$(dirname "$1")"
        [ -f "$1" ] || printf '[Settings]\n' > "$1"
        if grep -q "^$2=" "$1"; then
          sed -i "s|^$2=.*|$2=$3|" "$1"
        else
          sed -i "/^\[Settings\]/a $2=$3" "$1"
        fi
      }
      # GTK3 fallback for X11/XWayland apps (no GSettings there).
      setini "$cfg/gtk-3.0/settings.ini" gtk-theme-name "$gtk"
      # Always 0: adw-gtk3-dark is dark by itself. Running GTK3 apps read this key only
      # at startup (it isn't a GSettings key), so a 1 kept apps started in dark mode
      # (e.g. the Thunar daemon) on the dark variant after switching to light (tested).
      setini "$cfg/gtk-3.0/settings.ini" gtk-application-prefer-dark-theme 0

      # GTK4: follow color-scheme from the portal. A theme name or prefer-dark key here
      # would pin every GTK4 app (and makes libadwaita warn).
      if [ -f "$cfg/gtk-4.0/settings.ini" ]; then
        sed -i '/^gtk-theme-name=/d; /^gtk-application-prefer-dark-theme=/d' "$cfg/gtk-4.0/settings.ini"
      fi
      # Old links to adw-gtk3-dark's GTK4 stylesheet forced every libadwaita app dark.
      for f in gtk.css gtk-dark.css assets; do
        if [ -L "$cfg/gtk-4.0/$f" ]; then rm -f "$cfg/gtk-4.0/$f"; fi
      done

      # Hyprland group tabs: recolour live (ThemeGroupTabs is defined in hyprland.lua).
      if command -v hyprctl >/dev/null; then
        hyprctl eval "ThemeGroupTabs(\"$mode\")" >/dev/null 2>&1 || true
      fi

      # Qt Flatpaks on the KDE runtime (VLC, OpenSCAD on 5.15; LeoCAD, Kdenlive, ... on
      # 6.x): Qt 5 has no light/dark support, and the runtime's default Breeze style
      # ignores it outside Plasma. Give each app the matching Adwaita style
      # (org.kde.KStyle.Adwaita extension) via a per-app override; applies on next start.
      if [ "$mode" = dark ]; then qtstyle=Adwaita-Dark; else qtstyle=Adwaita; fi
      flatpak list --user --app --columns=application,runtime 2>/dev/null \
        | awk '$2 ~ /^org\.kde\.Platform\// {print $1}' \
        | while read -r app; do
            flatpak override --user --env=QT_STYLE_OVERRIDE="$qtstyle" "$app" || true
          done

      # Qt 6 Flatpaks (LeoCAD, ...): make sure they use the portal-following platform
      # theme whatever the host env says (a stale qt6ct from the session pinned them).
      flatpak override --user --env=QT_QPA_PLATFORMTHEME=xdgdesktopportal || true

      # NS-USBloader (JavaFX) has its own theme preference; applies on next start.
      nsprefs="$HOME/.java/.userPrefs/NS-USBloader/prefs.xml"
      if [ -f "$nsprefs" ]; then
        nscss="/res/app_$mode.css"
        if grep -q '<entry key="THEME"' "$nsprefs"; then
          sed -i "s|<entry key=\"THEME\" value=\"[^\"]*\"/>|<entry key=\"THEME\" value=\"$nscss\"/>|" "$nsprefs"
        else
          sed -i "s|</map>|  <entry key=\"THEME\" value=\"$nscss\"/>\n</map>|" "$nsprefs"
        fi
      fi

      # Qt 5 has no light/dark support; restart MEGAsync so its wrapper picks the style.
      if pgrep -x megasync >/dev/null; then
        pkill -x megasync || true
        sleep 1
        setsid -f megasync >/dev/null 2>&1 < /dev/null
      fi

      # CopyQ (Qt 6) builds its stylesheet from the palette once at startup, so it does
      # not switch live (tested). Restart it; clipboard history is kept on disk.
      if pgrep -f '\.copyq-wrapped' >/dev/null; then
        copyq exit >/dev/null 2>&1 || true
        sleep 1
        setsid -f copyq --start-server >/dev/null 2>&1 < /dev/null
      fi

      echo "theme-sync: $mode"
    '';
  };

  kittyThemes = "${pkgs.kitty-themes}/share/kitty-themes/themes";
in
{
  home.packages = [ themeSync ];

  # Noctalia: run theme-sync when the mode changes and once at startup.
  programs.noctalia.settings.hooks = {
    started = "${themeSync}/bin/theme-sync";
    theme_mode_changed = "${themeSync}/bin/theme-sync";
  };

  # kitty follows the system color scheme by itself (live) with these files.
  xdg.configFile."kitty/dark-theme.auto.conf".source = "${kittyThemes}/adwaita_dark.conf";
  xdg.configFile."kitty/light-theme.auto.conf".source = "${kittyThemes}/adwaita_light.conf";
  xdg.configFile."kitty/no-preference-theme.auto.conf".source = "${kittyThemes}/adwaita_light.conf";
}
