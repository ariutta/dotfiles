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
	 filetype off                   " required!

	 set rtp+=~/.vim/bundle/Vundle.vim/
	 call vundle#begin()

	 " let Vundle manage Vundle
	 " required! 
	 Plugin 'gmarik/Vundle.vim'

	 " ***********************
	 " original repos on github
	 " ***********************
	 Plugin 'othree/html5.vim'

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
	 " Before running :PluginInstall, it may be necessary
	 " 	to set which python to use, as describe here:
	 " http://stackoverflow.com/questions/11148403/homebrew-macvim-with-python2-7-3-support-not-working/12697440#12697440
	 " After running :PluginInstall, you need to compile it (at least on OS X)
	 "	 ~/.vim/bundle/YouCompleteMe/install.sh --clang-completer
	 " or if that command gives an error, try telling it to use the system libclang:
	 " ~/.vim/bundle/YouCompleteMe/install.sh --clang-completer --system-libclang
	 Plugin 'Valloric/YouCompleteMe'

	 Plugin 'moll/vim-node'

	 " ctrlp makes it easier to open files, buffers, etc.
	 " Call it with :CtrlPMixed or Ctrl+p
	 Plugin 'kien/ctrlp.vim'
	 " This C extension speeds up ctrlp's finder.
	 " After running PluginInstall, you need to finish installation,
	 " as described here:
	 " https://github.com/JazzCore/ctrlp-cmatcher/
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

	 call vundle#end()
 
	 " Indent plugin
	 filetype plugin indent on     " required!

 " ***********************
 " My custom additions to .vimrc
 " ***********************

 	 " riotjs .tag files are best handled as html files
	 " for syntax checking and highlighting
	 autocmd BufRead,BufNewFile *.tag set filetype=html

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
	 set wildignore+=*/.git/*,*.git,*/node_modules/*,*/frontend\/lib/*     " All
	 set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
	 "set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
	 let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
	 " Use a custom file listing command
	 "let g:ctrlp_user_command = 'find %s -type f'        " MacOSX/Linux
	 " let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d'  " Windows

	 "Show hidden files in NerdTree
	 let NERDTreeShowHidden=1

	 "autopen NERDTree
	 autocmd VimEnter * NERDTree
	 "focus cursor in new document
	 autocmd VimEnter * wincmd p
	 " Open NERDTree with CTRL-n
	 map <C-n> :NERDTreeToggle<CR>
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
	 " install jscs with "npm install -g jscs"
	 " and jshint with "npm install -g jshint"
	 let g:syntastic_javascript_checkers = ['jscs', 'jshint']

	 " checking JS in HTML appears to be working. Not sure
	 " whether it was this line below, or whether it was
	 " running this:
	 " jshint --extract=always ./demo/wikipathways-pathvisiojs.tag
	 " http://jshint.com/docs/cli/
	 " or maybe even this from in Vim when a tag file was open:
	 " setfiletype html.javascript
	 let g:syntastic_html_checkers = ['jscs', 'jshint']

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
				 \ "<style isn't allowed in <wikipathways-pathvisiojs> elements",
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
				 \ "wikipathways-pathvisiojs",
				 \ ]
	 let g:syntastic_html_tidy_inline_tags=[]
	 let g:syntastic_html_tidy_empty_tags=["i"]

	 " show line numbers by default
	 set number

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
	 " :so $MYVIMRC
