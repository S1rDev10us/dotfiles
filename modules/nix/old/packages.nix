{
  pkgs,
  lib,
  opts,
  ...
}: {
  environment.systemPackages = with pkgs;
    [
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
    ]);
  unfreePackages = with pkgs; [
    discord
    obsidian
  ];
}
