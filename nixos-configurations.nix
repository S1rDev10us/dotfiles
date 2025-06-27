{
  libx,
  parameters,
  hosts,
  nixpkgs,
}: {lib, ...}: {
  flake = {
    nixosConfigurations =
      lib.genAttrs hosts
      (
        host: let
          evaluatedOptions = libx.getHostSettings host;
        in
          libx.makeHost {
            architecture = evaluatedOptions.config.architecture;
            inherit host;
            opts = evaluatedOptions.config;
            stateVersion = evaluatedOptions.config.stateVersion;
            specialArgs = parameters;
          }
      );
  };
}
