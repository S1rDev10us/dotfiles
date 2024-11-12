{
  lib,
  libx,
  ...
} @ thisInputs: {
  host,
  evaluatedOptions,
  stateVersion,
  architecture ? "x86_64-linux",
  specialArgs ? thisInputs,
}:
lib.nixosSystem {
  system = architecture;
  specialArgs =
    specialArgs
    // {
      inherit stateVersion architecture host;
      opts = evaluatedOptions;
      env = "nixos";
    };

  modules =
    [
      {
        nixpkgs.hostPlatform = architecture;
      }
    ]
    ++ (libx.allModulesFrom ../modules/nix)
    ++ (libx.allModulesFrom ../modules/common)
    ++ (libx.ifExists ../hosts/${host}/configuration.nix)
    ++ (libx.ifExists ../hosts/${host}/hardware-configuration.nix);
}
