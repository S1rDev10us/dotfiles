{
  pkgs,
  lib,
  opts,
  ...
}:
lib.mkIf opts.environment.hyprland.enable {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  environment.systemPackages = with pkgs; [
    xwayland
    meson
    wayland-protocols
    wayland-utils
    wl-clipboard
    wlroots
    libnotify
    networkmanagerapplet
    hypridle
    brightnessctl
    grimblast
    adwaita-qt
  ];
  environment.sessionVariables = {
    QT_STYLE_OVERRIDE = "adwaita-dark";
  };
  qt.style = "adwaita-dark";
  # https://josiahalenbrown.substack.com/p/installing-nixos-with-hyprland
  fonts.packages = with pkgs; [
    meslo-lgs-nf
  ];
  fonts.fontconfig.defaultFonts = {monospace = lib.mkBefore ["JetBrainsMono NF" "Jetbrains Mono" "Fira Code"];};
  services = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    displayManager.defaultSession = lib.mkForce "hyprland-uwsm";
    blueman.enable = true;

    # Screensharing
    dbus.enable = true;
  };
  security.pam.services.hyprlock = {};
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
