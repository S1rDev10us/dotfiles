{ lib
, libx
, inputs
, options
, ...
} @ thisInputs: { host
                , user
                , defaultStateVersion ? "23.11"
                , architecture ? "x86_64-linux"
                , specialArgs ? thisInputs
                ,
                }:
inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = inputs.nixpkgs.legacyPackages."${architecture}";
  extraSpecialArgs =
    specialArgs
    // {
      inherit defaultStateVersion architecture host user;
      env = "home";
    };
  modules =
    [
      ../hosts/${host}
      ({ config, ... }: {
        _module.args = { user = config.home.username; };
        home.username = lib.mkDefault user;
      })
    ]
    ++ options
    ++ (libx.allModulesFrom ../users/${user})
    ++ (libx.allModulesFrom ../modules/home)
    ++ (libx.allModulesFrom ../modules/common)
    ++ libx.ifExists ../hosts/${host}/home.nix;
}
