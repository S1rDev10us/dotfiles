{
  userConfig,
  systemConfig,
  ...
} @ nixosInputs: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.extraSpecialArgs = {
    inherit nixosInputs;
    inherit userConfig;
    inherit systemConfig;
  };
  home-manager.sharedModules = [
    {
      /*
      The home.stateVersion option does not have a default and must be set
      */
      home.stateVersion = "23.11";
    }
  ];
}
