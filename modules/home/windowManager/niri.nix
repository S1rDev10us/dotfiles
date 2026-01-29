{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.niri.homeModules.config
    inputs.dankMaterialShell.homeModules.dank-material-shell
    inputs.dankMaterialShell.homeModules.niri
  ];
  programs.niri = {
    settings = {
      xwayland-satellite = {
        enable = true;
        path = lib.getExe pkgs.xwayland-satellite;
      };
      input = {
        focus-follows-mouse.enable = true;
        warp-mouse-to-focus.enable = true;
      };
      layout = rec {
        gaps = 0;
        struts = lib.listToAttrs (lib.map (dir: lib.nameValuePair dir 8) ["bottom" "top" "left" "right"]);

        focus-ring.enable = false;
        border = {
          enable = true;
          width = 4;
          active.color = "white";
          inactive.gradient = {
            angle = 135;
            from = "#536878";
            to = "#0C3F66";
            in' = "srgb";
            relative-to = "workspace-view";
          };
          urgent.gradient = {
            from = "#C20F21";
            to = "#ECEB29";
            in' = "srgb";
            relative-to = "workspace-view";
          };
        };

        shadow.enable = true;
        insert-hint.display.color = "#01495E50";

        preset-column-widths = [
          {proportion = 1. / 3.;}
          {proportion = 1. / 2.;}
          {proportion = 2. / 3.;}
        ];
        default-column-width = builtins.elemAt preset-column-widths 1;
      };
      prefer-no-csd = true;

      hotkey-overlay.skip-at-startup = true;

      binds =
        {
          # Keys consist of modifiers separated by + signs, followed by an XKB key name
          # in the end. To find an XKB name for a particular key, you may use a program
          # like wev.
          #
          # "Mod" is a special modifier equal to Super when running on a TTY, and to Alt
          # when running as a winit window.
          #
          # Most actions that you can bind here can also be invoked programmatically with
          # `niri msg action do-something`.

          # Mod+? shows important hotkeys
          "Mod+Shift+Slash".action.show-hotkey-overlay = [];

          # App spawn keybinds
          "Mod+Return" = {
            action.spawn = "foot";
            hotkey-overlay.title = "Open a terminal (foot)";
          };

          # Overview
          "Mod+O" = {
            action.toggle-overview = [];
            repeat = false;
          };
          "Mod+Tab" = {
            action.toggle-overview = [];
            repeat = false;
          };

          # Move focus/column to first column
          "Mod+Home".action.focus-column-first = [];
          "Mod+End".action.focus-column-last = [];
          "Mod+Ctrl+Home".action.move-column-to-first = [];
          "Mod+Ctrl+End".action.move-column-to-last = [];

          # Move focus/column Up+Down
          "Mod+Page_Up".action.focus-workspace-up = [];
          "Mod+Page_Down".action.focus-workspace-down = [];
          "Mod+Shift+Page_Up".action.move-column-to-workspace-up = [];
          "Mod+Shift+Page_Down".action.move-column-to-workspace-down = [];
          # Move workspace Up+Down
          "Mod+Alt+Page_Up".action.move-workspace-up = [];
          "Mod+Alt+Page_Down".action.move-workspace-down = [];

          # Move focus UDLR (scrollwheel)
          "Mod+WheelScrollUp" = {
            action.focus-workspace-up = [];
            cooldown-ms = 150;
          };
          "Mod+WheelScrollDown" = {
            action.focus-workspace-down = [];
            cooldown-ms = 150;
          };
          "Mod+Shift+WheelScrollUp" = {
            action.focus-column-left = [];
            cooldown-ms = 150;
          };
          "Mod+Shift+WheelScrollDown" = {
            action.focus-column-right = [];
            cooldown-ms = 150;
          };

          # The following binds move the focused window in and out of a column.
          # If the window is alone, they will consume it into the nearby column to the side.
          # If the window is already in a column, they will expel it out.
          "Mod+BracketLeft".action.consume-or-expel-window-left = [];
          "Mod+BracketRight".action.consume-or-expel-window-right = [];

          # Consume one window from the right to the bottom of the focused column.
          "Mod+Period".action.consume-window-into-column = [];
          # Expel the bottom window from the focused column to the right.
          "Mod+slash".action.expel-window-from-column = [];

          "Mod+R".action.switch-preset-column-width = [];

          "Mod+F11".action.maximize-column = [];
          "Mod+Shift+F11".action.fullscreen-window = [];
          "Mod+Alt+F11".action.toggle-windowed-fullscreen = [];

          # Expand the focused column to space not taken up by other fully visible columns.
          # Makes the column "fill the rest of the space".
          "Mod+Ctrl+F".action.expand-column-to-available-width = [];

          "Mod+C".action.center-column = [];
          # Finer width adjustments.
          # This command can also:
          # * set width in pixels: "1000"
          # * adjust width in pixels: "-5" or "+5"
          # * set width as a percentage of screen width: "25%"
          # * adjust width as a percentage of screen width: "-10%" or "+10%"
          # Pixel sizes use logical, or scaled, pixels. I.e. on an output with scale 2.0,
          # set-column-width "100" will make the column occupy 200 physical screen pixels.
          "Mod+Minus".action.set-column-width = "-10%";
          "Mod+Equal".action.set-column-width = "+10%";

          # Finer height adjustments when in column with other windows.
          "Mod+Shift+Minus".action.set-window-height = "-10%";
          "Mod+Shift+Equal".action.set-window-height = "+10%";

          # Move the focused window between the floating and the tiling layout.
          "Mod+F".action.toggle-window-floating = [];
          "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = [];

          "Print".action.screenshot = [];
          "Mod+Shift+S".action.screenshot = [];
          "Ctrl+Print".action.screenshot-screen = [];
          "Mod+Shift+Ctrl+S".action.screenshot-screen = [];
          "Alt+Print".action.screenshot-window = [];
          "Mod+Shift+Alt+S".action.screenshot-window = [];

          # Applications such as remote-desktop clients and software KVM switches may
          # request that niri stops processing the keyboard shortcuts defined here
          # so they may, for example, forward the key presses as-is to a remote machine.
          # It's a good idea to bind an escape hatch to toggle the inhibitor,
          # so a buggy application can't hold your session hostage.
          #
          # The allow-inhibiting=false property can be applied to other binds as well,
          # which ensures niri always processes them, even when an inhibitor is active.
          "Mod+Ctrl+Escape" = {
            action.toggle-keyboard-shortcuts-inhibit = [];
            allow-inhibiting = false;
          };

          # The quit action will show a confirmation dialog to avoid accidental exits.
          "Mod+Shift+E".action.quit = [];

          # TODO: replace with screensaver keybind
          # Powers off the monitors. To turn them back on, do any input like
          # moving the mouse or pressing any other key.
          "Mod+Shift+P".action.power-off-monitors = [];

          # Toggle autohide on DMS
          "Mod+BackSpace".action.spawn = ["dms" "ipc" "call" "bar" "toggleAutoHide" "name" "Main Bar"];

          # Colour picker
          "Mod+Shift+C" = {
            action.spawn = ["dms" "color" "pick" "-a"];
            repeat = false;
          };
          "XF86AudioPlay".action.spawn = ["${pkgs.playerctl}/bin/playerctl" "play-pause"];
          "XF86TouchpadToggle".action.spawn = ["${pkgs.playerctl}/bin/playerctl" "play-pause"];
          "XF86AudioPrev".action.spawn = ["${pkgs.playerctl}/bin/playerctl" "previous"];
          "XF86AudioNext".action.spawn = ["${pkgs.playerctl}/bin/playerctl" "next"];
        }
        // (lib.listToAttrs (lib.flatten (let
          inherit (lib) stringToCharacters nameValuePair;

          rHome.qwerty = stringToCharacters "HJKL";
          rHome.colemak = stringToCharacters "HNEI";

          rArrow.qwerty = stringToCharacters "JKIL";
          rArrow.colemak = stringToCharacters "NEUI";

          directions.chars = stringToCharacters "ldur";
          directions.full = map (key:
            {
              r = "Right";
              d = "Down";
              u = "Up";
              l = "Left";
            }.${
              key
            })
          directions.chars;

          dirIsHorizontal = {
            Right = true;
            Down = false;
            Up = false;
            Left = true;
          };

          # fromDirections :: (key-> dir -> val) -> [val]
          mapDirections = f:
            lib.map
            ({
              fst,
              snd,
            }:
              f fst snd)
            ((lib.zipLists rHome.qwerty directions.full) ++ (lib.zipLists directions.full directions.full));

          # gengenDirectionalBinds :: mods: ({key,dir,hor-win,hor-col,is-ver,dir-low} -> val) -> [{name=mods+"...";value=val;}]
          genDirectionalBinds = mods: genAction:
            mapDirections (
              key: dir:
                nameValuePair "${mods}+${key}" (genAction rec {
                  inherit key dir;
                  is-hor = dirIsHorizontal.${dir};
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
                })
            );
          # genSimpleDirectionalBinds :: mods: ({key,dir,hor-win,hor-col,is-ver,dir-low} -> action) -> [{name=mods+"...";value.action.${action}=[];}]
          genSimpleDirectionalBinds = mods: genActionName: genDirectionalBinds mods (args: {action.${genActionName args} = [];});
        in [
          (lib.map (
            code:
              nameValuePair code
              {
                action.close-window = [];
                repeat = false;
              }
          ) ["Mod+Escape" "Alt+F4"])

          (lib.genList (i: nameValuePair "Mod+${builtins.toString (lib.mod (i + 1) 10)}" {action.focus-workspace = [(i + 1)];}) 10)
          (lib.genList (i: nameValuePair "Mod+Shift+${builtins.toString (lib.mod (i + 1) 10)}" {action.move-window-to-workspace = [(i + 1)];}) 10)

          # Mod+J=focus-window-or-workspace-down
          # Mod+H=focus-column-or-monitor-left
          (genSimpleDirectionalBinds "Mod" ({
            hor-col,
            is-ver,
            hor-mon-ver-work,
            dir-low,
            ...
          }: "focus-${hor-col}-or-${hor-mon-ver-work}-${dir-low}"))

          # Mod+Ctrl+J=set-window-width +10%
          (genDirectionalBinds "Mod+Ctrl" ({
            dir,
            is-ver,
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
          in {action."set-${hor-col}-${hor-width}" = [amount];}))

          # Mod+Shift+J=move-window-down-or-to-workspace-down
          # Mod+Shift+L=move-column-right-or-to-monitor-right
          (genSimpleDirectionalBinds "Mod+Shift" ({
            hor-col,
            dir-low,
            hor-mon-ver-work,
            ...
          }: "move-${hor-col}-${dir-low}-or-to-${hor-mon-ver-work}-${dir-low}"))

          # Mod+Shift+Ctrl+J=move-column-to-workspace-down
          (genSimpleDirectionalBinds "Mod+Shift+Ctrl" ({
            dir-low,
            hor-mon-ver-work,
            ...
          }: "move-column-to-${hor-mon-ver-work}-${dir-low}"))
        ])));

      window-rules =
        lib.flatten [
          {
            matches = [
              {
                app-id = "firefox$";
                title = "^Picture-in-Picture$";
              }
            ];
            open-floating = true;
          }
          {
            matches = [
              {app-id = "^org\\.keepassxc\\.KeePassXC$";}
              {app-id = "^org\\.gnome\\.World\\.Secrets$";}
              {app-id = "^org\\.kde\\.kwalletmanager$";}
            ];
            block-out-from = "screen-capture";
          }
          {
            matches = [
              {app-id = "discord";}
              {app-id = "thunderbird";}
              {app-id = "firefox-comms";}
            ];
            block-out-from = "screencast";
          }
          {
            geometry-corner-radius = let
              rad = 12.;
            in {
              bottom-left = rad;
              bottom-right = rad;
              top-left = rad;
              top-right = rad;
            };
            clip-to-geometry = true;
          }
        ];

      layer-rules = [
        {
          matches = [
            {
              namespace = "dms:blurwallpaper";
            }
          ];
          place-within-backdrop = true;
        }
      ];

      animations = {
        window-close = {
          kind.easing = {
            duration-ms = 500;
            curve = "linear";
          };

          custom-shader = "
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
          ";
        };
      };
    };
  };
  programs.dank-material-shell = {
    enable = true;

    dgop.package = pkgs.unstable.dgop;
    niri = {
      enableKeybinds = true;
      enableSpawn = true;
      includes.enable = false;
    };

    # Core features
    enableSystemMonitoring = true; # System monitoring widgets (dgop)
    enableDynamicTheming = true; # Wallpaper-based theming (matugen)
    enableAudioWavelength = true; # Audio visualizer (cava)
  };
}
