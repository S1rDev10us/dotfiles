{
  pkgs,
  lib,
  opts,
  ...
}: {
  environment.systemPackages = with pkgs;
    [
      btop
    ]
    ++ (lib.optionals opts.GUI.enable [
      keepassxc
      obs-studio
      inkscape
      gimp
      blender
      thunderbird
      discord
      obsidian
      krita
      libreoffice
      gparted
    ]);
  unfreePackages = with pkgs; [
    discord
    obsidian
  ];
}
