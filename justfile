
default:
	@just --list

switch config="":
	@sudo nixos-rebuild switch --flake '.{{ if config!="" {"#"+config} else {""} }}'

switch-home config="":
	@home-manager switch --flake '.{{ if config!="" {"#"+config} else {""} }}'