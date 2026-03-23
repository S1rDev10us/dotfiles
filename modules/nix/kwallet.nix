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
  security.pam.services = let
    kwalletEnable = {
      enable = true;
      package = lib.mkForce pkgs.kdePackages.kwallet-pam;
    };
  in {
    login.kwallet = kwalletEnable;
    sddm.kwallet = kwalletEnable;
  };
  environment.sessionVariables.GIT_ASKPASS = "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";
}
