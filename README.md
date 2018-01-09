# dotfiles

Set configuration for my dev environment.

## First-Time Setup

```sh
git clone git@github.com:ariutta/dotfiles.git
```

### Nix:
Install Nix.

Set the channels:
```sh
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --add https://nixos.org/channels/nixos-17.09 stablepkgs
```

Set up localpkgs (TODO: haven't fully tested the steps below):
cd ~/Documents
git clone git@github.com:ariutta/nixpkgs.git
cd nixpkgs
git remote add nixpkgs https://github.com/NixOS/nixpkgs
cd
nix-env -f ariutta.nix -ri

To Update:
```sh
nix-channel --update
nix-env -f ariutta.nix -ri
```

`tosheets` needs to get permission the first time it runs.
Here's a dummy command to trigger this:
```sh
seq 1 10 | tosheets -c B4 --new-sheet=sample-spread-sheet-id-23sdf32543fs
if browser is on a different machine, may need to use --noauth_local_webserver
```

TODO: move these over to Nix:
brew list
brew cask list
pip2 list


If needed, you can test the channels with this command:
```sh
nix-env -iA stablepkgs.jq 
```

Install packages managed by Nix with this command:
```sh
nix-env -f ariutta.nix -ri
```

Note there is a file "/etc/nix/nix.conf" on macOS. This might be relevant to declarative package management for macOS.

### Non-Nix:
TODO: use Nix to install these as well.

Install powerline (or at least just the [fonts](https://github.com/powerline/fonts))

[Install bash-it](https://github.com/Bash-it/bash-it#install)

Enable completions:
```sh
bash-it enable completion tmux npm git pip pip3 ssh
```

Enable plugins:
```sh
bash-it enable plugin jenv virtualenv
```

Add this to .profile:
```sh
if [ -f ~/.profile.public ]; then
   source ~/.profile.public
fi
```

If your system uses `.bash_profile`, add this to it to make login shells, macOS terminal emulators (like Terminal.app or iTerm2) and interactive shells all load the same:
```sh
if [ -f ~/.profile ]; then
	. ~/.profile
fi
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi
```

Add this to .bashrc: 
```sh
if [ -f ~/.bashrc.public ]; then
   source ~/.bashrc.public
fi
```

## Purposes of Shell Startup/Config Files
* `.bash_profile`
    * bash login shells
    * Terminal.app treats every new terminal window as a login shell, so it runs this every time a new terminal window is opened
* `.profile`
    * All shells (not bash specific)
    * Recommended uses
      * env variables (export...)
      * command line tool dir locations (PATH...)
      * …
* `.profile.public`: same as `.profile`, except its content is under version control in my `dotfiles` repo
* `.bashrc`
    * Interactive (non-login) bash shells
    * Recommended uses
      * aliases
      * setting editor
      * …
    * rc = "run command"
* `.bashrc.public`: same as `.bashrc`, except its content is under version control in my `dotfiles` repo

## Shell Startup/Config File Execution:
### Bash
* Login shells (initial, one-time) and Terminal.app (always):
          `.bash_profile`
                 |
        -------------------
        |                 |
        v                 v
   `.profile`         `.bashrc`
        |                 |
        v                 v
`.profile.public`  `.bashrc.public`

* Non-login shells (subshells spawned after login shell, e.g., `screen` screens or `tmux` windows):
   `.bashrc`
       |
       v
`.bashrc.public`              

### Non-bash login (initial, one-time) shells
   `.profile`
        |
        v
`.profile.public`

[More information](https://serverfault.com/questions/261802/what-are-the-functional-differences-between-profile-bash-profile-and-bashrc)

## Updating Nix

```sh
nix-channel --update
nix-env -f ariutta.nix -ri
# nix-env -u '*' # why doesn't this work?
```
