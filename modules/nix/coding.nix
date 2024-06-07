{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.settings.coding.enable {
    environment.systemPackages =
      []
      ++ lib.optionals config.settings.GUI.enable (with pkgs; [
        alejandra
        nixd
        nil
        vscode
        git
      ]);
    settings.unfreePackages = lib.optionals config.settings.GUI.enable [pkgs.vscode];
  };
}
