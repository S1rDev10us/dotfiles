{
  description = "S1rDev10us' dotfiles";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix/release-24.11";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    flake-compat = {
      url = "github:inclyc/flake-compat";
      flake = false;
    };

    ags = {
      url = "github:Aylur/ags/v1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags-astal = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
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
  };
  outputs = {
    self,
    nixpkgs,
    ags,
    ags-astal,
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
      hosts = lib.filter (machine: ! (lib.elem machine ["chimera" "hydra" "minotaur"])) (libx.listChildren ./hosts);

      flakeModules = {
        ags = importApply ./resources/ags-dots/flake-part.nix {inherit (inputs) ags;};
        astal-packages = importApply ./resources/astal-dots/flake-part.nix {ags = ags-astal;};
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
              echo "linking types"
              ln -sf ${ags.packages.${system}.default}/share/com.github.Aylur.ags/types ./resources/ags-dots/
              echo "setting up git hooks"
              ${pkgs.husky}/bin/husky install
            '';
          };
        };
      };
    });
}
