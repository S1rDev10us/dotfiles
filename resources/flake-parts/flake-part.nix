inputs' @ {
  libx,
  inputs,
  ...
}: {
  lib,
  flake-parts-lib,
  ...
}: let
  flakeModules = lib.filter (template: template != "flake-part.nix") (libx.listChildren ./.);
  inherit (flake-parts-lib) importApply;
in {
  imports = [inputs.flake-parts.flakeModules.flakeModules];

  flake.flakeModules = lib.genAttrs' flakeModules (module: lib.nameValuePair (lib.removeSuffix ".nix" module) (importApply (./. + ("/" + module)) inputs'));
}
