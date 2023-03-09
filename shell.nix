# This is for initial testing. Ideally it will be a flake.

with import <nixpkgs> {};

let

  myPython = python3.withPackages (ps: with ps; [
    docopt
    python-gnupg
  ]);

  runDeps = with pkgs; [
    expect
    gnupg
    myPython
    openssl # TODO remove?
    pwgen
    qrencode
    ssss
    steghide
    unzip
  ];

  devDeps = runDeps ++ (with pkgs; [
    expect
  ]);

in pkgs.mkShell {
  buildInputs = devDeps;
  shellHook = ''
    export PATH=$PWD:$PATH
  '';
}
