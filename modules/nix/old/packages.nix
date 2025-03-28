{
  lib,
  pkgs,
  opts,
  ...
}: {
  environment.systemPackages = with pkgs;
  with kdePackages;
    [
      # System monitor
      btop
      # Media commandline tools
      exiftool
      ffmpeg
      # Spelling
      hunspellDicts.en-gb-large
      # cmdline tools
      jq
      nix-output-monitor
    ]
    ++ (lib.optionals opts.GUI [
      # theme
      breeze
      breeze-gtk
      breeze-icons
      # disk management
      baobab
      gparted
      # Password store
      keepassxc
      # Video
      obs-studio
      kdenlive
      # key/event viewer
      wev
    ]);
  # :TODO: replace with hyprcursor
  xdg.icons.fallbackCursorThemes = lib.mkDefault ["breeze_cursors"];
  # :TODO: only apply for git?
  programs.ssh.askPassword = "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";
}
