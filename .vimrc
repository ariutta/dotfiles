 " ***********************
 " not sure what these are
 " ***********************
	 set nocompatible               " be iMproved
	 filetype off                   " required!

 " ***********************
 " Vundle to manage vim bundles
 " ***********************
	 set rtp+=~/.vim/bundle/Vundle.vim/
	 call vundle#begin()

	 " let Vundle manage Vundle
	 " required! 
	 Plugin 'gmarik/Vundle.vim'

	 " ***********************
	 " original repos on github
	 " ***********************
	 Plugin 'jelera/vim-javascript-syntax'
	 Plugin 'heavenshell/vim-jsdoc'

	 " Tern provides JavaScript-based editing support.
	 " To finish installing tern,
	 " cd to .vim/bundle/tern_for_vim/
	 " run 'npm install'
	 Plugin 'marijnh/tern_for_vim'

	 Plugin 'nathanaelkane/vim-indent-guides'
	 Plugin 'Raimondi/delimitMate'
	 Plugin 'altercation/vim-colors-solarized'
	 Plugin 'scrooloose/nerdtree'
	 Plugin 'scrooloose/syntastic'

	 " Git wrapper
	 " For screencasts on how to use:
	 " https://github.com/tpope/vim-fugitive#screencasts
	 Plugin 'tpope/vim-fugitive'
	 Plugin 'tpope/vim-abolish'
	 Plugin 'Lokaltog/vim-easymotion'
	 Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
	 Plugin 'pangloss/vim-javascript'
	 Plugin 'elzr/vim-json'
	 Plugin 'hail2u/vim-css3-syntax'
	 Plugin 'tpope/vim-surround'
	 Plugin 'ariutta/Css-Pretty'

	 " YouCompleteMe provides autocomplete functionality.
	 " On OS X, you may need to compile it:
	 "	 cd ~/.vim/bundle/YouCompleteMe
	 "	 ./install.sh --clang-completer
	 " To finish installation, it may be necessary
	 " to set which python to use, as describe here:
	 " http://stackoverflow.com/questions/11148403/homebrew-macvim-with-python2-7-3-support-not-working/12697440#12697440
	 Plugin 'Valloric/YouCompleteMe'

	 Plugin 'moll/vim-node'

	 " ctrlp makes it easier to open files, buffers, etc.
	 " the C extension makes the finding faster.
	 " After running PluginInstall, you need to compile the C extension,
	 " as described here:
	 " https://github.com/JazzCore/ctrlp-cmatcher/
	 " Call it with :CtrlPMixed or Command+p
	 Plugin 'kien/ctrlp.vim'
	 Plugin 'JazzCore/ctrlp-cmatcher'

	 " ***********************
	 " vim-scripts repos
	 " ***********************
	 Plugin 'L9'
	 Plugin 'keepcase.vim'
	 
	 " ***********************
	 " non github repos
	 " ***********************
	 
	 " This script makes :q close both current file and NERDtree
	 " TODO look at line 130. It appears to be a dup with this.
	 "Plugin 'https://gist.github.com/8290763.git'

	 " ***********************
	 " git repos on your local machine (ie. when working on your own plugin)
	 " ***********************
	 " Plugin 'file:///Users/ariutta/.vim/bundle/Css-Pretty2/plugin/csspretty.vim'
	 " Plugin 'file:///Users/ariutta/.vim/bundle/FixCSS.vim'
	 " Plugin 'file:///Users/gmarik/path/to/plugin'
	 " ...


 " ***********************
 " My custom additions to .vimrc
 " ***********************
 
	 call vundle#end()
	 " Indent plugin
	 filetype plugin indent on     " required!

	 " F5 inserts current date as markdown header
	 nnoremap <silent> a<C-R>=strftime('%a %d %b %Y')<CR><CR>===============<CR><CR><Esc>
	 
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
	 set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
	 "set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
	 let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
	 " Use a custom file listing command
	 let g:ctrlp_user_command = 'find %s -type f'        " MacOSX/Linux
	 " let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d'  " Windows

	 "Show hidden files in NerdTree
	 let NERDTreeShowHidden=1

	 "autopen NERDTree
	 autocmd VimEnter * NERDTree
	 "focus cursor in new document
	 autocmd VimEnter * wincmd p
	 "close NERDTree if it's the only buffer left open
	 autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

	 " Not sure whether this is related to indent plugin
	 syntax enable

	 " colorscheme
	 set background=dark
	 colorscheme solarized

	 " settings for Syntastic, the syntax helper
	 let g:syntastic_mode_map = { 'mode': 'active',
		\ 'active_filetypes': [],
		\ 'passive_filetypes': [] }

	 " use jshint and jscs for javascript
	 let g:syntastic_javascript_checkers = ['jscs', 'jshint']

	 " make Syntastic work with ng-whatever from angular
	 let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"," proprietary attribute \"required"," proprietary attribute \"novalidate"]

	 " show line numbers by default
	 set number

 " ***********************
 " Help
 " ***********************
	 " # Vundle:
	 " :PluginList          - list configured bundles
	 " I don't know what the exclamation point means
	 " :PluginInstall(!)    - install(update) bundles
	 " :PluginSearch(!) foo - search(or refresh cache first) for foo
	 " :PluginClean(!)      - confirm(or auto-approve) removal of unused bundles
	 "
	 " see :h vundle for more details or wiki for FAQ
	 " NOTE: comments after Plugin command are not allowed.
	 " 
	 " # Refresh vimrc: 
	 " so $MYVIMRC
