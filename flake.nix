{
  description = "S1rDev10us's flake";

  inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-stable";
    stylix.url = "github:danth/stylix/release-23.11";
    stylix.inputs.nixpkgs.follows = "nixpkgs-stable";
    flake-compat = {
      url = "github:inclyc/flake-compat";
      flake = false;
      # inputs.nixpkgs.follows="nixpkgs-stable";
    };
  };

  outputs = {
    self,
    nixpkgs-stable,
    home-manager,
    stylix,
    ...
  } @ inputs: let
    specialArgs =
      {
        inherit inputs;
      }
      // (builtins.fromJSON (builtins.readFile ./settings.json));
    systemConfig = specialArgs.systemConfig;
    userConfig = specialArgs.userConfig;

    lib = nixpkgs-stable.lib;
  in {
    nixosConfigurations = {
      "${systemConfig.hostname}" = lib.nixosSystem {
        system = systemConfig.systemArchitecture;
        modules = [
          {
            nixpkgs.config = {
              packageOverrides = pkgs: {
                unstable = import inputs.nixpkgs-unstable {
                  config = pkgs.config;

                  system = systemConfig.systemArchitecture;
                };
              };
            };
          }
          home-manager.nixosModules.home-manager
          #stylix.nixosModules.stylix # Stylix is currently disabled because it doesn't appear to do anything and doesn't work
          ./configuration.nix
        ];
        inherit specialArgs;
      };
    };
  };
}
