{pkgs, ...}: {
  services = {
    postgresql.enable = true;
    postgresqlBackup.enable = true;
  };
  environment.systemPackages = with pkgs; [
    beekeeper-studio
  ];
  nixpkgs.config.permittedInsecurePackages = [
    "beekeeper-studio-5.1.5"
  ];
}
