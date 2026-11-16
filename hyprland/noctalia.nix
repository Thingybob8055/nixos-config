{ config, pkgs, lib, inputs, pkgs-stable, ... }:
let
  # Monitors that get a lock-screen layout. width/height are *logical* px
  # (resolution / scale); keep in sync with the hl.monitor() entries in hyprland.lua.
  # Every widget is positioned from these numbers, so the clock and password box are
  # centred automatically on each screen.
  lockMonitors = [
    { output = "eDP-1"; width = 2000; height = 1333; }
    { output = "DP-1"; width = 2560; height = 1440; }
    { output = "DP-4"; width = 1920; height = 1080; }
  ];

  # Per monitor: big time + date near the top, password box near the bottom.
  #
  # placement_width/height must equal the output's logical size. If they are missing
  # (or a connected monitor has no login box), Noctalia fills them in and writes the
  # whole lock-screen layout to ~/.local/state/noctalia/settings.toml, which then
  # overrides this config.
  lockWidgets = m:
    let
      cx = m.width / 2.0;
      base = {
        output = m.output;
        inherit cx;
        rotation = 0.0;
        placement_width = m.width * 1.0;
        placement_height = m.height * 1.0;
      };
      clock = { cy, boxW, boxH, format }: base // {
        type = "clock";
        inherit cy;
        box_width = boxW;
        box_height = boxH;
        settings = {
          clock_style = "digital";
          inherit format;
          color = "on_surface";
          shadow = true;
          background = false;
        };
      };
    in
    {
      "lock-time@${m.output}" = clock {
        cy = m.height * 0.17;
        boxW = 640.0;
        boxH = 210.0;
        format = "{:%H:%M}";
      };
      "lock-date@${m.output}" = clock {
        cy = m.height * 0.17 + 155.0;
        boxW = 620.0;
        boxH = 64.0;
        format = "{:%A, %d %B}";
      };
      "lockscreen-login-box@${m.output}" = base // {
        type = "login_box";
        cy = m.height - 182.0;
        box_width = 810.0;
        box_height = 196.0;
      };
    };
in
# Noctalia v5 (C++ rewrite, TOML config).
# This attrset is rendered to ~/.config/noctalia/config.toml and validated at build time
# (`noctalia config validate`). Changes made in the Settings GUI go to
# ~/.local/state/noctalia/settings.toml and override what is declared here.
# Reference: https://docs.noctalia.dev/noctalia/configuration/
{
  programs.noctalia = {
    enable = true;
    settings = {

      # ── Shell ──────────────────────────────────────────────────────────────
      shell = {
        telemetry_enabled = false;
        clipboard_enabled = true;
        animation = {
          enabled = true;
          speed = 1.0;
        };
        shadow.direction = "down_right";
        panel = {
          launcher_placement = "floating";
          launcher_position = "center";
          clipboard_placement = "floating";
          clipboard_position = "center";
          control_center_placement = "attached";
          session_placement = "floating";
        };
        # Built-in Alt+Tab switcher (replaces the Tabber plugin; see hyprland.lua).
        window_switcher = {
          # Size isn't configurable per style (only via global accessibility.ui_scale);
          # "carousel" uses large screen-relative cards with live previews.
          # Other styles: "icons" (small icon grid, Tabber-like), "compact", "grid".
          style = "carousel";
          mru = true; # most-recently-used order, so a quick Alt+Tab flips between two windows
          show_caption = true;
          show_count = true;
          show_app_icon = true;
        };
        launcher = {
          width = 920; # px, full layout (560–1200)
          sort_by_usage = true;
          ignore_mouse = false;
          pinned = [ ];
        };
      };

      # ── Theme (v4 predefinedScheme "ADW" is a community palette in v5) ────────
      theme = {
        mode = "dark";
        source = "community";
        community_palette = "ADW";
      };

      # ── Bar ────────────────────────────────────────────────────────────────
      # Same layout as the v4 "simple" bar; the sticky-notes plugin widget
      # sits right after the workspaces in the centre.
      bar = {
        order = [ "main" ];
        main = {
          position = "top";
          background_opacity = 0.93;
          capsule = true;
          capsule_opacity = 1.0;
          widget_spacing = 6;
          scale = 1.0;
          font_scale = 1.0;
          # Floating pill: inset from the screen edges, fully rounded ends.
          thickness = 34;
          radius = 17; # half the thickness = pill
          margin_ends = 8;
          margin_edge = 6;
          concave_edge_corners = false;
          reserve_space = true;
          auto_hide = false;
          show_on_workspace_switch = true;

          start = [ "launcher" "clock" "sysmon-cpu" "sysmon-temp" "sysmon-ram" "active_window" "media" ];
          center = [ "workspaces" "sticky-notes" ];
          end = [ "tray" "notifications" "battery" "volume" "brightness" "control-center" ];
        };
      };

      widget = {
        # v4 SystemMonitor showed CPU usage, CPU temp and memory; v5 uses one stat per widget.
        sysmon-cpu = {
          type = "sysmon";
          stat = "cpu_usage";
        };
        sysmon-temp = {
          type = "sysmon";
          stat = "cpu_temp";
        };
        sysmon-ram = {
          type = "sysmon";
          stat = "ram_pct";
        };
        # Plugin bar widget: <author>/<plugin>:<entry>
        sticky-notes = {
          type = "ahmedhossamdev/sticky-notes:bar";
        };
      };

      # ── Control Center ────────────────────────────────────────────────────
      # v4 "NoctaliaPerformance" has no v5 equivalent and was dropped.
      control_center.width = 920; # px (600–1200)
      control_center.shortcuts = [
        { type = "wifi"; }
        { type = "bluetooth"; }
        { type = "wallpaper"; }
        { type = "notification"; }
        { type = "power_profile"; }
        { type = "caffeine"; }
        { type = "nightlight"; }
      ];

      # ── Wallpaper ─────────────────────────────────────────────────────────
      wallpaper = {
        enabled = true;
        directory = "~/.wallpapers";
        fill_mode = "crop";
        transition = [ "fade" "disc" "stripes" "wipe" "pixel" "honeycomb" ];
        transition_duration = 1500;
        edge_smoothness = 0.05;
        transition_on_startup = true; # v4 skipStartupTransition = false
        automation = {
          enabled = false;
          interval_seconds = 300;
          order = "random";
        };
      };

      # ── Notifications / OSD ───────────────────────────────────────────────
      notification = {
        enable_daemon = true;
        position = "top_right";
        layer = "overlay";
        # Translucent so the Hyprland "noctalia-blur" layer rule shows through.
        # Keep above that rule's ignore_alpha (0.5) or the blur is skipped.
        background_opacity = 0.75;
      };

      osd = {
        position = "top_right";
        hide_delay_ms = 2000;
        background_opacity = 1.0;
      };

      # ── Lock screen ───────────────────────────────────────────────────────
      lockscreen = {
        enabled = true;
        blur_intensity = 0.0; # v4 lockScreenBlur = 0
        tint_intensity = 0.0; # v4 lockScreenTint = 0
      };

      # Large time + date at the top of the lock screen (v4 style), on every monitor.
      # v5 lock-screen widgets target exactly one output, so one pair is generated per
      # monitor in `lockMonitors` (see the let-block). Positions are logical px on that
      # output; text scales to fit its box.
      lockscreen_widgets = {
        enabled = true;
        schema_version = 2;
        widget_order = lib.concatMap (m: [
          "lock-time@${m.output}"
          "lock-date@${m.output}"
          "lockscreen-login-box@${m.output}"
        ]) lockMonitors;
        widget = lib.mergeAttrsList (map lockWidgets lockMonitors);
      };

      # ── Services ──────────────────────────────────────────────────────────
      audio = {
        enable_overdrive = true;
        spectrum_frame_rate = 30;
      };

      brightness.enable_ddcutil = false;

      nightlight = {
        enabled = false;
        force = false;
        temperature_day = 6500;
        temperature_night = 4000;
      };

      location.auto_locate = true;

      weather = {
        enabled = true;
        unit = "celsius";
        effects = true;
      };

      # v4 idle: screen off 600s, lock 660s, suspend 1800s, 5s fade.
      idle = {
        pre_action_fade_seconds = 5.0;
        behavior_order = [ "screen-off" "lock" "suspend" ];
        behavior = {
          screen-off = {
            timeout = 600;
            action = "screen_off";
            enabled = true;
          };
          lock = {
            timeout = 660;
            action = "lock";
            enabled = true;
          };
          suspend = {
            timeout = 1800;
            action = "lock_and_suspend"; # v4 lockOnSuspend = true
            enabled = true;
          };
        };
      };

      dock.enabled = false;
      # Needed for Noctes sticky notes (and any other desktop widget).
      # Widget placement is runtime state Noctalia keeps in ~/.local/state/noctalia/settings.toml.
      desktop_widgets.enabled = true;

      # ── Plugins ───────────────────────────────────────────────────────────
      # v4 QML plugins don't run on v5; these are the native Luau ports:
      #   sticky-notes -> ahmedhossamdev/sticky-notes (community source)
      # Tabber was dropped: v5 paints an opaque panel background behind plugin
      # panels, so its full-screen overlay showed as a grey block. The built-in
      # [shell.window_switcher] is used instead.
      # Declaring any source replaces the built-in defaults, so official +
      # community are listed explicitly. Enabled plugins are cloned on startup.
      plugins = {
        enabled = [
          "ahmedhossamdev/sticky-notes"
          # Sticky notes on the desktop: one desktop widget per note, edited in a panel.
          # First note: `noctalia msg plugin remo/noctes:service all desk`
          # Needs python3 on PATH (added in home.nix) for its tools/noctes-widget helper.
          "remo/noctes"
        ];
        auto_update = "none"; # v4 autoUpdate = false
        source = [
          {
            name = "official";
            kind = "git";
            location = "https://github.com/noctalia-dev/official-plugins";
            enabled = true;
          }
          {
            name = "community";
            kind = "git";
            location = "https://github.com/noctalia-dev/community-plugins";
            enabled = true;
          }
        ];
      };
    };
  };
}
