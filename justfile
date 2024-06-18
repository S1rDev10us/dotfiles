
default:
	@just --list

switch config="":
	@just switch-system config
	@just switch-home config

switch-system config="":
	sudo nixos-rebuild switch --flake '.{{ if config!="" {"#"+config} else {""} }}'

switch-home config="":
	home-manager switch --flake '.{{ if config!="" {"#"+config} else {""} }}'
