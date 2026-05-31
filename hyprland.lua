------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "eDP-1",
    mode     = "2000x1333@120",
    position = "auto",
    scale    = "auto",
})

hl.monitor({
    output   = "DP-1",
    mode     = "2560x1440",
    position = "0x0",
    scale    = "auto",
})

hl.monitor({
    output   = "DP-4",
    mode     = "1920x1080",
    position = "2560x218",
    scale    = "auto",
})


hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "1",
})


---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal    = "kitty"
local fileManager = "thunar"
local menu        =
"rofi -show drun -show-icons -theme ~/.local/share/rofi/themes/custom-theme.rasi  -calc-command \"printf '%s' '{result}' | wl-copy\""


-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function()
    hl.exec_cmd("noctalia-shell")
    --   hl.exec_cmd(terminal)
    --hl.exec_cmd("nm-applet --indicator")
    --hl.exec_cmd("swaync")
    --hl.exec_cmd("blueman-applet")
    -- hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd("copyq --start-server")
    --hl.exec_cmd("hypridle")
    --hl.exec_cmd("awww-daemon")
    --hl.exec_cmd("awww img ~/.wallpapers/2026-04-13-01-30-57-2mn8bo9krcx71.png")
    --hl.exec_cmd("awww img --outputs DP-1 ~/.wallpapers/2026-04-13-01-30-57-2mn8bo9krcx71.png")
   -- hl.exec_cmd("awww img --outputs DP-4 ~/.wallpapers/2026-04-13-01-30-57-2mn8bo9krcx71.png")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("gnome-keyring-daemon --start --components=pkcs11,secrets,ssh")

    --for libadwaita gtk4 apps you can use this command:
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme \"prefer-dark\" ")

    --for gtk3 apps you need to install adw-gtk3 theme
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme \"adw-gtk3-dark\" ")

    --hl.exec_cmd("systemctl --user start battery-alert")

    --hl.exec_cmd("systemctl --user start waybar")
    -- hl.exec_cmd("systemctl --user start swayosd")
    --hl.exec_cmd("swayosd-server")

    --hl.exec_cmd("systemctl --user start hyprshell")
    --hl.exec_cmd("hyprshell run")

    -- hl.exec_cmd("nwg-drawer -r")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Adwaita")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_STYLE_OVERRIDE", "Adwaita-Dark")

-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in          = 5,
        gaps_out         = 10,

        border_size      = 2,

        col              = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing    = false,

        layout           = "dwindle",
    },

    decoration = {
        rounding         = 10,
        rounding_power   = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow           = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur             = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            -- #popups = true
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- -- layerrule = blur on, match:namespace rofi
-- hl.layer_rule({
--     name  = "blur-rofi",
--     match = { namespace = "rofi" },
--     blur  = true,
--     xray = true
-- })

hl.window_rule({
    name    = "kitty-opacity",
    match   = { class = "kitty" },
    opacity = "0.9 0.9"
})

hl.window_rule({
    name    = "thunar-opacity",
    match   = { class = "thunar" },
    opacity = "0.95 0.95"
})

-- hl.layer_rule({
--     name       = "wleave-blur",
--     match      = { namespace = "wleave" },
--     blur       = true,
--     dim_around = true,
-- })

-- hl.layer_rule({
--     name         = "swaync-blur",
--     match        = { namespace = "swaync-control-center" },
--     blur         = true,
--     animation    = "slide right",
--     ignore_alpha = 0,
-- })

-- hl.layer_rule({
--     name         = "swaync-notif",
--     match        = { namespace = "swaync-notification-window" },
--     blur         = true,
--     animation    = "slide right",
--     ignore_alpha = 0,
-- })

-- hl.layer_rule({ match = { namespace = "waybar" }, blur = true })

-- hl.layer_rule({
--     name         = "swayosd-blur",
--     match        = { namespace = "swayosd" },
--     blur         = true,
--     ignore_alpha = 0,
-- })

-- hl.layer_rule({
--     name         = "nwgdraw-blur",
--     match        = { namespace = "nwg-drawer" },
--     blur         = true,
--     ignore_alpha = 0,
-- })

-- hl.layer_rule({
--     name         = "hyprshell_overview_blur",
--     match        = { namespace = "hyprshell_overview" },
--     blur         = true,
--     -- animation = "slide right",
--     ignore_alpha = 0,
-- })

-- hl.layer_rule({
--     name         = "hyprshell_switch_blur",
--     match        = { namespace = "hyprshell_switch" },
--     blur         = true,
--     -- animation = "slide right",
--     ignore_alpha = 0,
-- })

-- hl.layer_rule({
--     name         = "hyprshell_launcher_blur",
--     match        = { namespace = "hyprshell_launcher" },
--     blur         = true,
--     -- animation = "slide right",
--     ignore_alpha = 0,
-- })

hl.layer_rule({
    name         = "noctalia-blur",
    match        = { namespace = "noctalia-background-.*$" },
    blur         = true,
    -- animation = "slide right",
    ignore_alpha = 0.5,
    blur_popups = true
})


-- layerrule = animation slide right, match:namespace swaync-control-center

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Default springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "slide" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = false, -- If true disables the random hyprland logo / anime girl background. :(
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout    = "gb",
        kb_variant   = "",
        kb_model     = "",
        kb_options   = "",
        kb_rules     = "",

        follow_mouse = 1,

        sensitivity  = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad     = {
            natural_scroll       = true,
            tap_to_click         = true,
            clickfinger_behavior = true,
            drag_lock            = true,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
-- hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + G", hl.dsp.window.float({ action = "toggle" }))
-- hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("noctalia-shell ipc call launcher toggle"))
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd("noctalia-shell ipc call settings toggle"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + O", hl.dsp.layout("togglesplit")) -- dwindle only
hl.bind(mainMod .. " + M",
    hl.dsp.window.fullscreen({
        mode = "maximized",
        action = "toggle"
    })
)

hl.bind(mainMod .. " + SHIFT + M",
    hl.dsp.window.fullscreen({
        mode = "fullscreen",
        action = "toggle"
    })
)

-- hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("nwg-drawer -i breeze && nwg-drawer -i breeze -r"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
local hs = require("hyprsplit")
hs.config({ num_workspaces = 10 })
for i = 1, 10 do
    local key = i % 10
    hl.bind("SUPER + " .. key, hs.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + " .. key, hs.dsp.window.move({ workspace = i, follow = true }))
end

-- move to workspace +1/-1 with super ctrl left/right, if workspace +1 does not exist, create it and move there
local function focus_or_create_workspace(direction, type)
    local current_ws = hl.get_active_workspace()
    if not current_ws then
        return
    end
    
    local current_id = current_ws.id
    local target_id = direction == "next" and current_id + 1 or current_id - 1
    
    -- Check if target workspace exists
    local target_ws = hl.get_workspace(target_id)
    
    if not target_ws then
        -- Workspace doesn't exist, move a window there to create it, then focus it
        local active_win = hl.get_active_window()
        if active_win then
            if type == "move" then
                hl.dispatch(hs.dsp.window.move({ workspace = target_id, follow = true }))
            else
                hl.dispatch(hs.dsp.focus({ workspace = target_id, follow = true }))
            end
        else
            -- No active window, use exec to create the workspace
            hl.exec_cmd("hyprctl dispatch workspace " .. target_id)
        end
    else
        -- Workspace exists, just focus it
        if type == "move" then
            hl.dispatch(hs.dsp.window.move({ workspace = target_id, follow = true }))
        else
            hl.dispatch(hs.dsp.focus({ workspace = target_id }))
        end
    end
end

hl.bind("SUPER + CTRL + right", function()
    focus_or_create_workspace("next", "not_move")
end)

hl.bind("SUPER + CTRL + left", function()
    focus_or_create_workspace("prev", "not_move")
end)

-- -- move to a windows to workspace +1/-1 with super ctrl alt left/right, if a workspace does 
hl.bind("SUPER + CTRL + ALT + right", function()
    focus_or_create_workspace("next", "move")
end)

hl.bind("SUPER + CTRL + ALT + left", function()
    focus_or_create_workspace("prev", "move")
end)

-- Move all windows in current workspace to a target workspace

local function move_all_windows_to_workspace(target)
    local active_ws = hl.get_active_workspace()
    if not active_ws then
        return
    end
    local wins = hl.get_workspace_windows(active_ws)
    for _, w in ipairs(wins) do
        -- Use hyprsplit's dsp wrapper so workspace strings are mapped correctly
        local ok, move_fn = pcall(function()
            return hs.dsp.window.move({ workspace = target, window = w, follow = true })
        end)
        if ok and type(move_fn) == "function" then
            -- call the returned closure to perform the dispatch with hyprsplit mapping
            move_fn()
        else
            -- fallback: dispatch directly
            hl.dispatch(hl.dsp.window.move({ workspace = tostring(target), window = w, follow = false }))
        end
    end
end

-- Bind Super+Ctrl+Shift+[0-9] to move all windows to that workspace
for i = 1, 10 do
    local key = i % 10
    hl.bind("SUPER + CTRL + SHIFT + " .. key, function()
        move_all_windows_to_workspace(i)
    end)
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + W", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
-- hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume +5"), { locked = true, repeating = true })
-- hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume -5"), { locked = true, repeating = true })
-- hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"),
--     { locked = true, repeating = true })
-- hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --brightness +5"), { locked = true, repeating = true })
-- hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness -5"), { locked = true, repeating = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia-shell ipc call volume increase"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia-shell ipc call volume decrease"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("noctalia-shell ipc call volume muteOutput"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("noctalia-shell ipc call brightness increase"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("noctalia-shell ipc call brightness decrease"), { locked = true, repeating = true })



-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("screenshot area"))
hl.bind(mainMod .. " + SHIFT + CTRL + S", hl.dsp.exec_cmd("screenshot"))
hl.bind("Print", hl.dsp.exec_cmd("screenshot-satty-file"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("screenshot-satty-file area"))

hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("hypr-lid close"), { locked = true })
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("hypr-lid open"), { locked = true })

-- bind power button to open the session menu
hl.bind("XF86PowerOff", hl.dsp.exec_cmd("noctalia-shell ipc call sessionMenu toggle"), { locked = true })

hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("noctalia-shell ipc call lockScreen lock"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))

-- bind = $mainMod, S, togglegroup
hl.bind(mainMod .. " + S", hl.dsp.group.toggle())

hl.bind("SUPER + ALT + RIGHT", hl.dsp.group.next())
hl.bind("SUPER + ALT + LEFT", hl.dsp.group.prev())

-- bind = ALT, Tab, global, tabber:select-next
hl.bind("ALT + Tab", hl.dsp.global("tabber:select-next"))
hl.bind("ALT + SHIFT + Tab", hl.dsp.global("tabber:select-previous"))
hl.bind("ALT + Grave", hl.dsp.global("tabber:enter-group"))


hl.bind(mainMod .. " + SHIFT + left",
    hl.dsp.window.move({
        direction = "left",
        group_aware = true
    })
)

hl.bind(mainMod .. " + SHIFT + right",
    hl.dsp.window.move({
        direction = "right",
        group_aware = true
    })
)

hl.bind(mainMod .. " + SHIFT + up",
    hl.dsp.window.move({
        direction = "up",
        group_aware = true
    })
)

hl.bind(mainMod .. " + SHIFT + down",
    hl.dsp.window.move({
        direction = "down",
        group_aware = true
    })
)


hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("noctalia-shell ipc call launcher windows"))

hl.bind(mainMod .. " + CTRL + G", hl.dsp.group.lock_active())

hl.bind(mainMod .. " + SHIFT + CTRL + left",
    hl.dsp.window.move({ monitor = "l" })
)

hl.bind(mainMod .. " + SHIFT + CTRL + right",
    hl.dsp.window.move({ monitor = "r" })
)

hl.bind(mainMod .. " + SHIFT + CTRL + up",
    hl.dsp.window.move({ monitor = "u" })
)

hl.bind(mainMod .. " + SHIFT + CTRL + down",
    hl.dsp.window.move({ monitor = "d" })
)

hl.bind(mainMod .. " + J", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ workspace = "e+1" }))

local function set_visual_mode(resize)
    if resize then
        hl.config({
            general = {
                border_size = 2,
                gaps_in = 5,
                gaps_out = 10,
                col              = {
                active_border   = { colors = { "rgba(ffaa00ff)", "rgba(ffaa00ff)" }, angle = 45 },
                inactive_border = "rgba(595959aa)",
                }
            }
        })
    else
        hl.config({
            general = {
                border_size = 2,
                gaps_in = 5,
                gaps_out = 10,
                col              = {
                active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
                inactive_border = "rgba(595959aa)",
                }
            }
        })
    end
end

-- Enter resize submap
hl.bind(mainMod .. " + R", function()
    set_visual_mode(true)
    hl.dispatch(hl.dsp.submap("resize"))
end)

-- Define resize submap
hl.define_submap("resize", function()
    hl.bind("right", hl.dsp.window.resize({ x = 30, y = 0, relative = true }), { repeating = true })
    hl.bind("left", hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true })
    hl.bind("up", hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true })
    hl.bind("down", hl.dsp.window.resize({ x = 0, y = 30, relative = true }), { repeating = true })

    hl.bind("Escape", function()
        set_visual_mode(false)
        hl.dispatch(hl.dsp.submap("reset"))
    end)
end)


--------------------------------S
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name           = "suppress-maximize-events",
    match          = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name     = "fix-xwayland-drags",
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})
