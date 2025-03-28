{
  lib,
  libx,
  ...
}: let
  options = libx.allModulesFrom ../../options;

  processedHostModules = libx.internal.allProcessedModules ../../modules/nix;
  processedHomeModules = libx.internal.allProcessedModules ../../modules/home;
  processedCommonModules = libx.internal.allProcessedModules ../../modules/common;

  hostModules = lib.map (module: module.module) processedHostModules;
  homeModules = lib.map (module: module.module) processedHomeModules;
  commonModules = lib.map (module: module.module) processedCommonModules;

  allModules = processedHostModules ++ processedHomeModules ++ processedCommonModules;
  allEnablePaths = lib.unique (lib.map (module: module.enablePath) allModules);
  allEnableOptions = lib.map (path: libx.internal.pathListToOption path) allEnablePaths;
  combinedEnableOptions = lib.foldl (lib.recursiveUpdateUntil (_: _: right: (lib.isOption right))) {} allEnableOptions;
in {
  optModules = options;
  enableOptions = combinedEnableOptions;

  hostModules = hostModules ++ commonModules;
  homeModules = homeModules ++ commonModules;
}
