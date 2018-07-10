{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, bytestring, containers, deepseq
      , doctest, exceptions, hashable, lens, mtl, spiros, stdenv, text
      , transformers, unordered-containers
      }:
      mkDerivation {
        pname = "project2nix";
        version = "0.0";
        src = ./.;
        libraryHaskellDepends = [
          base bytestring containers deepseq exceptions hashable lens mtl
          spiros text transformers unordered-containers
        ];
        testHaskellDepends = [ base doctest ];
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
