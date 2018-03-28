{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, bytestring, Cabal, cabal-install
      , containers, deepseq, hnix, optparse-applicative, prettyprinter
      , spiros, stdenv, text
      }:
      mkDerivation {
        pname = "project2nix";
        version = "0.0";
        src = ./.;
        enableSeparateDataOutput = true;
        libraryHaskellDepends = [
          base bytestring Cabal cabal-install containers deepseq hnix
          optparse-applicative prettyprinter spiros text
        ];
        homepage = "http://github.com/sboosali/project2nix#readme";
        description = "TODO";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
