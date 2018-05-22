{ pkgs, callPackage }:

#let
#  # pkgs (from nixpkgs) is from https://nixos.org/channels/nixpkgs-unstable
#  vim = import ./vim/default.nix;
#  perlPackagesCustom = import ./perl-packages.nix { inherit pkgs; }; 
#in [
#  vim
#  # vim dependencies:
#  pkgs.python36Packages.autopep8
#  nixos.python36Packages.jsbeautifier
#  pkgs.python36Packages.sqlparse
#  pkgs.shellcheck
#  nixos.shfmt
#  perlPackagesCustom.pgFormatter
#] ++ (if stdenv.isDarwin then [] else [])
## ++ (if stdenv.isDarwin then [] else [nixos.xterm nixos.i3])

#with import ./vim/default.nix {  };
#with import ./vim/default.nix {  };

{

  #inherit vim;
  #vim = pkgs.vim;
  #vim = packageOverrides.vim;
  #vim = vim.vim {};

  #vim = callPackage ./vim/default.nix {  };
  #vim = callPackage ./vim/default.nix {  };
  vim = import ./vim/default.nix;
  #vim = import ./vim1/override.nix;
  #vim = import ./vim/override.nix;
  #vim = callPackage ./tosheets/default.nix {  };
  #vim = ./vim/default.nix {  };
  tosheets = callPackage ./tosheets/default.nix {  };

  # Generate python  using pypi2nix:
  #   For python packages used as applications:
  #   cd custom/tosheets
  #   pypi2nix -V 3 -e tosheets==0.3.0
  #
  #   If I ever need to generate for multiple packages not used as applications:
  #   cd custom/python-packages
  #   pypi2nix -V 3 -e homoglyphs==1.2.5 -e confusable_homoglyphs==3.1.1

}
