{
  pkgs,
  opts,
  lib,
  ...
}: {
  home.packages = with pkgs;
    [
      (pkgs.writeShellScriptBin "cls" ''
        clear
        fastfetch
      '')
      wl-clipboard
      libnotify
    ]
    ++ (lib.optionals opts.GUI [
      unstable.beeref
      brightnessctl
      element-desktop
      # disk management
      baobab
      gparted
      # Password store
      keepassxc
      # Video
      obs-studio
      kdePackages.kdenlive
      vlc
      # key/event viewer
      wev
      # Calculator
      kdePackages.kalgebra
      rink
      # Timer
      gnome-clocks
      # Camera image processing
      darktable
      # 3d printing
      orca-slicer
      # kindle
      calibre
    ]);
}
