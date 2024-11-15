{
  pkgs,
  lib,
  opts,
  ...
}: {
  environment.systemPackages = with pkgs;
    [
      btop
      exiftool
    ]
    ++ (lib.optionals opts.GUI.enable [
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
