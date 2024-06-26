{
  pkgs,
  lib,
  config,
  opts,
  ...
}:
lib.mkIf (opts.GUI.enable && opts.environment.gnome.enable) {
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
}
