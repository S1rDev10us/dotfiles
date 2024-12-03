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
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-compat = {
      url = "github:inclyc/flake-compat";
      flake = false;
    };

    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOs/nixos-hardware";

    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-extensions = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    ags,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib;
    libx = import ./utils (parameters
      // {
        inherit nixpkgs lib options;
      });
    hosts = libx.allFrom ./hosts;
    # hosts = lib.filter (machine: ! (lib.elem machine ["hydra"])) (libx.allFrom ./hosts);
    users = libx.allFrom ./users;
    parameters = {
      inherit inputs outputs libx;
    };
    options = libx.allModulesFrom ./options;
    allSystems = lib.systems.flakeExposed;
    forAllSystems = f:
      lib.genAttrs allSystems (system:
        f {
          inherit system;
          systemPkgs = nixpkgs.legacyPackages.${system};
        });
  in {
    templates = lib.genAttrs (libx.allFrom ./resources/templates) (template: let
      templateFolder = ./resources/templates/${template};
      templateFlake = templateFolder + "/flake.nix";
    in {
      path = templateFolder;
      description = let
        templateFlakeExists = builtins.pathExists templateFlake;
        placeholderDescription = "Template for ${template}";
      in
        if templateFlakeExists
        then ({description = placeholderDescription;} // import templateFlake).description
        else placeholderDescription;
    });

    nixosConfigurations =
      lib.genAttrs hosts
      (
        host: let
          evaluatedOptions = libx.getHostSettings host;
        in
          libx.makeHost {
            inherit host;
            evaluatedOptions = evaluatedOptions.config;
            stateVersion = evaluatedOptions.config.stateVersion;
            specialArgs = parameters;
          }
      );

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

    devShells = forAllSystems ({
      systemPkgs,
      system,
      ...
    }: {
      default = systemPkgs.mkShell {
        packages = with systemPkgs; [
          just
          alejandra
          nodejs_22
        ];
        shellHook = ''
          echo "linking types"
          ln -sf ${ags.packages.${system}.default}/share/com.github.Aylur.ags/types ./resources/ags-dots/
        '';
      };
    });
    packages = forAllSystems ({
      systemPkgs,
      system,
    }: rec {
      ags = systemPkgs.callPackage ./resources/ags-dots/default.nix {
        ags = inputs.ags.packages.${system}.default;
      };
      onhomenetwork = systemPkgs.callPackage ./resources/onhomenetwork/default.nix {};
    });
  };
}
