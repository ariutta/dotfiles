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
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
nix-channel --add https://nixos.org/channels/nixos-18.03 nixos
nix-channel --list # does the output correspond to the above?
# TODO what about a NixOS vs. non-NixOS system?
# For the NixOS system, nixpkgs is supposed to be the same as nixos, right?
```

Install packages managed by Nix (same command to update):

```sh
nix-channel --update
# NOTE: ~/dotfiles/.profile.public sets $NIX_PATH based on nix-channels.
# If nix-channels are added or removed, we need to source .profile.public again.
# TODO: test that this step is correct!
source ~/dotfiles/.profile.public
nix-env -f dotfiles/common.nix -ri
nix-env -f dotfiles/local.nix -ri
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
nix-env -f dotfiles/common.nix -ri
nix-env -f dotfiles/local.nix -ri
# nix-env -u '*' # why doesn't this work?
```

## Declarative Package Management for macOS and Linux

* https://nixos.org/nixpkgs/manual/#sec-declarative-package-management
* https://nixos.org/nix/manual/#ssec-relnotes-1.6.0

Possibly related:

* https://rycee.net/posts/2017-07-02-manage-your-home-with-nix.html
* https://unix.stackexchange.com/questions/369234/how-to-configure-a-nix-environment-outside-of-nixos
* https://github.com/ashgillman/dotfiles2/blob/master/install-ubuntu.sh

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
