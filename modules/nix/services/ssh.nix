{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentification = false;
      PermitRootLogin = "no";
    };
  };
}
