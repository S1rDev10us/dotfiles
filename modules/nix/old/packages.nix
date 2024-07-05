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
    ]);
  unfreePackages = with pkgs; [
    discord
    obsidian
  ];
}
