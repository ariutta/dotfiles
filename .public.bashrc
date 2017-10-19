# ██████╗ ██╗   ██╗██████╗ ██╗     ██╗ ██████╗     ██████╗ ███╗   ██╗██╗  ██╗   ██╗██╗
# ██╔══██╗██║   ██║██╔══██╗██║     ██║██╔════╝    ██╔═══██╗████╗  ██║██║  ╚██╗ ██╔╝██║
# ██████╔╝██║   ██║██████╔╝██║     ██║██║         ██║   ██║██╔██╗ ██║██║   ╚████╔╝ ██║
# ██╔═══╝ ██║   ██║██╔══██╗██║     ██║██║         ██║   ██║██║╚██╗██║██║    ╚██╔╝  ╚═╝
# ██║     ╚██████╔╝██████╔╝███████╗██║╚██████╗    ╚██████╔╝██║ ╚████║███████╗██║   ██╗
# ╚═╝      ╚═════╝ ╚═════╝ ╚══════╝╚═╝ ╚═════╝     ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝   ╚═╝
#                                                                                     
# Warning: this file will be made public online. Only include publicly shareable data.

# see ~/.public.profile re: differences between .profile, .bashrc, .bash_profile, etc.

# .bashrc sources this file like this:
#if [ -f ~/.public.bashrc ]; then
#   source ~/.public.bashrc
#fi

# startup jenv. Allows for setting a specific version of the Java environment.
eval "$(jenv init -)"

if [[ -r /usr/local/bin/virtualenvwrapper.sh ]]; then
        source /usr/local/bin/virtualenvwrapper.sh
else
	echo "WARNING: Can't find virtualenvwrapper.sh"
fi

# Enable Powerline
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
# This worked on Mac OS/X. Might need to get pip/powerline repository directory another way for other OS's.
source "$(pip show powerline-status | grep Location | sed 's/Location:\ //')/powerline/bindings/bash/powerline.sh"

# cls: clear terminal buffer.
# Uses Apple Script, so only works on OS X.
# Command-K does the same thing
function cls { 
	osascript -e 'tell application "System Events" to keystroke "k" using command down' 
}

# auto-complete in terminal for git branches 
# Download the .git-completion script, if you haven't done so already:
# curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/dev_helper_scripts/git-completion.bash
if [ -f ~/dev_helper_scripts/git-completion.bash ]; then
  . ~/dev_helper_scripts/git-completion.bash
fi

###-begin-npm-completion-###
#
# npm command completion script
#
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm
#

if type complete &>/dev/null; then
  _npm_completion () {
    local words cword
    if type _get_comp_words_by_ref &>/dev/null; then
      _get_comp_words_by_ref -n = -n @ -n : -w words -i cword
    else
      cword="$COMP_CWORD"
      words=("${COMP_WORDS[@]}")
    fi

    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${words[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
    if type __ltrim_colon_completions &>/dev/null; then
      __ltrim_colon_completions "${words[cword]}"
    fi
  }
  complete -o default -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi
###-end-npm-completion-###
