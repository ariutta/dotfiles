# Declarative Package Management for macOS and Linux
# https://nixos.org/nixpkgs/manual/#sec-declarative-package-management
# https://nixos.org/nix/manual/#ssec-relnotes-1.6.0

# Possibly related:
# https://rycee.net/posts/2017-07-02-manage-your-home-with-nix.html
# https://unix.stackexchange.com/questions/369234/how-to-configure-a-nix-environment-outside-of-nixos
# https://github.com/ashgillman/dotfiles2/blob/master/install-ubuntu.sh

# See README.md for instructions on installing/updating.

with import <nixpkgs> {config.vim.ftNix = false;};
let
  toSheetsPythonPkgs = import ./custom/tosheets/requirements.nix { inherit pkgs; };
  nixos = import <nixos> {};
  # pkgs (from nixpkgs) is from https://nixos.org/channels/nixpkgs-unstable
  vim = import ./custom/vim.nix;
  perlPackagesCustom = import ./custom/perl-packages.nix { inherit pkgs; }; 
in [
  nixos.irssi
  nixos.jq
  nixos.python36Packages.powerline
  nixos.ripgrep
  nixos.toot
  nixos.wget
  # Not currently installing successfully on macOS
  #pkgs.keepassxc
  pkgs.imagemagick
  pkgs.nix-repl
  pkgs.nox
  pkgs.pypi2nix
  pkgs.shellcheck
  pkgs.python36Packages.autopep8
  pkgs.python36Packages.sqlparse
  toSheetsPythonPkgs.packages."tosheets"
  perlPackagesCustom.pgFormatter
  vim
] ++ (if stdenv.isDarwin then [] else [])
# ++ (if stdenv.isDarwin then [] else [nixos.xterm nixos.i3])
