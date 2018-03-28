{ mkDerivation
#, stdenv 
#, lib

# systemPackages
, zlib

# haskellPackages
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
