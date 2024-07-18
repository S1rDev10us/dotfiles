{
  pkgs,
  lib,
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
  environment.systemPackages = with pkgs; [
    # swww # for wallpapers (using hyprpaper for now)
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    xwayland
    waybar
    meson
    wayland-protocols
    wayland-utils
    wl-clipboard
    wlroots
    libnotify
    networkmanagerapplet
    hypridle
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
  fonts.fontconfig.defaultFonts = {monospace = lib.mkBefore ["JetBrainsMono NF" "Jetbrains Mono" "Fira Code"];};
  services = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
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
