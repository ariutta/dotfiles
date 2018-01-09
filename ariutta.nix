# Declarative Package Management for macOS and Linux
# https://nixos.org/nixpkgs/manual/#sec-declarative-package-management
# https://nixos.org/nix/manual/#ssec-relnotes-1.6.0

# See README.md for instructions on installing/updating.

with import <nixpkgs> {config.vim.ftNix = false;};
let
  python = import ./tosheets/requirements.nix { inherit pkgs; };
  stablepkgs = import <stablepkgs> {};
  # pkgs (from nixpkgs) is from https://nixos.org/channels/nixpkgs-unstable
  localpkgs = import ./Documents/nixpkgs {};
  vim = import ./vim.nix;
in [
  stablepkgs.jq
  stablepkgs.wget
  stablepkgs.irssi
  stablepkgs.ripgrep
  pkgs.keepassxc
  pkgs.nix-repl
  pkgs.nox
  pkgs.pypi2nix
  pkgs.shellcheck
  python.packages."tosheets"
  vim
]
