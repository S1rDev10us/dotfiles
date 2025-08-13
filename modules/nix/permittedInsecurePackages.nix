{
  config,
  lib,
  ...
}: {
  options.permittedInsecurePackages = lib.mkOption {
    type = with lib.types; listOf (oneOf [package str]);
    default = [];
  };
  config.nixpkgs.config.permittedInsecurePackages = config.permittedInsecurePackages;
}
