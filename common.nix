# Declarative Package Management for macOS and Linux
# https://nixos.org/nixpkgs/manual/#sec-declarative-package-management
# https://nixos.org/nix/manual/#ssec-relnotes-1.6.0

# Possibly related:
# https://rycee.net/posts/2017-07-02-manage-your-home-with-nix.html
# https://unix.stackexchange.com/questions/369234/how-to-configure-a-nix-environment-outside-of-nixos
# https://github.com/ashgillman/dotfiles2/blob/master/install-ubuntu.sh

# See README.md for instructions on installing/updating.

with import <nixpkgs> { config.allowUnfree = true; };
let
  nixos = import <nixos> { config.allowUnfree = true; };
  custom = callPackage ./custom/all-custom.nix {};
in [
  # TODO see comment in ./custom/vim/default.nix regarding black
  custom.black
  # TODO same issue as described for custom.black
  #pkgs.nodePackages.prettier

  custom.tosheets
  custom.vim
  nixos.jq
  nixos.gettext
  nixos.ripgrep

  # NOTE: pkgs means nixpkgs.pkgs
  pkgs.pypi2nix
  pkgs.python36Packages.powerline
  pkgs.nix-repl
  pkgs.nox
  pkgs.nodePackages.node2nix
  pkgs.wget
] ++ (if stdenv.isDarwin then [] else [])
