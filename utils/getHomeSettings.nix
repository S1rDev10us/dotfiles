{
  lib,
  libx,
  options,
  ...
} @ inputs: host: user:
(libx.getHostSettings host).extendModules {
  modules =
    libx.ifExists ../users/${user}/default.nix;
  specialArgs = {inherit host user;};
}
