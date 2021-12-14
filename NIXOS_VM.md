# NixOS VM

1. Download & install VirtualBox: https://www.virtualbox.org/
2. Download: https://nixos.org/download.html#nixos-virtualbox
3. File > Import Appliance (3 CPUs, 8GB RAM)
4. Open Settings
   - Specify SSD for storage
   - Compare current settings with [docs](https://nixos.org/manual/nixos/stable/#sec-instaling-virtualbox-guest)
6. Start VM
7. Change password: `passwd`
8. Update `/etc/nixos/configuration.nix`
   - `sudo -i`
   - `nano /etc/nixos/configuration.nix` (see [docs](https://nixos.org/manual/nixos/stable/#sec-instaling-virtualbox-guest))
9. Apply and upgrade: `nixos-rebuild switch --upgrade`
