-- {-# LANGUAGE  #-}

{-| The package-specific custom prelude, which re-exports 
another custom ('Prelude.Spiros' from the @spiros@ package). 

-}
module Prelude.Distribution.Nixpkgs.Haskell.Cabal.New
 ( module Prelude.Spiros
 -- , module Prelude.Distribution.Nixpkgs.Haskell.Cabal.New
 -- , module X
 ) where

----------------------------------------

-- import as X

import "spiros" Prelude.Spiros

----------------------------------------

----------------------------------------