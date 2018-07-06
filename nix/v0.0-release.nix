########################################
let 

systemNixpkgs = import <nixpkgs> {};
 # for "bootstrapping" from the system of the person installing this release.

releaseNixpkgs = import
 (systemNixpkgs.fetchFromGitHub {
   owner  = "NixOS";
   repo   = "nixpkgs";
   rev    = "13e74a838db27825c88be99b1a21fbee33aa6803";
   sha256 = "04dgg0f2839c1kvlhc45hcksmjzr8a22q1bgfnrx71935ilxl33d";
 })
 {};
 # the actual nixpkgs snapshot that was known to install successfully
 # (at least, on my machine).

in
########################################

import ./v0.0-shell.nix {
  nixpkgs  = releaseNixpkgs; 
  compiler = "ghc841";
  development = false;
}
