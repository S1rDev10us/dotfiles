{
  lib,
  opts,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; (lib.optionals opts.GUI [
    discord
    signal-desktop
    # TODO: Replace this with programs.thunderbird
    thunderbird
  ]);
  unfreePackages = with pkgs; [
    discord
  ];
}
