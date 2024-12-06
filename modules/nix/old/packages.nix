{
  pkgs,
  lib,
  opts,
  ...
}: {
  environment.systemPackages = with pkgs;
    [
      btop
      ffmpeg
      exiftool
    ]
    ++ (lib.optionals opts.GUI.enable [
      kdenlive
      keepassxc
      obs-studio
      inkscape
      gimp
      blender
      thunderbird
      discord
      unstable.obsidian
      krita
      libreoffice
      gparted
      tenacity
    ]);
  unfreePackages = with pkgs; [
    discord
    obsidian
  ];
}
