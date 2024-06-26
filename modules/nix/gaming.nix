{
  config,
  lib,
  opts,
  ...
}: {
  config = lib.mkIf (opts.gaming.enable) {
    programs.steam.enable = true;
    unfreePackages = [
      "steam"
      "steam-original"
      "steam-run"
    ];
  };
}
