{
  pkgs ? import <nixpkgs> { system = "x86_64-linux"; }
}:

let
  horcrux = pkgs.callPackage ./package.nix {};

# TODO buildLayeredImage?
in pkgs.dockerTools.buildImage {
  name = "horcrux";
  config = {
    Cmd = [ "${horcrux}/bin/horcrux" ];
  };
}
