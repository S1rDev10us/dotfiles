{
  stateVersion = "24.05";
  toggles = {
    unstable.enable = true;
    unfree.enable = true;
    common.enable = true;
    users.enable = true;
    old.packages.enable = true;
    programs = {
      communication.enable = true;
      direnv.enable = true;
      doas.enable = true;
      office.enable = true;
      zsa.enable = true;
      ags.enable = true;
      fileNavigation.enable = true;
      firefox.enable = true;
      neovim.enable = true;
      terminal.enable = true;
      waybar.enable = true;
    };
    services = {
      audio.enable = true;
      bluetooth.enable = true;
      keyboard.enable = true;
      printing.enable = true;
    };
    windowManager = {
      KDE.enable = true;
      hyprland.enable = true;
    };
    batteryManagement.enable = true;
    coding.enable = true;
    fun.enable = true;
    gaming.enable = true;
    grub.enable = true;
    kwallet.enable = true;
  };
  GUI = true;
  grub.useEfi = true;
  grub.windowsLocation = "F4F3-9649";
  users.s1rdev10us = {
    enable = true;
    admin = true;
  };
}
