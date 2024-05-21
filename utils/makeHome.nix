{
  lib,
  libx,
  inputs,
  options,
  ...
} @ thisInputs: {
  host,
  stateVersion ? "23.11",
  architecture ? "x86_64-linux",
  specialArgs ? thisInputs,
}:
inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = inputs.nixpkgs.legacySystem."${architecture}";
  extraSpecialArgs =
    specialArgs
    // {
      inherit stateVersion architecture host;
      env = "home";
    };
  modules =
    [
      ../hosts/${host}
    ]
    ++ options
    ++ (libx.allModulesFrom ../modules/home)
    ++ (libx.allModulesFrom ../modules/common)
    ++ libx.ifExists ../hosts/${host}/home.nix;
}
