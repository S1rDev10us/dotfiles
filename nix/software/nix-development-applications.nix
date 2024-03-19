{pkgs, ...}: {
  # nixpkgs.config.permittedInsecurePackages = [
  #   "nix-2.16.2" # nixd currently relies on a version of nix that is insecure. This will be fixed in a few days
  #   # TODO check if this can be removed
  # ];
  environment.systemPackages = with pkgs; [
    alejandra
    nano
    git
    # unstable.nixd
    nil
  ];
}
