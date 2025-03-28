{
  lib,
  libx,
  ...
} @ inputs: host: user:
lib.evalModules (let
  inherit (libx.internal.getModules) optModules enableOptions;
in {
  modules =
    [
      ../hosts/${host}
      {options.toggles = enableOptions;}
    ]
    ++ (libx.ifExists ../users/${user}/default.nix)
    ++ optModules;
  specialArgs =
    inputs
    // {
      inherit host user;
      env = "home";
    };
})
