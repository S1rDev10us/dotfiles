{
  description = "S1rDev10us' dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-compat = {
      url = "github:inclyc/flake-compat";
      flake = false;
    };
  };
  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    stylix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    pkgs = nixpkgs;
    lib = nixpkgs.lib;
    libx = import ./utils (parameters
      // {
        inherit pkgs lib options;
      });
    hosts = libx.allFrom ./hosts;
    # hosts = lib.filter (machine: ! (lib.elem machine ["hydra"])) (libx.allFrom ./hosts);
    users = libx.allFrom ./users;
    parameters = {
      inherit inputs outputs libx;
    };
    options = libx.allModulesFrom ./options;
  in {
    nixosConfigurations =
      builtins.listToAttrs
      (builtins.map
        (host: let
          evaluatedOptions = libx.getHostSettings host;
        in {
          name = host;
          value = libx.makeHost {
            inherit host;
            evaluatedOptions = evaluatedOptions.config;
            stateVersion = evaluatedOptions.config.stateVersion;
            specialArgs = parameters;
          };
        })
        hosts);
    homeConfigurations = builtins.listToAttrs (lib.flatten (builtins.map
      (
        host: let
          hostOptions = libx.getHostSettings host;
        in (builtins.map
          (user: let
            evaluatedOptions = libx.getHomeSettings host user;
          in {
            name = user + "@" + host;
            value = libx.makeHome {
              inherit host user;
              evaluatedOptions = evaluatedOptions.config;
              stateVersion = evaluatedOptions.config.stateVersion;
              specialArgs = parameters;
            };
          })
          (builtins.filter (user: hostOptions.config.users.${user}.enable) users))
      )
      hosts));
  };
}
