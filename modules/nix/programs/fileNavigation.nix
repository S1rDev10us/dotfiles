{
  pkgs,
  config,
  ...
}: {
  xdg.icons.enable = true;
  # Automount
  services.udisks2.enable = true;
  # Trash, ... support in thunar
}
