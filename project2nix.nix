{ mkDerivation, aeson, ansi-wl-pprint, base, bytestring, Cabal
, containers, deepseq, directory, distribution-nixpkgs, doctest
, filepath, hackage-db, hnix, hopenssl, hpack, language-nix, lens
, optparse-applicative, pretty, process, spiros, split, stdenv
, tasty, tasty-golden, text, time, transformers, yaml
}:
mkDerivation {
  pname = "project2nix";
  version = "0.0";
  src = ./.;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    aeson ansi-wl-pprint base bytestring Cabal containers deepseq
    directory distribution-nixpkgs filepath hackage-db hnix hopenssl
    hpack language-nix lens optparse-applicative pretty process spiros
    split text time transformers yaml
  ];
  testHaskellDepends = [
    base Cabal doctest filepath language-nix lens pretty tasty
    tasty-golden
  ];
  homepage = "http://github.com/sboosali/project2nix#readme";
  description = "TODO";
  license = stdenv.lib.licenses.bsd3;
}
