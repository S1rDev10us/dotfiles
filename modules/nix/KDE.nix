{
  lib,
  opts,
  pkgs,
  ...
}:
lib.mkIf (opts.environment.KDE.enable && opts.GUI.enable) {
  services = {
    # This lets you use x11 as an escape hatch if wayland isn't working for some reason
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
  };
  environment.plasma6.excludePackages = with pkgs.kdePackages; [konsole xwaylandvideobridge];
}
