{ mkDerivation, aeson, base, bytestring, Cabal, containers, deepseq
, directory, doctest, filepath, hnix, lens, optparse-applicative
, prettyprinter, process, spiros, split, stdenv, tasty
, tasty-golden, text, time, transformers, yaml
}:
mkDerivation {
  pname = "project2nix";
  version = "0.0";
  src = ./.;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    aeson base bytestring Cabal containers deepseq directory filepath
    hnix lens optparse-applicative prettyprinter process spiros split
    text time transformers yaml
  ];
  testHaskellDepends = [
    base Cabal doctest filepath lens prettyprinter tasty tasty-golden
  ];
  homepage = "http://github.com/sboosali/project2nix#readme";
  description = "TODO";
  license = stdenv.lib.licenses.bsd3;
}
