# Declarative Package Management for macOS and Linux
# https://nixos.org/nixpkgs/manual/#sec-declarative-package-management
# https://nixos.org/nix/manual/#ssec-relnotes-1.6.0

# Install with this command:
# nix-env -f ariutta.nix -ri
#
# tosheets needs to get permission the first time it runs. Dummy command to make this happen:
# seq 1 10 | tosheets -c B4 --new-sheet=sample-spread-sheet-id-23sdf32543fs
# if browser is on a different machine, may need to use --noauth_local_webserver

# TODO: move these over to Nix:
# brew list
# brew cask list
# pip2 list

with import <nixpkgs> {config.vim.ftNix = false;};
let
  python = import ./tosheets/requirements.nix { inherit pkgs; };
  stablepkgs = import <stablepkgs> {};
  unstablepkgs = import <unstablepkgs> {};
  localpkgs = import ./Documents/nixpkgs {};
  vim = import ./vim.nix;
in [
  stablepkgs.jq
  stablepkgs.wget
  stablepkgs.irssi
  # Should I use pkgs (from nixpkgs) AND unstable pkgs?
  pkgs.nix-repl
  unstablepkgs.nox
  unstablepkgs.pypi2nix
  python.packages."tosheets"
  localpkgs.keepassxc
  vim
]
