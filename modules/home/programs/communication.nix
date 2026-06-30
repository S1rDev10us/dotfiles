{
  lib,
  opts,
  pkgs,
  ...
}: {
  home.packages = with pkgs; (lib.optionals opts.GUI [
    discord
    # TODO: re-add when electron version is not marked insecure
    # signal-desktop
    element-desktop
    # TODO: Replace this with programs.thunderbird
    thunderbird
  ]);
  unfreePackages = with pkgs; [
    discord
  ];
}
