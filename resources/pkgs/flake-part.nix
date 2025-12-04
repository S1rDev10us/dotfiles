{...}: {
  perSystem = {pkgs, ...}: let
  in {
    packages = rec {
      onhomenetwork = pkgs.callPackage ./onhomenetwork/default.nix {};
      isolate_command = pkgs.callPackage ./isolate_command/default.nix {};
    };
  };
}
