{
  description = "A basic template for bevy projects";
  inputs = {
    nixpkgs.url = "nixpkgs/24.05";
    rust-overlay = {
      src = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    nixpkgs,
    rust-overlay,
    ...
  }: let
    allSystems = ["x86_64-linux"];
    overlays = [(import rust-overlay)];
    forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {pkgs = import nixpkgs {inherit system overlays;};});
  in {
    devShells = forAllSystems ({pkgs}: {
      default = pkgs.mkShell rec {
        packages = with pkgs;
          [
            pkg-config
            lld
            # rust
            (rust-bin.fromRustupToolchainFile ./rust-toolchain.toml)
            # Bevy
            udev
            alsa-lib
            clang
            vulkan-tools
            vulkan-headers
            vulkan-validation-layers
            vulkan-loader
            # For compiling to wayland
            libxkbcommon
            wayland
            # For commitlint
            nodejs_22
            # Command runner
            just
          ]
          # For compiling to X11
          ++ (with xorg; [libX11 libXcursor libXi libXrandr]);
        shellHook = ''
          npm install
          npm run prepare
          export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath (with pkgs; [
            alsaLib
            udev
            vulkan-loader
            wayland
          ])}"
        '';
      };
    });
  };
}
