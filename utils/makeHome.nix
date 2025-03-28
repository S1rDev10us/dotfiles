{
  lib,
  libx,
  inputs,
  ...
} @ thisInputs: {
  host,
  user,
  opts,
  stateVersion,
  architecture ? "x86_64-linux",
  specialArgs ? thisInputs,
}:
inputs.home-manager.lib.homeManagerConfiguration (let
  inherit (libx.internal.getModules) optModules enableOptions homeModules;
in {
  pkgs = inputs.nixpkgs.legacyPackages."${architecture}";
  extraSpecialArgs =
    specialArgs
    // {
      inherit stateVersion architecture host user opts;
      env = "home";
    };
  modules =
    [
      ({config, ...}: {
        _module.args = {user = config.home.username;};
        home.username = lib.mkDefault user;
      })
      {
        imports = optModules;
        options.toggles = enableOptions;
        config = opts;
      }
    ]
    ++ homeModules
    ++ (libx.ifExists ../hosts/${host}/home.nix)
    # ++ (builtins.filter (path: path != ../users/${user}/default.nix) (libx.allModulesFrom ../users/${user}))
    ++ (libx.ifExists ../users/${user}/home.nix);
})
