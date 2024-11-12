{
  lib,
  libx,
  inputs,
  ...
} @ thisInputs: {
  host,
  user,
  evaluatedOptions,
  stateVersion,
  architecture ? "x86_64-linux",
  specialArgs ? thisInputs,
}:
inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = inputs.nixpkgs.legacyPackages."${architecture}";
  extraSpecialArgs =
    specialArgs
    // {
      inherit stateVersion architecture host;
      opts = evaluatedOptions;
      env = "home";
    };
  modules =
    [
      ({config, ...}: {
        _module.args = {user = config.home.username;};
        home.username = lib.mkDefault user;
      })
    ]
    ++ (libx.allModulesFrom ../modules/home)
    ++ (libx.allModulesFrom ../modules/common)
    ++ (libx.ifExists ../hosts/${host}/home.nix)
    # ++ (builtins.filter (path: path != ../users/${user}/default.nix) (libx.allModulesFrom ../users/${user}))
    ++ (libx.ifExists ../users/${user}/home.nix);
}
