# TODO should we use this, or should we use something more like the following line?
with import <nixpkgs> { config.vim.ftNix = false; };
#{ nixpkgs ? import <nixpkgs> {} }:

let
  vim_configured = import ./configured.nix;
  perlPackagesCustom = import ../perl-packages.nix { inherit pkgs; }; 
in

# overrideAttrs appears to allow for updating one or more selected attributes 
vim_configured.overrideAttrs (oldAttrs: {
  buildInputs = vim_configured.buildInputs ++ [
    # TODO test the dependencies (should all be included below)
    pkgs.python36Packages.autopep8
    pkgs.python36Packages.jsbeautifier
    pkgs.python36Packages.sqlparse
    pkgs.shellcheck
    pkgs.shfmt
    perlPackagesCustom.pgFormatter
  ];
})

## we can also specify each attribute to inherit
#stdenv.mkDerivation rec {
#  name = "vim";
#  # not sure why pkgs.vim works here, but vim_configured does not
#  inherit (pkgs.vim) version src postPatch hardeningDisable enableParallelBuilding meta nativeBuildInputs configureFlags postInstall;
#  buildInputs = pkgs.vim.buildInputs ++ [
#    pkgs.python36Packages.autopep8
#  ];
#}

# TODO do we need to use anything below?
#{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghc7102"  }:
#(vim)

#{
#  packageOverrides = pkgs: rec {
#    vim = pkgs.vim.override {
#    };
#    #dependencies = [pkgs.python36Packages.autopep8];
#  };
#}
