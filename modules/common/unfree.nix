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
    type = with lib.types; listOf (oneOf [package str]);
    default = [];
  };
  config = {
    nixpkgs.config.allowUnfree = lib.mkForce false;
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) processedPackages;
  };
}
