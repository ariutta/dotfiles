""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" enable the settings that only work with my plugins, extensions, etc.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

colorscheme gruvbox

" make csv.vim recognize the pound sign as indicating a comment
let g:csv_comment = '#'

" Adding CLI deps for Neoformat and ALE.
" In default.nix, we specify replacing CUSTOM_PATH_REPLACE_ME with a
" PATH variable containing the bin dir of each dep in ./buildInputs.
" In here, we add that variable to vim's runtimepath, which is
" essentially the PATH variable active inside vim.
" TODO is this option a good way to handle this issue? See issue
" https://github.com/NixOS/nixpkgs/issues/41613#issuecomment-396074416
exe 'set rtp+=' . expand("CUSTOM_PATH_REPLACE_ME")
" The line above is similar to the one below, but it's better, because
" it avoids conflicts it by essentially namespacing it under vim:
"let $PATH = "CUSTOM_PATH_REPLACE_ME" . ':' . $PATH

" this makes pyls and its plugins work:
let $PATH = $PATH . ':' . "CUSTOM_PATH_REPLACE_ME"

" Powerline:
" add bindings to Vim's runtimepath:
" default.nix handles replacing POWER_LINE_VIM_PATH_REPLACE_ME
exe 'set rtp+=' . expand("POWER_LINE_VIM_PATH_REPLACE_ME")
""""""""""""""""""""""""""""""""
" Neoformat: auto-format on save
""""""""""""""""""""""""""""""""
let g:neoformat_enabled_css = ['prettier']
let g:neoformat_enabled_html = ['js-beautify --html']
let g:neoformat_enabled_javascript = ['prettier']
let g:neoformat_enabled_markdown = ['prettier']
let g:neoformat_enabled_json = ['jq']

let g:neoformat_enabled_php = ['phpcsfixer']
" TODO look at using phpcbf vs. phpcsfixer. (NOTE: phpcbf not currently a supported option for Neoformat.)
" https://github.com/squizlabs/PHP_CodeSniffer
"
"let g:neoformat_enabled_php = ['phpcbf']
"
" This worked from the command line:
" phpcbf --standard="$(nix-env -q --out-path --no-name 'composer-mediawiki-mediawiki-codesniffer')/share/php/composer-mediawiki-mediawiki-codesniffer/vendor/mediawiki/mediawiki-codesniffer/MediaWiki/ruleset.xml" ../../wow.php

let g:neoformat_enabled_python = ['black']
let g:neoformat_enabled_sh = ['shfmt']
let g:neoformat_enabled_typescript = ['prettier']
let g:neoformat_enabled_xml = ['tidy']

" TODO sqlformat (from sqlparse) messes up CREATE TABLE statements:
" https://github.com/andialbrecht/sqlparse/issues/360
" So I added pg_format (from pgFormatter) as an option for Neoformat.
" But the version of Neoformat in Nixpkgs hasn't
" been updated yet to use my update.
" Watch for the neoformat expression to be updated to anything after Apr. 20
"   <https://github.com/NixOS/nixpkgs/blob/master/pkgs/misc/vim-plugins/default.nix#L2283>
" then enable the following line:
"let g:neoformat_enabled_sql = ['pg_format']
" And add *.sql to the list of file extensions for Neoformat

" Autoformat on save for filetypes specified:
autocmd BufWritePre *.css,*.html,*.js,*.jsx,*.json,*.md,*.php,*.py,*.sh,*.ts,*.tsx,*.xml Neoformat

"""""""""""""""""""""""""""""""
" ALE: check syntax and fix code
"""""""""""""""""""""""""""""""

" ctrl-k for previous error
" ctrl-j for next error
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Do not lint or fix minified files.
let g:ale_pattern_options = {
\ '\.min\.js$': {'ale_linters': [], 'ale_fixers': []},
\ '\.min\.css$': {'ale_linters': [], 'ale_fixers': []},
\ '\.py$': {'ale_linters': ['flake8', 'pyls'], 'ale_fixers': ['isort', 'black']},
\}

"\ '\.py$': {'ale_linters': ['flake8', 'pylint', 'pyls'], 'ale_fixers': ['isort', 'black']},
"\ '\.py$': {'ale_linters': ['flake8', 'pylint', 'pyls'], 'ale_fixers': ['isort', 'yapf', 'black']},

"" Python Language Server (pyls)
"" https://github.com/palantir/python-language-server
"" handles the following automatically:
""rope
""pyflakes
""mccabe
""pycodestyle
""pydocstyle
""autopep8
""YAPF
"" and the following w/ plugins installed:
""pyls-mypy
""pyls-isort
""pyls-black
"" It does not handle the following:
""flake8
""pylint

"Available Linters: ['bandit', 'flake8', 'mypy', 'prospector', 'pycodestyle', 'pydocstyle', 'pyflakes', 'pylama', 'pylint', 'pyls', 'pyre', 'vulture']
"  Enabled Linters: ['flake8', 'mypy', 'pylint']
" Suggested Fixers:
"  'add_blank_lines_for_python_control_statements' - Add blank lines before control statements.
"  'autopep8' - Fix PEP8 issues with autopep8.
"  'black' - Fix PEP8 issues with black.
"  'isort' - Sort Python imports with isort.
"  'remove_trailing_lines' - Remove all blank lines at the end of a file.
"  'reorder-python-imports' - Sort Python imports with reorder-python-imports.
"  'trim_whitespace' - Remove all trailing whitespace characters at the end of every line.
"  'yapf' - Fix Python files with yapf.

" E501: Black's default line length is 88 chars, but it will
" sometimes make long lines, e.g.: 119 chars
" https://github.com/python/black#line-length
" W503: black doesn't follow this.
let g:ale_python_flake8_options="--ignore=E501,W503"
"let g:ale_python_pycodestyle_options="--max-line-length=120"
"let g:ale_python_pycodestyle_options="--ignore=E501,W503"
"let g:ale_python_pyls_options="--ignore=E501,W503"
"let g:ale_python_pyls_use_global = 1

" Call shellcheck with param to follow files
let g:ale_sh_shellcheck_options = "-x"

"" Python Language Server <https://github.com/palantir/python-language-server>
"" handles the following automatically:
""rope
""pyflakes
""mccabe
""pycodestyle
""pydocstyle
""autopep8
""YAPF
"" and the following w/ plugins installed:
""pyls-mypy
""pyls-isort
""pyls-black
"" It does not handle the following:
""flake8
""pylint
""

"""""""""""""""""""""""""
" CtrlP: better searching
"""""""""""""""""""""""""
" Use the C extension for matching:
let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }
" Add commands for initiating CtrlP:
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" Tell CtrlP which files to ignore.
" This is for Mac/Linux. For Windows, see https://github.com/ctrlpvim/ctrlp.vim.
set wildignore+=*/tmp/*,*.so,*.swp,*.zip

"let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
			\ 'dir':  '\v[\/]\.(git|hg|svn)$',
			\ 'file': '\v\.(exe|so|dll)$',
			\ 'link': 'some_bad_symbolic_links',
			\ }
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Refactor
""
"" We want to be able to rename variables, but YCM only works for
"" the filetypes ['java', 'javascript', 'typescript', 'rust']. 
""
"" LanguageClient-neovim works for Python.
"" https://github.com/autozimu/LanguageClient-neovim
""
"" The following section is a wrapper to try handling
"" all filetypes with a unified API.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"call LanguageClient#setDiagnosticsList("Quickfix")
"let g:LanguageClient_serverCommands = {
"  \ 'python': ['pyls']
"  \ }
"  "\ 'python': ['PYLS_PATH_REPLACE_ME' . '/pyls']
"
"function! RefactorRenameYcm()
"  call inputsave()
"  let new_name = input('Rename to: ')
"  call inputrestore()
"  execute 'YcmCompleter RefactorRename ' . new_name
"endfunction
"
"function! RefactorRenameOther()
"  let old_name = expand("<cword>")
"  call inputsave()
"  let new_name = input('Rename to: ')
"  call inputrestore()
"  " only replacing when old_name matches the whole word.
"  execute '%s#\<' . old_name . '\>#' . new_name . '#g'
"endfunction
"
"function RefactorRenameGeneric()
"	if has_key(g:LanguageClient_serverCommands, &filetype)
"		nnoremap <buffer> <silent> <leader>r :call LanguageClient#textDocument_rename()<CR>
"	elseif (index(['java', 'javascript', 'typescript', 'rust'], &filetype) > 0)
"		nnoremap <buffer> <silent> <leader>r :call RefactorRenameYcm()<CR>
"	else
"		nnoremap <buffer> <silent> <leader>r :call RefactorRenameOther()<CR>
"	endif
"endfunction
"
"autocmd FileType * call RefactorRenameGeneric()
