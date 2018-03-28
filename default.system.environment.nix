# non-Haskell Nix environment, with executables and system dependencies only

{ mkDerivation
#, stdenv 
#, lib

, systemPackages ? {}
  # ^ explicit namespace which should be redundant
, zlib

, haskellPackages ? {}
  # ^ explicit namespace which should be redundant
, alex
, happy

}:

let

buildInputs = [ 
 zlib 
 alex happy
];

in

mkDerivation {

  inherit buildInputs;

  name = "project2nix-system-environment";

  # src = ./.; 

  # buildPhase = ''
  # '';

  # installPhase = ''
  # '';

}
