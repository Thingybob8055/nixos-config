{ config, pkgs, inputs, pkgs-stable, ... }:
{

    systemd.user.services.battery-alert = {
  Unit = {
    Description = "Battery warning daemon";
    After = [ "graphical-session.target" ];
  };

  Service = {
    ExecStart = pkgs.writeShellScript "battery-alert" ''
      #!/usr/bin/env bash

      # Only run in Hyprland
      if [ "$XDG_CURRENT_DESKTOP" != "Hyprland" ] && [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
        echo "Not in Hyprland, exiting"
        exit 0
      fi

      export PATH=${pkgs.lib.makeBinPath [
        pkgs.bash
        pkgs.coreutils
        pkgs.findutils
        pkgs.gnugrep
        pkgs.libnotify
        pkgs.gnugrep
        pkgs.upower
        pkgs.gawk
        pkgs.pulseaudio
      ]}

      BAT_PATH=$(upower -e | grep BAT | head -n1)

      while true; do

        BATTERY=$(upower -i "$BAT_PATH" | grep -m1 percentage | cut -d':' -f2 | tr -d ' %')
        STATUS=$(upower -i "$BAT_PATH" | grep -m1 state | cut -d':' -f2 | tr -d ' ')

        echo "Battery: $BATTERY | Status: $STATUS"

        if [ -n "$BATTERY" ] && [ "$STATUS" != "charging" ] && [ "$BATTERY" -le 25 ]; then
          if [ "$alerted" -eq 0 ]; then

            notify-send \
              -u critical \
              -t 0 \
              "Low Battery" \
              "Battery is at ''${BATTERY}%"

            paplay ${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/dialog-warning.oga

            alerted=1
          fi
        else
          alerted=0
        fi

        sleep 10
      done    '';

    Restart = "always";
    RestartSec = 5;
  };

  Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };


}