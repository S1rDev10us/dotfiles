{
  config,
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
          label = [
            {
              monitor = "";
              text_align = "center";
              halign = "center";
              valign = "center";
              text = "$LAYOUT";
              position = "0, -75";
              font_size = "12";
            }
            {
              monitor = "";
              text_align = "center";
              halign = "center";
              valign = "center";
              text = "$USER";
              position = "0, 25";
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
          ignoreExclusiveZones = true;
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
      mako = {
        enable = true;
        defaultTimeout = 30 * 1000;
      };
      hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "hyprlock";
            unlock_cmd = "pkill hyprlock";
          };

          listener = let
            minute = 60;
          in [
            {
              timeout = 2.5 * minute;
              on-timeout = "${pkgs.brightnessctl} -s set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
              on-resume = "${pkgs.brightnessctl} -r"; # monitor backlight restore.
            }

            # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
            {
              timeout = 2.5 * minute;
              on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0"; # turn off keyboard backlight.
              on-resume = "brightnessctl -rd rgb:kbd_backlight"; # turn on keyboard backlight.
            }

            {
              timeout = 5 * minute;
              on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
            }

            {
              timeout = 5.5 * minute;
              on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
              on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
            }

            {
              timeout = 30 * minute;
              on-timeout = "systemctl suspend"; # suspend pc
            }
          ];
        };
      };
      hyprpaper = {
        enable = false;
        settings = {splash = false;};
      };
    };
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      # plugins=[];

      settings = {
        exec-once = let
          withRules = rules: command: "[${builtins.concatStringsSep ";" rules}] ${command}";
          onWorkspaceWithRules = rules: workspace: command: withRules (["workspace ${builtins.toString workspace} silent"] ++ rules) command;
          onWorkspace = workspace: command: onWorkspaceWithRules [] workspace command;
          workspaces = {
            web = 2;
            notes = 4;
            communications = 9;
            passwords = 10;
          };
        in [
          "mako"
          "nm-applet"
          "blueman-applet"
          "swww-daemon"
          (onWorkspace workspaces.web "firefox")
          (onWorkspace workspaces.notes "obsidian")
          (onWorkspace workspaces.communications "thunderbird")
          (onWorkspace workspaces.communications "discord")
          (onWorkspace workspaces.communications "firefox -P comms --name 'firefox-comms'")
          # Starts in light mode if it spawns too quickly?
          (onWorkspace workspaces.passwords "sleep 5 && keepassxc")
        ];
        monitor = [
          ",preferred,auto,1"
        ];
        input = {
          kb_layout = "gb,gb";
          kb_variant = ",colemak";
          kb_options = "grp:win_space_toggle";
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
          inactive_opacity = 0.75;
          fullscreen_opacity = 1;
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(6a6a6aee)";
            color_inactive = "0xee1a1a1a";
          };
          blur = {
            enabled = true;
            size = 5;
            passes = 2;
            vibrancy = 0.1696;
            brightness = 0.5;
          };
        };
        animations = {
          enabled = true;
          bezier = [
            "myBezier, 0.05, 0.9, 0.1, 1.05"
            "easeOutBack, 0.34, 1.56, 0.64, 1"
          ];
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, easeOutBack, slide"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        gestures = {
          workspace_swipe = true;
          workspace_swipe_fingers = 4;
        };

        misc = {
          animate_manual_resizes = true;
          animate_mouse_windowdragging = true;
          force_default_wallpaper = 0;
          focus_on_activate = true;
          new_window_takes_over_fullscreen = 2;
          font_family = "JetbrainsMono NF";
        };

        windowrulev2 = let
          mkRules = selector: rules: builtins.map (rule: rule + ", " + selector) rules;
          notificationRules = ["move onscreen 100% 100%" "noinitialfocus"];
          onWorkspace = workspace: selector: "workspace ${builtins.toString workspace} silent,${selector}";
        in
          [
            "suppressevent maximize, class:.*"
            (onWorkspace 2 "class:^firefox$")
            (onWorkspace 9 "class:thunderbird")
            (onWorkspace 9 "class:discord")
            (onWorkspace 10 "initialClass:keepassxc")
          ]
          ++ mkRules "class:\\.blueman-applet-wrapped" notificationRules
          # Place thunderbird notifications in the bottom right of the screen and don't focus it
          ++ mkRules "class:thunderbird, title:^$" notificationRules
          # Float windows that aren't the main window or email composition windows
          ++ mkRules "class:thunderbird, title:^(?!Write|Mozilla)" [
            "float"
            # "move 100% 100%"
          ];
        layerrule = let
          barSelector = "bar\\d+";
          mkRules = selector: rules: builtins.map (rule: rule + ", " + selector) rules;
        in
          ["noanim, ${barSelector}" "noanim, notifications"]
          # Unfortunately, this is not currently implemented in the version but it will be when I update hyprland or use the flake version
          ++ lib.optional (lib.versionAtLeast config.wayland.windowManager.hyprland.package.version "0.43.0") "order -1000, ${barSelector}";
        workspace = builtins.genList (i: "${builtins.toString (i + 1)}, persistent:true") 10;

        bind = let
          # https://github.com/Aylur/dotfiles/blob/ags-pre-ts/home-manager/hyprland.nix
          binding = mod: cmd: key: arg: "${builtins.toString mod}, ${builtins.toString key}, ${builtins.toString cmd}, ${builtins.toString arg}";
          movefocus = binding "SUPER" "movefocus";
          movewindow = binding "SUPER&CTRL" "movewindow";
          goToWorkspace = binding "SUPER" "workspace";
          moveWindowToWorkspace = binding "SUPER SHIFT" "movetoworkspace";
          directionMapping = [["h" "l"] ["j" "d"] ["k" "u"] ["l" "r"]];
          /*
            *
            Calls the passed in function on every direction, passing in the key and then the direction it represents
          ```
          fromDirections :: (key -> dir -> val) -> [val, val, val, val]
          ```
          */
          fromDirections = f: builtins.map (val: f (builtins.head val) (lib.last val)) directionMapping;
        in
          lib.flatten (
            [
              "SUPER, T, layoutmsg, togglesplit"
              "SUPER, S, layoutmsg, swapsplit"
              "SUPER, P, pseudo"
              "SUPER, F, togglefloating"
              # Send notification when changing keyboard layout (to colemak and back)
              "SUPER, space, exec, notify-send switch-layout"
              # Move focus
              (fromDirections movefocus)
              # Move app
              (fromDirections movewindow)
              # Kill app
              "SUPER, escape, killactive"
              "ALT, F4, killactive"
              # Open terminal
              "SUPER, RETURN, exec, [float; center] foot"
              # Take screenshot
              ", Print, exec, grimblast copy area"
              "SHIFT, Print, exec, XDG_SCREENSHOTS_DIR=~/Pictures/Screenshots grimblast copysave area"
              "SHIFT SUPER, s, exec, grimblast copy area"
              "SHIFT SUPER, l, exec, hyprlock --immediate"
            ]
            ++ (builtins.genList (x: moveWindowToWorkspace (lib.mod (x + 1) 10) (x + 1)) 10)
            ++ (builtins.genList (x: goToWorkspace (lib.mod (x + 1) 10) (x + 1)) 10)
          );

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
          ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise --max-volume 120"
          ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower --max-volume 120"
          ", XF86MonBrightnessUp, exec, swayosd-client --brightness +10"
          ", XF86MonBrightnessDown, exec, swayosd-client --brightness -10"
        ];

        bindl = [
          # https://wiki.hyprland.org/Configuring/Binds/#media
          ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
          ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
          ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
          ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
          ", switch:Lid Switch, exec, hyprlock --immediate"
        ];

        bindr = [
          # App launcher
          "SUPER, SUPER_L, exec, pkill anyrun || anyrun"
        ];
      };
    };
    systemd.user.services.hyprland-polkit-agent = {
      Unit = {
        PartOf = ["hyprland-session.target"];
      };
      Service = {
        ExecStart = "${pkgs.pantheon.pantheon-agent-polkit}/libexec/policykit-1-pantheon/io.elementary.desktop.agent-polkit";
        # Restart = "on-failure";
        Restart = "always";
        # BusName = "org.freedesktop.PolicyKit1.Authority";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
      Install.WantedBy = ["hyprland-session.target"];
    };
    services.swayosd = {
      enable = true;
      topMargin = 0.8;
    };
    systemd.user.services.swayosd.Install.WantedBy = lib.mkForce ["hyprland-session.target"];
  };
}
