# Declarative Package Management for macOS and Linux
# https://nixos.org/nixpkgs/manual/#sec-declarative-package-management
# https://nixos.org/nix/manual/#ssec-relnotes-1.6.0

# Possibly related:
# https://rycee.net/posts/2017-07-02-manage-your-home-with-nix.html
# https://unix.stackexchange.com/questions/369234/how-to-configure-a-nix-environment-outside-of-nixos
# https://github.com/ashgillman/dotfiles2/blob/master/install-ubuntu.sh

# See README.md for instructions on installing/updating.


#{ stdenv, fetchurl, autoreconfHook, zlib, pcre, w3m, man }:

with import <nixpkgs> {config.vim.ftNix = false;};
let
  nixos = import <nixos> {};
  privoxyCustom = import ./custom/privoxy/privoxy-darwin.nix { inherit stdenv fetchurl autoreconfHook zlib pcre w3m man; }; 
in [
  nixos.pgmanage
  # TODO get standard privoxy to work on both linux and darwin
  #pkgs.privoxy
  privoxyCustom
  # Not currently installing successfully on macOS
  #pkgs.keepassxc
] ++ (if stdenv.isDarwin then [] else [])
