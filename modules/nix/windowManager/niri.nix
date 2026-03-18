{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.niri.nixosModules.niri
  ];
  niri-flake.cache.enable = false;
  programs.niri = {
    enable = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
    configPackages = with pkgs; [kdePackages.xdg-desktop-portal-kde];
  };
  systemd.user.services.niri-flake-polkit.enable = false;
}
