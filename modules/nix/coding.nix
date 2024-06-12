{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.settings.coding.enable {
    environment.systemPackages = with pkgs;
      [
        alejandra
        nixd
        nil
        git
      ]
      ++ lib.optionals config.settings.GUI.enable [
        vscode
      ];
    settings.unfreePackages = lib.optionals config.settings.GUI.enable [pkgs.vscode];
  };
}
