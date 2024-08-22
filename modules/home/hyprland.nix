{
  lib,
  pkgs,
  opts,
  inputs,
  ...
}: {
  imports = [inputs.anyrun.homeManagerModules.default];
  config = lib.mkIf opts.environment.hyprland.enable {
    home.packages = with pkgs; [
      swww
    ];
    programs = {
      hyprlock = {
        enable = true;
        settings = {
          general = {
            grace = 30; # Allow unlock with mouse movement within 30 secs
          };
          input-field = [
            {
              monitor = "";
              size = "200, 50";
              placeholder_text = "'<i>Password ...</i>'";
              halign = "center";
              valign = "center";
              fade_on_empty = false;
            }
          ];
          background = [
            {
              monitor = "";
              path = "screenshot";
              blur_passes = 1;
              blur_size = 7;
              noise = 0.1;
              brightness = 0.5;
            }
          ];
        };
      };
      anyrun = {
        enable = true;
        config = {
          plugins = with inputs.anyrun.packages.${pkgs.system}; [
            applications
            rink
            shell
            symbols
          ];
          layer = "overlay";
          closeOnClick = true;
          showResultsImmediately = true;
          hidePluginInfo = false;
        };
        extraCss = ''
          #window {
            background-color: rgba(0,0,0,0.5);
          }
        '';
      };
    };
    services = {
      hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "pidof hyprlock || hyprlock";
          };

          listener = [
            {
              timeout = 150; # 2.5min.
              on-timeout = "brightnessctl -s set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
              on-resume = "brightnessctl -r"; # monitor backlight restore.
            }

            # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
            {
              timeout = 150; # 2.5min.
              on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0"; # turn off keyboard backlight.
              on-resume = "brightnessctl -rd rgb:kbd_backlight"; # turn on keyboard backlight.
            }

            {
              timeout = 300; # 5min
              on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
            }

            {
              timeout = 330; # 5.5min
              on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
              on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
            }

            {
              timeout = 1800; # 30min
              on-timeout = "systemctl suspend"; # suspend pc
            }
          ];
        };
      };
      hyprpaper = {
        enable = true;
        settings = {splash = false;};
      };
    };
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      xwayland.enable = true;
      # plugins=[];

      settings = {
        exec-once = let
          withRules = rules: command: "[${builtins.concatStringsSep ";" rules}] ${command}";
          onWorkspace = workspace: command: withRules ["workspace ${builtins.toString workspace} silent"] command;
        in [
          "hyprpaper"
          "nm-applet"
          "blueman-applet"
          "swww-daemon"
          (onWorkspace 1 "foot")
          (onWorkspace 2 "firefox")
          (onWorkspace 4 "thunderbird")
          (onWorkspace 6 "obsidian")
          (onWorkspace 9 "discord")
          (onWorkspace 0 "keepassxc")
        ];
        monitor = [
          ",preferred,auto,1"
        ];
        input = {
          kb_layout = "gb";
          follow_mouse = 1;
          touchpad = {
            natural_scroll = true;
          };
          sensitivity = 0;
        };

        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;

          layout = "dwindle";
          allow_tearing = false;
        };

        decoration = {
          rounding = 10;
          blur = {
            enabled = true;
            size = 5;
            passes = 2;
            vibrancy = 0.1696;
            brightness = 0.5;
          };
          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;
        };
        animations = {
          enabled = true;
          bezier = [
            "myBezier, 0.05, 0.9, 0.1, 1.05"
          ];
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        # master = {
        #   new_is_master = true;
        # };

        gestures = {
          workspace_swipe = true;
        };

        misc = {
          force_default_wallpaper = 0;
        };

        windowrulev2 = let
          mkRules = selector: rules: builtins.map (rule: rule + ", " + selector) rules;
          notificationRules = ["move onscreen 100% 100%" "noinitialfocus"];
        in
          [
            "suppressevent maximize, class:.*"
            # "workspace 2 silent, class:firefox"
          ]
          ++ mkRules "class:\.blueman-applet-wrapped" notificationRules
          # Place thunderbird notifications in the bottom right of the screen and don't focus it
          ++ mkRules "class:thunderbird, title:^$" notificationRules
          # Float windows that aren't the main window or email composition windows
          ++ mkRules "class:thunderbird, title:^(?!Write|Mozilla)" [
            "float"
            # "move 100% 100%"
          ];
        workspace = builtins.genList (i: "${builtins.toString (i + 1)}, persistent:true") 10;

        bind = let
          # https://github.com/Aylur/dotfiles/blob/ags-pre-ts/home-manager/hyprland.nix
          binding = mod: cmd: key: arg: "${builtins.toString mod}, ${builtins.toString key}, ${builtins.toString cmd}, ${builtins.toString arg}";
          movefocus = binding "SUPER" "movefocus";
          movewindow = binding "SUPER&CTRL" "movewindow";
          goToWorkspace = binding "SUPER" "workspace";
          moveWindowToWorkspace = binding "SUPER SHIFT" "movetoworkspace";
        in
          [
            "SUPER, F, togglefloating"
            # Move focus
            (movefocus "k" "u")
            (movefocus "j" "d")
            (movefocus "l" "r")
            (movefocus "h" "l")
            # Move app
            (movewindow "k" "u")
            (movewindow "j" "d")
            (movewindow "l" "r")
            (movewindow "h" "l")
            # Kill app
            "SUPER, escape, killactive"
            "ALT, F4, killactive"
            # Open terminal
            "SUPER, RETURN, exec, [float; center] foot"
            # Take screenshot
            ", Print, exec, grimblast copy area"
            "SHIFT SUPER, s, exec, grimblast copy area"
          ]
          ++ (builtins.genList (x: moveWindowToWorkspace (lib.mod (x + 1) 10) (x + 1)) 10)
          ++ (builtins.genList (x: goToWorkspace (lib.mod (x + 1) 10) (x + 1)) 10);
        bindm = [
          "SUPER, mouse:272, movewindow"
          "SUPER, mouse:273, resizewindow"
          # For touchpad
          "SUPER, Control_L, movewindow"
          "SUPER, Alt_L, resizewindow"
        ];
        binde = let
          binding = mod: cmd: key: arg: "${mod}, ${key}, ${cmd}, ${arg}";
          resizeactive = binding "SUPER&ALT" "resizeactive";
        in [
          # Resize app
          (resizeactive "k" "0 -20")
          (resizeactive "j" "0 20")
          (resizeactive "l" "20 0")
          (resizeactive "h" "-20 0")
        ];
        bindel = [
          # https://wiki.hyprland.org/Configuring/Binds/#media
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ", XF86MonBrightnessUp, exec, brightnessctl s +5%"
          ", XF86MonBrightnessDown, exec, brightnessctl s -n=10% 5%-"
        ];
        bindl = [
          # https://wiki.hyprland.org/Configuring/Binds/#media
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ];
        bindr = [
          # App launcher
          "SUPER, SUPER_L, exec, pkill anyrun || anyrun"
        ];
      };
    };
  };
}
