# Tasks

## Hosts

### Homelab

- [ ] Create a home lab
  - [ ] Look at Home assistant
  - [ ] Look at Nextcloud
    - https://old.reddit.com/r/selfhosted/comments/1cx35ol/ticket_system_or_todo_for_your_homelab/
  - [ ] Look at cockpit
    - https://cockpit-project.org/
    - https://fictionbecomesfact.com/nixos-cockpit
  - [ ] Look at TailScale
    - https://old.reddit.com/r/homelab/comments/16bg3h2/why_tailscale/
    - https://old.reddit.com/r/Tailscale/comments/ut25pk/dynamic_ip/
    - https://tailscale.com/blog/how-tailscale-works
    - https://old.reddit.com/r/homelab/comments/13beyti/best_way_for_remote_access_to_homelab/
    - https://old.reddit.com/r/homelab/comments/mnqoka/how_do_you_access_your_homelab_from_outside/
  - https://old.reddit.com/r/homelab/comments/1djwtjz/starting_over_again_how_to_do_domains_certs_and/
  - [ ] Look at setting up hardware
    - https://old.reddit.com/r/NixOS/comments/cjgcih/installing_on_hp_proliant_gen8/
    - https://askubuntu.com/questions/524814/how-to-install-ubuntu-server-on-hp-proliant-microserver-gen8

### Amphisbaena

- [ ] Check what the error is in the boot (and shutdown) sequence (Looked to be something about "ACPI" I think, I'll need to record the boot sequence to see what it says)
- [ ] Look at what hardware specific options need to be set for my laptop
  - https://github.com/NixOS/nixos-hardware/tree/master/asus/zenbook/ux371
- [ ] Setup battery management (tlp?)
  - https://wiki.nixos.org/wiki/Laptop

## Maintenence

- [x] Document structure changes
- [ ] Setup auto-updates
  - https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/tasks/auto-upgrade.nix

## Upgrades

- [x] Configure user accounts under `users.users.${name}.whatever`
  - I could go back to the old way of extending the host config with the user config
  - Because then I could generate an option for each user and then only if it is enabled do I add the configuration.nix from the user
  - [x] Create an option for each user
  - [ ] If the option is enabled add configuration.nix from that folder to the config
  - [x] Automatically create the user using `users.users.${user}`
- [ ] Special input support
  - [ ] Logitech
    - [ ] Mouse
    - [ ] Keyboard
  - [ ] Steelseries keyboard
  - [ ] Razor mouse
  - [ ] Stream deck
- [ ] See if I can do anything about specialisations
  - If I'm making a specialisation per DE I could loop over the list of all DEs and create specialisations if more than one is enabled
  - Alternatively I could probably add in my implementation of the specialisation option in my modules system and then integrate that into the Nix specialisation option

### Security

- [ ] Disable logging into root and add a local admin account
- [ ] Various security hardening
  - [ ] https://github.com/fufexan/dotfiles/blob/e85f77b1ab197e6bb4f7c8861305a02db2ea38df/system/core/security.nix
  - [ ] https://wiki.nixos.org/wiki/Security
  - [ ] https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/profiles/hardened.nix
  - [ ] https://xeiaso.net/blog/paranoid-nixos-2021-07-18/
  - [ ] https://old.reddit.com/r/NixOS/comments/1aqck9l/systemd_hardening_some_preconfigured_options_d/
  - [ ] https://wiki.nixos.org/wiki/Security
  - [ ] [Secure boot](https://github.com/nix-community/lanzaboote) ([wiki](https://wiki.nixos.org/wiki/Secure_Boot))
  - [ ] [Systemd hardening](https://wiki.nixos.org/wiki/Systemd/Hardening)

### Package additions

- [ ] Use krunner / anyrunner instead of rofi?
- [ ] OBS
- [ ] Aseprite (I have it with steam but I think I saw it as a module which could be better?)
- [ ] Krita
- [x] Discord
- [x] Thunderbird
- [x] KeePassXC
- [x] Hyprland
  - [x] Setup options with home manager
  - [ ] Make sure it's working properly
  - https://github.com/lbonn/rofi
  - https://github.com/Alexays/Waybar/wiki/Configuration
  - https://wiki.hyprland.org/Useful-Utilities/Status-Bars/
  - https://github.com/fufexan/dotfiles/tree/main/home/programs/wayland/hyprland
- [x] Obsidian
  - [x] Check if it still needs to be in unstable because of the electron issue
  - It no longer needs to be in unstable! :)
- [x] Neovim
  - [x] Neovide (Terminals are better on linux. Will this be needed there?)
  - [ ] Neovim settings/config
    - [ ] Dependencies
      - [x] Rust
      - [ ] Fzf
- [ ] setup plymouth
- [ ] Look at setting up impermanence https://www.youtube.com/watch?v=YPKwkWtK7l0
- [ ] Take a look at [kando](https://github.com/kando-menu/kando)
  - [Packaged with nix](https://github.com/Zhaith-Izaliel/zhaith-nixos-configuration/blob/3d0869bc845759fa510c7f21595f14dff3b06a0c/packages/kando.nix#L10)
- [ ] Try getting stylix to work again
  - [ ] If not could I make my own version or something?
    - https://pablo.tools/blog/computers/system-wide-colorscheme/
- [ ] Get system back to old state
  - [ ] Import missing settings from git commit "feat!: burn it all"
    - [x] Audio
    - [x] Grub
    - [x] Misc apps
    - [x] Printing
    - [x] Network manager
    - [ ] Antivirus
    - [x] Doas
    - [x] Firefox
      - [/] With policies
        - [ ] Setup custom homepage
          - https://mozilla.github.io/policy-templates/#hompage
          - https://old.reddit.com/r/startpages
      - [ ] With extensions
        - Redirector
          - [ ] setup with redirects automatically
        - KeePassXC
        - UBlockOrigin
        - MultiAccountContainers
        - Google container
        - Facebook container
  - [ ] Convert those settings to modules
  - [ ] Create options for those modules
