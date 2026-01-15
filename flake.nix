{
  description = "S1rDev10us' dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix/release-25.11";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    flake-compat = {
      url = "github:inclyc/flake-compat";
      flake = false;
    };

    nixos-hardware.url = "github:NixOs/nixos-hardware";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-extensions = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Niri + DMS
    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
  };
  outputs = {
    self,
    nixpkgs,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} (top @ {
      config,
      withSystem,
      moduleWithSystem,
      flake-parts-lib,
      ...
    }: let
      inherit (nixpkgs) lib;
      inherit (flake-parts-lib) importApply;
      libx = import ./utils (parameters
        // {
          inherit lib options;
        });

      options = libx.allModulesFrom ./options;
      parameters = {
        inherit inputs libx;
        inherit (self) outputs;
      };
      hosts = lib.filter (machine: ! (lib.elem machine ["chimaera" "hydra"])) (libx.listChildren ./hosts);

      flakeModules = {
        myPkgs = ./resources/pkgs/flake-part.nix;
        nixosConfigurations = importApply ./nixos-configurations.nix {inherit libx parameters hosts nixpkgs;};
        homeConfigurations = importApply ./home-configurations.nix {inherit libx parameters hosts;};
        templates = importApply ./resources/templates/flake-part.nix {inherit libx;};
      };
    in {
      imports = [] ++ lib.attrValues flakeModules;
      flake = {
        inherit flakeModules libx self;
      };
      systems = ["x86_64-linux"];
      perSystem = {
        config,
        system,
        pkgs,
        ...
      }: {
        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; [
              just
              alejandra
              commitlint-rs
            ];
            shellHook = ''
              echo "setting up git hooks"
              ${pkgs.husky}/bin/husky install
            '';
          };
        };
      };
    });
}
