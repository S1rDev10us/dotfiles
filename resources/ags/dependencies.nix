{pkgs, ...}:
with pkgs; let
  # The distinction between these is a bit iffy (and tbh possible unnecessary given they're all being merged anyway) but:
  # runtimeDependencies is for libraries to compose things, like gtk or whatever
  # cmdDependencies is for things like brightnessctl that control things about the system
  # guiDependencies is for external GUIs that get called from the scripts
  #
  # Any buildtime dependencies should be specified in default.nix since that is where the build actually happens
  runtimeDependencies = [webkitgtk];
  cmdDependencies = [];
  guiDependencies = [];
in
  runtimeDependencies ++ cmdDependencies ++ guiDependencies
