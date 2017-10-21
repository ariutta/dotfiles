# ██████╗ ██╗   ██╗██████╗ ██╗     ██╗ ██████╗     ██████╗ ███╗   ██╗██╗  ██╗   ██╗██╗
# ██╔══██╗██║   ██║██╔══██╗██║     ██║██╔════╝    ██╔═══██╗████╗  ██║██║  ╚██╗ ██╔╝██║
# ██████╔╝██║   ██║██████╔╝██║     ██║██║         ██║   ██║██╔██╗ ██║██║   ╚████╔╝ ██║
# ██╔═══╝ ██║   ██║██╔══██╗██║     ██║██║         ██║   ██║██║╚██╗██║██║    ╚██╔╝  ╚═╝
# ██║     ╚██████╔╝██████╔╝███████╗██║╚██████╗    ╚██████╔╝██║ ╚████║███████╗██║   ██╗
# ╚═╝      ╚═════╝ ╚═════╝ ╚══════╝╚═╝ ╚═════╝     ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝   ╚═╝
#                                                                                     
# Warning: this file will be made public online. Only include publicly shareable data.

# see ~/README.md re: differences between .profile, .bashrc, .bash_profile, etc.

## start jenv. Allows for setting a specific version of the Java environment.
#if [ -n "$(command -v jenv)" ]; then
#        eval "$(jenv init -)"
#fi
#
## start virtual env wrapper
#if [[ -r /usr/local/bin/virtualenvwrapper.sh ]]; then
#        source /usr/local/bin/virtualenvwrapper.sh
#fi

## Enable Powerline
#if [ -n "$(command -v powerline-daemon)" ]; then
#        powerline-daemon -q
#        POWERLINE_BASH_CONTINUATION=1
#        POWERLINE_BASH_SELECT=1
#        # This worked on macOS. Might need to get pip/powerline repository directory another way for other OS's.
#        source "$(pip show powerline-status | grep Location | sed 's/Location:\ //')/powerline/bindings/bash/powerline.sh"
#fi

## cls: clear terminal buffer.
## Uses Apple Script, so only works on macOS.
## Command-K does the same thing
#if [ -n "$(command -v osascript)" ]; then
#        function cls {
#                osascript -e 'tell application "System Events" to keystroke "k" using command down'
#        }
#fi
