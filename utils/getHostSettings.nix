{
  lib,
  libx,
  ...
} @ inputs: host:
lib.evalModules (let
  inherit (libx.internal.getModules) optModules enableOptions;
in {
  modules =
    [
      ../hosts/${host}
      {options.toggles = enableOptions;}
    ]
    ++ optModules;
  specialArgs =
    inputs
    // {
      inherit host;
      env = "nixos";
    };
})
