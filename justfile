set shell := ["sh", "-c"]

currentUser := `whoami`
currentHost := `hostname`

default:
    @just --choose || just --list

switch host=currentHost user=currentUser: (rebuild "switch" host user)

rebuild method="switch" host="{{ currentHost }}" user="{{ currentUser }}": (rebuild-system method host) (rebuild-home user host)

rebuild-system method="switch" host=currentHost: format
    sudo nixos-rebuild {{method}} --flake '.#{{ host  }}'

rebuild-home user=currentUser host=currentHost: format
    home-manager switch --flake '.#{{ user }}@{{ host }}'

# Update specific inputs and rebuild
update: update-only && rebuild

# Update only some specific flake inputs
update-only:
    nix flake lock --update-input nixpkgs --update-input home-manager --update-input nixpkgs-unstable --update-input firefox-extensions

# Update all flake inputs
update-all: && rebuild
    nix flake update

format:
    @alejandra .

check: format
   nix flake check 

clean-light:
    nix-collect-garbage
    nix-store --optimise -v

clean: && clean-light
    nix-env --delete-generations +10
    home-manager expire-generations 5d
