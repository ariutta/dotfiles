# TODO should we use this, or should we use something more like the following line?
#with import <nixpkgs> { config.vim.ftNix = false; };
{ nixpkgs ? import <nixpkgs> { config.vim.ftNix = false; } }:

let
  pkgs = nixpkgs.pkgs;
  vim_configured = import ./configured.nix;
  perlPackagesCustom = import ../perl-packages.nix { inherit pkgs; }; 
in

# overrideAttrs appears to allow for updating one or more selected attributes 
vim_configured.overrideAttrs (oldAttrs: {
  buildInputs = vim_configured.buildInputs ++ [
    # Dependencies for my vim plugins
    # TODO test the dependencies below. Do I have them all?
    pkgs.python36Packages.autopep8
    pkgs.python36Packages.jsbeautifier
    pkgs.python36Packages.sqlparse
    pkgs.shellcheck
    pkgs.shfmt
    perlPackagesCustom.pgFormatter
  ];
})
