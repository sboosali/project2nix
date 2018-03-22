{ mkDerivation, base, bytestring, containers, deepseq, doctest
, exceptions, hashable, lens, mtl, spiros, stdenv, text
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
}
