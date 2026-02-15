{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    pkgs = nixpkgs.legacyPackages."x86_64-linux";
    packageOverrides = pkgs.callPackage ./python-packages.nix {};
    # for an specific python version change to pkgs.{python312,python313}. ..
    python = pkgs.python3.override {inherit packageOverrides;};
  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      packages = [
        (python.withPackages (p:
          with p; [
            numpy
            requests
            pandas
          ]))
      ];
    };

    env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      # for numpy
      pkgs.stdenv.cc.cc.lib
      pkgs.libz
    ];
  };
}
