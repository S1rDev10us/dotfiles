{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.dankMaterialShell.homeModules.dank-material-shell
  ];
  options.programs.niri = {
    extraRules = lib.mkOption {
      default = [];
      type = lib.types.listOf lib.types.lines;
    };
  };
  config = {
    home.checks = [
      (pkgs.runCommand "validate-niri-config" {
          buildInputs = [pkgs.niri];
        } ''
          niri validate -c ${config.xdg.configFile."niri/config.kdl".source}
          touch $out
        '')
    ];
    xdg.configFile."niri/config.kdl".text =
      ''
        prefer-no-csd
        spawn-at-startup "dms" "run"

        xwayland-satellite {
          path "${lib.getExe pkgs.xwayland-satellite}"
        }

        input {
          focus-follows-mouse max-scroll-amount="25%"
          warp-mouse-to-focus

          touchpad {
            natural-scroll
            tap
            drag true
          }
        }

        layout {
          gaps 0
          always-center-single-column

          default-column-width { proportion 0.5; }
          preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
          }

          struts {
            ${lib.join "\n    " (lib.map (dir: "${dir} 8") ["bottom" "top" "left" "right"])}
          }

          focus-ring { off; }
          border {
            on
            width 4
            active-color "white"
            inactive-gradient from="#536878" to="#0C3F66" angle=135 relative-to="workspace-view" in="srgb"
            urgent-gradient from="#C20F21" to="#ECEB29" relative-to="workspace-view" in="srgb"
          }
          shadow {
            on
          }

          insert-hint {
            on
            color "#01495E50"
          }

          tab-indicator {
            place-within-column
          }
        }

        hotkey-overlay {
          skip-at-startup
        }

        binds {
          // Mod+? shows important hotkeys
          Mod+Shift+Slash { show-hotkey-overlay; }

          // App spawn keybinds
          Mod+Return        hotkey-overlay-title="Open a terminal (foot)"      { spawn "foot"; }
          Mod+Space         hotkey-overlay-title="Toggle Application Launcher" { spawn "dms" "ipc" "spotlight" "toggle"; }
          Mod+N             hotkey-overlay-title="Toggle Notification Centre"  { spawn "dms" "ipc" "notifications" "toggle"; }
          Mod+Comma         hotkey-overlay-title="Toggle DMS settings"         { spawn "dms" "ipc" "settings" "toggle"; }
          Mod+P             hotkey-overlay-title="Toggle Notepad"              { spawn "dms" "ipc" "notepad" "toggle"; }
          Super+Alt+L       hotkey-overlay-title="Lock Screen"                 { spawn "dms" "ipc" "lock" "lock"; }
          Mod+X             hotkey-overlay-title="Toggle Power Menu"           { spawn "dms" "ipc" "powermenu" "toggle"; }
          Mod+V             hotkey-overlay-title="Toggle Clipboard Menu"       { spawn "dms" "ipc" "clipboard" "toggle"; }
          Ctrl+Shift+Escape hotkey-overlay-title="Toggle Process List"         { spawn "dms" "ipc" "processlist" "toggle"; }

          // Overview
          Mod+O repeat=false   { toggle-overview; }
          Mod+Tab repeat=false { toggle-overview; }

          // Move focus/column to first column
          Mod+Home       { focus-column-first; }
          Mod+End        { focus-column-last; }
          Mod+Shift+Home { move-column-to-first; }
          Mod+Shift+End  { move-column-to-last; }

          // Move focus/column Up+Down
          Mod+Page_Up         { focus-workspace-up; }
          Mod+Page_Down       { focus-workspace-down; }
          Mod+Shift+Page_Up   { move-column-to-workspace-up; }
          Mod+Shift+Page_Down { move-column-to-workspace-down; }

          // Move workspace Up/Down
          Super+Alt+Page_Up   { move-workspace-up; }
          Super+Alt+Page_Down { move-workspace-down; }

          // Move focus UDLR (scrollwheel)
          Mod+WheelScrollUp         cooldown-ms=150 { focus-workspace-up; }
          Mod+WheelScrollDown       cooldown-ms=150 { focus-workspace-down; }
          Mod+Shift+WheelScrollUp   cooldown-ms=150 { focus-column-left; }
          Mod+Shift+WheelScrollDown cooldown-ms=150 { focus-column-right; }

          // The following binds move the focused window in and out of a column.
          // If the window is alone, they will consume it into the nearby column to the side.
          // If the window is already in a column, they will expel it out.
          Mod+BracketLeft  { consume-or-expel-window-left; }
          Mod+BracketRight { consume-or-expel-window-right; }

          // Consume and expel windows from column
          Mod+Period { consume-window-into-column; }
          Mod+slash  { expel-window-from-column; }

          // Adjust window size
          Mod+R           { switch-preset-column-width; }

          Mod+F11         { maximize-column; }
          Mod+Shift+F11   { fullscreen-window; }
          Super+Alt+F11   { toggle-windowed-fullscreen; }

          Mod+Minus       { set-column-width "-10%"; }
          Mod+Equal       { set-column-width "+10%"; }
          Mod+Shift+Minus { set-window-height "-10%"; }
          Mod+Shift+Equal { set-window-height "+10%"; }

          // Expand the focused column to space not taken up by other fully visible columns.
          // Makes the column "fill the rest of the space".
          Mod+Ctrl+F { expand-column-to-available-width; }

          Mod+C { center-column; }

          // Move the focused window between the floating and the tiling layout.
          Mod+F       { toggle-window-floating; }
          Mod+Shift+V { switch-focus-between-floating-and-tiling; }

          // Screenshots
          Print             { screenshot; }
          Mod+Shift+S       { screenshot; }

          Ctrl+Print        { screenshot-screen; }
          Mod+Shift+Ctrl+S  { screenshot-screen; }

          Alt+Print         { screenshot-window; }
          Super+Shift+Alt+S { screenshot-window; }

          // Applications such as remote-desktop clients and software KVM switches may
          // request that niri stops processing the keyboard shortcuts defined here
          // so they may, for example, forward the key presses as-is to a remote machine.
          // It's a good idea to bind an escape hatch to toggle the inhibitor,
          // so a buggy application can't hold your session hostage.
          //
          // The allow-inhibiting=false property can be applied to other binds as well,
          // which ensures niri always processes them, even when an inhibitor is active.
          Mod+Ctrl+Escape hotkey-overlay-title="Toggle shortcut inhibit" allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

          // The quit action will show a confirmation dialog to avoid accidental exits.
          Mod+Shift+E { quit; }

          // TODO: replace with screensaver keybind
          // Powers off the monitors. To turn them back on, do any input like
          // moving the mouse or pressing any other key.
          Mod+Shift+P { power-off-monitors; }

          // Hide DMS
          Mod+BackSpace hotkey-overlay-title="Hide DMS" { spawn "dms" "ipc" "call" "bar" "toggleAutoHide" "name" "Main Bar"; }

          // Colour picker
          Mod+Shift+C repeat=false { spawn "dms" "color" "pick" "-a"; }

          // Media controls
          XF86AudioPlay      { spawn "${lib.getExe pkgs.playerctl}" "play-pause"; }
          XF86TouchpadToggle { spawn "${lib.getExe pkgs.playerctl}" "play-pause"; }
          XF86AudioPrev      { spawn "${lib.getExe pkgs.playerctl}" "previous"; }
          XF86AudioNext      { spawn "${lib.getExe pkgs.playerctl}" "next"; }

          XF86AudioMute        allow-when-locked=true { spawn "dms" "ipc" "audio" "mute"; }
          XF86AudioLowerVolume allow-when-locked=true { spawn "dms" "ipc" "audio" "decrement" "3"; }
          XF86AudioRaiseVolume allow-when-locked=true { spawn "dms" "ipc" "audio" "increment" "3"; }

          // Brightness controls
          XF86MonBrightnessDown allow-when-locked=true { spawn "dms" "ipc" "brightness" "decrement" "5" ""; }
          XF86MonBrightnessUp   allow-when-locked=true { spawn "dms" "ipc" "brightness" "increment" "5" ""; }

          // Tab controls
          Mod+W { toggle-column-tabbed-display; }

          // Close window
          Mod+Escape repeat=false { close-window; }
          Alt+F4     repeat=false { close-window; }

          // Begin programmatic binds
          ${lib.join "\n    " (let
          homeKeys.qwerty = lib.stringToCharacters "HJKL";
          directions = ["Left" "Down" "Up" "Right"];

          directionInfo = key: dir: rec {
            inherit key dir;
            is-hor = dir == "Left" || dir == "Right";
            is-ver = !is-hor;
            hor-win =
              if is-hor
              then "window"
              else "column";
            hor-col =
              if is-hor
              then "column"
              else "window";
            hor-width =
              if is-hor
              then "width"
              else "height";
            hor-mon-ver-work =
              if is-ver
              then "workspace"
              else "monitor";
            dir-low = lib.toLower dir;
          };

          # mapDirections :: (key -> dir -> val) -> [val]
          mapDirections = f:
            lib.map ({
              fst,
              snd,
            }:
              f fst snd)
            ((lib.zipLists homeKeys.qwerty directions) ++ (lib.zipLists directions directions));
          mapDirectionsWith = f: mapDirections (key: dir: f (directionInfo key dir));
        in
          lib.flatten [
            "// Move window to/focus workspace"
            (lib.genList (i: "Mod+${builtins.toString (lib.mod (i + 1) 10)} { focus-workspace ${builtins.toString (i + 1)}; }") 10)
            (lib.genList (i: "Mod+Shift+${builtins.toString (lib.mod (i + 1) 10)} { move-window-to-workspace ${builtins.toString (i + 1)}; }") 10)

            "// Focus window/column in direction"
            (mapDirectionsWith ({
              key,
              hor-col,
              is-ver,
              hor-mon-ver-work,
              dir-low,
              ...
            }: "Mod+${key} { focus-${hor-col}-or-${hor-mon-ver-work}-${dir-low}; }"))
            "// Move column horizontally or window vertically"
            (mapDirectionsWith ({
              key,
              hor-col,
              hor-mon-ver-work,
              dir-low,
              ...
            }: "Mod+Shift+${key} { move-${hor-col}-${dir-low}-or-to-${hor-mon-ver-work}-${dir-low}; }"))
            "// Move column in direction"
            (mapDirectionsWith ({
              key,
              hor-mon-ver-work,
              dir-low,
              ...
            }: "Mod+Shift+Ctrl+${key} { move-column-to-${hor-mon-ver-work}-${dir-low}; }"))

            "// Set column width and window height"
            (mapDirectionsWith ({
              key,
              dir,
              hor-col,
              hor-width,
              dir-low,
              ...
            }: let
              amount = "${
                if dir == "Right" || dir == "Down"
                then "+"
                else "-"
              }10%";
            in "Mod+Ctrl+${key} { set-${hor-col}-${hor-width} \"${amount}\"; }"))
          ])}
        }

        window-rule {
          match app-id="firefox$" title="^Picture-in-Picture$"

          open-floating true
        }

        window-rule {
          match app-id="^org\\.keepassxc\\.KeePassXC$"
          match app-id="^org\\.gnome\\.World\\.Secrets$"
          match app-id="^org\\.kde\\.kwalletmanager$"

          block-out-from "screen-capture"
        }

        window-rule {
          match app-id="discord"
          match app-id="thunderbird"
          match app-id="firefox-comms"

          block-out-from "screencast"
        }

        window-rule {
          clip-to-geometry true
        }

        window-rule {
          match app-id="steam" title="notificationtoasts"

          default-floating-position x=25 y=25 relative-to="bottom-right"
          open-focused false
        }

        layer-rule {
          match namespace="dms:blurwallpaper"

          place-within-backdrop true
        }

        animations {
          window-close {
            duration-ms 500
            curve "linear"
            custom-shader r"
              #define PI 3.14159
              #define CURVE_REPEAT 8.0
              #define TURN_RATE 5.0

              vec4 close_color(vec3 coords_geo, vec3 size_geo) {
                // Find distance to corner
                float max_rad = length(size_geo);

                // Coords in pixel space centered on the window
                vec2 cuv = (coords_geo.xy - 0.5) * size_geo.xy;

                // Polar co-ordinates
                float radius = length(cuv)/max_rad;
                float angle = atan(cuv.x, cuv.y) / PI + 0.5;

                // 1-0-1 along the width of each spiral
                float spiral = mod(radius * TURN_RATE + angle, 2.0 / CURVE_REPEAT) / (2.0 / CURVE_REPEAT);
                spiral = abs(spiral * 2.0 - 1.0);

                // Combine the spiral with the distance from the center
                float val = 1.0 - radius + spiral / 5.0;

                // Decrease value over time towards 0
                val = val * pow(1.0 - niri_clamped_progress, 2.0);
                // Create harsh boundary
                val = floor(val+0.5);
                // Clamp val to 0-1 to stop issues when multiplying val by color
                val = clamp(val, 0.0, 1.0);

                // Fade to half opacity by the end
                val *= 1.0 - niri_clamped_progress / 2.0;

                // Current pixel data
                vec3 coords_tex = niri_geo_to_tex * coords_geo;
                vec4 color = texture2D(niri_tex, coords_tex.st);

                return color * val;
              }
            "
          }
        }

        recent-windows {
          binds {
            Alt+Tab         { next-window; }
            Alt+Shift+Tab   { previous-window; }
            Alt+grave       { next-window     filter="app-id"; }
            Alt+Shift+grave { previous-window filter="app-id"; }
          }
        }

        // Extra rules

      ''
      + (lib.join "\n"
        (lib.imap0 (i: content: "include \"${pkgs.writeText "niri-extra-rule-${builtins.toString i}.kdl" content}\"")
          config.programs.niri.extraRules));

    programs.dank-material-shell = {
      enable = true;

      dgop.package = pkgs.unstable.dgop;

      # Core features
      enableSystemMonitoring = true; # System monitoring widgets (dgop)
      enableDynamicTheming = true; # Wallpaper-based theming (matugen)
      enableAudioWavelength = true; # Audio visualizer (cava)
    };
    xdg.portal = {
      enable = true;
      config.niri = {
        default = ["kde" "gtk" "gnome"];
        "org.freedesktop.impl.portal.Access" = "gtk";
        "org.freedesktop.impl.portal.Notification" = "gtk";
        "org.freedesktop.impl.portal.Secret" = "kwallet";
        "org.freedesktop.impl.portal.ScreenCast" = "gnome";
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal
        xdg-desktop-portal-gtk
        kdePackages.kwallet
        kdePackages.xdg-desktop-portal-kde
        xdg-desktop-portal-gnome
      ];
    };
  };
}
