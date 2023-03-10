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
  '';
}
