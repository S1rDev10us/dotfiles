{
  lib,
  libx,
  config,
  ...
}:
with lib; let
  enable = option: option // {default = true;};
in {
  options = {
    batteryManagement.enable = mkEnableOption "battery management";
    coding.enable = mkEnableOption "code editors";
    environment = {
      hyprland.enable = mkEnableOption "hyprland";
      gnome.enable = mkEnableOption "gnome";
      KDE.enable = mkEnableOption "KDE";
    };
    fun.enable = mkEnableOption "fun tools like `fastfetch`";
    gamedev.enable = mkEnableOption "game development tools";
    gaming.enable = mkEnableOption "games";
    grub = {
      enable = enable (mkEnableOption "grub");
      useEfi = mkEnableOption "grub efi support";
      windowsLocation = mkOption {
        type = types.str;
        default = "";
      };
    };
    # Automatically enables the default if one of the desktop environments (/window manager) is enabled
    GUI.enable = (mkEnableOption "gui packages") // {default = with config.environment; lib.any (x: x) [hyprland.enable gnome.enable KDE.enable];};
    stateVersion = mkOption {
      type = types.str;
      default = "23.11";
    };
    VM.enable = mkEnableOption "Virtual Box guest support";
    WSL.enable = mkEnableOption "WSL";
    users = lib.genAttrs (libx.listChildren ../users) (user: {
      enable = mkEnableOption "${user} user";
      admin = mkEnableOption "${user} admin";
    });
  };
}
