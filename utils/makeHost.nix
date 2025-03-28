{
  lib,
  libx,
  ...
} @ thisInputs: {
  host,
  opts,
  stateVersion,
  architecture ? "x86_64-linux",
  specialArgs ? thisInputs,
}:
lib.nixosSystem (let
  inherit (libx.internal.getModules) optModules enableOptions hostModules;
in {
  system = architecture;
  specialArgs =
    specialArgs
    // {
      inherit stateVersion architecture host opts;
      env = "nixos";
    };

  modules =
    [
      {
        nixpkgs.hostPlatform = architecture;
      }
      {
        imports = optModules;
        options.toggles = enableOptions;
        config = opts;
      }
    ]
    ++ hostModules
    ++ (libx.ifExists ../hosts/${host}/configuration.nix)
    ++ (libx.ifExists ../hosts/${host}/hardware-configuration.nix);
})
