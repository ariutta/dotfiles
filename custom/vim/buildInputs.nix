###################################################
# Dependencies for my customized Vim configuration.
#
# See my comments in ./default.nix regarding issue
# https://github.com/NixOS/nixpkgs/issues/26146
###################################################

with import <nixpkgs> { config.allowUnfree = true; };
let
  custom = callPackage ../all-custom.nix {};
in [
  pkgs.python3
  ####################
  # Deps for Neoformat
  ####################
  custom.black
  pkgs.html-tidy
  custom.perlPackages.pgFormatter
  pkgs.nodePackages.prettier
  pkgs.php72Packages.php-cs-fixer
  pkgs.python36Packages.flake8
  pkgs.python36Packages.jsbeautifier
  pkgs.python36Packages.pylint

  # sqlparse is on the command line as sqlformat.
  # It fails for some standard sql expressions (maybe CREATE TABLE?).
  pkgs.python36Packages.sqlparse

  pkgs.shfmt

  #####################################
  # Deps for Syntastic (Syntax Checker)
  #####################################
  custom.mediawiki-codesniffer
  # TODO phpcs is installed by mediawiki-codesniffer. Should we still use the following line?
  #pkgs.php72Packages.phpcs

  # TODO look into using phpstan with Syntastic:
  # https://github.com/vim-syntastic/syntastic/blob/master/syntax_checkers/php/phpstan.vim
  # I need to create a Nix expression for installing phpstan.
  # TODO Should phpstan be in addition to phpcs? Does phpstan conflict with the MW styleguide?

  pkgs.nodePackages.eslint

  # TODO pgsanity is not currently supported by Syntastic.
  #      Is it worth adding it? Or should we just rely on sqlint?
  #      Both pgsanity and sqlint currently only support PostgreSQL.
  #      https://github.com/markdrago/pgsanity
  #custom.pgsanity

  pkgs.shellcheck
  custom.sqlint
]
