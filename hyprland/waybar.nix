{ config, pkgs, inputs, pkgs-stable, ... }:
{

    home.packages = with pkgs; [
      waybar
    ];


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
      #custom-notifications,
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


}