{lib, ...}:
with lib; {
  options.settings = {
    coding = mkEnableOption "code editors";
    environment = {
      hyprland = mkEnableOption "hyprland";
      gnome = mkEnableOption "gnome";
    };
    fun = mkEnableOption "fun tools like `eDex-ui`";
    gamedev = mkEnableOption "game development tools";
    gaming = mkEnableOption "games";
    GUI = mkEnableOption "gui packages";
    WSL = mkEnableOption "WSL";
    unfreePackages = mkOption {
      type = lib.types.listOf lib.types.package;
    };
  };
}
