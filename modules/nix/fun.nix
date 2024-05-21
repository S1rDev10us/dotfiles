{
  lib,
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs;
    lib.optionals config.settings.fun.enable ([
      ]
      ++ (lib.optionals config.settings.GUI.enable [
        ]));
}
