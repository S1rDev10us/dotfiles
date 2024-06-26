{
  lib,
  defaultStateVersion,
  user,
  config,
  ...
}: {
  home = {
    stateVersion = lib.mkOverride 1499 defaultStateVersion;
    homeDirectory = lib.mkDefault "/home/${user}";
  };
}
