{
  stateVersion = "25.05";
  toggles = {
    fonts.enable = true;
    unstable.enable = true;
    unfree.enable = true;
    permittedInsecurePackages.enable = true;
    common.enable = true;
    users.enable = true;
    old.packages.enable = true;
    programs = {
      art.enable = true;
      communication.enable = true;
      direnv.enable = true;
      doas.enable = true;
      fileNavigation.enable = true;
      firefox.enable = true;
      helix.enable = true;
      office.enable = true;
      terminal.enable = true;
      VR.enable = true;
      waybar.enable = true;
      zsa.enable = true;
      miscDesktop.enable = true;
    };
    services = {
      audio.enable = true;
      bluetooth.enable = true;
      homelab-client.enable = true;
      keyboard.enable = true;
      printing.enable = true;
      ssh.enable = true;
    };
    windowManager = {
      KDE.enable = true;
    };
    coding.enable = true;
    fun.enable = true;
    gaming.enable = true;
    kwallet.enable = true;
  };
  GUI = true;
  users.s1rdev10us = {
    enable = true;
    admin = true;
  };
}
