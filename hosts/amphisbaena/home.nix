{
  lib,
  pkgs,
  outputs,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    # Generated using `gtf` https://old.reddit.com/r/hyprland/comments/18fb0zp/looking_for_help_with_resolution/kcypu7w/
    monitor = lib.mkBefore ["eDP-1, modeline 172.80 1920 2040 2248 2576 1080 1081 1084 1118 -hsync +vsync, 0x0, 1"];

    exec-once = lib.mkAfter [
      "[workspace 5 silent] foot -D ~/Documents/repos/pvp_spaceship_game/"
      "${outputs.packages.${pkgs.system}.audio-bar}/bin/audio-bar"
    ];
  };
  home.packages =
    [
      (pkgs.writeShellScriptBin "cls" ''
        clear
        fastfetch
      '')
      outputs.packages.${pkgs.system}.audio-bar
    ]
    ++ (with pkgs; [
      unstable.beeref
      # disk management
      baobab
      gparted
      # Password store
      keepassxc
      # Video
      obs-studio
      kdePackages.kdenlive
      # key/event viewer
      wev
      # Calculator
      kdePackages.kalgebra
      rink
      # Camera image processing
      darktable
    ]);
  xdg.desktopEntries = {
    beeref = {
      name = "Beeref";
      genericName = "Image Viewer";
      comment = "A simple reference image viewer";
      exec = "beeref %f";
      terminal = false;
      type = "Application";
      categories = ["Application" "Graphics" "Qt" "KDE"];
      icon = "${pkgs.unstable.beeref}/lib/python3.13/site-packages/beeref/assets/logo.png";
      mimeType = ["application/x-beeref"];
    };
  };
}
