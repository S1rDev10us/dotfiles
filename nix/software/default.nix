{...}: {
  imports = [
    ./applications.nix
    ./firefox.nix
    
    ./games.nix
    ./headless-applications.nix
    ./home-manager.nix
    ./jetbrains.nix
    ./nix-development-applications.nix
    ./rebuild-script.nix
    #./stylix.nix # Stylix is currently disabled because it doesn't appear to do anything and doesn't work
  ];
}
