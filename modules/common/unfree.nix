{
  config,
  lib,
  ...
}: {
  options.unfreePackages = lib.mkOption {
    type = with lib.types; listOf (oneOf [package str (functionTo bool)]);
    default = [];
  };
  config = {
    nixpkgs.config.allowUnfree = lib.mkForce false;
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.any (allowedPkg:
        if builtins.isString allowedPkg
        then (lib.getName pkg) == allowedPkg
        else if lib.isFunction allowedPkg
        then allowedPkg pkg
        else (lib.getName pkg) == (lib.getName allowedPkg))
      config.unfreePackages;
  };
}
