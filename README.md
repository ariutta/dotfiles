# dotfiles

Set configuration for my dev environment. If anyone else wants to use this, fork [`ariutta/dotfiles`](https://github.com/ariutta/dotfiles) and [`ariutta/mynixpkgs`](https://github.com/ariutta/mynixpkgs) to your own Github user or organization and replace `ariutta` below as appropriate.

## How to Install

- Install Xcode from App Store (macOS only)

- [Add SSH key to GitHub account](https://help.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account)

- Clone repo:

```sh
cd $HOME
git clone git@github.com:ariutta/dotfiles.git
ln -s dotfiles/.gitignore_global ./.gitignore_global
cp dotfiles/.gitconfig_sample ./.gitconfig # edit as needed
```

- [Install Nix](https://nixos.org/nix/manual/#chap-installation):

```sh
sh <(curl https://nixos.org/nix/install) --daemon
```

- Install [Powerline Fonts](https://github.com/powerline/fonts#quick-installation)

#### macOS

```
nix-env -iA nixpkgs.powerline-fonts
cp "$HOME"/.nix-profile/share/fonts/truetype/"Meslo LG S DZ"* /Library/Fonts/
sudo chown root:wheel /Library/Fonts/"Meslo LG S DZ"*
sudo chmod 644 /Library/Fonts/"Meslo LG S DZ"*
```

Note: even if you're installing this on a remote system, you still need the [Powerline Fonts](https://github.com/powerline/fonts#quick-installation) installed on your local machine for the terminal Powerline.

- Setup terminal theme: [gruvbox](https://github.com/morhetz/gruvbox-contrib)

#### macOS

Use the terminal profile for macOS saved here as `./Gruvbox-powerline.terminal`. Note that the [macOS terminal profile](https://github.com/morhetz/gruvbox-contrib/blob/master/osx-terminal/Gruvbox-dark.terminal) from gruvbox-contrib uses the font `Menlo`, but I switched to using `Meslo LG S DZ` with a line spacing of `0.9` in order to work with Powerline.

#### Linux

Try finding the right option at [gruvbox-contrib](https://github.com/morhetz/gruvbox-contrib).

TODO: right now, I'm setting up the terminal theme manually, but I could do it programmatically.
For macOS, see these examples:
** [zsh demo](https://github.com/JemarJones/mac-os-config/blob/23fc32c36cb0f26c65fc29e4f8c2718facfd0f5d/setup.sh#L59) and related [StackOverflow comment](https://apple.stackexchange.com/a/344464)
** [Apple Script example](https://github.com/geerlingguy/mac-dev-playbook/issues/26#issue-197509022)
** [bash demo](https://redlinetech.wordpress.com/2015/03/18/scripting-the-default-terminal-theme-in-os-x/)
** [Medium post](https://medium.com/@adamtowers/how-to-customize-your-terminal-and-bash-profile-from-scratch-9ab079256380): "How to Customize Your Terminal and BASH Profile from Scratch"

- Install Nix Packages

Install packages managed by Nix (same command to update):

```sh
nix-env -f dotfiles/mynixpkgs/environments/common.nix -i
```

`tosheets` needs to get permission the first time it runs.
If browser is on the same machine, you can run a dummy command to trigger this:

```sh
seq 1 10 | tosheets -c B4 --new-sheet=sample-spread-sheet-id-23sdf32543fs
```

If browser is on a different machine, you should be able to use `--noauth_local_webserver`, but that doesn't currently work with `tosheets`.

### Source `dotfiles` Startup Scripts

This repo is only for public information, so it never manages the startup scripts in your home directory (`~/.profile`, `~/.bashrc`, etc). To source the startup scripts in `dotfiles`, make the following manual edits:

#### NixOS

#### `.profile`

```sh
if [ -f "$HOME/dotfiles/.profile.public" ]; then
   . "$HOME/dotfiles/.profile.public"
fi
```

##### `.bashrc`

```
# Make login shells and interactive shells load the same way:
if [ -f "$HOME/.profile" ]; then
  . "$HOME/.profile"
fi

if [ -f "$HOME/dotfiles/.bashrc.public" ]; then
  . "$HOME/dotfiles/.bashrc.public"
fi
```

#### Ubuntu

##### `.profile`

```sh
if [ -f "$HOME/dotfiles/.profile.public" ]; then
   . "$HOME/dotfiles/.profile.public"
fi
```

##### `.bashrc`

```sh
if [ -f "$HOME/dotfiles/.bashrc.public" ]; then
   . "$HOME/dotfiles/.bashrc.public"
fi
```

#### macOS

##### `.profile`

```sh
if [ -f "$HOME/dotfiles/.profile.public" ]; then
   . "$HOME/dotfiles/.profile.public"
fi
```

##### `.bashrc`

```sh
if [ -f "$HOME/dotfiles/.bashrc.public" ]; then
   . "$HOME/dotfiles/.bashrc.public"
fi
```

##### `.bash_profile`

```sh
# Make the following all load the same way:
# * login shells
# * interactive shells
# * macOS terminal emulators (like Terminal.app or iTerm2)
if [ -f "$HOME/.profile" ]; then
	. "$HOME/.profile"
fi
if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
fi
```

## How to Update

TODO: how should we handle channels on NixOS, Ubuntu and macOS?
~~If not already set (see `nix-channel --list`), set the channels:~~

```sh
nix-channel --update
nix-env -f dotfiles/mynixpkgs/environments/common.nix -i
```

Note: the `r` flag indicates remove everything else:

```sh
nix-env -f dotfiles/mynixpkgs/environments/common.nix -ri
```

TODO: why doesn't the following work?

```sh
nix-env -u '*'
```

To edit/update entire NixOS, edit the configuration file to define what should
be installed on your system. Help is available in the configuration.nix(5) man
page and in the NixOS manual (accessible by running ‘nixos-help’).

```
sudo vim /etc/nixos/configuration.nix
```

Make changes take effect (`--upgrade` is optional):

```
sudo -i nixos-rebuild switch --upgrade
```

Rollback:

```
sudo -i nixos-rebuild switch --rollback
```

If xserver changed, save work and restart:

```
sudo -i nixos-rebuild switch && sudo systemctl restart display-manager
```

## Declarative Package Management for macOS and Linux

- https://nixos.org/nixpkgs/manual/#sec-declarative-package-management
- https://nixos.org/nix/manual/#ssec-relnotes-1.6.0

Possibly related:

- https://rycee.net/posts/2017-07-02-manage-your-home-with-nix.html
- https://unix.stackexchange.com/questions/369234/how-to-configure-a-nix-environment-outside-of-nixos
- https://github.com/ashgillman/dotfiles2/blob/master/install-ubuntu.sh

## Purposes of Shell Startup/Config Files

- `.bash_profile`
  - bash login shells
  - Terminal.app treats every new terminal window as a login shell, so it runs this every time a new terminal window is opened
- `.profile`
  - All shells (not bash specific)
  - Recommended uses
    - env variables (export...)
    - command line tool dir locations (PATH...)
    - …
- `.profile.public`: same as `.profile`, except its content is under version control in my `dotfiles` repo
- `.bashrc`
  - Interactive (non-login) bash shells
  - Recommended uses
    - aliases
    - setting editor
    - …
  - rc = "run command"
- `.bashrc.public`: same as `.bashrc`, except its content is under version control in my `dotfiles` repo

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

## Development

If you improve `mynixpkgs`, you can contribute back to the source.

Setup the `mynixpkgs` subtree, if not done already:

```
git remote add mynixpkgs git@github.com:ariutta/mynixpkgs.git
git subtree add --prefix mynixpkgs mynixpkgs master --squash
```

Sync subtree repo:

```
git subtree pull --prefix mynixpkgs mynixpkgs master --squash
git subtree push --prefix mynixpkgs mynixpkgs master
```

If you don't have write access to `ariutta/mynixpkgs`, make a pull request.
