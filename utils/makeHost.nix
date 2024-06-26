{
  inputs,
  lib,
  libx,
  options,
  ...
} @ thisInputs: {
  host,
  evaluatedOptions,
  defaultStateVersion ? "23.11",
  architecture ? "x86_64-linux",
  specialArgs ? thisInputs,
}:
lib.nixosSystem {
  system = architecture;
  specialArgs =
    specialArgs
    // {
      inherit defaultStateVersion architecture host;
      opts = evaluatedOptions;
      env = "nixos";
    };

  modules =
    [
      {
        nixpkgs.config = {
          packageOverrides = pkgs: {
            unstable = import inputs.nixpkgs-unstable {
              config = pkgs.config;

              system = architecture;
            };
          };
        };
      }
    ]
    ++ (libx.allModulesFrom ../modules/nix)
    ++ (libx.allModulesFrom ../modules/common)
    ++ (libx.ifExists ../hosts/${host}/configuration.nix)
    ++ (libx.ifExists ../hosts/${host}/hardware-configuration.nix);
}
