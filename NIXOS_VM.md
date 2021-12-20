# NixOS VM

## Setup

1. Download & install VirtualBox: https://www.virtualbox.org/
2. Download: https://nixos.org/download.html#nixos-virtualbox
3. File > Import Appliance (3 CPUs, 8GB RAM)
4. Open Settings
   - Rename to `nixos` and move `NixOS 21.11.334247.573095944e7 (x86_64-linux)` to Description
   - Specify SSD for storage
   - Compare current settings with [docs](https://nixos.org/manual/nixos/stable/#sec-instaling-virtualbox-guest)
   - Enable port forwarding for VirtualBox VM: Settings/Network/Advanced/Port Forwarding. Host Port: `2222`. Guest Port: `22`.
   - Specify shared folders, e.g., Host: `/Users/andersriutta/Documents/vmshare` Guest: `/home/ariutta/Documents/vmshare`
5. Start VM
6. Change password: `passwd`
7. Update `/etc/nixos/configuration.nix`
   - `sudo -i`
   - `nano /etc/nixos/configuration.nix`
   - Make changes as per [docs](https://nixos.org/manual/nixos/stable/#sec-instaling-virtualbox-guest), enable ssh, ...
   - Add user `ariutta`:
   ```
   users.users.ariutta = {
     isNormalUser = true;
     home = "/home/ariutta";
     extraGrous = [ "wheel" "networkmanager" "vboxsf" ]; # "wheel" enables `sudo` for user.
   };
   ```
   - Apply changes and do any upgrades:
     - `nix-channel --update`
     - `nixos-rebuild switch --upgrade`
8. Change password for ariutta: `passwd`
9. Copy SSH ID: `ssh-copy-id -p 2222 ariutta@localhost`
10. SSH from Mac: `ssh -p 2222 ariutta@localhost` (ensure nothing else is running on localhost)
11. Disable root login and password authentication for SSH:
```
services.openssh = {
  enable = true;
  passwordAuthentication = false; # default true
  permitRootLogin = "no";
};
```

## Run

1. `sh ./dotfiles/bin/vbox.sh ssh`
