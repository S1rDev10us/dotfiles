{
  config,
  lib,
  ...
}: let
  processedPackages = builtins.map (pkg:
    if builtins.isString pkg
    then pkg
    else lib.getName pkg)
  config.settings.unfreePackages;
in {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) processedPackages;
}
