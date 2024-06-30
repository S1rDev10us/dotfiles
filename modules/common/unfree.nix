{
  config,
  lib,
  ...
}: let
  processedPackages =
    builtins.map
    (pkg:
      if builtins.isString pkg
      then pkg
      else lib.getName pkg)
    config.unfreePackages;
in {
  options.unfreePackages = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [];
  };
  config = {
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) processedPackages;
  };
}
