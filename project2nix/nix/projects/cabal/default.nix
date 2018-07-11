########################################
{ haskellPackages
}:

########################################
let

repository = 
 import ./cabal.json;

in
########################################
let

Cabal         = haskellPackages.callPackage ./Cabal.nix {
};

cabal-install = haskellPackages.callPackage ./cabal-install.nix {
 inherit Cabal;
};

in
########################################
{
 inherit Cabal cabal-install;
}
########################################

# 
# Cabal         = import ./Cabal.nix;
# cabal-install = import ./cabal-install.nix;
