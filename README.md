# dotfiles

Set configuration for my dev environment.

## First-Time Setup

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
