{
  lib,
  pkgs,
  opts,
  ...
}:
lib.mkIf opts.environment.hyprland.enable {
  programs = {
    hyprlock.enable = true;
    waybar.enable = true;
    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      theme = "sidebar-v2";
    };
  };
  # Been getting an error where this is set to a missing attribute
  # Stopped that value being
  systemd.user.services.hypridle.Unit.X-Restart-Triggers = lib.mkForce [];
  services = {
    hypridle = {
      enable = true;
      # settings = {
      #   general = {
      #     lock_cmd = "pidof hyprlock || hyprlock";
      #   };
      #
      #   listener = [
      #     {
      #       timeout = 150; # 2.5min.
      #       on-timeout = "brightnessctl -s set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
      #       on-resume = "brightnessctl -r"; # monitor backlight restore.
      #     }
      #
      #     # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
      #     {
      #       timeout = 150; # 2.5min.
      #       on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0"; # turn off keyboard backlight.
      #       on-resume = "brightnessctl -rd rgb:kbd_backlight"; # turn on keyboard backlight.
      #     }
      #
      #     {
      #       timeout = 300; # 5min
      #       on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
      #     }
      #
      #     {
      #       timeout = 330; # 5.5min
      #       on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
      #       on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
      #     }
      #
      #     {
      #       timeout = 1800; # 30min
      #       on-timeout = "systemctl suspend"; # suspend pc
      #     }
      #   ];
      # };
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
      exec-once = ["waybar"];
      monitor = [
        ",preferred,auto,auto"
      ];
      input = {
        kb_layout = "gb";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = false;
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
      ];

      bind = let
        # https://github.com/Aylur/dotfiles/blob/ags-pre-ts/home-manager/hyprland.nix
        binding = mod: cmd: key: arg: "${mod}, ${key}, ${cmd}, ${arg}";
        movefocus = binding "SUPER" "movefocus";
        moveactive = binding "SUPER ALT" "moveactive";
        goToWorkspace = binding "SUPER" "workspace";
        movewindowtoworkspace = binding "SUPER SHIFT" "movetoworkspace";
        exec = "exec, ags -b hypr";
      in [
        "SUPER, F, togglefloating"

        (movefocus "k" "u")
        (movefocus "j" "d")
        (movefocus "l" "r")
        (movefocus "h" "l")

        (moveactive "k" "u")
        (moveactive "j" "d")
        (moveactive "l" "r")
        (moveactive "h" "l")
        "SUPER, Tab, exec, rofi -show window"
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
        # Launcher
        "SUPER, SUPER_L, exec, rofi -show drun"
      ];
    };
  };
}
