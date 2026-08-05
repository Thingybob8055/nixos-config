{ config, pkgs, inputs, pkgs-stable, ... }:
{
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
          on-timeout = loginctl lock-session
      }

      # -------------------------
      # 15 MIN → SUSPEND (BATTERY ONLY)
      # -------------------------
      listener {
          timeout = 900
          on-timeout = sh -c 'systemd-ac-power || systemctl suspend'
      }
    '';

}