# ██████╗ ██╗   ██╗██████╗ ██╗     ██╗ ██████╗     ██████╗ ███╗   ██╗██╗  ██╗   ██╗██╗
# ██╔══██╗██║   ██║██╔══██╗██║     ██║██╔════╝    ██╔═══██╗████╗  ██║██║  ╚██╗ ██╔╝██║
# ██████╔╝██║   ██║██████╔╝██║     ██║██║         ██║   ██║██╔██╗ ██║██║   ╚████╔╝ ██║
# ██╔═══╝ ██║   ██║██╔══██╗██║     ██║██║         ██║   ██║██║╚██╗██║██║    ╚██╔╝  ╚═╝
# ██║     ╚██████╔╝██████╔╝███████╗██║╚██████╗    ╚██████╔╝██║ ╚████║███████╗██║   ██╗
# ╚═╝      ╚═════╝ ╚═════╝ ╚══════╝╚═╝ ╚═════╝     ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝   ╚═╝
#                                                                                     
# Warning: this file will be made public online. Only include publicly shareable data.
# see ~/README.md re: differences between .profile, .bashrc, .bash_profile, etc.

# Python
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
export PIP_VIRTUALENV_BASE=$WORKON_HOME
export PIP_RESPECT_VIRTUALENV=true

# My helper scripts to run on startup
export PATH="$HOME/dev_helper_scripts:$PATH"

# Do something under Mac OS X platform        
if [ "$(uname)" == "Darwin" ]; then
	# From GH help docs:
	# On macOS, ssh-agent will "forget" your key, once it gets restarted during reboots.
	# But you can import your SSH keys into Keychain using this command:
	/usr/bin/ssh-add -K

	## TODO the code below doesn't seem to be needed anymore -- cls works w/out it on macOS now. Why?
	##      Is this defined somewhere else too? 
	##      Does bash_it define this?
	##      Did Apple add it to Terminal.app?
	##      something else?
	##
	## cls: clear terminal buffer.
	## Uses Apple Script, so only works on macOS.
	## Command-K does the same thing
	#if [ -n "$(command -v osascript)" ]; then
	#        function cls {
	#                osascript -e 'tell application "System Events" to keystroke "k" using command down'
	#        }
	#fi
fi
