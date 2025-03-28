{
  pkgs,
  opts,
  lib,
  ...
}: {
  # Use kwallet for a secret store
  environment.systemPackages = with pkgs;
  with kdePackages;
    [kwallet kwallet-pam]
    ++ (lib.optional opts.GUI kwalletmanager);
  xdg.portal.extraPortals = [
    pkgs.kdePackages.kwallet
  ];
  # Auto unlock with pam
  security.pam.services = {
    login.kwallet = {
      enable = lib.mkDefault true;
      package = lib.mkDefault pkgs.kdePackages.kwallet-pam;
    };
    sddm.kwallet = {
      enable = true;
      package = pkgs.kdePackages.kwallet-pam;
    };
  };
  environment.sessionVariables.GIT_ASKPASS = "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";
}
