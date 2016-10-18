" nocompatible means Vim doesn't have to support
" backwards compatibility with Vi.
" Usually this line does nothing.
set nocompatible               " be iMproved

 " ***********************
 " Vundle to manage vim bundles
 " ***********************
	" This is a workaround for a bug that affects Vundle.
	" filetype is turned back on at the end of this
	" Vundle section.
	 filetype off " required!

	 set rtp+=~/.vim/bundle/Vundle.vim/
	 call vundle#begin()

	 " let Vundle manage Vundle
	 " required! 
	 Plugin 'gmarik/Vundle.vim'

	 " ***********************
	 " original (not a fork) repos on github
	 " ***********************

	 " make vim syntax-aware
	 Plugin 'scrooloose/syntastic'

	 " markdown (github-flavored) syntax
	 Plugin 'gabrielelana/vim-markdown'

	 " HTML5 & inline SVG omnicomplete and syntax
	 Plugin 'othree/html5.vim'

	 " css syntax
	 Plugin 'hail2u/vim-css3-syntax'
	 Plugin 'ariutta/Css-Pretty'

	 " js syntax
	 Plugin 'jelera/vim-javascript-syntax'
	 Plugin 'pangloss/vim-javascript'
	 Plugin 'elzr/vim-json'
	 " jsdoc syntax
	 Plugin 'heavenshell/vim-jsdoc'

	 " typescript syntax
	 Plugin 'leafgarland/typescript-vim'

	 " js and ts indenting
	 Plugin 'jason0x43/vim-js-indent'

	 " Tern provides JavaScript-based editing support.
	 " This plugin will download the tern package, but you still
	 " need to finish installing tern:
	 "     cd ~/.vim/bundle/tern_for_vim/
	 "     npm install
	 Plugin 'marijnh/tern_for_vim'

	 " visually display indent levels
	 Plugin 'nathanaelkane/vim-indent-guides'

	 " automatic closing of quotes, parenthesis, brackets, etc.
	 Plugin 'Raimondi/delimitMate'

	 " Pretty colors
	 " Installation:
	 " 	A) Download and unzip http://ethanschoonover.com/solarized/files/solarized.zip
	 " 	B) If using iTerm2, import the colors:
	 " 		Preferences > Profiles > Colors > Load Presets > Import >
	 " 			solarized/iterm2-colors-solarized/Solarized Dark.itermcolors
	 " 	C) Repeat for Solarized Light.itermcolors
	 Plugin 'altercation/vim-colors-solarized'

	 " git wrapper
	 "   For screencasts on how to use:
	 "   https://github.com/tpope/vim-fugitive#screencasts
	 "   To compare a file across branches:
	 "   Gedit master:myfile.txt
     "   Gdiff dev:myfile.txt
	 Plugin 'tpope/vim-fugitive'

	 Plugin 'tpope/vim-abolish'
	 Plugin 'Lokaltog/vim-easymotion'
	 Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

	 Plugin 'tpope/vim-surround'

	 " Needed to make ycm and ultisnips work together:
	 " http://stackoverflow.com/questions/14896327/ultisnips-and-youcompleteme
	 Plugin 'ervandew/supertab'

	 " YouCompleteMe provides autocomplete functionality.
	 " Before running :PluginInstall, make sure Vim was compiled with Python support:
	 " 	:python import sys; print(sys.version)
	 " 
	 "	If it doesn't print a Python version, recompile with Python
	 " 	support as described in the Help section at the bottom of this file.
	 "
	 " After ensuring Python support:
	 " 	A) Open .vimrc and run :PluginInstall (may take a long time),
	 " 	B) Finish installing tern (as described near Plugin 'marijnh/tern_for_vim' above)
	 "	C) Check whether cmake is installed, and if not, install it:
	 "		which cmake
	 "		brew install cmake # only if above command returned nothing
	 " 	D) Compile YouCompleteMe:
	 " 		~/.vim/bundle/YouCompleteMe/install.py --clang-completer
	 Plugin 'Valloric/YouCompleteMe'

	 Plugin 'Valloric/MatchTagAlways'

	 " ultisnips provides snippets (basically context-specific code-completion)
	 " Track the engine.
	 "::
	 "Plugin 'SirVer/ultisnips'


	 " make YCM compatible with UltiSnips (using supertab)
	 let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
	 let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
	 let g:SuperTabDefaultCompletionType = '<C-n>'

	 " better key bindings for UltiSnipsExpandTrigger
	 let g:UltiSnipsExpandTrigger = "<tab>"
	 let g:UltiSnipsJumpForwardTrigger = "<tab>"
	 let g:UltiSnipsJumpBackwardTrigger = "<s-tab>""

	 " Snippets are separated from the engine. Add this if you want them:
	 Plugin 'honza/vim-snippets'

	 " If you want :UltiSnipsEdit to split your window.
	 let g:UltiSnipsEditSplit="vertical"

	 Plugin 'moll/vim-node'

	 " ctrlp makes it easier to open files, buffers, etc.
	 " Call it with :CtrlPMixed or Ctrl+p
	 Plugin 'kien/ctrlp.vim'
	 " This C extension speeds up ctrlp's finder.
	 " After running PluginInstall, you need to finish installation,
	 "   cd ~/.vim/bundle/ctrlp-cmatcher
	 "   ./install.sh
	 " Further info:
	 " https://github.com/JazzCore/ctrlp-cmatcher/
	 Plugin 'JazzCore/ctrlp-cmatcher'

	 " Write markdown in vim and see live preview in browser
	 " launch the Livedown server and preview your markdown file
	 " :LivedownPreview
	 "
	 " " stop the Livedown server
	 " :LivedownKill
	 "
	 " " launch/kill the Livedown server
	 " :LivedownToggle
	 Plugin 'shime/vim-livedown'

	 " vim-only installation of powerline 
	 " (Disabled, because I am using the system-wide installation, as detailed in the customization section)
	 "Plugin 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}

	 " ***********************
	 " vim-scripts repos
	 " ***********************
	 Plugin 'L9'
	 Plugin 'keepcase.vim'
	 " Handle delimited files (.csv, .tsv, etc.)
	 "   See http://vimawesome.com/plugin/csv-vim
	 "   If a file is .txt, tell vim it's delimited with:
	 "   :set filetype=csv
	 Plugin 'csv.vim'

	 
	 " ***********************
	 " non github repos
	 " gist, bitbucket, etc.
	 " ***********************

	 " Currently none in use, but here's a placeholder example:
	 "Plugin 'https://gist.github.com/8290763.git'

	 " ***********************
	 " git repos on your local machine
	 " (ie. when working on your own plugin)
	 " ***********************
	 "
	 " Currently none in use, but here are two placeholder examples:
	 "Plugin 'file:///Users/ariutta/.vim/bundle/Css-Pretty2/plugin/csspretty.vim'
	 "Plugin 'file:///Users/ariutta/.vim/bundle/FixCSS.vim'

	 call vundle#end()
 
	 " Indent plugin
	 filetype plugin indent on     " required!

 " ***********************
 " My customizations to .vimrc
 " ***********************
 
 	 " powerline enhances the status bar in vim.
	 " It can also work for bash, etc.
	 "
 	 " Powerline Installation Instructions: https://powerline.readthedocs.org/en/latest/installation.html
	 "
	 " The following are the steps that worked for me for a system-wide
	 " installation on OS/X:
	 " A) Run:
	 " 	pip install powerline-status
	 " B) Get and install the patched fonts::
	 "  	git clone https://github.com/powerline/fonts.git
	 "  	cd ./fonts
	 " 	bash ./install.sh
	 " C) Set terminal and MacVim to use 'Liberation Mono for Powerline'
	 " D) Add terminal bindings to .bashrc/.bash_profile
	 "    # Enable Powerline
	 "    powerline-daemon -q
	 "    POWERLINE_BASH_CONTINUATION=1
	 "    POWERLINE_BASH_SELECT=1
	 "    # This worked on Mac OS/X. Might need to get pip/powerline repository directory another way for other OS's.
	 "    source "$(pip show powerline-status | grep Location | sed 's/Location:\ )/powerline/bindings/bash/powerline.sh") 
	 " E) Add the following lines to your .vimrc (taken from https://powerline.readthedocs.org/en/latest/usage/other.html#vim-statusline):
	 python from powerline.vim import setup as powerline_setup
	 python powerline_setup()
	 python del powerline_setup
	 " always show statusline
	 set laststatus=2

	 " F5 inserts current date as markdown header
	 nnoremap <silent> <F5> a<C-R>=strftime('%Y-%m-%d %a')<CR><CR>===============<CR><CR><Esc>
	 
	 " turn off beep (at least when hitting "Esc")
	 set visualbell

	 " make backspace behave 'normally'
	 set backspace=indent,eol,start

	 " Add newline with Ctrl-C
	 let delimitMate_expand_cr = 1
	 let delimitMate_expand_space = 0

	 " needed to make ctrlp use the C extension for matching
	 let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }
	 " add commands for initiating CtrlP
	 let g:ctrlp_map = '<c-p>'
	 let g:ctrlp_cmd = 'CtrlP'
	 " ignore files for CtrlP
	 set wildignore+=*/.git/*,*.git,*/node_modules/*,*/js-compiled/*,*/frontend\/lib/*     " All
	 set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
	 "set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
	 let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
	 " Use a custom file listing command
	 "let g:ctrlp_user_command = 'find %s -type f'        " MacOSX/Linux
	 " let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d'  " Windows

	 " In the quickfix window, <CR> is used to jump to the error under the
	 " cursor, so undefine the mapping there.
	 " from http://superuser.com/questions/815416/hitting-enter-in-the-quickfix-window-doesnt-work
	 autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
	 
	 " Enables using colors to show language syntax (I think?)
	 syntax enable

	 " colorscheme
	 set background=dark
	 colorscheme solarized

	 " make csv.vim recognize the pound sign as indicating a comment
	 let g:csv_comment = '#'

	 " settings for Syntastic, the syntax helper
	 let g:syntastic_mode_map = { 'mode': 'active',
		\ 'active_filetypes': [],
		\ 'passive_filetypes': [] }
	 " Enable this option to tell syntastic to always stick any detected
	 " errors into the loclist:
	 let g:syntastic_always_populate_loc_list=1

	 " use eslint for javascript
	 " install eslint with "npm install -g eslint"
	 "let g:loaded_syntastic_typescript_tsc_checker = ['tsc']
	 let g:syntastic_typescript_checkers = ['tslint', 'tsc']
	 let g:syntastic_javascript_checkers = ['eslint']
	 let g:syntastic_html_checkers = ['eslint']

	 " make Syntastic work with ng-whatever from angular
	 " first, install the HTML5 version of HTML Tidy
	 "   brew tap homebrew/dupes
	 "   brew install homebrew/dupes/tidy --HEAD
	 " for more info on the options:
	 " https://github.com/scrooloose/syntastic/wiki/HTML:---tidy
	 let g:syntastic_html_tidy_ignore_errors=[
				 \ "trimming empty <i>",
				 \ "trimming empty <span>",
				 \ "trimming empty <button>",
				 \ "<meta> proprietary attribute \"property",
				 \ " proprietary attribute \"required",
				 \ " proprietary attribute \"novalidate",
				 \ "unescaped & which should be written as &amp;",
				 \ "'<' + '/' + letter not allowed here",
				 \ "<img> lacks \"src\" attribute",
				 \ "<style isn't allowed in <wikipathways-pvjs> elements",
				 \ ]
	 let g:syntastic_html_tidy_blocklevel_tags=[
				 \ "tab",
				 \ "tab-heading",
				 \ "tabset",
				 \ "bridgedb-xref-specifier",
				 \ "bridgedb-gpml-type-selector",
				 \ "bridgedb-dataset-selector",
				 \ "bridgedb-xref-search",
				 \ "bridgedb-xref-search-results",
				 \ "wikipathways-pvjs",
				 \ ]
	 let g:syntastic_html_tidy_inline_tags=[]
	 let g:syntastic_html_tidy_empty_tags=["i"]

	 " show line numbers by default
	 set number

	 " Typing "jk" quickly leaves insert mode
	 inoremap jk <Esc>

	 " enable indent guides by default
	 autocmd BufReadPre,FileReadPre * :IndentGuidesEnable

	 " Use Google's JS indent style for typescript
	 autocmd FileType typescript setlocal shiftwidth=2 tabstop=2

	 " Run TypeScript formatter on current file with `\tsf`
	 " Before running, need to install npm dependencies:
	 " npm install -g typescript typescript-formatter
	 funct! Tsfmt()
		 let current_line = line(".")
		 redir => output
		 silent exec "!tsfmt " . expand('%:p')
		 redir END
		 let output = substitute(output, "
", "", "g")
		 let @o = output
		 silent execute "1,$d"
		 silent execute "put o"
		 " TODO we are currently clipping the first two lines
		 " from the formatted result because they are not the
		 " desired code but instead are just print logs saying
		 " we ran the ts formatter.
		 " Check why are we getting log-style lines included
		 " in stdout?
		 silent execute "1,3d"
		 " TODO removing the last line, because it's blank.
		 " This seems like the wrong spot to do this.
		 " Why is this still being added, even though I've
		 " set .editorconfig and tslint.json to indicate
		 " NOT adding a final newline?
		 :execute "normal! Gdd"
		 :execute "normal! " current_line . "G"
		 " Note we need to return something in order for
		 " us to get the cursor back to its original line.
		 return ""
	 endfunct!
	 nmap <leader>tsf :silent execute Tsfmt()<CR>

	 " disable arrow keys
	 map <up> <nop>
	 map <down> <nop>
	 map <left> <nop>
	 map <right> <nop>
	 imap <up> <nop>
	 imap <down> <nop>
	 imap <left> <nop>
	 imap <right> <nop>

 " ***********************
 " Help
 " ***********************
	 "
	 " *** Install Vim and MacVim on OS/X
	 "
	 " A) Check whether python (not python3) is included in list of items installed via brew:
	 " 	brew list
	 "
	 " 	1) If no, install macvim: 
	 " 		brew rm macvim # optional, only if you had it installed previously  
	 " 		brew install macvim --with-override-system-vim
	 " 	2) If yes
	 "		a) get the current homebrew version of python from terminal:
	 " 			python --version
	 "		b) symlink to homebrew python (use your version in place of the specified version, and
	 "                 check that the directories you’re changing from actually exist, because you may get a
	 "                 value like “Python 2.7.10” from —version but actually need to use a value like “2.7.10_2”):
	 " 			cd /System/Library/Frameworks/Python.framework/Versions
	 " 			sudo mv Current Current-sys
	 " 			sudo mv 2.7 2.7-sys
	 " 			sudo ln -s /usr/local/Cellar/python/2.7.11/Frameworks/Python.framework/Versions/2.7 Current
	 " 			sudo ln -s /usr/local/Cellar/python/2.7.11/Frameworks/Python.framework/Versions/2.7 2.7
	 "		c) install macvim as per step 1) above
	 " B) Install vundle:
	 "	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	 " C) Open ~/.vimrc in Vim and run :PluginInstall (may take a long time)
	 " D) Finish installing tern (instructions in Vundle section above)
	 " E) Compile YouCompleteMe (instructions in Vundle section above)
	 " F) Install powerline (instructions in custom section above)
	 " G) Install solarized color scheme for terminal (instructions in Vundle section above)
	 " H) If python was installed via brew (point A.2. above), revert the python symlinks:
	 "	cd /System/Library/Frameworks/Python.framework/Versions
	 " 	sudo rm Current
	 " 	sudo mv Current-sys Current
	 " 	sudo rm 2.7
	 " 	sudo mv 2.7-sys 2.7
	 " I) brew pin python macvim # python and macvim not incl/ in generic "brew upgrade"
	 "
	 " The steps above were modified from the instructions here:
	 " http://stackoverflow.com/questions/11148403/homebrew-macvim-with-python2-7-3-support-not-working/12697440#12697440
	 "
	 " *** Use Vundle
	 "
	 " :PluginList          - list configured bundles
	 " :PluginInstall    	- install bundles
	 " :PluginInstall!    	- update bundles
	 " :PluginSearch foo 	- search for foo
	 " :PluginSearch! foo 	- refreshing cache first and then search for foo
	 " :PluginClean      	- confirm removal of unused bundles
	 " :PluginClean!      	- auto-approve removal of unused bundles
	 "
	 " see :h vundle for more details or wiki for FAQ
	 " NOTE: comments after Plugin command are not allowed.
	 " 
	 " *** Refresh .vimrc
	 "
	 " :so $MYVIMRC
