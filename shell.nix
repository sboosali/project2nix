########################################
arguments@
{ nixpkgs       
   ? import <nixpkgs> { }

, system
   ? builtins.currentSystem

, ...
}:
########################################
let

haskellPackages =
 (import ./.) { inherit nixpkgs; };

projectEnvironment =
  haskellPackages.shellFor {
    withHoogle = true;
    packages = self: with self;
      [
        (project2nix)
      ];
  };

in
########################################

projectEnvironment

########################################
