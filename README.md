# S1rDev10us/dotfiles

⚠️ warning, this readme is not always up to date with the current system configuration, I am not focused on making sure this readme is updated accurately and my configuration is constantly in development

## Repo description

This repo contains the dotfiles for my NixOS config.

If you want to try it out you need to create a new host and potentially a new user account and then run `just switch`

If you want to setup a Windows dualboot you need to set Windows to use [UTC time instead of local time](https://wiki.archlinux.org/title/System_time#UTC_in_Microsoft_Windows)

This configuration is constantly in development and may also not reflect the current state of my config.

Feel free to take elements and inspiration from this config in order to create your own

## Structure

There are two config directories for each user in a system.

They have a set of options that are only applied when using home manager and a set of options that are applied when using NixOS and home manager

The home manager specific configuration is in `./users/${user}/default.nix` and the shared system config is in `./hosts/${host}/default.nix`

Those options are not evaluated by the usual home manager or nix modules system,
instead they are evaluated ahead of time.
This means that that config's settings can be used to get the `stateVersion`
(and potentially the system architecture in the future)

Modules for NixOS and home manager as well as shared modules are stored in the `modules` folder (under the `nix`, `home` and `common` folders respectively)

The options for the aforementioned system config are stored in the `options` directory and are recursively gathered.
The options that they generate are documented [below](#host-config-options)

The NixOS and home manager configs also gather a few specific files for their config so that
if you need to specify configuration that is unique to that computer or user then
you can do so.

These files are:

- Home manager:
  - `./users/${user}/home.nix`
  - `./hosts/${host}/home.nix`
- NixOS:
  - `./hosts/${host}/configuration.nix`
  - `./hosts/${host}/hardware-configuration.nix`

Modules in system specific files cannot affect the main system options and the config for the options can't control the systems directly

The overall structure of the system is as follows:

(Modules with ! aren't optional, modules with \_ are home manager specific and modules with - are NixOS specific)

```
dotfiles
| hosts
| ⌞ ${host}
|   | _home.nix
|   | !default.nix
|   | -configuration.nix
|   ⌞ -hardware-configuration.nix
| modules
| | common
| | ⌞ *
| | nix
| | ⌞ -*
| ⌞ home
|  ⌞ _*
| options
| ⌞ *
⌞ users
  ⌞ ${user}
    | default.nix
    ⌞ _home.nix
```

## Hosts

|  Hostname   |    Environment     |         Use case          |         State          | Device description  |
| :---------: | :----------------: | :-----------------------: | :--------------------: | :-----------------: |
|    Hydra    |       NixOS        |   Linux learning device   |           ⛔           |  Old silver laptop  |
| Amphisbaena |   NixOS Dualboot   |     Main work device      |           ✅           |  Thin black laptop  |
|  Minotaur   | WSL on Amphisbaena | Linux features on windows |           ⛔           |          ^          |
|  Chimaera   |   NixOS Dualboot   |   Gaming and streaming    | [🚧](## "in progress") | Large white desktop |
| Archimedes  |   RPi 400 Server   |          Server           |           ✅           |       RPi 400       |

✅ yes

⛔ no

🚧 in progress

## Features

- Individual configs for different machines by customizing data in the hosts folder
- Update home manager and NixOS together or separately
- Templates for various project types in resources/templates

## Host config options

- `stateVersion` = a string that is used for the stateVersion
- `batteryManagement.enable` = enable battery management
- `coding.enable` = enable generic code editors
- `environment`
  - `hyprland.enable` = enable hyprland
  - `gnome.enable` = enable gnome
  - `KDE.enable` = enable KDE
- `fun.enable` = enable fun tools like fastfetch
- `gamedev.enable` = enable game development tools
- `gaming.enable` = enable games
- `grub`
  - `enable` = enable grub
  - `useEfi` = enable grub EFI support
  - `windowsLocation` = uuid of windows partition
- `GUI.enable` = enable GUI packages
- `WSL.enable` = enable WSL support
- `VM.enable` = enable vm support
- `users.${user}`
  - `enable` = enable this user
  - `admin` = give this user admin permissions

## Potential issues

When using a wsl config like `minotaur` it may occasionally throw an error along the lines of
`Failed to mount /lib/modules/5.15.146.1-microsoft-standard-WSL2.`.
This is because you have updated your WSL version without changing the mount path of the wsl config.
To fix this go to the hardware-configuration for the system and change the line that has that mount path to respect your current WSL version.
(You can get your WSL version with `WSL --version`, the line you're looking for is "Kernel version")

## Custom module layout

I've made a custom module layout which can be confusing

```nix
{
  # Unless you use some recursive logic inside config you want
  # to get the enable value from config instead of opts so
  # that specializations can be used
  #
  # Defaults to false
  useOpts = false;
  # Same as usual. If it is a path under the basePath used
  # by the current module (i.e. `modules/nix/`) then it will
  # be processed by this module system as well. Otherwise it
  # is just passed through opaquely
  #
  # Defaults to an empty list
  imports = [...];
  # Same as usual
  options = {...};
  # Same as usual. Unless options is defined this can be placed inline instead like usual
  #
  # Defaults to {}
  config = {...};
  # Same as usual
  # See https://github.com/NixOS/nixpkgs/blob/master/lib/modules.nix for more details
  key=...;
  _file=...;
}
```

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
- [librephoenix](https://librephoenix.com/tags/nixos.html)

[(A more up to date and comprehensive list of what I've looked at)](https://github.com/stars/S1rDev10us/lists/nixos)

No doubt I've missed a few from when I was first getting into nix but I am thankful to everyone who left their config on the internet for me to learn from.

<!-- -- >
Reference for self:
- [Interesting mixin style config](https://github.com/MatthewCroughan/nixcfg)
- [Separation of home manager and NixOS config](https://github.com/wimpysworld/nix-config)
- [Method of loading all files easily](https://github.com/donovanglover/nix-config/blob/master/flake.nix)
- [helpful guide for separating home manager and NixOS](https://jdisaacs.com/blog/nixos-config/)
<!-- -->

## Stargazers over time

[![Stargazers over time](https://starchart.cc/S1rDev10us/dotfiles.svg?variant=adaptive)](https://starchart.cc/S1rDev10us/dotfiles)
