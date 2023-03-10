with import <nixpkgs> {};

let
  myPython = python3.withPackages (ps: with ps; [
    docopt
    python-gnupg
  ]);

in pkgs.stdenv.mkDerivation rec {
  name = "horcrux-${version}";
  version = "0.9";
  src = ./.;
  buildInputs = with pkgs; [

    expect      # only used by test scripts
    makeWrapper # only used by nix install
    unzip       # TODO remove?

    gnupg
    pwgen # pwgen-secure?
    qrencode
    ssss
    # stegseek # TODO is it better than steghide, or is that deprecated?
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
      --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}

    mkdir -p $out/test
    cp test/example.* $out/test/
    for f in $src/test/*.sh; do
      install -m755 $f $out/test/$(basename $f)
      wrapProgram $out/test/$(basename $f) \
        --prefix PATH : $out/bin:${pkgs.lib.makeBinPath buildInputs}
    done

    ln -s $out/test/test.sh $out/bin/horcrux-test

  '';

  # doCheck = true;
  # checkPhase = ''
  #   source $stdenv/setup
  #   $out/test/test.sh
  # '';
}
