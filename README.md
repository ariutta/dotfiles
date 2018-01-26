# dotfiles

Set configuration for my dev environment.

## How to Install

```sh
cd $HOME
git clone git@github.com:ariutta/dotfiles.git
ln -s dotfiles/.gitignore_global ./.gitignore_global
```

### Source `dotfiles` Startup Scripts
This repo is only for public information, so it never manages the startup scripts in your home directory (`~/.profile`, `~/.bashrc`, etc). To source the startup scripts in `dotfiles`, make the following manual edits:
#### `.profile`
```sh
if [ -f "$HOME/dotfiles/.profile.public" ]; then
   . "$HOME/dotfiles/.profile.public"
fi
```

#### `.bashrc`
```sh
if [ -f "$HOME/dotfiles/.bashrc.public" ]; then
   . "$HOME/dotfiles/.bashrc.public"
fi
```

#### `.bash_profile` (optional)
If your system uses `.bash_profile`, add this to it to make login shells, macOS terminal emulators (like Terminal.app or iTerm2) and interactive shells all load the same:
```sh
if [ -f "$HOME/.profile" ]; then
	. "$HOME/.profile"
fi
if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
fi
```

### Install Nix

If not already set (see `nix-channel --list`), set the channels:
```sh
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --add https://nixos.org/channels/nixos-17.09 nixos
```

Install packages managed by Nix (same command to update):
```sh
nix-channel --update
nix-env -f dotfiles/ariutta.nix -ri
```

`tosheets` needs to get permission the first time it runs.
If browser is on the same machine, you can run a dummy command to trigger this:
```sh
seq 1 10 | tosheets -c B4 --new-sheet=sample-spread-sheet-id-23sdf32543fs
```
If browser is on a different machine, you should be able to use `--noauth_local_webserver`, but that doesn't currently work with `tosheets`. 

Note there is a file "/etc/nix/nix.conf" on macOS. This might be relevant to declarative package management for macOS.

### Install bash-it
[Install bash-it](https://github.com/Bash-it/bash-it#install)
```sh
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh --no-modify-config
```

Enable completions and plugins:
```sh
bash-it enable completion tmux npm git ssh
bash-it enable plugin jenv
```

## How to Update

```sh
nix-channel --update
nix-env -f dotfiles/ariutta.nix -ri
# nix-env -u '*' # why doesn't this work?
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
```
* Login shells (initial, one-time) and Terminal.app (always):
          `.bash_profile`
                 |
        -------------------
        |                 |
       ???                |
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
```

### Non-bash login (initial, one-time) shells
```
   `.profile`
        |
        v
`.profile.public`
```

[More information](https://serverfault.com/questions/261802/what-are-the-functional-differences-between-profile-bash-profile-and-bashrc)
