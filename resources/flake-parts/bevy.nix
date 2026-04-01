{self, ...}: {lib, ...}: {
  imports = [self.flakeModules.rust];
  perSystem = {pkgs, ...}: {
    make-shells.default = {
      env = {
        LD_LIBRARY_PATH = lib.makeLibraryPath (
          with pkgs; [
            vulkan-loader
            libX11
            libXi
            libXcursor
            libxkbcommon
            wayland
            alsa-lib
            libudev-zero
          ]
        );
      };
      buildInputs = with pkgs; [
        # for Linux
        # Audio (Linux only)
        alsa-lib
        # Cross Platform 3D Graphics API
        vulkan-loader
        # For debugging around vulkan
        vulkan-tools
        # Other dependencies
        libudev-zero
        libX11
        libXcursor
        libXi
        libXrandr
        libxkbcommon
        wayland
      ];
    };
  };
}
