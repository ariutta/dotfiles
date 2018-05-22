{ pkgs }:

pkgs.vim_configurable.customize {
    # Specifies the vim binary name.
    # E.g. set this to "my-vim" and you need to type "my-vim" to open this vim
    # This allows to have multiple vim packages installed (e.g. with a different set of plugins)
    name = "vim";
    vimrcConfig.customRC = ''
	"# Here one can specify what usually goes into `~/.vimrc` 
	" nocompatible means Vim doesn't have to support
	" backwards compatibility with Vi.
	" Usually this line does nothing.
	set nocompatible               " be iMproved
  set encoding=utf-8

	 " Detect filetype and use indent plugin
	 filetype plugin indent on

	" enable syntax highlighting?
	syntax enable

	 " make backspace behave 'normally'
	 set backspace=indent,eol,start

	 " show line numbers by default
	 set number

   "******************
   " Key Mappings
   "******************

	 " Typing 'jk' quickly leaves insert mode
	 inoremap jk <Esc>

	 " disable arrow keys
	 map <up> <nop>
	 map <down> <nop>
	 map <left> <nop>
	 map <right> <nop>
	 imap <up> <nop>
	 imap <down> <nop>
	 imap <left> <nop>
	 imap <right> <nop>

   " Neoformat: auto-format on save (e.g., apply prettier to *.ts files)
	 " TODO: install prettier
   let g:neoformat_enabled_html = ['js-beautify --html']
   let g:neoformat_enabled_python = ['autopep8']
   let g:neoformat_enabled_sh = ['shfmt']
   let g:neoformat_enabled_sql = ['pg_format']
	 autocmd BufWritePre *.html,*.js,*.jsx,*.json,*.py,*.sh,*.sql,*.ts,*.tsx Neoformat

	 " make csv.vim recognize the pound sign as indicating a comment
	 " TODO: install csv.vim and re-enable this
	 "let g:csv_comment = '#'

	 " In the quickfix window, <CR> is used to jump to the error under the
	 " cursor, so undefine the mapping there.
	 " from http://superuser.com/questions/815416/hitting-enter-in-the-quickfix-window-doesnt-work
	 autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

	 " settings for Syntastic, the syntax helper
	 let g:syntastic_mode_map = { 'mode': 'active',
		\ 'active_filetypes': ['nix'],
		\ 'passive_filetypes': [] }
	 " Enable this option to tell syntastic to always stick any detected
	 " errors into the loclist:
	 let g:syntastic_always_populate_loc_list=1
	 " TypeScript checkers
	 " Make tsuquyomi output display in syntastic gutter (disabled now bc it freezes vim for minutes)
	 "let g:tsuquyomi_disable_quickfix = 1
	 let g:syntastic_typescript_checkers = ['tsuquyomi']
	 " I'm not using tslint at present
	 "let g:syntastic_typescript_checkers = ['tslint']

	 let g:syntastic_nix_checkers = ['nix']

	 " use eslint for javascript
	 " install eslint with "npm install -g eslint"
	 let g:syntastic_javascript_checkers = ['eslint']
	 " strangely, when g:tsuquyomi_disable_quickfix is set to 1, I needed
	 " to add tsuquyomi as below to make the errors to show in the gutter
	 "let g:syntastic_javascript_checkers = ['eslint', 'tsuquyomi']
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
   " make syntastic call shellcheck with param to follow files
   let g:syntastic_sh_shellcheck_args = "-x"

	 " Make ctrlp use the C extension for matching
	 let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }
	 " add commands for initiating CtrlP
	 let g:ctrlp_map = '<c-p>'
	 let g:ctrlp_cmd = 'CtrlP'
	 " ignore files for CtrlP (Mac/Linux)
	 " (For Windows, see https://github.com/ctrlpvim/ctrlp.vim)
	 set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux

	 let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
	 let g:ctrlp_custom_ignore = {
				 \ 'dir':  '\v[\/]\.(git|hg|svn)$',
				 \ 'file': '\v\.(exe|so|dll)$',
				 \ 'link': 'some_bad_symbolic_links',
				 \ }
	 let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
    '';
    # Use the default plugin list shipped with nixpkgs
    vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
    #vimrcConfig.vam.knownPlugins = super.vimPlugins;
    vimrcConfig.vam.pluginDictionaries = [
      { names = [
        # Here you can place all your vim plugins
        # They are installed managed by `vam` (a vim plugin manager)
        # Lookup names at http://vam.mawercer.de/
        #
        # provides nix syntax highlighting, filetype detection and indentation.
        "vim-nix"
        #
        # make vim syntax-aware
        "Syntastic"
        # syntax providers:
        "vim-javascript"
        "vim-jsdoc"
        "typescript-vim"
        #
        # automatic closing of quotes, parenthesis, brackets, etc.
        # https://github.com/jiangmiao/auto-pairs
        "auto-pairs"
        #
        # ctrlp makes it easier to open files, buffers, etc.
        # Call it with :CtrlPMixed or Ctrl+p
        "ctrlp"
        # This C extension speeds up ctrlp's finder
        "ctrlp-cmatcher"
        #
        # format code
        "neoformat"
        # See dependencies at top of this file.
        #
        # type "ysiw]" to surround w/ brackets
        "surround"
        #
        # provides typescript autocomplete, error checking and more.
        "tsuquyomi"
        #
        # git wrapper
        #   For screencasts on how to use:
        #     https://github.com/tpope/vim-fugitive#screencasts
        #   To compare a file across branches:
        #     Gedit master:myfile.txt
        #     Gdiff dev:myfile.txt
        "fugitive"
        #
        # autocomplete
        "YouCompleteMe"
        #
        # Handle delimited files (.csv, .tsv, etc.)
        #   http://vimawesome.com/plugin/csv-vim
        #   If a file is .txt, tell vim it's delimited with:
        #     :set filetype=csv
        "csv"
      ]; }
    ];
}
