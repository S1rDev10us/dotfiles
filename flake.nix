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
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
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

    devShells = let
      allSystems = ["x86_64-linux"];
      forAllSystems = f: lib.genAttrs allSystems (system: f {systemPkgs = pkgs.legacyPackages.${system};});
    in
      forAllSystems ({systemPkgs}: {
        default = systemPkgs.mkShell {
          packages = with systemPkgs; [
            just
            alejandra
            nodejs_22
          ];
          shellHook = ''
            echo "linking types"
            ln -sf ${systemPkgs.ags}/share/com.github.Aylur.ags/types ./resources/ags-dots/types
          '';
        };
      });
    packages.x86_64-linux.ags = pkgs.legacyPackages.x86_64-linux.callPackage ./resources/ags-dots/default.nix {ags = inputs.ags.packages.x86_64-linux.default;};
  };
}
