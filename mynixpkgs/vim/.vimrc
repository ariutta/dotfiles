""""""""""""""""""""""""""""""""""""""""""""""""
" Enable the Vim settings that work everywhere
" ----------------------------------------------
" Can apply at least some of my Vim settings for
" any machine by setting this file as ~/.vimrc.
" https://raw.githubusercontent.com/ariutta/mynixpkgs/master/vim/.vimrc
" curl '<url>' >~/.vimrc
""""""""""""""""""""""""""""""""""""""""""""""""

" nocompatible means Vim doesn't have to support
" backwards compatibility with Vi.
" Usually this line does nothing.
set nocompatible               " be iMproved
set encoding=utf-8

" Detect filetype and use indent plugin
filetype plugin indent on

syntax enable
set background=dark

" make status bar always show:
set laststatus=2

" make backspace behave 'normally'
set backspace=indent,eol,start

" show line numbers by default
set number

"******************
" Key Mappings
"******************

" Quickly type 'jk' to leave insert mode
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

" Run the current file. Default <leader> is "\".
nnoremap <leader>r :!clear; "%:p"<Enter>

" In the quickfix window, <CR> is used to jump to the error under the
" cursor, so undefine the mapping there.
" from http://superuser.com/questions/815416/hitting-enter-in-the-quickfix-window-doesnt-work
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>

autocmd Filetype * setlocal tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
autocmd Filetype python setlocal tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab

" JS/TS/JSON indent settings: match prettier defaults
autocmd Filetype javascript setlocal tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
autocmd Filetype typescript setlocal tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
autocmd Filetype json setlocal tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab

" makefiles need to use tabs: https://stackoverflow.com/a/9007018
autocmd FileType make setlocal noexpandtab

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable the settings that only work with my plugins, extensions, etc.
" --------------------------------------------------------------------
" Note: The section below isn't relevant to the Nix package, because
" default.nix just concatenates .vimrc and custom.vim and passing the
" result as a string to 'vimrcConfig.customRC'.
" But I'm leaving the section below in here anyway for now as an
" example of how this could work for a non-Nix package.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" The 's' prefix indicates a script-variable. For more info, run ':h s:'.
" Get script dir (safe for symlinks): https://stackoverflow.com/a/18734557
let s:custom_vim_settings_path = fnamemodify(resolve(expand('<sfile>:p')), ':h') . '/custom.vim'
if filereadable(s:custom_vim_settings_path)
  exec "source " . s:custom_vim_settings_path
endif
