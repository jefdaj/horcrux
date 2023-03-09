{
  inputs = {
    # TODO which style of url is better, the gz one or the github: one?
    # TODO add sha256sums here?
    # TODO track unstable on develop branch, but pin for releases
    # nixpkgs.url     = "https://github.com/NixOS/nixpkgs/archive/refs/tags/22.11.tar.gz";
    nixpkgs.url     = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    mach-nix.url    = "github:DavHau/mach-nix";
  };
  outputs = { self, nixpkgs, flake-utils, mach-nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        machNix = mach-nix.lib."${system}";

        # TODO unify this with info from setup.py
       packageName = "horcrux";
        packageVersion = "0.1.0";
        requirements = ''
          docopt
          python-gnupg
        '';

        customOverrides = self: super: { };

        source_preferences = {
          _default = "nixpkgs,wheel,sdist";
          dhall = "wheel";
        };

        env = machNix.mkPython {
          inherit requirements;
          packagesExtra = with pkgs; [
            expect
            gnupg
            openssl
            pwgen
            qrencode
            ssss
            steghide
            unzip
          ];
        };

        app = machNix.buildPythonApplication {
          pname = packageName;
          version = packageVersion;
          src = ./.;
          inherit requirements;
        };

      in {
        packages.${packageName} = app;

        devShell = pkgs.mkShell {
          buildInputs = [ env ];
          shellHook = ''
            export LD_LIBRARY_PATH=${pkgs.openssl.out}/lib
          '';
        };
        defaultPackage = self.packages.${system}.${packageName};
        apps.${system}.default = app;

      });
}
