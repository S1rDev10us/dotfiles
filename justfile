set shell := ["sh", "-c"]

currentUser := `whoami`
currentHost := `hostname`

default:
    @just --choose || just --list

switch host="":
    @just switch-system {{ if host == "" { "" } else { "'" + host + "'" } }}
    @just switch-home {{ if host == "" { "" } else { "'" + currentUser + "@" + host + "'" } }}

switch-system host="": format
    sudo nixos-rebuild switch --flake '.#{{ if host != "" { host } else { currentHost } }}'

switch-home user="": format
    home-manager switch --flake '.#{{ if user != "" { user } else { currentUser } }}@{{ currentHost }}'

update:
    @just update-only
    just switch

update-only:
    nix flake update

format:
    @alejandra .

check: format
   nix flake check 


clean:
    nix-env --delete-generations +10
    nix-collect-garbage
    nix-store --optimise -v
