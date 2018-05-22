# Declarative Package Management for macOS and Linux
# https://nixos.org/nixpkgs/manual/#sec-declarative-package-management
# https://nixos.org/nix/manual/#ssec-relnotes-1.6.0

# Possibly related:
# https://rycee.net/posts/2017-07-02-manage-your-home-with-nix.html
# https://unix.stackexchange.com/questions/369234/how-to-configure-a-nix-environment-outside-of-nixos
# https://github.com/ashgillman/dotfiles2/blob/master/install-ubuntu.sh

# See README.md for instructions on installing/updating.

# TODO should config.vim.ftNix go here or in all-custom.nix?
#with import <nixpkgs> { config.vim.ftNix = false; config.allowUnfree = true; };
with import <nixpkgs> { config.vim.ftNix = false; };
let
  nixos = import <nixos> {};
  custom = import ./custom/all-custom.nix { inherit pkgs callPackage; };
in [
  custom.tosheets
  #custom.vim
  nixos.irssi
  nixos.jq
  nixos.lynx
  nixos.python36Packages.powerline
  nixos.ripgrep
  nixos.toot
  nixos.wget
  pkgs.pypi2nix
  # Not currently installing successfully on macOS
  #pkgs.keepassxc
  pkgs.imagemagick
  pkgs.nix-repl
  pkgs.nox
] ++ (if stdenv.isDarwin then [] else [])
