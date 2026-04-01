{inputs, ...}: {
  lib,
  config,
  ...
}: let
  # Uhhh, without these lines I get import errors???
  err = inputs ? "make-shell";
  err2 = inputs ? "rust-overlay";
in {
  imports = [inputs.make-shell.flakeModules.default];
  options.rustToolchain = lib.mkOption {
    type = lib.types.path;
  };
  config.perSystem = {pkgs, ...}: let
    rustPkgs = pkgs.extend (import inputs.rust-overlay);
  in {
    make-shells.default = {
      buildInputs = with pkgs; [
        (rustPkgs.rust-bin.fromRustupToolchainFile config.rustToolchain)
        pkg-config
        lld
        clang
        # tools
        just
        bacon
        commitlint-rs
      ];
    };
  };
}
