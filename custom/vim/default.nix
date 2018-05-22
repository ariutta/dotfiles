# TODO which of the following lines is best?
#with import <nixpkgs> { config.vim.ftNix = false; };
#{ nixpkgs ? import <nixpkgs> { config.vim.ftNix = false; } }:
{ pkgs, callPackage }:

let
  vim_configured = callPackage ./configured.nix {};
  perlPackagesCustom = callPackage ../perl-packages.nix {}; 
in

vim_configured.overrideAttrs (oldAttrs: {
  buildInputs = vim_configured.buildInputs ++ [
    # Dependencies for my vim plugins
    # TODO test the dependencies below. Do I have them all?
    # Syntastic dependencies:
    # * sqlint (TODO: install)
    #     https://github.com/purcell/sqlint
    #     Another option: pgsanity (although it's not currently one of the Syntastic-supported options)
    #       https://github.com/markdrago/pgsanity
    # neoformat dependencies:
    # * nixos.python36Packages.jsbeautifier
    # * nixos.shfmt
    # * prettier (TODO: install)
    # * pkgs.python36Packages.autopep8
    # * nixos.python36Packages.sqlparse
    # * https://github.com/darold/pgFormatter
    pkgs.python36Packages.autopep8
    pkgs.python36Packages.jsbeautifier
    pkgs.python36Packages.sqlparse
    pkgs.shellcheck
    pkgs.shfmt
    perlPackagesCustom.pgFormatter
  ];
})
