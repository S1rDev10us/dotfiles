{
  description = "S1rDev10us' dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix/release-23.11";
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
        inherit pkgs lib;
      });
    # hosts = ["minotaur"];
    hosts = libx.allFrom ./hosts;
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
  };
}
