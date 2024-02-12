let
  # nixpkgs = import (builtins.fetchTarball {
  #   name = "nixos-unstable-2023-03-15";
  #   url = "https://github.com/nixos/nixpkgs/archive/eec97855384951087980a9596af6f69a0e0bdfa1.tar.gz";
  #   sha256 = "0v13l0rwlg4g0pxbsg2nj823pkv9my6p6zfjnf018d3d0npz6b8i";
  # }) {};
  nixpkgs = import <nixpkgs> {};

in nixpkgs.pkgs.callPackage ./. {}
