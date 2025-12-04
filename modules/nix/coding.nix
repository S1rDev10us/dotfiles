{
  lib,
  pkgs,
  opts,
  ...
}: {
  environment.systemPackages = with pkgs;
    [
      lazygit
      ripgrep
    ]
    ++ lib.optionals opts.GUI [
      (
        unityhub.override {
          extraLibs = pkgs: [pkgs.openssl_1_1];
        }
      )
      jetbrains-toolbox
      # These are needed for Jetbrains Rider to work with unity. Alternatively they could be provided only to Rider using something like [this](https://huantian.dev/blog/unity3d-rider-nixos/) [configuration](https://github.com/huantianad/nixos-config/blob/main/modules/editors/rider.nix)
      # dotnetCorePackages.sdk_6_0
      dotnetCorePackages.dotnet_9.sdk
      dotnetPackages.Nuget
      mono
      # msbuild
      waypipe
    ];
  permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];
  unfreePackages = lib.optionals opts.GUI (with pkgs; [
    corefonts
    unityhub
    jetbrains-toolbox
    jetbrains.rider
  ]);
  programs = {
    git.enable = true;
    nix-ld = {
      enable = true;
      libraries = with pkgs; [openssl stdenv.cc.cc mesa];
    };
  };
  # environment.variables.NIX_LD = lib.makeLibraryPath (with pkgs; [openssl]);

  # Settings so unity can open browser
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };
}
