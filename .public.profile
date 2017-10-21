# ██████╗ ██╗   ██╗██████╗ ██╗     ██╗ ██████╗     ██████╗ ███╗   ██╗██╗  ██╗   ██╗██╗
# ██╔══██╗██║   ██║██╔══██╗██║     ██║██╔════╝    ██╔═══██╗████╗  ██║██║  ╚██╗ ██╔╝██║
# ██████╔╝██║   ██║██████╔╝██║     ██║██║         ██║   ██║██╔██╗ ██║██║   ╚████╔╝ ██║
# ██╔═══╝ ██║   ██║██╔══██╗██║     ██║██║         ██║   ██║██║╚██╗██║██║    ╚██╔╝  ╚═╝
# ██║     ╚██████╔╝██████╔╝███████╗██║╚██████╗    ╚██████╔╝██║ ╚████║███████╗██║   ██╗
# ╚═╝      ╚═════╝ ╚═════╝ ╚══════╝╚═╝ ╚═════╝     ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝   ╚═╝
#                                                                                     
# Warning: this file will be made public online. Only include publicly shareable data.

# Python
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true

# My helper scripts to run on startup
export PATH="$HOME/dev_helper_scripts:$PATH"
