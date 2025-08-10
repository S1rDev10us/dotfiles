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

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole
    /*
    xwaylandvideobridge
    */
  ];
  xdg.portal = {
    config = {
      kde.default = ["kde" "gtk" "gnome"];
      kde."org.freedesktop.portal.FileChooser" = ["kde"];
      kde."org.freedesktop.portal.OpenURI" = ["kde"];
    };

    extraPortals = with pkgs.kdePackages; [
      xdg-desktop-portal-kde
    ];
  };
}
