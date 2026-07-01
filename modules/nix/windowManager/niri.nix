{
  lib,
  pkgs,
  ...
}: {
  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  services.gnome.gnome-keyring.enable = false;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;

    config.niri = lib.mkForce {
      default = ["kde" "gtk" "gnome"];
      "org.freedesktop.impl.portal.Access" = "gtk";
      "org.freedesktop.impl.portal.Notification" = "gtk";
      "org.freedesktop.impl.portal.Secret" = "kwallet";
      "org.freedesktop.impl.portal.ScreenCast" = "gnome";
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      kdePackages.kwallet
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gnome
    ];
    configPackages = with pkgs; [kdePackages.xdg-desktop-portal-kde];
  };
  systemd.user.services.niri-flake-polkit.enable = false;
}
