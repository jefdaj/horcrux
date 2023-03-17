let
  nixpkgs = import (builtins.fetchTarball {
    name = "nixos-unstable-2023-03-15";
    url = "https://github.com/nixos/nixpkgs/archive/eec97855384951087980a9596af6f69a0e0bdfa1.tar.gz";
    sha256 = "0v13l0rwlg4g0pxbsg2nj823pkv9my6p6zfjnf018d3d0npz6b8i";
  }) {};

  myPython = nixpkgs.python3.withPackages (ps: with ps; [
    docopt
    python-gnupg
  ]);

in nixpkgs.pkgs.stdenv.mkDerivation rec {
  name = "horcrux-${version}";
  version = "0.4";
  src = ./.;
  buildInputs = with nixpkgs.pkgs; [

    expect      # only used by test scripts
    which       # only used by test scripts
    makeWrapper # only used by nix install
    unzip       # TODO remove?

    gnupg
    pwgen # pwgen-secure?
    qrencode
    ssss
    steghide

    (python3.withPackages (ps: with ps; [
      docopt
      python-gnupg
    ]))

  ];

  shellHook = ''
    export PATH=$PWD:$PATH
  '';

  installPhase = ''

    mkdir -p $out/bin
    install -m755 horcrux $out/bin/horcrux
    wrapProgram $out/bin/horcrux \
      --prefix PATH : ${nixpkgs.pkgs.lib.makeBinPath buildInputs}

    mkdir -p $out/test
    cp test/example.* $out/test/
    cp test/test-*-*.txt $out/test/
    for f in $src/test/*.sh; do
      install -m755 $f $out/test/$(basename $f)
      wrapProgram $out/test/$(basename $f) \
        --prefix PATH : $out/bin:${nixpkgs.pkgs.lib.makeBinPath buildInputs}
    done

    ln -s $out/test/test.sh $out/bin/horcrux-test

  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/horcrux-test
  '';
}
