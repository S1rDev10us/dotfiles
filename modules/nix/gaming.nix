{
  config,
  lib,
  opts,
  ...
}: {
  config = lib.mkIf (opts.gaming.enable && opts.GUI.enable) {
    programs.steam.enable = true;
    unfreePackages = [
      "steam"
      "steam-original"
      "steam-run"
    ];
  };
}
