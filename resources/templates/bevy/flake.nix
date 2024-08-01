{
  description = "A basic template for bevy projects";
  inputs = {
    pkgs.url = "nixpkgs/24.05";
  };
  outputs = {nixpkgs, ...}: let
    allSystems = ["x86_64-linux"];
    forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {pkgs = import nixpkgs {inherit system;};});
  in {
    devShells = forAllSystems ({pkgs}: {
      default = pkgs.mkShell rec {
        packages = with pkgs;
          [
            pkg-config
            lld
            # rust
            cargo
            rustup
            clippy
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
          ]
          # For compiling to X11
          ++ (with xorg; [libX11 libXcursor libXi libXrandr]);
        shellHook = ''
          rustup install stable
          npm install
          npm run prepare
          export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath (with pkgs; [
            alsaLib
            udev
            vulkan-loader
          ])}"
        '';
      };
    });
  };
}
