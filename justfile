set shell := ["sh", "-c"]

currentUser := `whoami`
currentHost := `hostname`

default:
    @just --choose || just --list

switch host="{{currentHost}}" user = "{{currentUser}}":
    @just rebuild "switch" '{{host}}' '{{currentUser}}'

rebuild method="switch" host="{{currentHost}}" user="{{currentUser}}":
    @just rebuild-system '{{method}}' '{{host}}'
    @just rebuild-home '{{user}}' '{{host}}'

rebuild-system method="switch" host="{{currentHost}}": format
    sudo nixos-rebuild {{method}} --flake '.#{{ host  }}'

rebuild-home user="{{currentUser}}" host="{{currentHost}}": format
    home-manager switch --flake '.#{{ user }}@{{ host }}'


update: && rebuild
    @just update-only

update-only:
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
