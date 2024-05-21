{
  inputs,
  lib,
  libx,
  options,
  ...
} @ thisInputs: {
  host,
  stateVersion ? "23.11",
  architecture ? "x86_64-linux",
  specialArgs ? thisInputs,
}:
lib.nixosSystem {
  system = architecture;
  specialArgs =
    specialArgs
    // {
      inherit stateVersion architecture host;
      env = "nixos";
    };

  modules =
    [
      ../hosts/${host}
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
    ++ options
    ++ (libx.allModulesFrom ../modules/nix)
    ++ (libx.ifExists ../hosts/${host}/configuration.nix)
    ++ (libx.ifExists ../hosts/${host}/hardware-configuration.nix);
}
