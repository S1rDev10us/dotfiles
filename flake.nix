{
  description = "S1rDev10us' dotfiles";

  inputs = let
    nix_version="23.11";
  in {
    nixpkgs.url = "nixpkgs/nixos-${nix_version}";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-${nix_version}";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix/release-${nix_version}";
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
    # hosts = ["cerberus"];
    hosts = lib.filter (machine: ! (lib.elem machine ["hydra"])) (libx.allFrom ./hosts);
    users = libx.allFrom ./users;
    parameters = {
      inherit inputs outputs libx;
    };
    options = libx.allModulesFrom ./options;
  in {
    nixosConfigurations =
      builtins.listToAttrs
      (builtins.map (host: {
          name = host;
          value = libx.makeHost {
            inherit host;
            specialArgs = parameters;
          };
        })
        hosts);
    homeConfigurations = builtins.listToAttrs (lib.flatten (builtins.map (
        user: (builtins.map (host: {
            name = user + "@" + host;
            value = libx.makeHome {
              inherit host;
              inherit user;
              specialArgs = parameters;
            };
          })
          hosts)
      )
      users));
  };
}
