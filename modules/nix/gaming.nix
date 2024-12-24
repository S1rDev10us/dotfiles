{
  config,
  lib,
  opts,
  ...
}: {
  config = lib.mkIf (opts.gaming.enable && opts.GUI.enable) {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = false;
      dedicatedServer.openFirewall = false;
    };
    programs.gamemode.enable = true;
    unfreePackages = [
      "steam"
      "steam-unwrapped"
      "steam-original"
      "steam-run"
    ];
  };
}
