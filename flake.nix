{
  description = "Horcrux test flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  };
  outputs = { self, nixpkgs }@inputs: {
    # TODO which other systems will also work?
    # TODO include docker here
    # TODO include tests here for `nix flake test`
    packages.x86_64-linux.horcrux = nixpkgs.legacyPackages.x86_64-linux.callPackage ./package.nix {};
    packages.x86_64-linux.default = self.packages.x86_64-linux.horcrux;
  };
}
