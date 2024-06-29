# Tasks

- [ ] Get system back to old state
  - [ ] Import missing settings from git commit "feat!: burn it all"
    - [x] Audio
    - [x] Grub
    - [x] Misc apps
    - [x] Printing
    - [ ] Network manager
    - [ ] Antivirus
    - [ ] Doas
  - [ ] Convert those settings to modules
  - [ ] Create options for those modules
- [ ] Disable logging into root and add a local admin account
- [ ] Try getting stylix to work again
  - [ ] If not could I make my own version or something?
    - https://pablo.tools/blog/computers/system-wide-colorscheme/
- [ ] Special input support
  - [ ] Logitech
    - [ ] Mouse
    - [ ] Keyboard
  - [ ] Steelseries keyboard
  - [ ] Razor mouse
  - [ ] Stream deck
- [ ] Add missing packages to system with relevant options
  - [ ] Discord
  - [ ] KeePassXC
  - [ ] Obsidian
    - [ ] Check if it still needs to be in unstable because of the electron issue
  - [ ] Neovim
    - [ ] Neovide (Terminals are better on linux. Will this be needed there?)
    - [ ] Neovim settings/config
- [ ] See if I can do anything about specialisations
  - If I'm making a specialisation per DE I could loop over the list of all DEs and create specialisations if more than one is enabled
  - Alternatively I could probably add in my implementation of the specialisation option in my modules system and then integrate that into the Nix specialisation option