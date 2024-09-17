{
  inputs = {
    nixpkgs.url = "nixpkgs/24.05";
  };
  outputs = {nixpkgs}: let
    allSystems = ["x86_64-linux"];
    forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {pkgs = nixpkgs.legacyPackages."${system}";});
  in {
    devShells = forAllSystems ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          nodejs_22
          just
        ];
        shellHook = ''
          npm run prepare
        '';
      };
    });
    packages = forAllSystems ({pkgs}: {
      default = pkgs.callPackage ./default.nix {};
    });
  };
}
