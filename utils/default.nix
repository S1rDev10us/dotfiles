{...} @ inputs: {
  makeHome =
    import ./makeHome.nix inputs;
  makeHost =
    import ./makeHost.nix inputs;
  ifExists = import ./ifExists.nix inputs;
  allFrom = import ./allFrom.nix inputs;
  allModulesFrom = import ./allModulesFrom.nix inputs;
  getHomeSettings = import ./getHomeSettings.nix inputs;
  getHostSettings = import ./getHostSettings.nix inputs;
  getEnabledUsers = import ./getEnabledUsers.nix inputs;
}
