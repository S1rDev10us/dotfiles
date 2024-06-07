{
  lib,
  defaultStateVersion,
  ...
}: {
  home.stateVersion = lib.mkOverride 1499 defaultStateVersion;
}
