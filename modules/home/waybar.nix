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
      }
    ];
  };
}
