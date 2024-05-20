{...} @ inputs: {
  makeHome =
    import ./makeHome.nix inputs;
  makeHost =
    import ./makeHost.nix inputs;
  ifExists = import ./ifExists.nix inputs;
  allFrom = import ./allFrom.nix inputs;
  allModulesFrom = import ./allModulesFrom.nix inputs;
}
