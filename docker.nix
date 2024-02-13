{ pkgs ? import <nixpkgs> { }
, pkgsLinux ? import <nixpkgs> { system = "x86_64-linux"; }
}:

let horcrux = pkgs.callPackage ./default.nix {};

# TODO buildLayeredImage?
in pkgs.dockerTools.buildImage {
  name = "horcrux";
  config = {
    Cmd = [ "${horcrux}/bin/horcrux" ];
  };
}
