{
  lib,
  pkgs,
  opts,
  ...
}: {
  environment.systemPackages = with pkgs;
    [
      btop
      ffmpeg
      exiftool
      jq
      nix-output-monitor
      hunspellDicts.en-gb-large
    ]
    ++ (lib.optionals opts.GUI.enable [
      wev
      kdenlive
      keepassxc
      obs-studio
      inkscape
      gimp
      blender
      thunderbird # TODO: Replace this with programs.thunderbird
      discord
      unstable.obsidian
      krita
      libreoffice
      gparted
      tenacity
      super-productivity
      signal-desktop
    ]);
  unfreePackages = with pkgs; [
    discord
    obsidian
  ];
}
