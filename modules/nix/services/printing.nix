{lib, ...}: {
  services = {
    # Enable CUPS to print documents.
    printing.enable = true;
    avahi = {
      enable = lib.mkDefault false;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
  programs.system-config-printer.enable = true;
}
