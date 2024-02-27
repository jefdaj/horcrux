{
  pkgs ? import <nixpkgs> { system = "x86_64-linux"; }
}:

let
  horcrux = pkgs.callPackage ./package.nix {};

in pkgs.dockerTools.buildLayeredImage {
  name = "horcrux";
  config = {
    Cmd = [ "${horcrux}/bin/horcrux" ];
  };
}
