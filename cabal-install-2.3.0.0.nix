{ mkDerivation, array, async, base, base16-bytestring, binary
, bytestring, Cabal, containers, cryptohash-sha256, deepseq
, directory, echo, edit-distance, fetchgit, filepath
, hackage-security, hashable, HTTP, mtl, network, network-uri
, pretty, pretty-show, process, QuickCheck, random, resolv, stdenv
, stm, tagged, tar, tasty, tasty-hunit, tasty-quickcheck, time
, unix, zlib
}:
mkDerivation {
  pname = "cabal-install";
  version = "2.3.0.0";
  src = fetchgit {
    url = "https://github.com/haskell/cabal/";
    sha256 = "1p939qcni4fbanpwn590bkz9rlj51197yy2fkhqflfmf549m7jrs";
    rev = "6ca34b078e3718633e25ae3a788c671ac0f28a70";
  };
  postUnpack = "sourceRoot+=/cabal-install; echo source root reset to $sourceRoot";
  isLibrary = true;
  isExecutable = true;
  setupHaskellDepends = [ base Cabal filepath process ];
  libraryHaskellDepends = [
    array async base base16-bytestring binary bytestring Cabal
    containers cryptohash-sha256 deepseq directory echo edit-distance
    filepath hackage-security hashable HTTP mtl network network-uri
    pretty process random resolv stm tar time unix zlib
  ];
  executableHaskellDepends = [
    array async base base16-bytestring binary bytestring Cabal
    containers cryptohash-sha256 deepseq directory echo edit-distance
    filepath hackage-security hashable HTTP mtl network network-uri
    pretty process random resolv stm tar time unix zlib
  ];
  testHaskellDepends = [
    array async base bytestring Cabal containers deepseq directory
    edit-distance filepath hashable mtl network network-uri pretty-show
    QuickCheck random tagged tar tasty tasty-hunit tasty-quickcheck
    time zlib
  ];
  doCheck = false;
  postInstall = ''
    mkdir $out/etc
    mv bash-completion $out/etc/bash_completion.d
  '';
  homepage = "http://www.haskell.org/cabal/";
  description = "The command-line interface for Cabal and Hackage";
  license = stdenv.lib.licenses.bsd3;
}
