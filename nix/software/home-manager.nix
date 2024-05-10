{
  userConfig,
  systemConfig,
  config,
  lib,
  ...
} @ nixosInputs: {
  options.home-module = lib.mkOption {
    type = lib.types.anything;
    default = {};
  };
  config = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit nixosInputs;
        inherit userConfig;
        inherit systemConfig;
      };
      sharedModules = [
        {
          /*
          The home.stateVersion option does not have a default and must be set
          */
          home.stateVersion = "23.11";
        }
        config.home-module
      ];
    };
  };
}
