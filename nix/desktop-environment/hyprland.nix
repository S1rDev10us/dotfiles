{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    xwayland = {
      hidpi = true;
      enable = true;
    };
  };
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  environment.systemPackages = with pkgs; [
    hyprland
    swww # for wallpapers
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    xwayland
    waybar
    meson
    wayland-protocols
    wayland-utils
    wl-clipboard
    wlroots
  ];
  # https://josiahalenbrown.substack.com/p/installing-nixos-with-hyprland
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      });
    })
  ];
  fonts.fonts = with pkgs; [
    nerdfonts
    meslo-lgs-nf
  ];
  # Screensharing
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
  home-module = {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      xwayland.enable = true;
      # plugins=[];

      settings = {
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

        master = {
          new_is_master = true;
        };

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
        ];
        bindel=[
          # https://wiki.hyprland.org/Configuring/Binds/#media
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ];
        bindl=[
          # https://wiki.hyprland.org/Configuring/Binds/#media
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ];
      };
    };
  };
}
