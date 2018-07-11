########################################
{ nixpkgs       
   ? import <nixpkgs> { }
   # ? import ./nixpkgs {}

# , compilerName   ? null  # :: Maybe String 
# , compilerFlavor ? null  # :: Maybe String

}:
########################################
let

projectPacakges = {

 project2nix = ./project2nix;

};

haskellPackages =
 nixpkgs.haskellPackages.extend
  (nixpkgs.haskell.lib.packageSourceOverrides
    projectPacakges);

in
########################################

haskellPackages

########################################
