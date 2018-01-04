# Declarative Package Management for macOS and Linux
# https://nixos.org/nixpkgs/manual/#sec-declarative-package-management
# https://nixos.org/nix/manual/#ssec-relnotes-1.6.0

# Install with this command:
# nix-env -f ariutta.nix -ri

# move these over to Nix:
# brew list
# brew cask list
# pip2 list

with import <nixpkgs> {config.vim.ftNix = false;};
let
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
  localpkgs.keepassxc
  vim
]
