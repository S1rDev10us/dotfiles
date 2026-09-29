{
  config,
  lib,
  ...
}: {
  assertions = [
    {
      # assertion = config.boot.kernelPackages.kernel.version == "7.2.4";
      assertion = config.boot.kernelPackages.kernel.version == "7.2.8";
      message = "Nvidia driver patch reminder for aether";
    }
  ];
  # https://github.com/NixOS/nixpkgs/issues/554125#issuecomment-5346123812
  # The version of the nvidia-open driver that goes along with the 7.2 kernel currently fails to build
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "595.91.07";
    sha256_64bit = "sha256-yiPIjdJLB6GRZE4eEc+3vN11NzBXSa9A+YABiwleYxM=";
    sha256_aarch64 = "sha256-fqkN7ONFXtTeXyu2mQxorrk362Epxq3bz88hhKYQzwQ=";
    openSha256 = "sha256-OB8Epd+qn/WywxsPiFpxEOAzlJqb6I1SyRoV3a8l71k=";
    settingsSha256 = "sha256-QzT8Cw1luuZGP9DUje3HN/0ngiayqHURj+bqPsxlJ5w=";
    persistencedSha256 = "sha256-3JQBaNmkwxvCXv9q8aHKas6VZM/JjLsuilC2t7ET0u0=";
  };
  unfreePackages = [
    config.boot.kernelPackages.nvidia_x11
    "nvidia-settings"
    # CUDA support (below)
    (pkg: pkg ? "meta" && pkg.meta ? "license" && lib.lists.all (license: license.shortName == "CUDA EULA") (lib.lists.toList pkg.meta.license))
    "cudnn"
  ];
  nixpkgs.overlays = [
    (final: prev: {
      btop = prev.btop.override {cudaSupport = true;};
    })
  ];
}
