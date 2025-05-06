{ags}: {...}: {
  perSystem = {pkgs, ...}: let
    astal-packages = pkgs.callPackage ./default.nix {inherit ags;};
  in {
    packages = {
      inherit
        (astal-packages)
        audio-bar
        ;
    };
  };
}
