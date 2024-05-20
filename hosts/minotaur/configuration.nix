{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alejandra
    nixd
    nil
    wget
    nodejs
    git
  ];
}
