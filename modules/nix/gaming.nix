{
  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = false;
  };
  programs.gamemode.enable = true;
  unfreePackages = [
    "steam"
    "steam-unwrapped"
    "steam-original"
    "steam-run"
  ];
}
