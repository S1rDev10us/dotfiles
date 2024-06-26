{
  lib,
  libx,
  options,
  ...
} @ inputs: host:
lib.evalModules {
  modules =
    [
      ../hosts/${host}
    ]
    ++ options;
  specialArgs = inputs // {inherit host;};
}
