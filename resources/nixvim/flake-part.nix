{
  libx,
  nixvim,
  parameters,
}: {lib, ...}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: let
    nixvim' = nixvim.legacyPackages.${system};
  in {
    packages.nixvim = nixvim'.makeNixvimWithModule {
      inherit pkgs;
      module = {...}: {imports = lib.filter (module: module != ./flake-part.nix) (libx.allModulesFrom ./.);};
      extraSpecialArgs = parameters;
    };
  };
}
