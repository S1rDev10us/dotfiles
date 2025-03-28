{
  lib,
  opts,
  pkgs,
  ...
}: {
  services = {
    displayManager.sddm.enable = true;
    desktopManager.plasma6.enable = true;
  };
  environment.plasma6.excludePackages = with pkgs.kdePackages; [konsole xwaylandvideobridge];
}
