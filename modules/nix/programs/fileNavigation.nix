{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs;
  with kdePackages; [
    dolphin
    dolphin-plugins
    qtsvg
  ];
  xdg.icons.enable = true;
  # Automount
  services.udisks2.enable = true;
}
