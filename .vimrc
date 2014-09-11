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

 " My Plugins here:
 "
 " original repos on github
 Plugin 'jelera/vim-javascript-syntax'
 Plugin 'heavenshell/vim-jsdoc'
 Plugin 'marijnh/tern_for_vim'
 	" to finish installing tern, cd to wherever .vim/bundle/tern_for_vim/
	" is located and then run 'npm install'
 Plugin 'nathanaelkane/vim-indent-guides'
 Plugin 'Raimondi/delimitMate'
 Plugin 'altercation/vim-colors-solarized'
 Plugin 'scrooloose/nerdtree'
 Plugin 'tpope/vim-fugitive'
 Plugin 'tpope/vim-abolish'
 Plugin 'Lokaltog/vim-easymotion'
 Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
 Plugin 'pangloss/vim-javascript'
 Plugin 'elzr/vim-json'
 Plugin 'hail2u/vim-css3-syntax'
 Plugin 'tpope/vim-surround'
 Plugin 'ariutta/Css-Pretty'
 Plugin 'Valloric/YouCompleteMe'
 	" to finish installation, it may be necessary to set which python to
	" use like this:
	" http://stackoverflow.com/questions/11148403/homebrew-macvim-with-python2-7-3-support-not-working/12697440#12697440
 Plugin 'moll/vim-node'
 " vim-scripts repos
 Plugin 'L9'
 Plugin 'FuzzyFinder'
 Plugin 'Syntastic'
 Plugin 'keepcase.vim'
 
 " non github repos
 	" helper for opening files. start it with \t
 Plugin 'git://git.wincent.com/command-t.git'
	 " :q closes NERDtree
 Plugin 'https://gist.github.com/8290763.git'
 " git repos on your local machine (ie. when working on your own plugin)
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

 " Add newline with Ctrl-C
 let delimitMate_expand_cr = 1

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

 " make Syntastic work with ng-whatever from angular
 let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"," proprietary attribute \"required"," proprietary attribute \"novalidate"]

 " show line numbers by default
 set number

 " ***********************
 " Help
 " ***********************
 "
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
