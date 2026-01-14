{pkgs, ...}: {
  programs.alvr = {
    enable = true;
    openFirewall = true;
  };
  programs.steam.remotePlay.openFirewall = true;
  environment.systemPackages = with pkgs; [wlx-overlay-s];
}
