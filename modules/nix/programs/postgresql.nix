{pkgs, ...}: {
  services = {
    postgresql.enable = true;
    postgresqlBackup.enable = true;
  };
  environment.systemPackages = with pkgs; [
    beekeeper-studio
  ];
  permittedInsecurePackages = [
    "beekeeper-studio-5.3.4"
  ];
}
