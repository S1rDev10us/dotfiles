{
  inputs,
  lib,
  libx,
  ...
} @ thisInputs: {
  host,
  stateVersion ? "23.11",
  architecture ? "x86_64-linux",
  specialArgs ? thisInputs,
}:
lib.nixosSystem {
  system = architecture;
  inherit specialArgs;
  modules =
    [
      {
        networking.hostName = lib.mkForce host;
        system.stateVersion = stateVersion;
        nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
      }
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
    ++ (libx.allModulesFrom ../options)
    ++ (libx.allModulesFrom ../modules/nix)
    ++ (libx.ifExists ../hosts/${host}/configuration.nix)
    ++ (libx.ifExists ../hosts/${host}/hardware-configuration.nix);
}
