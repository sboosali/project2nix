{ nixpkgsPath ? <nixpkgs>
, nixpkgsWith ? import nixpkgsPath
, nixpkgs     ? nixpkgsWith {}

, pkgs              ? nixpkgs.pkgs
, callSystemPackage ? pkgs.callPackage

, stdenv       ? pkgs.stdenv
, mkDerivation ? stdenv.mkDerivation

, utilities       ? stdenv.lib
, fetchFromGitHub ? utilities.fetchFromGitHub
, importJSON      ? utilities.importJSON
  
, derivationPath ? ./default.system.environment.nix

, compiler       ? null
, resolver       ? null
, integer-simple ? false

, withHoogle         ? false 
, withProfiled       ? false
, withTested         ? false
, withBenchmarked    ? false
, withDocumented     ? false
, withHyperlinked    ? true
, withDwarf          ? false
, whichObjectLibrary ? "default"
, whichLinker        ? "default"

}:

########################################
let

directory2string = path:
 toString (baseNameOf path);

in
########################################
let

# customMkDerivation = self: super: args:
#   super.mkDerivation
#     (args // customDerivationOptions);

# customDerivationOptions = 
#     { enableLibraryProfiling = withProfiled; 
#       doCheck                = withTested; 
#       doBenchmark            = withBenchmarked; 
#       doHaddock              = withDocumented;
#       doHyperlinkSource      = withDocumented && withHyperlinked;
#       enableDWARFDebugging   = withDwarf;
#     } //
#     ( if   (whichObjectLibrary == "shared") 
#       then { enableSharedLibraries  = true; 
#            }
#       else 
#       if   (whichObjectLibrary == "static")
#       then { enableStaticLibraries  = true; 
#            }
#       else
#       if   (whichObjectLibrary == "both") # TODO
#       then { enableSharedLibraries  = true;
#              enableStaticLibraries  = true; 
#            }
#       else 
#       if   (whichObjectLibrary == "default")
#       then {}
#       else {} # TODO
#     ) // 
#     utilities.optionalAttrs (whichLinker == "gold") 
#       { linkWithGold = true;
#       }
#  ;

hooglePackagesOverride = self: super:
  {
    ghcWithPackages = self.ghc.withPackages;

    ghc = super.ghc //
      { withPackages = super.ghc.withHoogle; 
      };
  };

in
########################################
let

haskellPackagesWithCompiler1 = 
  if   (compiler == null) || (compiler == "default")
       #TODO `integer-simple` is ignored if this matches
  then pkgs.haskellPackages

  else 
  if   integer-simple
  then pkgs.haskell.packages.integer-simple.${compiler}

  else 
  if   utilities.isString resolver
  then pkgs.haskell.packages.stackage.${resolver} # e.g. "lts-107"

  else pkgs.haskell.packages.${compiler};

haskellPackagesWithCustomPackages2 =
  if   withHoogle
  then haskellPackagesWithCompiler1.override {
         overrides = hooglePackagesOverride;
       }
  else haskellPackagesWithCompiler1;

haskellPackagesWithCustomDerivation3 = 
  haskellPackagesWithCustomPackages2.override {
    overrides = self: super: {
      # mkDerivation = customMkDerivation self super;
    };
};

haskellPackages = haskellPackagesWithCustomDerivation3;

callHaskellPackage = haskellPackages.callPackage;

in
########################################
let

callPackage = callSystemPackage;

_derivation = callPackage derivationPath {
 inherit mkDerivation;

 systemPackages  = pkgs;
 # inherit (haskellPackages) zlib;

 haskellPackages = haskellPackages;
 inherit (haskellPackages) alex happy;

};

environment = _derivation; #.env;

in
########################################

environment
