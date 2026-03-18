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
    login.kwallet.enable = true;
    sddm.kwallet.enable = true;
  };
  environment.sessionVariables.GIT_ASKPASS = "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";
}
