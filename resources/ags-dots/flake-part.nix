{ags}: {...}: {
  perSystem = {
    system,
    pkgs,
    ...
  }: {
    packages.ags = pkgs.callPackage ./default.nix {ags = ags.packages.${system}.default;};
  };
}
