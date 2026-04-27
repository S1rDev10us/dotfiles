{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";

    flake-parts.url = "github:hercules-ci/flake-parts";
    make-shell.url = "github:nicknovitski/make-shell";

    rust-overlay.url = "github:oxalica/rust-overlay";
  };
  outputs = {
    nixpkgs,
    flake-parts,
    self,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({flake-parts-lib, ...}: {
      imports = [inputs.flake-parts.flakeModules.flakeModules];
      flake.flakeModules = rec {
        rust = import ../rust.nix {inherit inputs;};
        bevy = import ../bevy.nix {inherit self;};
        default = bevy;
      };
      flake.mkInputs = self': other-inputs: let inputs' = inputs // other-inputs // {self = self' // {inputs = inputs';};}; in inputs';
    });
}
