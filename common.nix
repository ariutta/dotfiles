# Declarative Package Management for macOS and Linux
# https://nixos.org/nixpkgs/manual/#sec-declarative-package-management
# https://nixos.org/nix/manual/#ssec-relnotes-1.6.0

# Possibly related:
# https://rycee.net/posts/2017-07-02-manage-your-home-with-nix.html
# https://unix.stackexchange.com/questions/369234/how-to-configure-a-nix-environment-outside-of-nixos
# https://github.com/ashgillman/dotfiles2/blob/master/install-ubuntu.sh

# See README.md for instructions on installing/updating.

# TODO Where should config.vim.ftNix be specified? Here? In custom/all-custom.nix?
with import <nixpkgs> { config.vim.ftNix = false; config.allowUnfree = true; };
let
  nixos = import <nixos> {};
  custom = callPackage ./custom/all-custom.nix {};
in [
  # TODO see TODO in ./custom/vim/default.nix regarding black
  custom.black
  custom.tosheets
  custom.vim
  nixos.jq
  nixos.python36Packages.powerline
  nixos.ripgrep
  nixos.wget
  # NOTE: pkgs means nixpkgs.pkgs
  pkgs.pypi2nix
  pkgs.nix-repl
  pkgs.nox
] ++ (if stdenv.isDarwin then [] else [])
