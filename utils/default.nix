{
  lib,
  libx,
  ...
} @ inputs: {
  allModulesFrom = import ./allModulesFrom.nix inputs;
  getEnabledUsers = import ./getEnabledUsers.nix inputs;
  getHomeSettings = import ./getHomeSettings.nix inputs;
  getHostSettings = import ./getHostSettings.nix inputs;
  ifExists = import ./ifExists.nix inputs;
  internal = import ./internal/default.nix inputs;
  listChildren = import ./listChildren.nix inputs;
  makeHome = import ./makeHome.nix inputs;
  makeHost = import ./makeHost.nix inputs;
  processModule = import ./processModule.nix inputs;
}
