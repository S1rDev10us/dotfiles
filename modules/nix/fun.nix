{
  lib,
  config,
  pkgs,
  opts,
  ...
}: {
  environment.systemPackages = with pkgs;
    lib.optionals opts.fun.enable ([
      ]
      ++ (lib.optionals opts.GUI.enable [
        ]));
}
