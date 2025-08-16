inputs: {
  allProcessedModules = import ./allProcessedModules.nix inputs;
  getModules = import ./getModules.nix inputs;
  moduleShouldBeEnabled = import ./moduleShouldBeEnabled.nix inputs;
  pathListToOption = import ./pathListToOption.nix inputs;
  unifyModuleSyntax = import ./unifyModuleSyntax.nix inputs;
}
