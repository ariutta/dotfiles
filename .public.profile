# ██████╗ ██╗   ██╗██████╗ ██╗     ██╗ ██████╗     ██████╗ ███╗   ██╗██╗  ██╗   ██╗██╗
# ██╔══██╗██║   ██║██╔══██╗██║     ██║██╔════╝    ██╔═══██╗████╗  ██║██║  ╚██╗ ██╔╝██║
# ██████╔╝██║   ██║██████╔╝██║     ██║██║         ██║   ██║██╔██╗ ██║██║   ╚████╔╝ ██║
# ██╔═══╝ ██║   ██║██╔══██╗██║     ██║██║         ██║   ██║██║╚██╗██║██║    ╚██╔╝  ╚═╝
# ██║     ╚██████╔╝██████╔╝███████╗██║╚██████╗    ╚██████╔╝██║ ╚████║███████╗██║   ██╗
# ╚═╝      ╚═════╝ ╚═════╝ ╚══════╝╚═╝ ╚═════╝     ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝   ╚═╝
#                                                                                     
# Warning: this file will be made public online. Only include publicly shareable data.

# Purposes of Shell Startup Files
#
# .profile: all shells (export..., PATH, ...)
#    not bash specific
# .bashrc: interactive, non-login shells (aliases, set editor, ...).
#    bash only
#    rc = "run command"
# .bash_profile: login shells
#    bash only
#    Terminal.app treats every new terminal window as a login shell, so it
#                 runs this every time a new terminal window is opened
# .public.profile, .public.bashrc: include these in my dotfiles
#
# https://serverfault.com/questions/261802/what-are-the-functional-differences-between-profile-bash-profile-and-bashrc

# .profile sources this file like this:
#if [ -f ~/.public.profile ]; then
#   source ~/.public.profile
#fi

# Python
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true

# My helper scripts to run on startup
export PATH="$HOME/dev_helper_scripts:$PATH"
