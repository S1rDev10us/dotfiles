{...}: {
  perSystem = {pkgs, ...}: let
  in {
    packages = rec {
      onhomenetwork = pkgs.callPackage ./onhomenetwork/default.nix {};
    };
  };
}
