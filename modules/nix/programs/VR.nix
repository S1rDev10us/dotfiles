{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.nixpkgs-xr.nixosModules.nixpkgs-xr];
  programs.steam.remotePlay.openFirewall = true;
  environment.systemPackages = [
    (let
      wayvr =
        pkgs.callPackage (builtins.import "${pkgs.fetchFromGitHub {
          owner = "NixOS";
          repo = "nixpkgs";
          rev = "6234254a9bffd106b244d2bb73ca1bf76bd152c3";
          hash = "sha256-NKXK1/xb89r2pAtusGg8HWRRBLZ6/4vguA4Uzzme/F0=";
        }}/pkgs/by-name/wa/wayvr/package.nix")
        {inherit wayvr;};
    in
      wayvr)
  ];
  services.wivrn = {
    enable = true;
    openFirewall = true;
  };
}
