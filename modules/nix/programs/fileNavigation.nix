{
  pkgs,
  config,
  ...
}: {
  xdg.icons.enable = true;
  # Automount
  services.udisks2.enable = true;
  # Trash, ... support in thunar

  environment.systemPackages = with pkgs.kdePackages; [
    dolphin
    baloo-widgets # baloo information in Dolphin
    dolphin-plugins
  ];
  # Fix Dolphin file associations on non-Plasma desktop environments
  # https://github.com/NixOS/nixpkgs/issues/409986
  environment.etc."xdg/menus/applications.menu".source = "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
}
