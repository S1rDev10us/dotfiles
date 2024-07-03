{
  pkgs,
  lib,
  config,
  opts,
  ...
}:
lib.mkIf (opts.GUI.enable && opts.environment.gnome.enable) {
  services.xserver = {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME desktop environment
    desktopManager = {
      gnome.enable = true;
      gdm.enable = true;
    };
  };

  # Gnome specific packages
  environment.systemPackages =
    (with pkgs; [
      gnome.gnome-tweaks
      gnome.dconf-editor
      gnome-extension-manager
    ])
    ++ (with pkgs.gnomeExtensions; [
      paperwm
      dash-to-panel
      blur-my-shell
      appindicator
      extension-list
    ]);

  # Remove undesired gnome packages
  environment.gnome.excludePackages =
    (with pkgs; [
      #gnome-photos
      gnome-tour
    ])
    ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      #gnome-terminal
      #gedit # text editor
      epiphany # web browser
      geary # email reader
      evince # document viewer
      #gnome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);
}
