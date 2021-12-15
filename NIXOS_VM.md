# NixOS VM

1. Download & install VirtualBox: https://www.virtualbox.org/
2. Download: https://nixos.org/download.html#nixos-virtualbox
3. File > Import Appliance (3 CPUs, 8GB RAM)
4. Open Settings
   - Specify SSD for storage
   - Compare current settings with [docs](https://nixos.org/manual/nixos/stable/#sec-instaling-virtualbox-guest)
   - Enable port forwarding for VirtualBox VM: Settings/Network/Advanced/Port Forwarding. Host Port: 2222. Guest Port: 22.
   - Specify shared folders
5. Start VM
6. Change password: `passwd`
7. Update `/etc/nixos/configuration.nix`
   - `sudo -i`
   - `nano /etc/nixos/configuration.nix`
   - Make changes as per [docs](https://nixos.org/manual/nixos/stable/#sec-instaling-virtualbox-guest), enable ssh, ...
   - apply changes and do any upgrades: `nixos-rebuild switch --upgrade`
8. SSH from Mac: `ssh -p 2222 demo@localhost` (ensure nothing else is running on localhost)
