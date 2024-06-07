

# dotfiles

## TOC
- [dotfiles](#dotfiles)
	- [TOC](#toc)
	- [Repo description](#repo-description)
	- [Hosts](#hosts)
	- [Features](#features)
	- [Host config options](#host-config-options)
	- [Inspirations](#inspirations)

## Repo description

This repo contains 

If you want to try it out you need to create a `settings.json` file and then apply the schema from `settingsSchema.json` to it and fill out the required fields.

This configuration is constantly in development and may also not reflect the current state of my config.

Feel free to take elements and inspiration from this config in order to create your own 

## Hosts

|  Hostname   |    Environment     |         Use case          |         State         | Secondary GPU | Device description  |
| :---------: | :----------------: | :-----------------------: | :-------------------: | :-----------: | :-----------------: |
|    Hydra    |       NixOS        |   Linux learning device   |           ✅           |       ⛔       |  Old silver laptop  |
| Amphisbaena |   NixOS Dualboot   |     Main work device      | [🚧](## "in progress") |       ⛔       |  Thin black laptop  |
|  Minotaur   | WSL on Amphisbaena | Linux features on windows |           ✅           |       ⛔       |          ^          |
|Cerberus|NixOS VM on Amphisbaena|Using Linux more often|✅|⛔|^|
|  Chimaera   |   NixOS Dualboot   |   Gaming and streaming    | [🚧](## "in progress") |       ⛔       | Large white desktop |

✅ yes

⛔ no

🚧 in progress

## Features

- Individual configs for different machines by customizing data in the hosts folder
- Update home manager and nixos together or separately

## Host config options

- `settings`
  - `coding.enable` 			= enable generic code editors
  - `environment`
	- `hyprland.enable` 			= enable hyprland
	- `gnome.enable` 				= enable gnome
  - `fun.enable` 				= enable fun tools like [eDex ui](https://github.com/GitSquared/edex-ui/tree/v2.2.8)
  - `gamedev.enable` 			= enable game development tools
  - `gaming.enable` 			= enable games
  - `GUI.enable` 				= enable GUI packages
  - `WSL.enable` 				= enable WSL support
  - `VM.enable`=enable vm support
  - `unfreePackages.enable` 	= a list of unfree packages



## Inspirations

A few of the configs that I've taken ideas from include:
- [nmasur](https://github.com/nmasur/dotfiles)
- [wimpysworld](https://github.com/wimpysworld/nix-config)
- [donovanglover](https://github.com/donovanglover/nix-config)
- [hlissner](https://github.com/hlissner/dotfiles)
- [pinpox](https://github.com/pinpox/nixos)
- [fufexan](https://github.com/fufexan/dotfiles)
- [MatthewCroughan](https://github.com/MatthewCroughan/nixcfg)
- [jordanisaacs](https://github.com/jordanisaacs/dotfiles)



No doubt I've missed a few from when I was first getting into nix but I am thankful to everyone who left their config on the internet for me to learn from.


<!-- -- >
Reference for self:
- [Interesting mixin style config](https://github.com/MatthewCroughan/nixcfg)
- [Separation of home manager and NixOS config](https://github.com/wimpysworld/nix-config)
- [Method of loading all files easily](https://github.com/donovanglover/nix-config/blob/master/flake.nix)
- [helpful guide for separating home manager and NixOS](https://jdisaacs.com/blog/nixos-config/)
<!-- -->