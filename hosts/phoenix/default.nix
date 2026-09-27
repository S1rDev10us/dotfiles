{
  stateVersion = "25.11";
  toggles = {
    fonts.enable = true;
    unstable.enable = true;
    unfree.enable = true;
    permittedInsecurePackages.enable = true;
    common.enable = true;
    users.enable = true;
    programs = {
      art.enable = true;
      audioProduction.enable = true;
      communication.enable = true;
      direnv.enable = true;
      doas.enable = true;
      fileNavigation.enable = true;
      firefox.enable = true;
      helix.enable = true;
      office.enable = true;
      open-preset-apps = {
        enable = true;
        apps-to-run = [
          "firefox"
          "thunderbird"
          "discord"
          "obsidian"
          # "super-productivity"
        ];
        spawn-app = app: "niri msg action spawn -- ${app}";
      };
      terminal.enable = true;
      VR.enable = true;
      zsa.enable = true;
      miscDesktop.enable = true;
    };
    services = {
      audio.enable = true;
      backups.enable = true;
      homelab-client.enable = true;
      keyboard.enable = true;
      printing.enable = true;
      ssh.enable = true;
    };
    windowManager = {
      KDE.enable = true;
      niri.enable = true;
    };
    coding.enable = true;
    fun.enable = true;
    gaming = {
      enable = true;
      minecraft.enable = true;
    };
    kwallet.enable = true;
  };
  GUI = true;
  users.s1rdev10us = {
    enable = true;
    admin = true;
  };
}
