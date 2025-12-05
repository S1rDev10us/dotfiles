{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.niri.homeModules.config
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
    inputs.dankMaterialShell.homeModules.dankMaterialShell.niri
  ];
  programs.niri = {
    settings = {
      xwayland-satellite = {
        enable = true;
        path = lib.getExe pkgs.xwayland-satellite;
      };
      input = {focus-follows-mouse.enable = true;};
      layout = rec {
        gaps = 8;
        focus-ring = {
          enable = true;
          width = 4;

          active.color = "white";
          inactive.color = "grey";

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

      binds = let
        inherit (lib) stringToCharacters optionalString;
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
        directionsToHorizontalWindows = {
          Right = "window";
          Down = "column";
          Up = "column";
          Left = "window";
        };
        directionsToHorizontalColumns = lib.mapAttrs (name: value:
          if value == "window"
          then "column"
          else "window")
        directionsToHorizontalWindows;
        # fromDirections :: (key-> dir -> val) -> [val]
        mapDirections = f:
          lib.map
          ({
            fst,
            snd,
          }:
            f fst snd)
          ((lib.zipLists rHome.qwerty directions.full) ++ (lib.zipLists directions.full directions.full));
        # fromDirections :: (key-> dir -> {name: string;value;}) -> {<name>=...;}
        mapDirectionsToAttrs = f: lib.listToAttrs (mapDirections f);
        genDirectionalBinds = mods: genAction:
          mapDirectionsToAttrs (key: dir: {
            name = "${mods}+${key}";
            value = genAction rec {
              inherit key dir;
              hor-win = directionsToHorizontalWindows.${dir};
              hor-col = directionsToHorizontalColumns.${dir};
              is-hor = hor-win == "window";
              is-ver = !is-hor;
              dir-low = lib.toLower dir;
            };
          });
        genSimpleDirectionalBinds = mods: genActionName: genDirectionalBinds mods (args: {action.${genActionName args} = [];});
      in
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
          "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = [];
          "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = [];

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
          "Ctrl+Print".action.screenshot-screen = [];
          "Alt+Print".action.screenshot-window = [];

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
        }
        # Mod+J=focus-window-or-workspace-down
        // (genSimpleDirectionalBinds "Mod" ({
          hor-col,
          is-ver,
          dir-low,
          ...
        }: "focus-${hor-col}${optionalString is-ver "-or-workspace"}-${dir-low}"))
        # Mod+Ctrl+J=move-window-down-or-to-workspace-down
        // (genSimpleDirectionalBinds "Mod+Ctrl" ({
          hor-col,
          is-ver,
          dir-low,
          ...
        }:
          "move-${hor-col}-${dir-low}" + optionalString is-ver "-or-to-workspace-${dir-low}"))
        # Mod+Shift+J=focus-monitor-down
        // (genSimpleDirectionalBinds "Mod+Shift" ({dir-low, ...}: "focus-monitor-${dir-low}"))
        # Mod+Shift+Ctrl+J=move-column-to-monitor-down
        // (genSimpleDirectionalBinds "Mod+Shift+Ctrl" ({dir-low, ...}: "move-column-to-monitor-${dir-low}"))
        // (lib.listToAttrs (lib.flatten (let
          bind = key: value: {
            name = key;
            inherit value;
          };
        in [
          (lib.map (
            code:
              bind code
              {
                action.close-window = [];
                repeat = false;
              }
          ) ["Mod+Escape" "Alt+F4"])
        ])));

      window-rules = [
        {
          matches = [
            {app-id = "firefox$";}
            {title = "^Picture-in-Picture$";}
          ];
          open-floating = true;
        }
        {
          matches = [
            {app-id = "^org\\.keepassxc\\.KeePassXC$";}
            {app-id = "^org\\.gnome\\.World\\.Secrets$";}
          ];
          block-out-from = "screen-capture";
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
    };
  };
  programs.dankMaterialShell = {
    enable = true;

    niri.enableKeybinds = true;
    niri.enableSpawn = true;

    # Core features
    enableSystemMonitoring = true; # System monitoring widgets (dgop)
    enableClipboard = true; # Clipboard history manager
    enableBrightnessControl = true; # Backlight/brightness controls
    enableColorPicker = true; # Color picker tool
    enableDynamicTheming = true; # Wallpaper-based theming (matugen)
    enableAudioWavelength = true; # Audio visualizer (cava)
    enableSystemSound = true; # System sound effects
  };
}
