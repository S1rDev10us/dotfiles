{
  description = "S1rDev10us' dotfiles";
  inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-stable";
    stylix.url = "github:danth/stylix/release-23.11";
    stylix.inputs.nixpkgs.follows = "nixpkgs-stable";
  };
  outputs = {
    self,
    nixpkgs-stable,
    home-manager,
    stylix,
    ...
  } @ inputs: let
    lib = nixpkgs-stable.lib;
  in {
  };
}
