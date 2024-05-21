{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.settings.gaming.enable) {
    programs.steam.enable = true;
    settings.unfreePackages = [
      "steam"
      "steam-original"
      "steam-run"
    ];
  };
}
