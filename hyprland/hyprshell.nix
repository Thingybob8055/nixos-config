{ config, pkgs, inputs, pkgs-stable, ... }:
{
   home.packages = with pkgs; [
      hyprshell
    ];
    
    services.hyprshell.enable = true;

    xdg.configFile."hyprshell/styles.css".text = ''
    :root {
    --border-color: rgba(65, 72, 104, 0.6);
    --border-color-active: rgba(122, 162, 247, 1);

    --bg-color: rgba(26, 27, 38, 0.92);
    --bg-color-hover: rgba(41, 46, 66, 1);

    --border-radius: 12px;
    --border-size: 3px;
    --border-style: solid;

    --text-color: rgba(192, 202, 245, 1);

    --window-padding: 0px;
    --bg-window-color: rgba(30, 32, 48, 0.85);
    }

    /* ======================================== */
    /* Remove blur halo around outer containers */
    /* ======================================== */

    .monitor,
    .launcher {
        /* border: unset; */
        /* outline: none; */
        box-shadow: none;
    }

    /* Keep workspace/client borders intact */

    .workspace,
    .client,
    .launcher-input,
    .launcher-item,
    .launcher-plugin {
        background-clip: padding-box;
    }

    /* ======================================== */
    /* More transparent overview only */
    /* ======================================== */

    .monitor,
    .workspace,
    .client {
        background: rgba(26, 27, 38, 0.68);
    }

    /* Slightly stronger active glow to compensate */

    .workspace.active,
    .client.active {
        border-color: rgba(122, 162, 247, 1);

        box-shadow:
            0 0 10px rgba(122, 162, 247, 0.14);
    }                 
  '';
    

}