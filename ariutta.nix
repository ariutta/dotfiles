# Declarative Package Management for macOS and Linux
# https://nixos.org/nixpkgs/manual/#sec-declarative-package-management
# https://nixos.org/nix/manual/#ssec-relnotes-1.6.0

# Install:
# #TODO: I haven't tested the steps below for adding localpkgs
# cd ~/Documents
# git clone git@github.com:ariutta/nixpkgs.git
# cd nixpkgs
# git remote add nixpkgs https://github.com/NixOS/nixpkgs
# cd
# #TODO: verify import <stablepkgs>, etc. uses these channels
# nix-channel --add https://nixos.org/channels/nixpkgs-unstable
# nix-channel --add https://nixos.org/channels/nixos-17.09 stablepkgs
# nix-env -f ariutta.nix -ri
#
# Update:
# nix-channel --update
# nix-env -f ariutta.nix -ri
#
# tosheets needs to get permission the first time it runs.
# Here's a dummy command to trigger this:
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
  # pkgs (from nixpkgs) is from https://nixos.org/channels/nixpkgs-unstable
  localpkgs = import ./Documents/nixpkgs {};
  vim = import ./vim.nix;
in [
  stablepkgs.jq
  stablepkgs.wget
  stablepkgs.irssi
  stablepkgs.ripgrep
  pkgs.nix-repl
  pkgs.nox
  pkgs.pypi2nix
  pkgs.keepassxc
  python.packages."tosheets"
  vim
]
