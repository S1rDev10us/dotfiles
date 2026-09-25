{
  lib,
  pkgs,
  opts,
  outputs,
  ...
}: {
  environment.systemPackages = with pkgs;
  with kdePackages;
    [
      # System monitor
      btop
      # Don't use once rebuild command is rebuilt
      outputs.packages.${pkgs.stdenv.hostPlatform.system}.isolate_command
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
    ]);
  # :TODO: replace with hyprcursor
  xdg.icons.fallbackCursorThemes = lib.mkDefault ["breeze_cursors"];

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
  };
}
