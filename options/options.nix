{lib, ...}:
with lib; {
  options.settings = {
    coding.enable = mkEnableOption "code editors";
    environment = {
      hyprland.enable = mkEnableOption "hyprland";
      gnome.enable = mkEnableOption "gnome";
    };
    fun.enable = mkEnableOption "fun tools like `eDex-ui`";
    gamedev.enable = mkEnableOption "game development tools";
    gaming.enable = mkEnableOption "games";
    GUI.enable = mkEnableOption "gui packages";
    WSL.enable = mkEnableOption "WSL";
    unfreePackages = mkOption {
      type = lib.types.listOf lib.types.package;
    };
  };
}
