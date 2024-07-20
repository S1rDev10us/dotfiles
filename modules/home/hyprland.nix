{
  lib,
  pkgs,
  opts,
  ...
}:
lib.mkIf opts.environment.hyprland.enable {
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
    waybar = {
      enable = true;
      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };
      settings = [
        {
          # Based on https://github.com/Alexays/Waybar/blob/44f39ca0ce53659df2c959fa9177cfe158f23273/resources/config.jsonc
          layer = "top";
          position = "top";
          spacing = 4;
          modules-left = [
            "hyprland/workspaces"
          ];
          modules-center = [
            "hyprland/window"
          ];
          modules-right = [
            "mpd"
            "idle_inhibitor"
            "pulseaudio"
            "network"
            "power-profiles-daemon"
            "cpu"
            "memory"
            "temperature"
            "backlight"
            "battery"
            "clock"
            "tray"
            "custom/power"
          ];
          "hyprland/window" = {
            # The separator is uABCD (In neovim/vim you can get it by going into insert mode then pressing "<C-v>uabcd")
            format = "{title}ꯍ{initialTitle}ꯍ{class}ꯍ{initialClass}";
            rewrite = {
              ########
              # NVIM #
              ########

              # File editor, open file
              "([^\\s]*) \\((.*)\\) - NVIMꯍ.*" = " (Viewing $2/$1)";
              "([^\\s]*) \\+ \\((.*)\\) - NVIMꯍ.*" = " (Editing $2/$1)";
              # Neotree
              "\\w*neo-tree (.*) \\[.\\] - \\((.*)\\) - NVIMꯍ.*" = " ($1: $2)";

              # "(.*) [(](.*)[)] - NVIM" = "NVIM - ($1 @ $2)";
              # Generic
              # "(.*) - NVIM" = "NVIM ($1)";
              ###########
              # Firefox #
              ###########
              "((.*) — )?Mozilla Firefoxꯍ.*" = "󰈹 $2";
              #########
              # Empty #
              #########
              "ꯍꯍꯍ" = "";
            };
          };
          "hyprland/workspaces" = {
            format = "{icon} {windows} ";
            format-icons =
              (builtins.listToAttrs (builtins.genList (x: let
                  y = x + 1;
                in {
                  name = "${builtins.toString y}";
                  value = "${builtins.toString y}  ";
                })
                10))
              // {
                "2" = "2 󰈹";
                active = "  ";
              };
            format-window-separator = " ";
            window-rewrite-default = "";
            window-rewrite = {
              "class<foot>" = "";
              "title<.*NVIM>" = "";
              "class<firefox>" = "󰈹";
              "class<obsidian>" = "";
            };
          };
          "custom/power" = {
            format = "⏻ ";
            tooltip = false;
            menu = "on-click";
            menu-file = "${
              builtins.fetchurl {
                url = "https://github.com/Alexays/Waybar/raw/44f39ca0ce53659df2c959fa9177cfe158f23273/resources/custom_modules/power_menu.xml";
                sha256 = "sha256:0yi9vrmlv721dm1a3k0i6c8a4whiqx4hpxsr1f0z6gnjrf9lgpd1";
              }
            }";
            menu-actions = {
              shutdown = "shutdown now";
              reboot = "reboot";
              suspend = "systemctl suspend";
              hibernate = "systemctl hibernate";
            };
          };
        }
      ];
    };
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      theme = "fancy";
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
      "debug:disable_logs" = false;
      exec-once = let
        bash = command: "bash \"${command}\"";
      in [
        (bash "hyprpaper &")
        (bash "waybar &")
        (bash "dunst &")
        (bash "nm-applet &")
        (bash "firefox &")
      ];
      monitor = [
        ",preferred,auto,auto"
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
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
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

      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "workspace 2, class:firefox"
      ];
      workspace = builtins.genList (i: "${builtins.toString (i + 1)}, persistent:true") 10;

      bind = let
        # https://github.com/Aylur/dotfiles/blob/ags-pre-ts/home-manager/hyprland.nix
        binding = mod: cmd: key: arg: "${builtins.toString mod}, ${builtins.toString key}, ${builtins.toString cmd}, ${builtins.toString arg}";
        movefocus = binding "SUPER" "movefocus";
        movewindow = binding "SUPER&CTRL" "movewindow";
        goToWorkspace = binding "SUPER" "workspace";
        moveWindowToWorkspace = binding "SUPER SHIFT" "movetoworkspace";
        # exec = "exec, ags -b hypr";
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
          # App switcher
          "SUPER, Tab, exec, pkill rofi || rofi -show window"
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
      ];
      bindl = [
        # https://wiki.hyprland.org/Configuring/Binds/#media
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];
      bindr = [
        # App launcher
        "SUPER, SUPER_L, exec, pkill rofi || rofi -show drun"
      ];
    };
  };
}
