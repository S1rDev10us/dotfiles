{lib, ...}: {
  programs.alvr = {
    enable = true;
    openFirewall = true;
  };
  programs.steam.remotePlay.openFirewall = true;
}
