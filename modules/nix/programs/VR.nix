{lib, ...}: {
  programs.alvr = {
    enable = true;
    openFirewall = true;
  };
}
