{
  lib,
  options,
  ...
} @ inputs: host:
lib.evalModules {
  modules =
    [
      ../hosts/${host}
    ]
    ++ options;
  specialArgs =
    inputs
    // {
      inherit host;
      env = "nixos";
    };
}
