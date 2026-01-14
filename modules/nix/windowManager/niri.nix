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

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.kdePackages.xdg-desktop-portal-kde];
  systemd.user.services.niri-flake-polkit.enable = false;
}
