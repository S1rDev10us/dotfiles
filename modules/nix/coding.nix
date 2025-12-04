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
      waypipe
    ];
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
