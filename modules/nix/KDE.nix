{
  lib,
  opts,
  ...
}:
lib.mkIf (opts.environment.KDE.enable && opts.GUI.enable) {
  # This lets you use x11 as an escape hatch if wayland isn't working for some reason
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
}
