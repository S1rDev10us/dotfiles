{
  lib,
  opts,
  ...
}:
lib.mkIf opts.environment.hyprland.enable {
  programs.waybar = {
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
          # "hyprland/workspaces" # replaced by ags
        ];
        modules-center = [
          "hyprland/window"
        ];
        modules-right = [
          "idle_inhibitor"
          "pulseaudio"
          "cpu"
          "memory"
          "backlight"
        ];
        "hyprland/window" = {
          # The separator is uABCD (In neovim/vim you can get it by going into insert mode then pressing "<C-v>uabcd")
          format = "{title}ꯍ{initialTitle}ꯍ{class}ꯍ{initialClass}";
          rewrite = {
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
}
