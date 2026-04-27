{
  description = "A basic template for bevy projects";
  inputs = {
    bevy-template.url = "github:s1rdev10us/dotfiles?dir=resources/flake-parts/bevy";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs = inputs @ {
    bevy-template,
    flake-parts,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inputs = bevy-template.mkInputs self inputs;} (
      {...}: {
        systems = ["x86_64-linux"];
        rustToolchain = ./rust-toolchain.toml;
        imports = [bevy-template.flakeModules.bevy];
        flake.self = self;
      }
    );
}
