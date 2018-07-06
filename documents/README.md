[![Build Status](https://secure.travis-ci.org/sboosali/project2nix.svg)](http://travis-ci.org/sboosali/project2nix)
[![Hackage](https://img.shields.io/hackage/v/project2nix.svg)](https://hackage.haskell.org/package/project2nix)

# project2nix

TODO 

## Example

```
import Distribution.Nixpkgs.Haskell.Cabal.New

-- TODO
```

## Requirements

Requires a `nixpkgs` wherein `haskellCompilerName` has the version too (e.g. "ghc-8.4.2", not just "ghc"). 
Before this commit:

  https://github.com/NixOS/nixpkgs/commit/a9646b39cfcf8ecb860587c4adbc986ca627d2ce

  Fix haskellCompilerName version.
  This matters for `callCabal2nix`, when the cabal file has something
  like `if impl(ghc >= 7.7)`

it only had the "compiler flavor".

## Links

[Hackage](https://hackage.haskell.org/package/project2nix)

[Example module source](https://hackage.haskell.org/package/project2nix/docs/src/Example.Distribution.Nixpkgs.Haskell.Cabal.New.html). 

## Development

### Nix
TODO

### Cabal
TODO

### Stack
TODO

