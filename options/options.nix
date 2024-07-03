{
  lib,
  libx,
  ...
}:
with lib; let
  enable = option: option // {default = true;};
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
    grub = {
      enable = enable (mkEnableOption "grub");
      useEfi = mkEnableOption "grub efi support";
      efiLocation = mkOption {
        type = with types; nullOr string;
      };
    };
    GUI.enable = mkEnableOption "gui packages";
    WSL.enable = mkEnableOption "WSL";
    VM.enable = mkEnableOption "Virtual Box guest support";
    users = lib.genAttrs (libx.allFrom ../users) (user: {
      enable = mkEnableOption "${user} user";
      admin = mkEnableOption "${user} admin";
    });
  };
}
