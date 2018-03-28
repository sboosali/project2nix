{ mkDerivation, base, bytestring, Cabal, cabal-install, containers
, deepseq, hnix, optparse-applicative, prettyprinter, spiros
, stdenv, text
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
}
