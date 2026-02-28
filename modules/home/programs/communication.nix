{
  lib,
  opts,
  pkgs,
  ...
}: {
  home.packages = with pkgs; (lib.optionals opts.GUI [
    discord
    signal-desktop
    element-desktop
    # TODO: Replace this with programs.thunderbird
    thunderbird
  ]);
  unfreePackages = with pkgs; [
    discord
  ];
}
