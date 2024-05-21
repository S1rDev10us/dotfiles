{
  config,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.any (newpkg:
      if builtins.isString newpkg
      then (lib.getName pkg) == newpkg
      else newpkg == pkg) (config.settings.unfreePackages);
}
