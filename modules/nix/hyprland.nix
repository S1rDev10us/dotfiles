{
  pkgs,
  lib,
  config,
  opts,
  ...
}:
lib.mkIf opts.environment.hyprland.enable {
  programs.hyprland = {
    enable = true;
    xwayland = {
      # hidpi = true; #  XWayland patches are deprecated https://wiki.hyprland.org/Configuring/XWayland

      enable = true;
    };
  };
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  environment.systemPackages = with pkgs; [
    hyprland
    swww # for wallpapers
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    xwayland
    waybar
    meson
    wayland-protocols
    wayland-utils
    wl-clipboard
    wlroots
  ];
  # https://josiahalenbrown.substack.com/p/installing-nixos-with-hyprland
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      });
    })
  ];
  fonts.packages = with pkgs; [
    nerdfonts
    meslo-lgs-nf
  ];
  # Screensharing
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
