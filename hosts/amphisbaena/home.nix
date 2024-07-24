{lib, ...}: {
  # Generated using `gtf` https://old.reddit.com/r/hyprland/comments/18fb0zp/looking_for_help_with_resolution/kcypu7w/
  wayland.windowManager.hyprland.settings.monitor = lib.mkBefore ["eDP-1, modeline 172.80 1920 2040 2248 2576 1080 1081 1084 1118 -hsync +vsync, 0x0, 1"];
}
