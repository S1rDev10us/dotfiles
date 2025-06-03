{
  pkgs,
  config,
  ...
}: {
  programs.thunar.enable = true;
  xdg.icons.enable = true;
  # Automount
  services.udisks2.enable = true;
  # Trash, ... support in thunar
  services.gvfs.enable = true;
}
