{
  lib,
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs;
    lib.optionals config.settings.fun.enable ([
        fastfetch
      ]
      ++ (lib.optionals config.settings.GUI.enable [
        ]));
}
