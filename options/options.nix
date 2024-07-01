{
  lib,
  libx,
  ...
}:
with lib; let
  mkEnabledEnableOption = name: (mkEnableOption name) // {default = true;};
in {
  options = {
    stateVersion = mkOption {
      type = types.str;
      default = "23.11";
    };
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
    VM.enable = mkEnableOption "Virtual Box guest support";
    users = lib.genAttrs (libx.allFrom ../users) (user: {
      enable = mkEnableOption "${user} user";
      admin = mkEnableOption "${user} admin";
    });
  };
}
