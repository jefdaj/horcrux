{ pkgs ? import <nixpkgs> { }
, pkgsLinux ? import <nixpkgs> { system = "x86_64-linux"; }
}:

let horcrux = import ./default.nix;

in pkgs.dockerTools.buildImage {
  name = "horcrux";
  config = {
    Cmd = [ "${horcrux}/bin/horcrux" ];
  };
}
