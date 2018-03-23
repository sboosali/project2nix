{ mkDerivation, array, base, base-compat, base-orphans, binary
, bytestring, containers, deepseq, Diff, directory, fetchgit
, filepath, integer-logarithms, mtl, optparse-applicative, parsec
, pretty, process, QuickCheck, stdenv, tagged, tar, tasty
, tasty-golden, tasty-hunit, tasty-quickcheck, text, time
, transformers, tree-diff, unix
}:
mkDerivation {
  pname = "Cabal";
  version = "2.3.0.0";
  src = fetchgit {
    url = "https://github.com/haskell/cabal/";
    sha256 = "02y822g6ashm9xcvm588w8a6036kpwb0nq4007x3j6f4n8h1y877";
    rev = "6ba33d8bf8a3f8036dd06fee147f759235d086a1";
  };
  postUnpack = "sourceRoot+=/Cabal; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    array base binary bytestring containers deepseq directory filepath
    mtl parsec pretty process text time transformers unix
  ];
  testHaskellDepends = [
    array base base-compat base-orphans bytestring containers deepseq
    Diff directory filepath integer-logarithms optparse-applicative
    pretty process QuickCheck tagged tar tasty tasty-golden tasty-hunit
    tasty-quickcheck text tree-diff
  ];
  doCheck = false;
  homepage = "http://www.haskell.org/cabal/";
  description = "A framework for packaging Haskell software";
  license = stdenv.lib.licenses.bsd3;
}
