{pkgs, ...}: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME desktop environment
  services.xserver.desktopManager.gnome.enable = true;

  # Gnome specific packages
  environment.systemPackages =
    (with pkgs; [
      gnome.gnome-tweaks
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

  ################
  # Home Manager #
  ################
  home-module = {
    dconf = {
      enable = true;
      settings = {
        # Dark mode
        "org/gnome/desktop/interface".color-scheme = "prefer-dark";

        # Screen lock
        "org/gnome/desktop/session".idle-delay = 300;
        "org/gnome/desktop/screensaver".lock-enabled = true;
        "org/gnome/desktop/screensaver".lock-delay = 1800;
        "org/gnome/desktop/notifications".show-in-lock-screen = true;

        # Disable autorun
        "org/gnome/desktop/media-handling".autorun-never = true;

        # Show battery number
        "org/gnome/desktop/interface".show-battery-percentage = true;

        # Edge tiling
        "org/gnome/mutter".edge-tiling = false;

        # Hot corners
        "org/gnome/desktop/interface".enable-hot-corners = true;

        # Scroll method
        "org/gnome/desktop/peripherals/mouse".natural-scroll = false;

        # Dynamic workspaces
        "org/gnome/mutter".dynamic-workspaces = true;

        # Enabled gnome extensions
        "org/gnome/shell".enabled-extensions = [
          "extension-list@tu.berry"
          "appindicatorsupport@rgcjonas.gmail.com"
          "blur-my-shell@aunetx"
          "dash-to-panel@jderose9.github.com"
          "paperwm@paperwm.github.com"
          "drive-menu@gnome-shell-extensions.gcampax.github.com"
        ];

        # Gnome tweaks config
        "org/gnome/desktop/wm/preferences".button-layout = "appmenu:minimize,maximize,close";

        # Dash to panel settings
        "org/gnome/shell/extensions/dash-to-panel".dot-style-focused = "SEGMENTED";
        "org/gnome/shell/extensions/dash-to-panel".dot-style-unfocused = "DOTS";
      };
    };
  };
}
