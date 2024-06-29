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
    unfreePackages = [
      "steam"
      "steam-original"
      "steam-run"
    ];
  };
}
