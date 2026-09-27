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
      type = lib.types.singleLineStr;
      default = "x86_64-linux";
    };
    environment = {
    };
    grub = {
      useEfi = mkEnableOption "grub efi support";
      windowsLocation = mkOption {
        type = types.str;
        default = "";
      };
    };
    GUI = mkEnableOption "GUI";
    stateVersion = mkOption {
      type = types.str;
      default = "23.11";
    };
    toggles.programs.open-preset-apps = {
      apps-to-run = mkOption {
        type = types.listOf types.str;
        default = [];
      };
      spawn-app = mkOption {
        type = types.functionTo types.str;
      };
    };
    users = lib.genAttrs (libx.listChildren ../users) (user: {
      enable = mkEnableOption "${user} user";
      admin = mkEnableOption "${user} admin";
    });
  };
}
