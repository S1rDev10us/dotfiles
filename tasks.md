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
  - [ ] Look at [QEMU](https://www.qemu.org/)
    - https://mynixos.com/nixpkgs/options/virtualisation.qemu
  - [ ] https://github.com/astro/microvm.nix
  - [ ] https://github.com/TRPB/docker-nixos
  - [ ] https://wiki.nixos.org/wiki/NixOS_Containers

## Maintenence

- [ ] Setup auto-updates
  - https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/tasks/auto-upgrade.nix

## Upgrades

- Convert various package installs to modules
  - [ ] obs-studio
  - [ ] thunderbird
- [ ] Special input support
  - [ ] Stream deck

### Security

- [ ] Setup ClamAV and potentially add systemd task to run it automatically
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
  - [ ] https://github.com/cynicsketch/nix-mineral
  - [ ] https://github.com/JayRovacsek/nix-config/blob/0f18ebf54033e291bee32bf52171676514563862/home-manager-modules/firefox/default.nix
  - [ ] https://github.com/JayRovacsek/vulnix-pre-commit/blob/main/README.md
  - [ ] https://apparmor.net/
    - https://discourse.nixos.org/t/apparmor-default-profiles/16780
  - [ ] https://wiki.nixos.org/wiki/Workgroup:SELinux

### Package additions

- [ ] Add [Freetube](https://freetubeapp.io/) https://mynixos.com/home-manager/options/programs.freetube
- [ ] Phone connection app? KDE Connect would probably work
- [ ] setup plymouth
- [ ] Look at setting up impermanence https://www.youtube.com/watch?v=YPKwkWtK7l0
- [ ] Take a look at [kando](https://github.com/kando-menu/kando)
  - [Packaged with nix](https://github.com/Zhaith-Izaliel/zhaith-nixos-configuration/blob/3d0869bc845759fa510c7f21595f14dff3b06a0c/packages/kando.nix#L10)
- [ ] https://search.nixos.org/packages?query=vlc
- [ ] https://search.nixos.org/packages?query=ludusavi
- [ ] https://mynixos.com/nixpkgs/package/gnome.gnome-clocks
- [ ] https://alternativeto.net/software/zotero/about/
- [ ] https://alternativeto.net/software/natron/about/
- [ ] nix-tree
- [ ] [NixOS generations trimmer](https://wiki.nixos.org/wiki/NixOS_Generations_Trimmer)
- [ ] [tldr](https://tldr.sh/)
