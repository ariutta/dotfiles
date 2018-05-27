# TODO which of the following lines is best?
#with import <nixpkgs> { config.vim.ftNix = false; };
#{ nixpkgs ? import <nixpkgs> { config.vim.ftNix = false; } }:
{ pkgs, callPackage }:

let
  # TODO specifying black here doesn't put it on the path. Neither does
  # adding it to propagatedBuildInputs or most of the other options
  # (I think I tried all of them).
  # But black needs to be on the path to work with Neoformat.
  # (Although the docs for black seem to say it's faster to run it without
  # calling the CLI? Should I be using it without Neoformat?)
  # For now, I'm using a hack by specifying
  # black in dotfiles/common.nix, but I shouldn't have to do that.
  # More info: https://nixos.org/nixpkgs/manual/#ssec-stdenv-dependencies
  # See also: https://github.com/NixOS/nixpkgs/issues/26146
  black = callPackage ../black/default.nix {}; 
  perlPackagesCustom = callPackage ../perl-packages.nix {}; 

  vim_configured = pkgs.vim_configurable.customize {
      name = "vim";
      vimrcConfig.customRC = builtins.readFile ./.vimrc;

      # Use the default plugin list shipped with nixpkgs
      vimrcConfig.vam.knownPlugins = pkgs.vimPlugins;
      vimrcConfig.vam.pluginDictionaries = [
        { names = [
          # Here you can place all your vim plugins
          # They are installed managed by `vam` (a vim plugin manager)
          # Lookup names at http://vam.mawercer.de/

          # provides nix syntax highlighting, filetype detection and indentation.
          # TODO where should I specify this: { config.vim.ftNix = false; }
          "vim-nix"

          # make vim syntax aware
          "Syntastic"
          # syntax providers (see dependencies in vim_configured.buildInputs)
          "vim-javascript"
          "vim-jsdoc"
          "typescript-vim"

          # format code (see dependencies in vim_configured.buildInputs)
          "neoformat"

          # provides typescript autocomplete, error checking and more.
          "tsuquyomi"

          # autocomplete
          "YouCompleteMe"

          # automatic closing of quotes, parenthesis, brackets, etc.
          # https://github.com/jiangmiao/auto-pairs
          "auto-pairs"

          # type "ysiw]" to surround w/ brackets
          "surround"

          # ctrlp makes it easier to open files, buffers, etc.
          # Call it with :CtrlPMixed or Ctrl+p
          "ctrlp"
          # This C extension speeds up ctrlp's finder
          "ctrlp-cmatcher"

          # git wrapper
          #   For screencasts on how to use:
          #     https://github.com/tpope/vim-fugitive#screencasts
          #   To compare a file across branches:
          #     Gedit master:myfile.txt
          #     Gdiff dev:myfile.txt
          "fugitive"

          # Handle delimited files (.csv, .tsv, etc.)
          #   http://vimawesome.com/plugin/csv-vim
          #   If a file is .txt, tell vim it's delimited with:
          #     :set filetype=csv
          "csv"
        ]; }
      ];
  };
in

vim_configured.overrideAttrs (oldAttrs: {
  buildInputs = vim_configured.buildInputs ++ [
    # Custom Dependencies

    # Deps for Syntastic (Syntax Checker)
    # * sqlint (TODO: install)
    #     https://github.com/purcell/sqlint
    #     Another option: pgsanity (although it's not currently one of the Syntastic-supported options)
    #       https://github.com/markdrago/pgsanity
    pkgs.shellcheck

    # Deps for Neoformat
    pkgs.python36Packages.jsbeautifier
    pkgs.shfmt
    black
    pkgs.python36Packages.sqlparse
    perlPackagesCustom.pgFormatter
    # TODO Create Nix pkg for prettier and install
    # prettier
  ];
})
