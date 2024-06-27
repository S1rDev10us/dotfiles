{
  lib,
  stateVersion,
  user,
  config,
  ...
}: {
  home = {
    stateVersion = lib.mkForce stateVersion;
    homeDirectory = lib.mkDefault "/home/${user}";
  };
}
