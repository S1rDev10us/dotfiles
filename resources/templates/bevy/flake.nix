{
  description = "A basic template for bevy projects";
  inputs = {
    dotfiles.url = "github:s1rdev10us/dotfiles";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs =
    {
      nixpkgs,
      dotfiles,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        systems = [ "x86_64-linux" ];
        rustToolchain = ./rust-toolchain.toml;
        imports = [ dotfiles.flakeModules.bevy ];
      }
    );
}
