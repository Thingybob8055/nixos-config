{ config, pkgs, inputs, pkgs-stable, ... }:
{

    home.packages = with pkgs; [
      wleave
    ];

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



}