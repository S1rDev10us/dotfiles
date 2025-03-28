{
  libx,
  lib,
  ...
}: basePath: lib.map (libx.processModule basePath) (libx.allModulesFrom basePath)
