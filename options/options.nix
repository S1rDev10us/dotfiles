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
    architecture = mkOption {
      type = lib.types.string;
      default = "x86_64-linux";
    };
    GUI = mkEnableOption "GUI";
    environment = {
    };
    grub = {
      useEfi = mkEnableOption "grub efi support";
      windowsLocation = mkOption {
        type = types.str;
        default = "";
      };
    };
    # Automatically enables the default if one of the desktop environments (/window manager) is enabled
    stateVersion = mkOption {
      type = types.str;
      default = "23.11";
    };
    users = lib.genAttrs (libx.listChildren ../users) (user: {
      enable = mkEnableOption "${user} user";
      admin = mkEnableOption "${user} admin";
    });
  };
}
