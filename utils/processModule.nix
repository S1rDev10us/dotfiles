{
  lib,
  libx,
  ...
}:
# /modules/nix
# /modules/home
# /modules/common
basePath:
# /modules/nix/windowManager/hyprland.nix
path: let
  # Convert the file to an option path
  relativePath = lib.removePrefix "./" (lib.path.removePrefix basePath path);
  relativePathWithoutExtension = lib.removeSuffix ".nix" relativePath;
  componentsWithDefault = builtins.filter (x: !builtins.isList x) (builtins.split "/" relativePathWithoutExtension);
  fileName = lib.last componentsWithDefault;

  isDefault = fileName == "default";

  components =
    if isDefault
    then lib.lists.init componentsWithDefault
    else componentsWithDefault;
in {
  enablePath = components;
  module = {pkgs, ...} @ inputs: let
    fileContents = import path;
    fileIsFunction = builtins.isFunction fileContents;
    calledModule =
      if fileIsFunction
      then (fileContents inputs)
      else fileContents;
    filteredModule = lib.removeAttrs calledModule ["useOpts"];

    useOpts = calledModule.useOpts or false;
    configSource =
      if useOpts
      then inputs.opts
      else inputs.config;

    moduleEnabled = libx.internal.moduleShouldBeEnabled components configSource;

    unifiedModule = lib.unifyModuleSyntax path relativePath filteredModule;
    config = lib.mkIf moduleEnabled unifiedModule.config;
  in
    unifiedModule // {inherit config;};
}
