########################################
let

nixpkgsRevision = {
 rev    = "ee28e35ba37ab285fc29e4a09f26235ffe4123e2";
 sha256 = "04dgg0f2839c1kvlhc45hcksmjzr8a22q1bgfnrx71935ilxl33d";
};

/* ^

$ nix-channel --update
...

$ cat ~/.nix-defexpr/channels/nixpkgs/.git-revision
ee28e35ba37ab285fc29e4a09f26235ffe4123e2

$ nix-prefetch-git --no-deepClone --url https://github.com/NixOS/nixpkgs --rev ee28e35ba37ab285fc29e4a09f26235ffe4123e2


*/

in
########################################
let 

bootstrapNixpkgs
 = import <nixpkgs> {};

 # ^ for "bootstrapping" from the system of the person installing this release.

releaseNixpkgs
 = import (bootstrapNixpkgs.fetchFromGitHub (nixpkgsWithRevision nixpkgsRevision)) {};

 # ^ the actual nixpkgs snapshot that was known to install successfully
 # (at least, on my machine).

nixpkgsWithRevision = { rev, sha256 }:
{
 owner = "NixOS";
 repo  = "nixpkgs";
 inherit rev sha256;
};

in
########################################

import ./shell.nix { nixpkgs = releaseNixpkgs; }

########################################
