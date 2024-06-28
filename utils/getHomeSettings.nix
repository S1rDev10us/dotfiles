{
  lib,
  libx,
  options,
  ...
} @ inputs: host: user:
lib.evalModules {
  modules =
    [
      ../hosts/${host}
    ]
    ++ (libx.ifExists ../users/${user}/default.nix)
    ++ options;
  specialArgs =
    inputs
    // {
      inherit host user;
      env = "home";
    };
}
