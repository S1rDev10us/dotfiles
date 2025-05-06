{
  libx,
  parameters,
  hosts,
}: {lib, ...}: {
  flake = {
    homeConfigurations = builtins.listToAttrs (lib.flatten (builtins.map
      (
        host: let
          hostOptions = libx.getHostSettings host;
        in (builtins.map
          (user: let
            evaluatedOptions = libx.getHomeSettings host user;
          in {
            name = user + "@" + host;
            value = libx.makeHome {
              architecture = evaluatedOptions.config.architecture;
              inherit host user;
              opts = evaluatedOptions.config;
              stateVersion = evaluatedOptions.config.stateVersion;
              specialArgs = parameters;
            };
          })
          (libx.getEnabledUsers hostOptions.config))
      )
      hosts));
  };
}
